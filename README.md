# Marcelo's NixOS configuration

Personal, single-host NixOS flake for `marcelo@starscream`. It manages a GNOME Wayland workstation, development tools, virtualization, containerized homelab services, monitoring, Secure Boot, and encrypted secrets.

This repository is machine-specific. It can be used as a reference, but it is not intended to be applied unchanged on another host.

## Highlights

- NixOS and Home Manager evaluated together from one flake
- Lanzaboote Secure Boot and USB-key LUKS unlock on the XanMod kernel
- GNOME on Wayland with GDM, PipeWire, AMD graphics, ROCm, Bluetooth, and OpenRGB
- Fish, Starship, Ptyxis, tmux, Neovim, VS Code, Zed, Kubernetes, Terraform, and Ansible tooling
- Docker/Arion services behind Traefik
- Libvirt/KVM and Cockpit for local virtualization
- Host-native Prometheus with containerized Grafana
- SOPS-managed system and user secrets
- Local Nix packages for applications not provided in the desired form upstream

## Layout

```text
.
├── flake.nix                    # Inputs and the starscream NixOS configuration
├── flake.lock                   # Pinned flake inputs
├── nixos/
│   ├── configuration.nix        # System entry point
│   ├── hardware-configuration.nix
│   └── modules/
│       └── arion/               # Traefik, Portainer, Autokube, streaming, Grafana
├── marcelo/
│   ├── home.nix                 # Home Manager entry point
│   └── modules/                 # Shell, desktop, editor, and user tooling
├── pkgs/                        # Local package derivations
├── secrets/marcelo.yaml         # SOPS-encrypted secrets
└── docs/                        # Machine setup and recovery notes
```

## Desktop

The system runs GNOME on Wayland; X11 is disabled and GDM is the display manager. Unused GNOME applications are dropped through `environment.gnome.excludePackages` in `nixos/modules/gnome.nix`.

The user side lives in `marcelo/modules/gnome.nix`, which installs the shell extensions and GNOME utilities and imports `marcelo/modules/dconf.nix`. That file declares the desktop state itself — enabled extensions, dock favorites, fonts, theme, input sources, keybindings, night light, Nautilus defaults, and the Ptyxis profile. Settings changed through the GNOME UI are overwritten on the next switch unless they are also written there.

Ptyxis is the terminal and starts Fish through a custom command. Fonts are Adwaita Sans/Mono and JetBrainsMono Nerd Font; the GTK theme is `adw-gtk3-dark` with Papirus-Dark icons.

## Local packages

`pkgs/` holds derivations for applications that upstream does not provide in the desired form:

- `attack-shark-x11` — Electron configuration app for the Attack Shark X11 mouse, built from the upstream `v1.4.3` tag with a regenerated `package-lock.json`
- `lens-desktop` — wraps the upstream AppImage
- `spotify-xwayland` — forces the XWayland launch path

They are imported directly in `marcelo/home.nix`. Claude Desktop comes from the `llm-agents` flake input, and `marcelo/modules/packages.nix` supplies the desktop entry with window-matching, GPU, and icon fixes. The Spotify wrapper retains the XWayland launch behavior.

## Common operations

Evaluate the configuration without building:

```sh
nix flake check --no-build
```

Build without switching the running system:

```sh
sudo nixos-rebuild build --flake .#starscream
```

Review the resulting package and service changes:

```sh
nvd diff /run/current-system result
```

Apply the configuration:

```sh
sudo nixos-rebuild switch -L --flake .#starscream
```

Format an edited Nix file:

```sh
nixfmt path/to/file.nix
```

The Fish function `nrs` automates the update, lock-file commit, build, diff, and switch prompt. Run it only when that complete workflow is intended.

## Containers and monitoring

Arion uses Docker to run `traefik`, `portainer`, `autokube`, `streaming`, and `grafana`. The projects share the `proxy` network, and Traefik routes services under `*-sc.alvesm.dev`.

`streaming` is declared but no longer starts at boot: its generated unit is detached with `systemd.services.<streaming unit>.wantedBy = lib.mkForce [ ]`. Start it on demand with `systemctl start arion-streaming`.

Prometheus and node-exporter run directly on the host. Grafana reaches Prometheus through `host.docker.internal`. Media data is stored under `/mnt/myexternaldisk/streaming`; application configuration is stored under `/home/marcelo/docker/streaming` or Docker volumes.

Most container images use upstream mutable tags, so rebuilding NixOS does not fully pin their runtime contents.

## Secrets

Secrets are encrypted with SOPS and age:

```sh
sops secrets/marcelo.yaml
```

The age key is expected at `/home/marcelo/.config/sops/age/keys.txt`. Never commit the key or decrypted secret material. System secrets are declared in `nixos/modules/secrets.nix`; user secrets are declared in `marcelo/modules/secrets.nix`.

## Machine notes

- [Secure Boot setup](docs/secure-boot-setup.md)
- [Ryzen 5700X and X570 BIOS tuning](docs/bios-tuning-ryzen-5700x-x570.md)

The Attack Shark X11 udev rules in `nixos/modules/hardware.nix` are shipped through `services.udev.packages` with a `60-` filename prefix, not through `services.udev.extraRules`. The latter writes to `99-local.rules`, but systemd turns the `uaccess` tag into an ACL from `73-seat-late.rules`, so a tag set at 99 is never acted on and the device stays root-only.

`system.stateVersion` and `home.stateVersion` preserve compatibility with existing state; they are not package-version selectors and should not be changed during routine upgrades.

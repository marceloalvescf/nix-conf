# Marcelo's NixOS configuration

Personal, single-host NixOS flake for `marcelo@starscream`. It manages a Plasma 6 Wayland workstation, development tools, virtualization, containerized homelab services, monitoring, Secure Boot, and encrypted secrets.

This repository is machine-specific. It can be used as a reference, but it is not intended to be applied unchanged on another host.

## Highlights

- NixOS and Home Manager evaluated together from one flake
- Lanzaboote Secure Boot and USB-key LUKS unlock on the XanMod kernel
- Plasma 6, greetd/tuigreet, PipeWire, AMD graphics, ROCm, Bluetooth, and OpenRGB
- Fish, Kitty, tmux, Neovim, VS Code, Zed, Kubernetes, Terraform, and Ansible tooling
- Docker/Arion services behind Traefik
- Libvirt/KVM and Cockpit for local virtualization
- Host-native Prometheus with containerized Grafana
- Host-native Ollama on ROCm, reachable from kind clusters
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

## Local packages

`pkgs/` holds derivations for applications that upstream does not provide in the desired form:

- `attack-shark-x11` — Electron configuration app for the Attack Shark X11 mouse, built from a pinned `main` commit with a regenerated `package-lock.json`
- `claude-desktop` — repackages the official `.deb`, repairs the ELF interpreter and rpaths, removes the setuid `chrome-sandbox`, and keeps GPU acceleration working
- `lens-desktop` — wraps the upstream AppImage
- `plasmoids/` — third-party Plasma widgets: Andromeda Launcher, Resources Monitor, and Weather Widget Plus

The first three are imported in `marcelo/home.nix`; the plasmoids are installed from `marcelo/modules/plasma.nix`. The Fish function `claude-desktop-update` compares the pinned Claude Desktop version against the Anthropic apt repository.

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

Ollama also runs directly on the host, on the ROCm build, and binds to `0.0.0.0:11434` so pods in `kind` clusters can reach it. Access is restricted by a firewall rule scoped to the Docker network, not by the bind address. See `nixos/modules/ollama.nix` and the `firewall.extraCommands` entry in `nixos/modules/networking.nix`.

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

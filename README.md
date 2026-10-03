# Marcelo's NixOS configuration

Personal, single-host NixOS flake for `marcelo@starscream`. It manages a Plasma 6 Wayland workstation, development tools, virtualization, containerized homelab services, monitoring, Secure Boot, and encrypted secrets.

This repository is machine-specific. It can be used as a reference, but it is not intended to be applied unchanged on another host.

## Highlights

- NixOS and Home Manager evaluated together from one flake
- Lanzaboote Secure Boot and USB-key LUKS unlock on the XanMod kernel
- zram swap (zstd, 16 GiB cap) with kernel reclaim tuned for compressed swap, no disk swap
- Plasma 6, greetd/tuigreet, PipeWire, AMD graphics, ROCm, Bluetooth, and OpenRGB
- Fish, Kitty, tmux, Neovim, VS Code, Zed, Kubernetes, Terraform, and Ansible tooling
- Docker/Arion services behind Traefik
- Libvirt/KVM and Cockpit for local virtualization
- Sunshine game streaming with KMS capture
- Host-native Prometheus with containerized Grafana and a provisioned libvirt dashboard
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

The system runs Plasma 6 on Wayland; X11 and SDDM are disabled. greetd starts `tuigreet --cmd startplasma-wayland` in `nixos/modules/plasma.nix`, and `pam_kwallet5` runs with `force_run` so the VT login still unlocks KWallet.

User settings are declared with Plasma Manager in `marcelo/modules/plasma.nix`: the Qogir global themes, switched automatically between light and dark at Night Light's sunrise and sunset (colours, Qogir icons and cursors, Plasma theme, window decoration), Apple SF fonts, input devices, night light, power management, the screen locker, 3 virtual desktops, and a GNOME-inspired layout. A thin top bar holds the kara pill workspace indicator on the left, the clock (with date and Weather Widget Plus) in the centre, and the Resources Monitor, a System Monitor pie chart for root filesystem usage (sensor ID derived from `fileSystems."/"`), the system tray, and a Shutdown or Switch power menu on the right. A floating bottom dock that dodges windows holds the AppGrid launcher (from the `appgrid` flake input, opened by Meta or by clicking it) and the pinned task manager. The top-left screen corner opens Overview, like GNOME's Activities hot corner.

GTK settings are left to Plasma's GTK sync, which follows the active global theme; only the GTK theme name (`Qogir-Light`, whose dark variant is `Qogir-Dark`) is set, once, by a Plasma Manager startup script.

Panels, themes, and the wallpaper are applied by the Plasma Manager autostart script at login. To apply them after a switch without logging out:

```sh
~/.local/share/plasma-manager/run_all.sh
qdbus org.kde.KWin /KWin reconfigure
```

Restart the shell with `systemctl --user restart plasma-plasmashell` when a new widget or sensor face was installed. Input devices and fonts in already open applications still need a new login.

## Local packages

`pkgs/` holds derivations for applications that upstream does not provide in the desired form:

- `lens-desktop` — wraps the upstream AppImage
- `plasmoids/` — third-party Plasma widgets: Shutdown or Switch, Resources Monitor, and Weather Widget Plus
- `sensorfaces/piechart-small.nix` — copy of the stock Plasma Pie Chart sensor face with a 2pt smaller center value, rebuilt from the installed `libksysguard`

`lens-desktop` is imported in `marcelo/home.nix`; the plasmoids and the sensor face are installed from `marcelo/modules/plasma.nix`. Claude Desktop is no longer packaged here: it comes from the `llm-agents` flake input, and `marcelo/modules/packages.nix` ships the desktop entry that carries the window-matching, GPU, and icon fixes.

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

Prometheus, node-exporter, and the libvirt exporter run directly on the host. Grafana reaches Prometheus through `host.docker.internal`; its datasource (with a pinned UID) and the libvirt dashboard are provisioned from `nixos/modules/arion/grafana/provisioning/` with UI edits disabled. Media data is stored under `/mnt/myexternaldisk/streaming`; application configuration is stored under `/home/marcelo/docker/streaming` or Docker volumes.

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

`system.stateVersion` and `home.stateVersion` preserve compatibility with existing state; they are not package-version selectors and should not be changed during routine upgrades.

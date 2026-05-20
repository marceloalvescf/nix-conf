# Setting Up Secure Boot on NixOS with Lanzaboote

- **Date:** 2026-02-17
- **Machine:** starscream
- **Motherboard:** ASUS TUF GAMING X570-PLUS/BR
- **Dual boot:** NixOS (NVMe) + Windows (NVMe)

## Context

Windows requires Secure Boot enabled for games that use kernel-level anti-cheat (Vanguard, EAC, BattlEye, etc.). To avoid toggling Secure Boot every time you switch between OSes, NixOS can be configured to boot with Secure Boot using Lanzaboote.

Lanzaboote signs NixOS boot components (kernel, initrd, systemd-boot stub) with custom Secure Boot keys. Combined with Microsoft's vendor keys, both OSes boot with Secure Boot enabled.

## Prerequisites

- NixOS with flakes enabled
- systemd-boot as the current bootloader
- A working Windows installation on a separate disk

## Step 1: Add Lanzaboote to flake inputs

In `flake.nix`, add the lanzaboote input:

```nix
inputs = {
  # ... existing inputs ...

  lanzaboote = {
    url = "github:nix-community/lanzaboote";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Add it to the outputs function arguments and include the module:

```nix
outputs =
  inputs@{
    lanzaboote,
    # ... other inputs ...
  }:
  {
    nixosConfigurations = {
      starscream = nixpkgs.lib.nixosSystem {
        modules = [
          # ... existing modules ...
          lanzaboote.nixosModules.lanzaboote
        ];
      };
    };
  };
```

## Step 2: Configure boot module

Update the boot configuration to disable systemd-boot (Lanzaboote manages it) and enable Lanzaboote:

```nix
{ pkgs, lib, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    # ... rest of boot config ...
  };

  environment.systemPackages = [
    pkgs.sbctl
  ];
}
```

## Step 3: Create Secure Boot keys

The keys must exist before rebuilding, otherwise Lanzaboote will fail trying to sign boot files. Since `sbctl` is not yet installed on the system, run it via Nix:

```sh
sudo nix run nixpkgs#sbctl -- create-keys
```

This creates the PKI bundle (PK, KEK, db keys) at `/var/lib/sbctl/keys/`.

## Step 4: Rebuild NixOS

With Secure Boot still disabled in BIOS:

```sh
sudo nixos-rebuild switch --flake .#starscream
```

Lanzaboote will sign all boot generations with the newly created keys.

Verify all boot files are signed:

```sh
sudo sbctl verify
```

## Step 5: Put firmware in Setup Mode

The firmware ships with Microsoft's factory keys in User Mode. To enroll custom keys, the firmware must be in Setup Mode.

1. Reboot and press **Del** to enter BIOS setup.
2. Navigate to **Advanced > Boot > Secure Boot > Key Management**.
3. Select **Clear Secure Boot keys** (or equivalent option to reset to Setup Mode).
4. Keep Secure Boot disabled.
5. Save and exit.

This does not affect Windows. It only clears the key database so new keys can be enrolled.

## Step 6: Enroll keys with Microsoft vendor certificates

Boot back into NixOS and run:

```sh
sudo sbctl enroll-keys --microsoft
```

The `--microsoft` flag is required for dual-boot. It enrolls your custom keys alongside Microsoft's UEFI signing certificates, so Windows continues to boot and anti-cheat validation passes.

Verify enrollment:

```sh
sudo sbctl status
```

Expected output:

```
Installed:      sbctl is installed
Setup Mode:     Disabled
Secure Boot:    Disabled
Vendor Keys:    microsoft
```

Secure Boot shows disabled because it has not been turned on in BIOS yet.

## Step 7: Enable Secure Boot in BIOS

1. Reboot and press **Del** to enter BIOS setup.
2. Navigate to **Advanced > Boot > Secure Boot**.
3. Set **OS Type** to **Windows UEFI mode** (this is the only option that enables Secure Boot on ASUS X570 boards).
4. Save and exit.

Note: On this board, there is no separate "Enable Secure Boot" toggle. The OS Type setting controls it. Despite the name "Windows UEFI mode," custom-enrolled keys are preserved.

## Step 8: Verify

After booting into NixOS:

```sh
bootctl status
```

Look for:

```
Secure Boot: enabled (user)
```

The `(user)` indicates custom-enrolled keys are active.

```sh
sudo sbctl status
```

Expected output:

```
Installed:      sbctl is installed
Setup Mode:     Disabled
Secure Boot:    Enabled
```

Boot into Windows and confirm anti-cheat games work as expected.

## Maintenance

No manual steps are needed going forward. Every `nixos-rebuild switch` automatically signs new boot generations with the enrolled keys.

The keys at `/var/lib/sbctl/keys/` should be backed up securely. Losing them requires re-enrollment.

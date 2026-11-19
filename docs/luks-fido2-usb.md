# Root LUKS unlock: detached header, USB drive and YubiKey

How the encrypted root of `starscream` is laid out, what is needed to boot it, and how to recover when one of the pieces is missing. The declarative side lives in `nixos/hardware-configuration.nix` (`boot.initrd.luks.devices."nixos-rootfs"`) and `nixos/modules/boot.nix`.

The commands under Maintenance and Recovery are derived from that configuration and from the `cryptsetup` and `systemd-cryptenroll` manuals. Read them against the current state before running any of them.

## Layout

The root NVMe (`/dev/disk/by-path/pci-0000:01:00.0-nvme-1`) is encrypted as a whole disk and carries no LUKS header and no partition table. Without the header the disk is indistinguishable from random data.

Everything needed to boot sits on the Samsung USB flash drive:

| Part | PARTUUID | Label | Content |
| --- | --- | --- | --- |
| 1 | `d3a16764-9496-4c51-b708-7857493e2412` | `primary` | Detached LUKS2 header of the root disk (32 MiB) |
| 2 | `d95a329c-a5f3-4e7f-8b95-89b932bef26f` | `primary` | ESP, mounted at `/boot` |
| 3 | `ccdbcf26-6a55-4295-b481-61598bc381f4` | `usb-key` | Former raw key file (1 MiB), no longer referenced |
| 4 | `2befda4d-f8b8-4434-b3c4-79f7e5d26155` | `usb-data` | LUKS2 data partition, unlocked and mounted by hand |

The drive's `sdX` name changes between boots. Address it through `/dev/disk/by-id/usb-Samsung_Flash_Drive_*` or the PARTUUIDs above, never through `/dev/sdX`.

The second NVMe holds Windows (BitLocker) with its own ESP and is not touched by this configuration.

## What a boot needs

1. The USB drive: the firmware loads the signed boot files from part 2 and the initrd reads the header from part 1.
2. The YubiKey: the header has a FIDO2 keyslot, declared with `crypttabExtraOpts = [ "fido2-device=auto" ]`.
3. The FIDO2 PIN and a touch.

Unlocking runs in the systemd stage-1 initrd (`boot.initrd.systemd.enable = true`). A passphrase keyslot remains as the recovery path when the YubiKey is unavailable.

## Things that destroy access

- `ykman fido reset` wipes the FIDO2 credential. Only the passphrase keyslot opens the disk afterwards.
- Repartitioning, reformatting or losing the USB drive loses the header. Without a header backup the root disk is unrecoverable, passphrase or not.
- Killing the passphrase keyslot removes the only fallback for a lost or reset YubiKey.

## Maintenance

Take a header backup after every keyslot change and keep it off the USB drive and off the root disk:

```sh
sudo cryptsetup luksHeaderBackup \
  /dev/disk/by-partuuid/d3a16764-9496-4c51-b708-7857493e2412 \
  --header-backup-file starscream-root-header.img
```

Inspect keyslots and tokens:

```sh
sudo cryptsetup luksDump /dev/disk/by-partuuid/d3a16764-9496-4c51-b708-7857493e2412
```

Enroll a new or reset YubiKey (asks for the passphrase):

```sh
sudo systemd-cryptenroll \
  --fido2-device=auto \
  --fido2-with-client-pin=yes \
  --fido2-with-user-presence=yes \
  /dev/disk/by-partuuid/d3a16764-9496-4c51-b708-7857493e2412
```

Remove a stale FIDO2 slot only after the new one has unlocked a real boot, using `systemd-cryptenroll --wipe-slot=<slot>` with the slot number from `luksDump`.

## Recovery

**YubiKey lost or reset.** Boot normally; when the FIDO2 prompt fails or times out, systemd falls back to the passphrase. Then enroll the replacement key as above.

**Unlocking from a live system.** With the USB drive (or a header backup file) attached:

```sh
sudo cryptsetup open \
  --header /dev/disk/by-partuuid/d3a16764-9496-4c51-b708-7857493e2412 \
  /dev/disk/by-path/pci-0000:01:00.0-nvme-1 nixos-rootfs
sudo mount /dev/mapper/nixos-rootfs /mnt
```

**USB drive lost or dead.** Partition a new drive, restore the header backup onto its first partition with `cryptsetup luksHeaderRestore`, create a new ESP, then update the two PARTUUIDs in `nixos/hardware-configuration.nix` and reinstall the boot files from a live system (`nixos-enter`, then `nixos-rebuild boot --flake .#starscream`). Secure Boot signing keys live in `/var/lib/sbctl` on the root disk, so they survive; see [Secure Boot setup](secure-boot-setup.md).

## The data partition

Part 4 is intentionally absent from `crypttab` and `fileSystems`. Open it by hand when needed:

```sh
sudo cryptsetup open /dev/disk/by-partlabel/usb-data usb-data
sudo mount /dev/mapper/usb-data /mnt/usb-data
```

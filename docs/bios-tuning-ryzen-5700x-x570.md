# NixOS Workstation BIOS Tuning — Ryzen 7 5700X + ASUS TUF X570-PLUS/BR

## Hardware Context

* CPU: AMD Ryzen 7 5700X
* Motherboard: ASUS TUF GAMING X570-PLUS/BR
* BIOS version used during tuning: 5021
* RAM:

  * 2×16 GB Corsair CMK32GX4M2B3200C16
  * 2×16 GB Corsair CMK32GX4M2E3200C16
  * Total: 64 GB DDR4
* Operating system: NixOS
* Kernel recommendation: official/latest NixOS kernel, not Zen Kernel

---

# 1. Final Stable Goal

The final stable workstation configuration is:

```text
RAM: 64 GB DDR4 @ 3000 MHz
CPU PBO: Enabled
Curve Optimizer: Negative -10 all-core
Max CPU Boost Clock Override: +200 MHz
Kernel: Official/latest NixOS kernel
```

This setup prioritizes stability for DevOps workstation tasks while still improving CPU and memory performance.

---

# 2. RAM Slot Layout

Use all four DIMM slots:

```text
DIMM_A1: CMK32GX4M2E3200C16
DIMM_A2: CMK32GX4M2B3200C16
DIMM_B1: CMK32GX4M2E3200C16
DIMM_B2: CMK32GX4M2B3200C16
```

The system uses mixed Corsair kits, so DDR4-3200 was not stable with all 4 DIMMs.

DDR4-3000 was selected as the stable compromise.

---

# 3. BIOS RAM Configuration

Enter BIOS and apply the following settings.

## Step 1 — Load Defaults

```text
Load Optimized Defaults
Save
Re-enter BIOS
```

## Step 2 — Enable DOCP

```text
AI Tweaker
  AI Overclock Tuner = D.O.C.P.
```

This loads the memory profile, usually close to:

```text
DDR4-3200
1.35V
16-20-20-38 or similar
```

Do not keep 3200 MHz.

## Step 3 — Manually Lower RAM Frequency

```text
Memory Frequency = DDR4-3000
```

Keep the DOCP timings and voltage, but override only the frequency.

## Step 4 — Verify DRAM Voltage

```text
DRAM Voltage = 1.35V
```

If Auto already sets 1.35V, leave it.

## Step 5 — Set Infinity Fabric

```text
FCLK Frequency = 1500 MHz
```

Because DDR4-3000 means:

```text
MCLK = 1500 MHz
FCLK = 1500 MHz
```

This keeps Ryzen running in the preferred 1:1 fabric ratio.

## Step 6 — UCLK

If available:

```text
UCLK DIV1 MODE = UCLK=MCLK
```

If this option is not visible, leave it on Auto.

## Step 7 — Leave Advanced Voltages on Auto

Do not manually tune these unless troubleshooting:

```text
SOC Voltage
VDDG CCD
VDDG IOD
CLDO VDDP
ProcODT
CAD Bus
LLC
```

---

# 4. BIOS CPU / PBO Configuration

Apply these settings:

```text
Precision Boost Overdrive = Enabled
Curve Optimizer = Enabled
All Core Curve Optimizer Sign = Negative
All Core Curve Optimizer Magnitude = 10
Max CPU Boost Clock Override = +200 MHz
```

This results in:

```text
PBO enabled
Curve Optimizer all-core -10
Boost Override +200 MHz
```

This is a conservative and stable Ryzen 7 5700X tuning profile.

---

# 5. Kernel Recommendation

Use the official/latest NixOS kernel.

Avoid Zen Kernel on this workstation.

Observed issue:

```text
Zen Kernel caused hard freezes, abnormal memory/cache behavior, and instability.
Official/latest kernel resolved the freezes.
```

---

# 6. Linux Validation Commands

## Verify RAM Speed

```bash
sudo lshw -C memory
```

Expected:

```text
size: 64GiB
clock: 3000MHz / 3GHz
```

Alternative:

```bash
sudo dmidecode -t memory | grep -i speed
```

## Verify CPU Boost Ceiling

```bash
grep . /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
```

Expected value should be around:

```text
4866949
```

This indicates that the +200 MHz boost override is active.

## Monitor CPU Temperature

Use:

```bash
sensors
```

Watch:

```text
Tctl
```

Use `Tctl` for CPU thermal decisions.

`Tccd1` can be observed, but `Tctl` is the main control temperature.

---

# 7. Stability Tests

## Memory Test

Run Memtest again after BIOS changes.

Known result:

```text
DDR4-3200 failed Memtest with 4 mixed DIMMs.
DDR4-3000 passed Memtest.
```

## Linux Stress Test

```bash
stress-ng --cpu 16 --timeout 10m
```

Optional mixed workload test:

```bash
stress-ng --cpu 8 --io 4 --vm 2 --vm-bytes 8G --timeout 30m
```

## Real-World Stability Test

Validate using normal workload:

```text
Docker / containers
Nix builds
Browsers
DevOps tools
Heavy gaming
```

Previously validated:

```text
DDR4-3000 passed Memtest and multiple hours of heavy gaming.
```

---

# 8. Expected Performance Gains

Compared to JEDEC DDR4-2133:

```text
DDR4-3000 provides roughly 40% more theoretical memory bandwidth.
Ryzen Infinity Fabric also improves from ~1066 MHz to 1500 MHz.
```

Expected real-world benefits:

```text
Better desktop responsiveness
Better multitasking
Better container workload behavior
Better gaming 1% lows
Better CPU boost behavior with PBO + Curve Optimizer
```

---

# 9. Final Known-Good Configuration

```text
RAM:
  64 GB DDR4
  4 DIMMs
  DDR4-3000
  FCLK 1500 MHz
  DRAM Voltage 1.35V

CPU:
  PBO Enabled
  Curve Optimizer Enabled
  All-core Negative -10
  Max Boost Override +200 MHz

OS:
  NixOS
  Official/latest kernel
  Avoid Zen Kernel
```

---

# 10. Notes

If BIOS resets again, repeat this process from the beginning.

Also verify cooling settings after BIOS reset, especially:

```text
AIO pump speed
CPU fan curve
Case fan curve
```

BIOS resets may revert pump/fan profiles.

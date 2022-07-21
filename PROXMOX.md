# Proxmox

Proxmox is a controller of Virtual Machines, more details [here](https://www.proxmox.com/).

## Creating ARM64 VM

First download `ubuntu-20.04.1-live-server-arm64.iso` image from:

https://mirror.yandex.ru/ubuntu-cdimage/ubuntu/releases/20.04.1/release/

Then will need to create VM with EFI support, all other parameters
can be saved in default state, but will need to attach ISO image
and probably change size of HDD, from 32Gb to something more larger.

Then need to `Hardware` tab and delete EFI partition, then
click to `Add` button and create `EFI` drive again.
It looks insane, but by some reason Proxmox for EFI VMs each time
want to create 128Kb drive, which trigger error like:
`qemu-system-aarch64: device requires 67108864 bytes, block backend provides 131072 bytes`
on VM boot stage.

This message mean what for VM need 64Mb drive for EFI.

For enabling ARM64 emulation need after creating via
web-interface open a configuration file ov VM
(for example ID of VM will be 110). This configuration can be found
in following folder: `/etc/pve/nodes/vm/qemu-server`.

```shell script
sudo mcedit /etc/pve/nodes/vm/qemu-server/110.conf
```

Then need add missed fields, for example will need to add at least `arch: aarch64`,
then need to remove string like: `vmgenid: 0000000000000000000`.

Example configuration:

```
arch: aarch64
bios: ovmf
boot: dcn
bootdisk: scsi0
cores: 1
efidisk0: local:vm-110-disk-1,size=64M
memory: 2048
name: k3s-server
net0: virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1
numa: 0
ostype: l26
scsi0: local:vm-110-disk-0,size=40G
scsi1: local:iso/ubuntu-20.04.1-live-server-arm64.iso,media=cdrom,size=881M
scsihw: virtio-scsi-pci
serial0: socket
smbios1: uuid=ffffffff-ffff-ffff-ffff-ffffffffffff
sockets: 1
vga: serial0
```

## Installing Ubuntu to VM

Then need to start VM and open `xterm.js` console, because default `noVNC`
not able for work with VGA via serial port (each press to any key will send Enter to VM).

After Ubuntu started just wait some time (booting may take about 10-20 minutes),
then follow installation instruction.

When installation is almost done and you see `Security Updates` stage click to
`Cancel`, because by some reason VM stuck on this stage (open status tab, you'll
see 100% of CPU and memory usage).

After installation Ubuntu should receive IP address via DHCP, and you may finally login.

> BTW: Full path from start to end of installation may take about couple hours, so do not worry and just be patient.

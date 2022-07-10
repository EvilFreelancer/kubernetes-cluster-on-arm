# Kubernetes cluster on ARM nodes (WIP)

Project about simple Kubernetes clusters on ARM nodes.

![Image](arm-cluster.png)

<!-- toc -->

* [Specifications](#Specifications)
  * [NanoPi NEO3 based solution](#NanoPi-NEO3-based-solution)
  * [Raspberry Pi CM3 based solution](#Raspberry-Pi-CM3-based-solution)
  * [Software](#Software)
* [Installing Operating Systems](#Installing-Operating-Systems)
  * [Installing OS to NanoPi NEO3](#Installing-OS-to-NanoPi-NEO3)
  * [Installing OS to Raspberry Pi CM3](#Installing-OS-to-Raspberry-Pi-CM3)
* [Deploying K3S with help of Ansible](#Deploying-K3S-with-help-of-Ansible)
  * [Install all required packages on all servers](#Install-all-required-packages-on-all-servers)
  * [Deploy k3s server to controller](#Deploy-k3s-server-to-controller)
  * [Deploy k3s agent to nodes](#Deploy-k3s-agent-to-nodes)
* [Video blog about this project](#Video-blog-about-this-project)

<!-- tocstop -->

## Specifications

### NanoPi NEO3 based solution

- 1x D-Link DGS-1005A/c
- 4x Ethernet cable (with four copper pairs)
- 4x USB Type-C cable
- 4x Power supply adapter 5V/2A for USB devices
- 4x NanoPi NEO3 (CPU: quad-core, RAM: 2Gb)
- 4x MicroSD card 32Gb (by Samsung, the EVO series)

### Raspberry Pi CM3 based solution

- 1x D-Link DGS-1005A/c
- 2x Ethernet cable (with four copper pairs)
- 1x USB Type-C cable
- 1x Power supply adapter 5V/2A for USB devices
- 1x Power supply adapter 12V/5A for TuringPi board
- 1x [TuringPi V1](https://turingpi.com/v1/) cluster board
- 7x Raspberry Pi CM3 (CPU: quad-core, RAM: 1Gb)
- 1x Raspberry Pi 4B (CPU: quad-core, RAM: 8Gb)
- 8x MicroSD card 32Gb (by Samsung, the EVO series)

### Software

- Operating Systems on all devices in Ubuntu 20.04 LTS (or recent) for ARM64 CPUs;
- On controller should be installed `k3s server`;
- On all nodes should be installed `k3s agent`;
- All agents and controller should work from inside Docker container, for example with help of docker-compose;
- Deployment of `docker-compose.yml` and other following files should be made via [Ansible](https://www.ansible.com/).

## Installing Operating Systems

### Installing OS to NanoPi NEO3

On MicroSD cards will be used Ubuntu 20.04 LTS _Focal Fossa_ (or recent).

First download `Armbian_21.08.1_Nanopineo3_focal_current_5.10.60.img.xz` archive from:

https://armbian.hosthatch.com/archive/nanopineo3/archive/

Then extract an archive:

```shell script
xz -d Armbian_21.08.1_Nanopineo3_focal_current_5.10.60.img.xz
```

Then connect MicroSD card and check name of device:

```shell script
~$ sudo fdisk -l | grep 'model: Micro' -A 10 -B 2

Disk /dev/sdX: 29,81 GiB, 32010928128 bytes, 62521344 sectors
Disk model: Micro SD
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0000000
```

`/dev/sdX` is a device name of connected Micro SD card, your probably will be different.

Flash the image to this card:

```shell script
dd if=Armbian_21.08.1_Nanopineo3_focal_current_5.10.60.img of=/dev/sdX bs=1024k status=progress
```

Then wait some time.

> By default, size of created partition is about 800Mb, try to use `gparted` for increasing space to 32Gb

After flashing, you may connect a card to NanoPi NEO3, then turn on the device.

In a few seconds device will receive and IP address if you have DHCP server in your network,
try to [connect via SSH](https://docs.armbian.com/User-Guide_Getting-Started/#how-to-login).

* Username: `root`
* Password: `1234`

After first login NanoPi's prompt will ask you about a new password and some other things.

NanoPi is ready for usage, congrats :)

### Installing OS to Raspberry Pi CM3

On MicroSD cards will be used Ubuntu 20.04 LTS _Focal Fossa_ (or recent).

Need to install `rpi-imager` tool:

https://github.com/raspberrypi/rpi-imager

```shell script
sudo apt-get install rpi-imager
```

After need to run `rpi-image`, choose Ubuntu Server from **Other general purpose OS** section and select USB flash drive.

You also may preconfigure names of hosts, default login/pass and SSH key in settings of `rpi-imager`, for this just click to **cog** icon.

After you ready click to **Write** button and wait some time.

## Deploying K3S with help of Ansible

Here will be described part about installing additional tools to controller and nodes, plus about deploy
of docker-compose configs to machines.

First need to install ansible tool via package manager:

```
sudo apt-get install ansible
```

All commands below will be executed in `ansible` subfolder:

```
cd ansible
```

All hosts and groups described in `inventory` file, copy from example, then change to your hosts:

```
cp inventory.dist inventory
```

### Install all required packages on all servers

> playbook-default.yml

It's a default playbook, steps descrbed in this file should be execute on all
machines of cluster.

```
ansible-playbook -i inventory playbook-default.yml --ask-become-pass
```

### Deploy k3s server to controller

> playbook-controller.yml

K3S server is a core of our project, it will execute management operations.

Second service here is Rancher web-interface.

```
ansible-playbook -i inventory playbook-controller.yml --ask-become-pass
```

After executing this command API of Kubernetes cluster will be available on https://192.168.1.200:6443

### Deploy k3s agent to nodes

> playbook-node.yml

Now we just need add nodes to cluster controller, nodes will connect automatically:

```
ansible-playbook -i inventory playbook-node.yml
```

Then go to Rancher web-interface and look at Nodes tab.

## Video blog about this project

All videos on Russian language.

1. [Introduction and technical description](https://www.youtube.com/watch?v=jXRgqQrbKAo)
2. [Installing operation systems](https://www.youtube.com/watch?v=A4kwBo6eRKE)
3. Installing and using additional tools for automation
4. TBA...
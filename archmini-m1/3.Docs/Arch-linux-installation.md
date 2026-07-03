# Arch linux installation instructions:

## Connect to wifi

1. Once booted into the "Archiso tty", you want to connect to the internet. If connecting via wifi then run:

```
iwctl
```

**Once inside iwctl, list your wireless devices:**

```
device list
```

**Scan for networks (replace `wlan0` with your device name from above):**

```
station wlan0 scan
```

**List available networks:**

```
station wlan0 get-networks
```

**Connect to a network:**

```
station wlan0 connect "YourNetworkName"
```

It will prompt you for the password. After entering it, you should be connected.

**Exit iwctl:**

```
exit
```

Test your connect by running:

```
ping google.com

```

## If you want ssh into your device to set your configuration then you must install openssh, add password, and find your ip address.

1. Install openssh to be able to ssh into your device.

```
sudo pacman -S openssh

```

2. Add a password to ssh into your device. It will ask you to input your password and you need to re-enter to confirm

```
passwd
```

3. Get your ip address

```
ip a

```

Once you have your ip address then you can:

```
ssh root@192.168.50.211

```

From another device. This will give you the ability to scroll the terminal in a configured shell since you don't have that ability in the archiso tty.

```




```

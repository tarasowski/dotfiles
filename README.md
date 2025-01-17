# Thinkpad T14 Ubuntu Setup

## Fix the issue with Shure MV7 Microphone
- I replaced PulseAudio with PipeWire and now the MV7 works perfectly. I used the following PPA: https://github.com/pipewire-debian/pipewire-debian#1-ppa-configuration

## Change default keyboard mapping
- Here is the default keyd .conf file [.conf](https://github.com/tarasowski/thinkpad/blob/main/etc/keyd/default.conf)

## Add missing <> on US keyboard
- Sine in a german (macintosh) version on US keyboard the following keys are missing <> do the following:

```
sudo vi /usr/share/X11/xkb/symbols/de

# find this section
xkb_symbols "mac" {
    ...
};

# add this at the end
key <TLDE> { [ less, greater ] };

# run the command
sudo dpkg-reconfigure xkb-data

# log out and log in again

```

## Fix weird touchpad issues

```
sudo apt update
# this reinstalls the driver for the touchpad
sudo apt install --reinstall xserver-xorg-input-libinput
```



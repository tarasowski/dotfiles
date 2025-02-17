# Thinkpad T14 Ubuntu Setup

## Fix the issue with Shure MV7 Microphone
I replaced PulseAudio with PipeWire and now the MV7 works perfectly. I used the following PPA: https://github.com/pipewire-debian/pipewire-debian#1-ppa-configuration

## Change default keyboard mapping
Here is the default keyd .conf file [.conf](https://github.com/tarasowski/thinkpad/blob/main/etc/keyd/default.conf)

## Add missing <> on US keyboard
Sine in a german (macintosh) version on US keyboard the following keys are missing <> do the following:

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
# XP Pen Setup
- Pair power on + shortcut (first button)
- Download the drivers for Linux [download](https://www.xp-pen.com/download/deco-mw.html)
- Install Gromit-MPX
- Setup shortcuts for Gromit-MPX via Settings > Keyboard > View and customize shortcuts
- Launch Gromit: ctrl + d (gromit-mpx --toggle ↵)
- Clear Gomir: ctrl + o (gromit-mpx --clear && gromit-mpx --toggle ↵)

# Add .env profiles

```
function load_profile() {
    echo "Enter the profile name: "
    read profile_name
    if [ -f ~/.env/"$profile_name" ]; then
        source ~/.env/"$profile_name"
        # Update the PS1 prompt with the current profile name
        PS1="[$profile_name] $PS1"
        echo "Loaded profile: $profile_name"
    else
        echo "Using default profile 'mvpfoundry'."
        source ~/.env/mvpfoundry
        PS1="[mvpfoundry] $PS1"
    fi
}

load_profile
```
## Fix mouse precision
- set acceleration to flat via gnome-tweaks

```
gsettings set org.gnome.desktop.peripherals.touchpad speed 0.2
```

## Fix the touchpad issue clicking on any button down to highlight the text

- or open up `gnome-tweaks` go to `keyboard & mouse` go to mouse click emulation and activate mode `fingers` or run the command down below

```
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
``` 


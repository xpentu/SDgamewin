# sdgamewin

a small powershell script to start steam bigpicture and close explorer, imitating the steamos game mode. more of a aesthetic thing imo.

this is the first part of a small set of things im making for the steam deck.

## requirements

- windows
- powershell
- five minutes of your time

## installation

**[find the latest release](https://github.com/xpentu/sdgamewin/releases/latest)**. you have two choices. the result will be the same.

- download and run the latest installer.
- download the repository and run ```setup.ps1``` by right-clicking and selecting run with powershell.

setup is easy. just answer a few questions and the script will configure itself.

you'll be asked to select the steam executable, easy, right?

then you'll be asked if you want to set this to start on boot. done.  
**note:** you can always add the script to start on login later by running the following command in powershell:

```schtasks /create /tn 'gamemode startup' /tr 'powershell.exe -File ""$env:APPDATA\sdgamewin\gamemode.ps1""' /sc onstart```

## config

you can use any text editor to change the steam install directory in `config.cfg` located in the `%appdata%\sdgamewin` folder. just look for the line that starts with `SteamExePath` and update it to your desired steam installation directory.

## uninstallation

to uninstall, simply run `uninstall.ps1` located in the `%appdata%\sdgamewin` folder.

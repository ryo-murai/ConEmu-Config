ConEmu-Config
=============

My ConEmu settings.

## Usage
to run with this config, use `/LoadCfgFile` option. 

`ConEmu.exe /LoadCfgFile path-to-this-dir\ConEmu.xml` 

or generate a shortcut `ConEmu.lnk` by running `CreateConEmuShortCut.ps1`

or generate a jumplist by following steps.
 
## setup custom jump list
1. run `CreateConEmuJumpList.ps1` from *ConEmu Console*, then manually pin the created jump list for next use.
2. manually update the `Console Emulator` root shortcut with argument `/LoadCfgFile path-to-this-dir\ConEmu.xml`

## todo
* fix: path to msys sh.exe is invalid on 64 bit system
* (setup) pin the jumplist programmically
* (setup) update the shortcut programmically  
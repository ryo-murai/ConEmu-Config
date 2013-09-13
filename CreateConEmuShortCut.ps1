# create a shortcut to launch conemu with conemu.xml located here.
#  * command line options are
#    https://code.google.com/p/conemu-maximus5/wiki/Command_Line

$currDir = Split-Path $MyInvocation.MyCommand.Path
$conEmuDir = "C:\Program Files\ConEmu\"

$shell = New-Object -COM WScript.Shell
$shortcut = $shell.CreateShortcut("$currDir\ConEmu.lnk")
$shortcut.TargetPath = "$conEmuDir\ConEmu.exe"
$shortcut.Arguments = "/LoadCfgFile $currDir\ConEmu.xml"
$shortcut.WorkingDirectory = "$conEmuDir"
$shortcut.Description = "Console Emulator (x86)"
$shortcut.IconLocation = "$conEmuDir\ConEmu.exe, 0"
$shortcut.WindowStyle = 1
$shortcut.Save()

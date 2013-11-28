# this script creates a shortcut for ConEmu to run with conemu.xml in the current directory.
#  * refer to ConEmu command line options:
#    https://code.google.com/p/conemu-maximus5/wiki/Command_Line

$currDir = Split-Path $MyInvocation.MyCommand.Path
$conEmuDir = "${env:ProgramFiles}\ConEmu\"
$exePath = Get-ChildItem $conEmuDir -filter *.exe | select -first 1 | % {$_.FullName}

$shell = New-Object -COM WScript.Shell
$shortcut = $shell.CreateShortcut("$currDir\ConEmu.lnk")
$shortcut.TargetPath = $exePath
$shortcut.Arguments = "/LoadCfgFile $currDir\ConEmu.xml"
$shortcut.WorkingDirectory = "$conEmuDir"
$shortcut.Description = "Console Emulator"
$shortcut.IconLocation = "$exePath, 0"
$shortcut.WindowStyle = 1
$shortcut.Save()

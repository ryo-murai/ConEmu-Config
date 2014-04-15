# this script creates a link for the ConEmu.xml 

$currDir = Split-Path $MyInvocation.MyCommand.Path
$conEmuConf = "${env:APPDATA}\ConEmu.xml"

iex "cmd /c `"mklink $conEmuConf $currDir\ConEmu.xml`""

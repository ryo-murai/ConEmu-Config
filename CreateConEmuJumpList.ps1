function FindConEmuProc {
  # todo: check if number of processes
  Get-Process -name ConEmu | select -First 1
}

function InitCodePackDll {
  # todo: fail fast
  if(Test-Path $env:ChocolateyInstall) {
    #Microsoft.WindowsAPICodePack.dll
    #Microsoft.WindowsAPICodePack.Shell.dll
    Get-ChildItem $env:ChocolateyInstall -Filter Microsoft.WindowsAPICodePack*.dll -Recurse -File | 
     % { Add-Type -Path $_.FullName -ErrorAction Stop }
  }
}

function NewConEmuTask {
  param(
    [string]$exe, 
    [string]$param, 
    [string]$label, 
    [int]$icoRefIndex)

  Write-Host "creating links for exe:$exe, param:$param, label:$label, index:$icoRefIndex"

  $Link = new-object Microsoft.WindowsAPICodePack.Taskbar.JumpListLink `
   -ArgumentList $exe,$label
  $Link.Arguments = "$param"
  $Link.IconReference = new-object Microsoft.WindowsAPICodePack.Shell.IconReference `
   -ArgumentList $exe, $icoRefIndex

  $Link
}

function JumpListTasks {
  param([string]$currDir)
  $conEmuDir = "${env:ProgramFiles}\ConEmu\"
  $exePath = Get-ChildItem $conEmuDir -filter *.exe | select -first 1 | % {$_.FullName}
  Write-Host "found conemu exe at $exePath"
  
  $param = "/LoadCfgFile $currDir\ConEmu.xml"
  
  $Links = @(
    (NewConEmuTask -exe "$exePath" -param "$param /cmd {powershell}" -label "powershell" -icoRefIndex 0),
    (NewConEmuTask -exe "$exePath" -param "$param /cmd {msys}" -label "msys" -icoRefIndex 1),
    (NewConEmuTask -exe "$exePath" -param "$param /cmd {cmd}" -label "cmd" -icoRefIndex 2))

  $Links
}

function AddJumpListTasks {
  param(
    [Microsoft.WindowsAPICodePack.Taskbar.JumpListTask[]] $tasks,
    [System.Diagnostics.Process] $conEmuProc)

  #$isPfSup = [Microsoft.WindowsAPICodePack.Taskbar.TaskbarManager]::IsPlatformSupported
  $taskbarMgr = [Microsoft.WindowsAPICodePack.Taskbar.TaskbarManager]::Instance
  $taskbarMgr.ApplicationId = "ConEmu"
  $appId = $taskbarMgr.ApplicationId

  $JumpList = [Microsoft.WindowsAPICodePack.Taskbar.JumpList]::CreateJumpListForIndividualWindow(`
    $appId, $conEmuProc.MainWindowHandle)
  $JumpList.AddUserTasks($tasks)
  $JumpList.Refresh()
}

function Main {
  param([string]$currDir)

  try {
    $conEmuProc = FindConEmuProc
    InitCodePackDll
    $tasks = JumpListTasks -currDir $currDir
    AddJumpListTasks -tasks $tasks -conEmuProc $conEmuProc
  } catch {
    $_.Exception | Format-List * -Force
    throw
  }
}

$currDir = Split-Path $MyInvocation.MyCommand.Path

Main -currDir $currDir

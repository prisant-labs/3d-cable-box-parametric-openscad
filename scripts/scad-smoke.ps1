param(
  [string]$ScadFile = "cable-box-parametric.scad",
  [string]$OpenScadExe = "C:\Program Files\OpenSCAD\openscad.exe",
  [string]$OutDir = "ci-smoke-out"
)

$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$paramFile = Join-Path $OutDir 'scad-smoke-params.json'
'{"fileFormatVersion":"1","parameterSets":{"lid_only":{"Part_To_Render":"Lid Only"},"box_and_lid":{"Part_To_Render":"Box and Lid"}}}' | Set-Content -Path $paramFile

function Invoke-SmokeRender {
  param(
    [string]$OutFile,
    [string[]]$Defines = @(),
    [string[]]$ExtraArgs = @()
  )

  if (Test-Path $OutFile) { Remove-Item $OutFile -Force }

  $args = @('-o', $OutFile, $ScadFile)
  foreach ($def in $Defines) {
    $args += @('-D', $def)
  }
  $args += $ExtraArgs

  $stdout = [System.IO.Path]::GetTempFileName()
  $stderr = [System.IO.Path]::GetTempFileName()
  try {
    $proc = Start-Process -FilePath $OpenScadExe -ArgumentList $args -NoNewWindow -Wait -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
    $outputText = ((Get-Content $stdout -Raw) + "`n" + (Get-Content $stderr -Raw)).Trim()

    if ($proc.ExitCode -ne 0) {
      throw "OpenSCAD failed with exit code $($proc.ExitCode) for args: $($args -join ' ')`n$outputText"
    }

    if (!(Test-Path $OutFile)) {
      throw "OpenSCAD did not produce expected output '$OutFile' for args: $($args -join ' ')`n$outputText"
    }
  }
  finally {
    Remove-Item $stdout -Force -ErrorAction SilentlyContinue
    Remove-Item $stderr -Force -ErrorAction SilentlyContinue
  }
}

Invoke-SmokeRender -OutFile (Join-Path $OutDir '01_baseline.stl')
Invoke-SmokeRender -OutFile (Join-Path $OutDir '02_lid_only.stl') -ExtraArgs @('-p', $paramFile, '-P', 'lid_only')
Invoke-SmokeRender -OutFile (Join-Path $OutDir '03_slicing_preview.stl') -Defines @('Enable_Slicing=true', 'Slice_Count=2', 'Slice_Piece_To_Render=0') -ExtraArgs @('-p', $paramFile, '-P', 'box_and_lid')

$expectedFail = Join-Path $OutDir '04_expected_fail.stl'
if (Test-Path $expectedFail) { Remove-Item $expectedFail -Force }

$failArgs = @('-o', $expectedFail, $ScadFile, '-D', 'Enable_Slicing=true', '-D', 'Slice_Count=2', '-D', 'Slice_Piece_To_Render=3')
$stdout = [System.IO.Path]::GetTempFileName()
$stderr = [System.IO.Path]::GetTempFileName()
try {
  $proc = Start-Process -FilePath $OpenScadExe -ArgumentList $failArgs -NoNewWindow -Wait -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
  $outputText = ((Get-Content $stdout -Raw) + "`n" + (Get-Content $stderr -Raw)).Trim()

  if (Test-Path $expectedFail) {
    throw 'Expected fail case produced STL unexpectedly.'
  }

  if ($outputText -notmatch 'Assertion') {
    throw "Expected fail case did not report assertion failure.`n$outputText"
  }
}
finally {
  Remove-Item $stdout -Force -ErrorAction SilentlyContinue
  Remove-Item $stderr -Force -ErrorAction SilentlyContinue
}

Write-Host 'SCAD smoke checks completed'

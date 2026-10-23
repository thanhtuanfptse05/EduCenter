[CmdletBinding()]
param([switch]$Integration, [switch]$Serve, [switch]$Fixture, [int]$Port = 18080)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$antCommand = Get-Command ant -ErrorAction SilentlyContinue
$antPath = if ($antCommand) { $antCommand.Source } else { 'C:/Program Files/NetBeans-17/netbeans/extide/ant/bin/ant.bat' }
if (-not (Test-Path -LiteralPath $antPath)) { throw 'Set up Apache Ant or NetBeans 17 before running verification.' }
if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'build/tools/tomcat/catalina.jar'))) {
    $tomcatDir = 'C:\Program Files\Apache Software Foundation\Tomcat 10.1'
    if (Test-Path $tomcatDir) {
        New-Item -ItemType Directory -Force -Path (Join-Path $projectRoot 'build/tools/tomcat') | Out-Null
        Copy-Item "$tomcatDir\lib\*.jar" (Join-Path $projectRoot 'build/tools/tomcat\')
        Copy-Item "$tomcatDir\bin\tomcat-juli.jar" (Join-Path $projectRoot 'build/tools/tomcat\')
    } else {
        throw 'Copy the local Tomcat 10.1 lib/*.jar and bin/tomcat-juli.jar into build/tools/tomcat before verification.'
    }
}
Push-Location -LiteralPath $projectRoot
try {
    $target = if ($Serve) { 'repair-serve' } elseif ($Integration) { 'repair-integration' } else { 'verify' }
    $ErrorActionPreference = 'Continue'
    & $antPath '-f' 'build.xml' "-Drepair.port=$Port" "-Drepair.fixture=$($Fixture.IsPresent.ToString().ToLowerInvariant())" $target
    $antExitCode = $LASTEXITCODE
    $ErrorActionPreference = 'Stop'
    if ($antExitCode -ne 0) { throw "Ant $target failed ($antExitCode)." }
} finally { Pop-Location }

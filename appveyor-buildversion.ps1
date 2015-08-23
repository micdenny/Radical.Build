$checkVersion = "$Env:APPVEYOR_BUILD_VERSION" -match "^(?<major>[0-9]+)\.(?<minor>[0-9]+)\.(?<patch>([0-9]+))(-(?<prerelease>[a-zA-Z0-9]+))?(\+(?<build>([0-9]+)))(-(?<random>[a-z0-9]+))?$"
if (!$checkVersion) {
	Write-Error "The version number specified is not valid. You must enter a valid semantic version (2.0): Major.Minor.Patch-PreRelease+Build-Random (e.g.: 1.5.2-Alpha1+{build}-{random}). Pre-release, build and random number are optional. Random number is appended by appveyor just when building pull requests." -Category InvalidArgument
	$host.SetShouldExit(666)
	exit
}

$major = $matches['major'] -as [int]
$minor = $matches['minor'] -as [int]
$patch = $matches['patch'] -as [int]
$prerelease = $matches['prerelease']
$build = $matches['build'] -as [int]
      
$assemblyVersion = "$major.$minor.$patch.0"
$assemblyFileVersion = "$major.$minor.$patch.$build"
if ($prerelease) {
	$assemblyInformationalVersion = "$major.$minor.$patch-$prerelease+$build"
	$packageVersion = "$major.$minor.$patch-$prerelease"
} else {
	$assemblyInformationalVersion = "$major.$minor.$patch+$build"
	$packageVersion = "$major.$minor.$patch"
}

if ($Env:use_build_number_in_packages) {
	$packageVersion = "$packageVersion-$build"
}
      
Set-AppveyorBuildVariable -Name "assembly_major" -Value "$major"
Set-AppveyorBuildVariable -Name "assembly_minor" -Value "$minor"
Set-AppveyorBuildVariable -Name "assembly_patch" -Value "$patch"
Set-AppveyorBuildVariable -Name "assembly_prerelease" -Value "$prerelease"
Set-AppveyorBuildVariable -Name "assembly_build" -Value "$build"
      
Set-AppveyorBuildVariable -Name "assembly_version" -Value "$assemblyVersion"
Set-AppveyorBuildVariable -Name "assembly_file_version" -Value "$assemblyFileVersion"
Set-AppveyorBuildVariable -Name "assembly_informational_version" -Value "$assemblyInformationalVersion"
Set-AppveyorBuildVariable -Name "package_version" -Value "$packageVersion"
      
Write-Host "Assembly Version: $assemblyVersion"
Write-Host "Assembly File Version: $assemblyFileVersion"
Write-Host "Assembly Informational Version: $assemblyInformationalVersion"
Write-Host "Package Version: $packageVersion"
[cmdletbinding()]
param (
    $Architecture,
    $Destination,
    $locale = "en-us"
)

#
# Environment Variables
#
$TEMPL = "media"
$FWFILES = "fwfiles"

$WinKitsPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit"
$WinPEPath = "$WinKitsPath\Windows Preinstallation Environment"
$DandlPath = "$WinKitsPath\Deployment Tools"

# Constructing tools paths relevant to the current Processor Architecture
$DISMPath = "$DandlPath\$env:PROCESSOR_ARCHITECTURE\DISM"
$BCDBootPath = "$DandlPath\$env:PROCESSOR_ARCHITECTURE\BCDBoot"
$ImagingRoot = "$DandlPath\$env:PROCESSOR_ARCHITECTURE\Imaging"
$OSCDImgPath = "$DandlPath\$env:PROCESSOR_ARCHITECTURE\Oscdimg"
$WdsmcastPath = "$DandlPath\$env:PROCESSOR_ARCHITECTURE\Wdsmcast"

# Now do the paths that apply to all architectures
$HelpIndexerRoot = "$DandlPath\HelpIndexer"
$WSIMPath = "$DandlPath\WSIM"

# Copy Windows PE sources to destination directory.
.\Copy-WinPE.ps1 -Architecture $Architecture -Destination $Destination

# Mount Windows PE boot.wim
Mount-WindowsImage -ImagePath "$Destination\$TEMPL\sources\boot.wim" -Path "$Destination\mount" -Index 1 -CheckIntegrity

# Add Powershell Support
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\WinPE-WMI.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\$locale\WinPE-WMI_$locale.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\WinPE-NetFX.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\$locale\WinPE-NetFX_$locale.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\WinPE-Scripting.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\$locale\WinPE-Scripting_$locale.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\WinPE-Powershell.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\$locale\WinPE-Powershell_$locale.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\WinPE-StorageWMI.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\$locale\WinPE-StorageWMI_$locale.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\WinPE-DismCmdlets.cab" -Path "$Destination\mount"
Add-WindowsPackage -PackagePath "$WinPEPath\$Architecture\WinPE_OCs\$locale\WinPE-DismCmdlets_$locale.cab" -Path "$Destination\mount"

# Dismount image and save changes to image
Dismount-WindowsImage -Path "$Destination\mount" -Save -CheckIntegrity
<#
	.SYNOPSIS
		Backup files using Robocopy.

	.DESCRIPTION
		Read a list of folders from Folders.txt and back up those folders using Robocopy.

	.PARAMETER Destination
		Destination directory for backup. By default, the folder the script is running in will be used.

	.EXAMPLE
		PS C:\>Backup-Safely.ps1 -Destination C:\Backup

#>
param(
	[string]$Destination = $PSScriptRoot
)

Set-StrictMode -Version 3.0
#Requires -Version 5.1

# $Folder: Source folder for files being backed up. Used to include folder from Folders.txt in the backup.
# This is more organized than simply dumping files into the backup directory.
Write-Verbose -Message "Reading folder list..."
Get-Content -Path "$PSScriptRoot\Folders.txt" | ForEach-Object {
	$Folder = Split-Path -Path $_ -Leaf
	# Robocopy parameters: -E copies subdirectories. -TEE triggers verbose output.
	Write-Debug -Message "Current folder is $_."
	robocopy $_ ($Destination + "/" + "$Folder") -E -TEE
}
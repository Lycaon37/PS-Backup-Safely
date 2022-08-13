New-Item -ItemType File -Force -Path "$PSScriptRoot\Folders.txt" | Out-Null
do { 
	Write-Information -MessageData ("This interactive menu is controllable by hotkeys:
	- Arrow up/down: Navigate menu items.
	- Enter: Select menu item..
	- Page up/down: Go one page up or down - if the menu is larger then the screen.
	- Home/end: Go to the top or bottom of the menu.
	- Escape: Quit the menu." ) -InformationAction Continue
	$Choice = Show-Menu -MenuItems @(
		"Add Folder"
		"Remove Folder"
		"View Folder List"
	)

	switch ($Choice) {
		"Add Folder" {
			Add-Type -AssemblyName System.Windows.Forms
			Push-Location
			$FileBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
			  ShowNewFolderButton = $true
			  RootFolder = 'Desktop'
			}
			Pop-Location
			if($FileBrowser.ShowDialog() -ne "OK") {
				Write-Information -Message "Selection canceled." -InformationAction Continue
				Read-Host "Press any key to return to the main menu"
			}
			else {
				$NewFolder = $FileBrowser.SelectedPath
				$FileContents = Get-Content $PSScriptRoot\Folders.txt
				if($FileContents -contains $NewFolder) {
					Write-Error -Message "Folder is already in the list."
					Read-Host "Press any key to return to the main menu"
				}
				else { Add-Content -Value "$NewFolder" $PSScriptRoot\Folders.txt }
			}
		}

		"Remove Folder" {
			if (-not(Get-Content -Path "$PSScriptRoot\Folders.txt")) {
				Write-Error "Folder list is already empty."
				Read-Host "Press any key to return to the main menu"
			}
			else {
			$BadFolder = Show-Menu -MenuItems @(Get-Content -Path "$PSScriptRoot\Folders.txt")
			# Output of Get-Content is saved as otherwise file was held up when attempting to write to it.
			$Contents = Get-Content $PSScriptRoot\Folders.txt | Where-Object {$_ -ne "$BadFolder"}
			if (-not($Contents)) {
				Clear-Content $PSScriptRoot\Folders.txt
			}
			else {
				$Contents | Set-Content $PSScriptRoot\Folders.txt
			}
			Write-Verbose -Message "Removed $BadFolder from the folder list."
			}
		}

		"View Folder List" {
			$FolderList = Get-Content $PSScriptRoot\Folders.txt
			if (-not($FolderList)) { Write-Information -MessageData "Folder list is empty." -InformationAction Continue}
			else { Write-Information -MessageData $FolderList -InformationAction Continue }
			Read-Host "Press any key to return to the main menu"
		}
	}
	Clear-Host
} until ($null -eq $Choice)
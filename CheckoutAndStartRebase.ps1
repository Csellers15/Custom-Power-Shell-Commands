Function CheckoutAndStartRebase {
	$ChangedFileCount = $(git status --porcelain | Measure-Object | Select-Object -expand Count)
	$currentBranch = git branch --show-current 

	if ($ChangedFileCount -gt 0)
	{
		Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
		Write-Output "Found $ChangedFileCount changed files" -ForegroundColor 'DarkGreen'
		Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
		Write-Host ''
		Write-Host ''

		git stash save "Rebase Stash"
	}

	Write-Host ''
	Write-Host ''
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	Write-Host "Checking Out Main" -ForegroundColor 'DarkGreen'
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	git checkout main 

	Write-Host ''
	Write-Host ''
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	Write-Host "Pulling Main" -ForegroundColor 'DarkGreen'
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	git pull

	Write-Host ''
	Write-Host ''
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	Write-Host "Checking out $currentBranch"-ForegroundColor 'DarkGreen'
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	git checkout $currentBranch

	Write-Host ''
	$isInteractive = Read-Host -Prompt 'Enter ''Y'' to do interactive rebase or anything else will do a non interactive rebase'
	if ($isInteractive.ToUpper() -eq 'Y') {
		git rebase -i main 
	} else {
		git rebase main 
	}
	
	#Redoing this command to verify we are not on main before pushing
	$currentBranch = git branch --show-current 
	$forcePush = Read-Host -Prompt 'Enter ''Y'' to do interactive rebase or anything else will do a non interactive rebase'
	if(($currentBranch -ne "main") -and ($forcePush.ToUpper() -eq 'Y')){
		git push --force
	}
	
	if ($ChangedFileCount -gt 0){
		$shouldGetUncommitedFiles = Read-Host -Prompt 'Enter ''Y'' to pop uncommited changes back onto your branch'
		if ($shouldGetUncommitedFiles.ToUpper() -eq 'Y') {
			git stash pop
		} else{
			Write-Host '=============================================================' -ForegroundColor 'DarkYellow'
			Write-Host 'Your uncommited chnages on $currentBranch will be in your stash under the entry ''Rebase Stash'' '-ForegroundColor 'DarkYellow'
			Write-Host '=============================================================' -ForegroundColor 'DarkYellow'
		}
	}
}

CheckoutAndStartRebase

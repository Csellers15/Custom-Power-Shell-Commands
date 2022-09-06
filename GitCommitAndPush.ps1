function GitCommitAndPush {
	Write-Host '=============================================================' -ForegroundColor 'DarkMagenta';
	Write-Host '=============================================================' -ForegroundColor 'DarkMagenta';
	Write-Host "THIS WILL ONLY WORK IF YOU WANT TO COMMIT ALL CHANGES" -ForegroundColor 'DarkMagenta';
	Write-Host '=============================================================' -ForegroundColor 'DarkMagenta';
	Write-Host '=============================================================' -ForegroundColor 'DarkMagenta';


	$ChangedFileCount = $(git status --porcelain | Measure-Object | Select-Object -expand Count)
	$currentBranch = git branch --show-current
	$doesNotExistInRemote = git ls-remote --exit-code . origin/$currentBranch /dev/null

	if($ChangedFileCount -eq 0) {
		Write-Host '' 
		Write-Host ''
		Write-Host '=============================================================' -ForegroundColor 'DarkRed';
		Write-Host "You have no files to commit ------ Exiting" -ForegroundColor 'DarkRed';
		Write-Host '=============================================================' -ForegroundColor 'DarkRed';
		exit
	}

	Write-Host '' 
	Write-Host ''
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	$commitMessage = Read-Host -Prompt 'Enter a commit message'
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'

	git add .
	git commit -m "$commitMessage";

	if ($LASTEXITCODE -ne 0) {
		Write-Host '=============================================================' -ForegroundColor 'DarkRed';
		Write-Host "Must Fix errors/warnings order to commit" -ForegroundColor 'DarkRed';
		Write-Host '=============================================================' -ForegroundColor 'DarkRed';
		exit
	}

	Write-Host $doesNotExistInRemote

	if($null -eq $doesNotExistInRemote) {
		Write-Host '' 
		Write-Host ''
		Write-Host '=============================================================' -ForegroundColor 'DarkYellow'
		Write-Host 'Upstream branch not found' -ForegroundColor 'DarkYellow';
		Write-Host '=============================================================' -ForegroundColor 'DarkYellow'
		Write-Host ''
		Write-Host 'Setting upstream and Pushing' -ForegroundColor 'DarkGreen';
		Write-Host '' 
		Write-Host ''
		

		git push --set-upstream origin $currentBranch
	} else {
		git push 
	}
}

GitCommitAndPush

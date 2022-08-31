Function CleanOldGitBranches {
	# Prune branches
	Write-Host ''
	git remote prune origin;
	Write-Host ''
	# List local branches
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	Write-Host 'Here''s all of the branches I see along with their upstreams' -ForegroundColor 'DarkGreen'
	Write-Host '=============================================================' -ForegroundColor 'DarkGreen'
	git branch -vv
	Write-Host ''
	# Pipe output from previous command to string match to find only those with deleted upstreams
	# then pipe THAT output to the actual delete command
	Write-Host '=============================================================' -ForegroundColor 'DarkYellow'
	Write-Host 'Here are the branches I''m gonna nuke.  Better make sure you don''t want to keep any of these!' -ForegroundColor 'DarkYellow'
	Write-Host '=============================================================' -ForegroundColor 'DarkYellow'
	git branch -vv | where { $_ -match '(\[origin\/.*: gone\])|^((?!\[origin).)*$' } | foreach { $_.split(" ", [StringSplitOptions]'RemoveEmptyEntries')[0] }
	Write-Host ''
	# Delete the branches! (After confirmation prompt)
	Write-Host '=============================================================' -ForegroundColor 'Red'
	Write-Host 'THIS IS THE PART WHERE WE DELETE BRANCHES - Review these ^^^^' -ForegroundColor 'Red'
	Write-Host '=============================================================' -ForegroundColor 'Red'
	$Proceed = Read-Host -Prompt 'Wanna nuke them all?  Enter ''Y'' to proceed or anything else to bail out'
	if ($Proceed.ToUpper() -eq 'Y') {
		Write-Host 'OK.  Here we go!' -ForegroundColor 'DarkGreen'
		git branch -vv | where { $_ -match '(\[origin\/.*: gone\])|^((?!\[origin).)*$' } | foreach { git branch -D ($_.split(" ", [StringSplitOptions]'RemoveEmptyEntries')[0]) }
		Write-Host 'Gone.  Only the reflog can save you now' -ForegroundColor 'DarkGreen'
	}
	else {
		Write-Host 'Okey Doke.  Not doing anything.' -ForegroundColor 'DarkGreen'
	}
}

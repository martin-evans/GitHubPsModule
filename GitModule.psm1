function Create-GitHubHeaders(){
	$token= GitHubPersonalAccessToken
	$headers = @{}                                                                                                                                                                                     
	$headers.Add("Authorization","Bearer $token")
	return $headers
}

<#
	.SYNOPSIS
		New-GitHubRepo

	.DESCRIPTION
		Creates a new GitHub repo on a user account
		
	.LINK
		https://developer.github.com/v3/repos/#create

	.PARAMETER  repoName
		The name of the repo to be created

	.PARAMETER  private
		Creates the repo as private when set
	
	.EXAMPLE
		PS C:\> New-GitHubRepo -repoName "MyRepo"
		Creates a new public repo on GitHub named "MyRepo", for the specified user

	.EXAMPLE
		PS C:\> New-GitHubRepo -repoName "MyRepo" -private
		Creates a new private repo on GitHub named "MyRepo", for the specified user

#>
function New-GitHubRepo(){

[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[String]$repoName,
		[Parameter()]
		[switch]$private = $false
	)

	if(-NOT(Token-Present))
	{
		return;
	}
	
	$body= @{ 
		name="$repoName"; 
		description="test description"; 
		homepage="https://github.com"; 
		private= $private; 
		gitignore_template = "VisualStudio" 
		}
		
	$j = (ConvertTo-Json $body)
	$headers = Create-GitHubHeaders

	Invoke-WebRequest  -Uri "https://api.github.com/user/repos" -Method Post -Body $j -Headers $headers -UseBasicParsing
}


<#
	.SYNOPSIS
		Remove-GitHubRepo

	.DESCRIPTION
		deletes a GitHub repo
		
	.LINK
		https://developer.github.com/v3/repos/#delete-a-repository

	.PARAMETER  repoName
		The name of the repo to be deleted
	
	.EXAMPLE
		PS C:\> Remove-GitHubRepo -repoName "MyRepo"
		Creates a new public repo on GitHub named "MyRepo", for the specified user
	

#>
function Remove-GitHubRepo(){

[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[String]$repoName
	)
  
	if(-NOT(Token-Present))
	{
		return;
	}
  
	$headers = Create-GitHubHeaders
	
	$accountName = Get-GitHubPersonalAccountName
	
	Invoke-WebRequest  -Uri "https://api.github.com/repos/$accountName/$repoName" -Method DELETE -Headers $headers -UseBasicParsing
   
}


<#
	.SYNOPSIS
		Add-Collaborator

	.DESCRIPTION
		Adds GitHubUsers as collaborrators to an existing GitHub repository
		
	.LINK
		https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator

	.PARAMETER  repoName
		The name of the repo to be deleted

	.PARAMETER  gitHubUserNames
		A list of gitHub usernames to be added as collaborator

	
	.EXAMPLE
		PS C:\> Add-Collaborator -repoName "MyRepo" -gitHubUserName "johnsmith"
		Adds GitHub username JohnSmith as the collaborator to the repo MyRepo
	

#>
function Add-Collaborator(){

[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[String] $repoName,
		[Parameter(Mandatory=$true)]
		[String[]] $gitHubUserNames
	)
		
	if(-NOT(Token-Present))
	{
		return;
	}

	$headers = Create-GitHubHeaders
	$headers.Add("Content-Length",0)	
	
	$accountName = Get-GitHubPersonalAccountName

	foreach ($username in $gitHubUserNames)
	{
	
		$url = "https://api.github.com/repos/$accountName/$repoName/collaborators/$gitHubName"
	
		write-host "Adding $username as collaborator to repo $repoName"	
	
		Invoke-WebRequest  -Uri $url -Method PUT -Headers $headers -UseBasicParsing                                                                     
	}
}


<#
	.SYNOPSIS
		Set-GitHubPersonalAccessToken

	.DESCRIPTION
		Saves the supplied personal access token for use in GitHub API interactions
		
	.LINK
		https://github.com/settings/tokens


	.PARAMETER  token
		The Personal Access token value supplied by GitHub to be used to identify the user account when perfoming API requests

	.EXAMPLE
		PS C:\> Set-GitHubPersonalAccessToken -token "abjkhi121121kjkjk"

#>
function Set-GitHubPersonalAccessToken(){

[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[String] $token
	)

	[Environment]::SetEnvironmentVariable("GitHubPersonalAccessToken",$token,"User")
}

<#
	.SYNOPSIS
		Clear-GitHubPersonalAccessToken

	.DESCRIPTION
		rtemoves the saved personal access token for use in GitHub API interactions
		
	.LINK
		https://github.com/settings/tokens

	.PARAMETER  token
		The Personal Access token value supplied by GitHub to be used to identify the user account when perfoming API requests

	.EXAMPLE
		PS C:\> Clear-GitHubPersonalAccessToken

#>

function Clear-GitHubPersonalAccessToken(){
	[Environment]::SetEnvironmentVariable("GitHubPersonalAccessToken",$null,"User")
}


<#
	.SYNOPSIS
		Set-GitHubPersonalAccountName

	.DESCRIPTION
		Saves the supplied personal GitHub profile name for use in GitHub API interactions
		
	.LINK
		https://github.com/settings/profile

	.PARAMETER  userName
		The profile name to be used to identify the user account when perfoming API requests

	.EXAMPLE
		PS C:\> Set-GitHubPersonalAccessToken -token "abjkhi121121kjkjk"

#>
function Set-GitHubPersonalAccountName(){

[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[String] $userName
	)

	[Environment]::SetEnvironmentVariable("GitHubPersonalAccountName",$userName,"User")
}


<#
	.SYNOPSIS
		Clear-GitHubPersonalAccountName

	.DESCRIPTION
		removes the profile name used in GitHub API interactions
		
	.LINK
		https://github.com/settings/profile

	
	.EXAMPLE
		PS C:\> Clear-GitHubPersonalAccountName

#>

function Clear-GitHubPersonalAccountName(){
	[Environment]::SetEnvironmentVariable("GitHubPersonalAccountName",$null,"User")
}

function Get-GitHubPersonalAccessToken(){
	[Environment]::GetEnvironmentVariable("GitHubPersonalAccessToken","User")
}

function Get-GitHubPersonalAccountName(){
	[Environment]::GetEnvironmentVariable("GitHubPersonalAccountName","User")
}

function Token-Present(){

	$ret = $true

	if((Get-GitHubPersonalAccessToken) -eq $null){
		Write-Host "Personal Access Token NOT set"  -ForegroundColor DarkYellow
		Write-Host "Create a personal access token at https://github.com/settings/tokens then use Set-GitHubPersonalAccessToken to save it as an environment variable for future use."
		
		$ret = $false
	}
	
	
	if((Get-GitHubPersonalAccountName) -eq $null){
		Write-Host "GitHub username NOT set"  -ForegroundColor DarkYellow
		Write-Host "Use Set-GitHubPersonalAccountName to save it as an environment variable for future use."
		
		$ret = $false
	}
	
	
	return $ret
	
}

Token-Present

Set-Alias nghr New-GitHubRepo -Description "Creates new GitHub repo"
Set-Alias rghr Remove-GitHubRepo-GitHubRepo -Description "Deletes GitHub repo"

export-modulemember -alias * -function 	New-GitHubRepo,
										Remove-GitHubRepo, 
										Add-Collaborator, 
										New-RepoWithCollaborator, 
										Set-GitHubPersonalAccessToken,
										Set-GitHubPersonalAccountName,
										Clear-GitHubPersonalAccessToken									
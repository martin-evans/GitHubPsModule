# GitHubPsModule #

This repo contains a Powershell Module to assisit in interacting with the GitHub API.

## The problem ##
I needed to be able to quickly create a git hub repo and other github users as a collaborator. Manually, this was an interruption to my workflow.
I also wanted the opportunity to learn more about the GitHub Api : https://developer.github.com/v3/ and brush up on my powershell :-)
	
## GitModule.psm1 ##
This is a simple powershell module that may be referenced and invoked when needed to  create and delete personal repositories. For wexisting repositories, you'll be able to add collaborators.
	
	
When the Module is referenced, you'll be prompted to provide your username and a personal access token that you'll have to generate via your GitHub account at https://github.com/settings/tokens
You'll have to supply these criteria before the module will work. Once supplied you'll no longer be prompted.

For a full list of available commands offered by the module, from a PS Command line, run the command
	
> Get-Command -Module GitModule

	


﻿<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Invoke-Scans
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [Parameter(Position=0)]
        [ValidateNotNullOrEmpty()]
        $Path
    )

    Begin
    {
    }
    Process
    {
    }
    End
    {
        $scanModuleScripts = Get-ChildItem -Path $path -Filter "ScanModule*.psm1"
        foreach ($script in $scanModuleScripts)
        {
            Write-Verbose "Loading module $($script.BaseName)"
            Import-Module $script.FullName
        }

        $scanModules = Get-Module | Where-Object Name -Match "ScanModule"
        
        $scanModuleFunctions = $scanModules | Select-Object @{Label="Command"; Expression = {$_.ExportedCommands.Keys.GetEnumerator()}}

        foreach ($function in ($scanModuleFunctions))
        {
            $command = $function.Command
            $moduleID = $command.TrimStart("Get-")
            $computerName = $env:COMPUTERNAME
            $date = Get-Date -Format "yyyy-MM-dd"

            Write-Verbose "Executing $($function.Command)"
            $results = [scriptblock]::Create($function.Command).Invoke()

            #Write-Outp#ut $results

            $results | Write-ScanResults -Path 'C:\temp\ScriptgamesTemp' -ModuleName $moduleID -Computer $computerName -Password 'ScriptingGames' -SerializeAs JSON
            
        }

    }
}

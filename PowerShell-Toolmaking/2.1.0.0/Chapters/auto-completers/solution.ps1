$sb = {
    param (
      $commandName, 
      $parameterName, 
      $wordToComplete, 
      $commandAst, 
      $fakeBoundParameter
      )

    Get-Verb -Verb "$wordToComplete*" |
    ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_.Verb,$_.Verb,
        'ParameterValue',("Group: $($_.Group)"))
    }
}

$params = @{
 CommandName = "Get-Command"
 ParameterName = "Verb"
 ScriptBlock  = $sb
}

Register-ArgumentCompleter @params
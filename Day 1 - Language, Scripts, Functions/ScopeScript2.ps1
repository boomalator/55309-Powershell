Function FunctionScope
{
    ''
    'Changing $MyVar in the local function scope...'
    $local:MyVar = "This is MyVar in the function's local scope."
    'Changing $MyVar in the script scope...'
    $script:MyVar = 'MyVar used to be set by a script. Now set by a function.'
    'Changing $MyVar in the global scope...'
    $global:MyVar = 'MyVar was set in the global scope. Now set by a function.'
    ''
    'Checking $MyVar in each scope...'
    "Local: $local:MyVar"
    "Script: $script:MyVar"
    "Global: $global:MyVar"
    ''
}
''
'Getting current value of $MyVar.'
"MyVar says $MyVar"
''
'Changing $MyVar by script.'
$MyVar = 'I got set by a script!'
"MyVar says $MyVar"

FunctionScope

'Checking $MyVar from script scope before exit.'
"MyVar says $MyVar"
''
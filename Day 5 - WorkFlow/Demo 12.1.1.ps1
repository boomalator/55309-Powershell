Import-Module PSWorkflow

workflow Test-Workflow {
    
    $a = 1
    "A is $a after a=1"

    $a++
    "A is $a after a++"

    $b = $a + 2
    "B is $b ater $a + 2"

}

Test-Workflow

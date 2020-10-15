Workflow Test-Workflow {
    "$((get-date).tostring('mm:ss.fff')) This will run first"

    parallel {

        "$((get-date).tostring('mm:ss.fff')) Command 1"
 
 
        "$((get-date).tostring('mm:ss.fff')) Command 2"
    
        sequence {
            "$((get-date).tostring('mm:ss.fff')) Command A"
            Start-Sleep -Seconds 5
            "$((get-date).tostring('mm:ss.fff')) Command B"
            }

        Sequence { 
            Start-Sleep -Seconds 3         
            "$((get-date).tostring('mm:ss.fff')) Command 3"
            }
 
   }
}

"$((get-date).tostring('mm:ss.fff')) Workflow compiling starts..."

Test-Workflow
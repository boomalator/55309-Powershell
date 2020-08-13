Workflow Test-Workflow {
    "This will run first"

    parallel {
        "$((get-date).tostring('mm:ss.fff')) Command 1"
        Sequence { 
            Start-Sleep -Seconds 3         
            "$((get-date).tostring('mm:ss.fff')) Command 3"
            }
        "$((get-date).tostring('mm:ss.fff')) Command 2"
    
        sequence {
            "$((get-date).tostring('mm:ss.fff')) Command A"
            Start-Sleep -Seconds 2
            "$((get-date).tostring('mm:ss.fff')) Command B"
        }
    }
}


Test-Workflow
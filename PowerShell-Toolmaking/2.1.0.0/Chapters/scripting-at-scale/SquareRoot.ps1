Function SquareRoot {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [int[]]$Value
    )

    Begin {
        Write-Verbose "[BEGIN  ] Starting: $($MyInvocation.Mycommand)"
    } #begin

    Process {
        foreach ($item in $value) {
            [pscustomobject]@{
                Value      = $item
                SquareRoot = [math]::Sqrt($item)
            }
        }
    } #process

    End {
        Write-Verbose "[END    ] Ending: $($MyInvocation.Mycommand)"
    } #end
}

<#
test performance

$n = 1..1000
measure-command { $n | squareroot}
measure-command { squareroot $n }

10,100,500,1000,5000,10000 | foreach {
 $n = 1..$_
 $pipe = (measure-command { $n | squareroot}).totalMilliseconds
 $param = (measure-command {squareroot $n}).TotalMilliseconds

 [pscustomobject]@{
  ItemCount = $_
  PipelineMS = $pipe
  ParameterMS = $param
  PctDiff = 100 - (($param/$pipe) * 100 -as [int])
 }
}
#>


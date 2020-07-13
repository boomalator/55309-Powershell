Param(
	[string]$UserLevel
)
DynamicParam {
	If ($UserLevel -eq "Administrator") {
		# create an $AdminType parameter
		$attr = New-Object System.Management.Automation.ParameterAttribute
		$attr.HelpMessage = "Enter admin type"
		$attr.Mandatory = $true
		$attr.ValueFromPipelineByPropertyName = $true
		$attrColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
		$attrColl.Add($attr)
		$param = New-Object System.Management.Automation.RuntimeDefinedParameter('AdminType',[string],$attrColl)
		$dict = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
		$dict.Add('AdminType',$param)
		return $dict
	}
}
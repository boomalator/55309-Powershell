
#get hotfix data
$data = Get-HotFix -ComputerName $env:computername | 
Select-Object -property Caption,InstalledOn,InstalledBy,HotfixID,Description

#create a name mapping hashtable
$map = [ordered]@{
    'update-id' = 'HotFixID'
    'update-type' = 'Description'
    'install-date' = 'InstalledOn'
    'install-by' = 'InstalledBy'
    caption = 'Caption'
}

#create document
[xml]$Doc = New-Object System.Xml.XmlDocument

#create declaration
$dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)

#append to document
$doc.AppendChild($dec) | Out-Null

#create a comment and append it in one line
$text = @"

Hotfix Inventory
$(Get-Date)

"@

$doc.AppendChild($doc.CreateComment($text)) | Out-Null

#create root Node
$root = $doc.CreateNode("element","Computer",$null)

#create a Name tag
$name = $doc.CreateElement("Name")

#set the value
$name.InnerText = $env:computername

$root.AppendChild($name) | Out-Null

#create the hotfixes node
$hf = $doc.CreateNode("element","Updates",$null)

#loop through the data and create an entry for each one
foreach ($item in $data) {
    $h = $doc.CreateNode("element","Update",$null)
    #create the entry values from the mapping hash table
    $map.GetEnumerator() | foreach-object {
      $e = $doc.CreateElement($_.Name)
      $e.innerText = $item.$($_.value)
      #append to Update
      $h.AppendChild($e) | Out-Null
    }
    #append the element
    $hf.AppendChild($h) | Out-Null
}

#append the Updates node to the root
$root.AppendChild($hf) | Out-Null

#append root to document
$doc.AppendChild($root) | Out-Null

#save file
$doc.Save("c:\work\hotfix.xml")

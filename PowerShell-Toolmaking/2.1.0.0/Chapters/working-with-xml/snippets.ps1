Return "This is a snippets file not a script to run."

# exporting drive information
Get-CimInstance win32_logicaldisk -filter "drivetype=3" |
Export-Clixml .\ disks.xml


# import the file
$d = Import-Clixml .\disks.xml


# importing native XML
[xml]$data = Get-Content .\BandData.xml

# manipulate the data
$data.bands.band | Select-Object -property @{Name="Name";Expression = {$_.name.'#text'}},
@{Name="Founded";Expression={$_.name.Year}},
@{Name="Lead";Expression={$_.lead}},
@{Name="Members";Expression={$_.members.member}}

# filtering
$p = $data.bands.band | where {$_.Name.'#text' -eq 'Poison'}
$p

# searching
$data.SelectNodes("//Bands/Band[Name='Poison']")

$p.name
$p.name.year = '1983'
$p.name.city = 'Mechanicsburg, PA'
$p.name


# example XML
<Band>
    <Name Year="1966" City="London, England">Cream</Name>
    <Lead>Eric Clapton</Lead>
    <Members>
        <Member>Ginger Baker</Member>
        <Member>Jack Bruce</Member>
    </Members>
</Band>


# create element
$band = $data.CreateNode("element","Band","")


# create name
$name = $data.CreateElement("Name")


# set name
$name.InnerText = "Cream"


# attributes
$y = $data.CreateAttribute("Year")
$y.InnerText = "1966"
$c = $data.CreateAttribute("City")
$c.InnerText = "London, England"


# append
$name.Attributes.Append($y)
$name.Attributes.Append($c)


# verify
$name.OuterXml


# append
$band.AppendChild($name)


# lead element
$LeadMember =  $data.CreateElement("Lead")
$LeadMember.InnerText = "Eric Clapton"
$band.AppendChild($LeadMember)


# members
$members = $data.CreateNode("element","Members","")
$people = "Ginger Baker", "Jack Bruce"
    
foreach ($item in $people) {
    $m = $data.CreateElement("Member")
    $m.InnerText = $item
    $members.AppendChild($m)
}

#add members to the band node
$band.AppendChild($members)


# append it all
$data.Bands.AppendChild($band)


# save it
$data.Save('c:\work\banddata.xml')


# converting to XML
Get-CimInstance win32_service | ConvertTo-Xml



# selectivity
$s = Get-CimInstance win32_service -ComputerName $env:computername | 
Select-Object -Property * -ExcludeProperty CimClass,Cim*Properties |
ConvertTo-Xml

$s.objects.object[0]

$s.objects.object[0].Property

$s.Save("c:\work\services.xml")


# get some data
$data = Get-Hotfix -ComputerName $env:computername | 
Select-Object -property Caption,InstalledOn,InstalledBy,HotfixID,Description



# create name map
$map = [ordered]@{
    'update-id' = 'HotFixID'
    'update-type' = 'Description'
    'install-date' = 'InstalledOn'
    'install-by' = 'InstalledBy'
    caption = 'Caption'
}



# new XML doc
[xml]$Doc = New-Object System.Xml.XmlDocument



# doc properties
$dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)
$doc.AppendChild($dec) | Out-Null



# append info
$text = @"

Hotfix Inventory
$(Get-Date)

"@

$doc.AppendChild($doc.CreateComment($text)) | Out-Null



# create node
$root = $doc.CreateNode("element","Computer",$null)
$name = $doc.CreateElement("Name")
$name.InnerText = $env:computername
$root.AppendChild($name) | Out-Null



# updates
$hf = $doc.CreateNode("element","Updates",$null)



# add items
foreach ($item in $data) {
    $h = $doc.CreateNode("element","Update",$null)
    #create the entry values from the mapping hash table
    $map.GetEnumerator() | ForEach-Object {
      $e = $doc.CreateElement($_.Name)
      $e.innerText = $item.$($_.value)
      #append to Update
      $h.AppendChild($e) | Out-Null
    }
    #append the element
    $hf.AppendChild($h) | Out-Null
}



# finish up
$root.AppendChild($hf) | Out-Null
$doc.AppendChild($root) | Out-Null
$doc.Save("c:\work\hotfix.xml")



# final XML
<?xml version="1.0" encoding="UTF-8"?>
<!--
Hotfix Inventory
02/06/2017 15:11:44
-->
<Computer>
  <Name>CLI01</Name>
  <Updates>
    <Update>
      <update-id>KB2899189_Microsoft-Windows-CameraCodec-Package</update-id>
      <update-type>Update</update-type>
      <install-date>12/11/2013 00:00:00</install-date>
      <install-by>NT AUTHORITY\SYSTEM</install-by>
      <caption>http://support.microsoft.com/kb/2899189</caption>
    </Update>
    <Update>
      <update-id>KB2693643</update-id>
      <update-type>Update</update-type>
      <install-date>11/26/2013 00:00:00</install-date>
      <install-by>CLI01\Jeff</install-by>
      <caption>
      </caption>
    </Update>
...
  </Updates>
</Computer>

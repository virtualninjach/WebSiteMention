


$json = Get-Content -raw -path .\config.json

$config = $json | ConvertFrom-Json

$DBServer="server"
$DB="websiteMention"
<<<<<<< HEAD
$user="userid"
$password = "password"
=======
$user=""
$password = ""
>>>>>>> origin/master

$cn = new-object System.Data.SqlClient.SqlConnection("Database=$DB;Server=$DBServer;User ID=$user;Password=$password;")
$cn.open() 


foreach ($site in $config.websites)
{
    $siteFormalName = $site.websiteName
    $siteURL = $site.websiteURL

    foreach($mentionPair in $config.names)
    {
        $mentionCount = 0
        $stringToLookFor = $mentionPair.alias
        $stringFormalName = $mentionPair.name
        
        $siteContent = Invoke-WebRequest -UseBasicParsing -Uri $siteURL

        $mentionCount = $siteContent.Content | Select-String -Pattern $stringToLookFor -AllMatches | Select-Object -ExpandProperty Matches | Measure-Object | Select-Object -ExpandProperty Count

        #Run SQL Serve Update
        $Query = "Insert mentionModel (Name,WebSiteURL,WebSiteAlias,NameAlias,MentionCount) values ('$stringFormalName','$siteURL','$siteFormalName','$stringToLookFor',$mentionCount)"
        
        try
        {
            $cmd = new-object System.Data.SqlClient.SqlCommand $Query,$cn
            $datawriter = $cmd.ExecuteNonQuery()
        }
        catch
        {
               #Write error message on screen and to a LOG file
               write-host $_.Exception.Message
               $_.Exception.Message | Out-File C:\logs\mention-error-log.txt -Append
        }
        finally
        {
            $ErrorActionPreference = "Continue"
        }
    
    }
    
    
}
$cn.Close()
$cn = $null

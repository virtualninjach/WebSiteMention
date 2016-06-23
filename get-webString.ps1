
$siteArray = (("Fox News","http://www.foxnews.com/"),
               ("CNN","http://www.cnn.com/"),
                ("Huffington Post","http://www.huffingtonpost.com/"),
                ("Yahoo News","https://www.yahoo.com/news/"),
                ("Google News","https://news.google.com/"),
                ("New York Times","http://www.nytimes.com/"),
                ("NBC News","http://www.nbcnews.com/"),
                ("Daily Mail","http://www.dailymail.co.uk/ushome/index.html"),
                ("Washington Post","https://www.washingtonpost.com/"),
                ("The Guardian","http://www.theguardian.com/us"),
                ("Wall Street Journal","http://www.wsj.com/"),
                ("ABC News","http://abcnews.go.com/"),
                ("BBC","http://www.bbc.com/news"),
                ("USA Today","http://www.usatoday.com/"),
                ("LA Times","http://www.latimes.com/"),
                ("Associated Press","http://ap.org/"),
                ("Reuters","http://www.reuters.com/"),
                ("Politico","http://www.politico.com/"),
                ("Bloomberg","http://www.bloomberg.com/"))

$mention = (("Donald Trump","Trump"),
            ("Donald Trump","Donald Trump"),
            ("Hillary Clinton","Hillary"),
            ("Hillary Clinton","Hillary Clinton"))

$DBServer="Workstation1"
$DB="websiteMention"
$user="mention"
$password = "!Lyndon2"

$cn = new-object System.Data.SqlClient.SqlConnection("Database=$DB;Server=$DBServer;User ID=$user;Password=$password;")
$cn.open() 


foreach ($site in $siteArray)
{
    foreach($name in $mention)
    {
        $datawriter =""
        $$name[0]
        $name[1]
        $site[0]
        $site[1]
        
        $siteContent = Invoke-WebRequest -UseBasicParsing -Uri $site[1]

        $mentionCount = $siteContent.Content | Select-String -Pattern $name[1] -AllMatches | Select-Object -ExpandProperty Matches | Measure-Object | Select-Object -ExpandProperty Count
        $mentionCount

        #Run SQL Serve Update
        $Query = "Insert mentionModel (Name,WebSiteURL,WebSiteAlias,NameAlias,MentionCount) values ('$name[0]','$site[1]','$site[0]','$name[1]',$mentionCount)"
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

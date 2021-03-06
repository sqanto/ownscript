###############################################################################################
#Name            Old User                                                                     #
#Owner           sommer                                                                       # 
#Datum           05.11.13                                                                     #
#Beschreibung    Entfernt User aus Gruppen , sendet mail mit User > 180 Days Lastlogon        #
###############################################################################################
#Import-Module activedirectory
#load ad
add-pssnapin Quest.ActiveRoles.ADManagement
#Variable
$Now = get-date
$old = $Now.ADDDays(-180)
[array]$OldUserarray 
$i=0
$users = get-QADUser -SearchRoot 'berlin.%.de/Domain User/ausgeschiedene  MA' 

#html body
$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"
$html = $style
$html += "<p>Guten Tag</p>"
$html += "<p>Folgende User sind länger als 180 Tage nicht online. `n <br> "
$html += "<table><tr><td>User</td><td>Lastlogon</td></tr>"

#Schleife start
foreach ($u in $users){

    $M = get-qaduser $u -includeallproperties | Select-Object -Property "Name","LastLogon" 
    
    $gruppen = Get-QADmemberof $u
    
    "$M $gruppen"
####New####   
    $Userlast = $M.LastLogon
##Sammle Old User    
    if($Userlast -lt $old)
    
 {
    #Unterscheide Kontakte zu User (N/A)
    
        if($M.LastLogon -eq $null)
        {
            $logon = "N/A"
            $html += "<tr><td>" + $M.Name + "</td><td>" + $logon + "</td></tr>"
        }
        
    else{
        $html += "<tr><td>" + $M.Name + "</td><td>" + $M.LastLogon + "</td></tr>"
        }
      
 }
####New####   
    foreach ($g in $gruppen) {
    
    #Gruppen entfernen
              Remove-QADGroupMember -identity $g -Member $u
              
          }
$N = "$N$M"     

}

$body= $html
###Mail sned
function sendEmail($body)
{
$SmtpClient = new-object system.net.mail.smtpClient
$MailMessage = New-Object system.net.mail.mailmessage
$SmtpClient.Host = "172.31.3.8"
$mailmessage.from = "support_intern@%.de"
$mailmessage.To.add("sommer@%.de")
$mailmessage.Subject = “User älter als $old”
$MailMessage.IsBodyHtml = $true
$mailmessage.Body = $body
$smtpclient.Send($mailmessage)
}
function getMailAdress($employeeID) 
{
$Contact = get-qadobject -type "contact" -includedproperties employeeID,sn,givenname,mail  |  select-object employeeID,mail | findstr $employeeID 
try {

$mailaddress= $Contact.Substring(5)
$mailaddress.Trim(" ")
return $mailaddress
}
catch {
}
}

. sendEmail $body
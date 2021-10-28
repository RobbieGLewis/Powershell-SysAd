<#
SYNOPSIS:
    Tool for common tasks in SysAdmin and Support 
AUTHOR:
    James Wylde
VERSION:
    0.1
LICENCE:
    MIT Licence
PREREQUISITES:
    Script works on assumption Pa/PsExec does not exist in $env:path - add PStools contents to C:\Temp
    See #Modules
PURPOSE:
    One button fixes.

#>

#----------------------------------------------------------------------------------------#
#   Modules

#   Install RSAT if AD tools fails
#   https://docs.microsoft.com/en-us/windows-server/remote/remote-server-administration-tools

Import-Module ActiveDirectory

Clear-Host

#----------------------------------------------------------------------------------------#
#   Lost and Found vars

$dayGet = (get-date).DayOfWeek
$dateGet = Get-Date -f "dddd - dd/MM/yyyy - hh:MM"

function Start-RevertTimer {

    # 30 mins to revert

    [int]$time = 1800
    $length = $time / 100
    for ($time; $time -gt 0; $time--) {
         $min = [int](([string]($time/60)).split('.')[0])
         $text = " " + $min + " minutes " + ($time % 60) + " seconds left."
         Write-Progress -Activity "Reverting SCCM remote control registry key in" -Status $text -PercentComplete ($time / $length)
         Start-Sleep 1
    }
}


function Show-ActiveDirectoryMenu {

    Clear-Host
    
    #----------------------------------------------------------------------------------------#
    #   ADMenu bulk landing
    
    function Show-ADHome
    {
         param (
               [string]$Title = "Active Directory Tools" 
         )
         Clear-Host
         Write-Host "`n `r "
         Write-Host "    $Title    " -ForegroundColor Black -BackgroundColor Green
         Write-Host "`n `r "
         Write-Host "    1 - AD Get User info - Unlock - Password reset"
         Write-Host "    2 - AD Find all locked out users"
         Write-Host "    3 - AD Change Employeed ID"
         Write-Host "    4 - AD Copy Group Members to another Group" 
         Write-Host "    5 - AD Add all Members to a group from .txt" 
         Write-Host "    6 - AD Group Members Export to .csv"
         Write-Host "    7 - AD Search for machine"
         Write-Host "`n `r "
         Write-Host "    Q - Quit."
         Write-Host "`n `r "
    }
    
    #----------------------------------------------------------------------------------------#
    #   Functions
    
    #   Todo - rename temp function names
    #        - add Get-Credential for A1 object manipulation 

    function functionAD1 {
    
        Write-Host "`n `r "
        Write-Host "  AD User information - Unlock - Reset Password" -ForegroundColor Black -BackgroundColor Green
        Write-Host "`n `r "
    
        $userName = Read-Host -Prompt 'Search for user'
        Write-Host "`n `r "
        $Users = Get-Aduser -Filter "anr -like '$userName'"
        if ($Users.count -gt 1){
            Write-Host 'Multiple users found.' -ForegroundColor Black -BackgroundColor yellow
            Write-Host 'Select a user:' -ForegroundColor Black -BackgroundColor yellow
            Write-Host "`n `r "
            for($i = 0; $i -lt $Users.count; $i++){
                Write-Host "$($i): $($Users[$i].SamAccountName) | $($Users[$i].Name)"
            }
            Write-Host "`n `r "
            $selection = Read-Host -Prompt 'Select user (0, 1, 2 etc.)'
            Write-Host "`n `r "
            $ResultUser = $Users[$selection]
        }
    
        Get-ADUser $ResultUser -Properties Name,Title,EmailAddress,MobilePhone,Enabled,LockedOut,BadLogonCount,Manager | Select-Object Name,Title,EmailAddress,MobilePhone,Enabled,LockedOut,BadLogonCount,Manager | Format-List
        
    
                $Resultuser = Get-ADUser wyldeja -Properties msDS-UserPasswordExpiryTimeComputed
                $userCredExpiryDate = [DateTime]::FromFileTime( $Resultuser.'msDS-UserPasswordExpiryTimeComputed' )
                Write-Output "Password Expires: $userCredExpiryDate"

                Write-Host "`n `r "
    
        $input5 = Read-Host "Unlock user [y/n]" 
        switch($input5){
                  y{ Unlock-ADAccount -Identity $ResultUser
                  }
                  n{continue}
                  default{write-warning "Y or N only."}
                }
    
    Write-Host "`n `r "
    
        $input6 = Read-Host "Change password [y/n]" 
        switch($input6){
                    y{ 
                        $passWord = Read-Host "New password"
                        Set-ADAccountPassword -Identity $ResultUser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$passWord" -Force) | Unlock-ADAccount –Identity $ResultUser
                    }
                    n{
                        Write-Host "`n `r "
                        return}
                    default{write-warning "Y or N only."}
                }            
    
                Write-Host "`n `r "
    
        #Expiry
        #[DateTime]::FromFileTime( $user.'msDS-UserPasswordExpiryTimeComputed' )
        $user = Get-ADUser wyldeja -Properties msDS-UserPasswordExpiryTimeComputed
        $userCredExpiryDate = [DateTime]::FromFileTime( $user.'msDS-UserPasswordExpiryTimeComputed' )
        Write-Output "Password Expires:"$userCredExpiryDate
    
    
    }

    Function functionAD5 {
    
        Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
        Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
        Write-Host - '**ENSURE RELEVANT PERMISSIONS HAVE BEEN SOUGHT BEFORE PROCEEDING**' -ForegroundColor White -BackgroundColor Red
        Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
        Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
        Write-Host "`n `r "
        Read-Host -Prompt "PROCEED WITH CAUTION - PRESS ENTER TO CONTINUE"
        Write-Host "`n `r "
    
        Write-Host "  AD Group Member Export" -ForegroundColor Black -BackgroundColor Green
    
        $adGroupname = Read-Host "Group name"
    
        try {
    
            Get-ADGroupMember "$adGroupname" | ForEach-Object  {Get-ADUser $_ -properties emailaddress} | Select-Object Name, SamAccountName, EmailAddress | Export-Csv -path C:\temp\ADGroupExport.csv
    
            Write-Host "`n `r "
        
            Write-Host "  Export will be located in c:\temp\ADGroupExport.csv" -ForegroundColor Black -BackgroundColor Green
    
            Write-Host "`n `r "
            
        }
        catch [EXCEPTION]
        {
            Write-Host "`n `r "
            Write-Host "  Failed - either the name is wrong or doesn't exist." -ForegroundColor White -BackgroundColor Red
            Write-Host "`n `r "
        }
        
        Write-Host "`n `r "
    
    }
    
    Function functionAD2 {
    
    
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '**ENSURE RELEVANT PERMISSIONS HAVE BEEN SOUGHT BEFORE PROCEEDING**' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host "`n `r "
            Read-Host -Prompt "PROCEED WITH CAUTION - PRESS ENTER TO CONTINUE"
            Write-Host "`n `r "
    
            Write-Host "  AD Change Employeed ID" -ForegroundColor Black -BackgroundColor Green
            Write-Host "`n `r "
    
                $SearchUser = Read-Host -Prompt 'Search user'
                try {
                    $Users = Get-Aduser -Filter "anr -like '$SearchUser'"
                    if ($Users.count -gt 1){
                        Write-Host 'Multiple users were found.' -ForegroundColor Red -BackgroundColor Yellow
                        Write-Host 'Please select a user:' -ForegroundColor Red -BackgroundColor Yellow
                        for($i = 0; $i -lt $Users.count; $i++){
                            Write-Host "$($i): $($Users[$i].SamAccountName) | $($Users[$i].Name) | $($Users[$i].EmployeeID)"
                        }
                        Write-Host "`n `r "
                        $selection = Read-Host -Prompt 'Select user (0, 1, 2 etc.)'
                        Write-Host - ' '
                        $ResultUser = $Users[$selection]
    
                        Write-Host - ' '
                        $CurrentEmployeeNo = Get-ADUser $ResultUser -Properties employeeid | Select-Object employeeID
                        Write-Host - 'Current employee number:' $CurrentEmployeeNo
                
                        $EID = Read-Host -Prompt 'New employee number'
                            if ($EID) { 
                                Write-Host = "Employee ID change successful." -ForegroundColor White -BackgroundColor Green
                            } 
                            else { 
                                Write-Host = "Employee ID change unsuccessful." -ForegroundColor White -BackgroundColor Red
                            }
                
                        Set-ADUser $ResultUser -EmployeeID $EID
                
                        Write-Host "`n `r "
                    
                    }
                    else {
                        Write-Host "`n `r "
                        Write-Host = "Is this a standard user account? Doubt it." -ForegroundColor White -BackgroundColor Red
                    }
                }
                catch [EXCEPTION] {
                    Write-Host "`n `r "
                    Write-Host "Did you even enter anything?" -ForegroundColor White -BackgroundColor Red
                    Write-Host "`n `r "
                    
                }
    
    
    
    
    }
    
    
    Function functionAD3 {
    
    
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '**ENSURE RELEVANT PERMISSIONS HAVE BEEN SOUGHT BEFORE PROCEEDING**' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host "`n `r "
            Read-Host -Prompt "PROCEED WITH CAUTION - PRESS ENTER TO CONTINUE"
            Write-Host "`n `r "
    
            Write-Host "  AD Copy Group Members to another Group" -ForegroundColor Black -BackgroundColor Green
            Write-Host "`n `r "
    
            $credentials = Get-Credential -Message 'Enter a2/a1 credentials.'
    
            $sourceGroup = Read-Host -Prompt 'Enter name of group to copy members from'
            $destinationGroup = Read-Host -Prompt 'Enter name of group to copy members to'
    
            $users = Get-ADGroupMember -Identity $sourceGroup -Credential $credentials
    
            $startCount = (Get-ADGroupMember -Identity $destinationGroup).Count
            $newMembersCount = $users.Count
    
            foreach ($user in $users) {
                Add-ADGroupMember -Identity $destinationGroup -Members $user.distinguishedname -Credential $credentials
            }
    
            $endCount = (Get-ADGroupMember -Identity $destinationGroup).Count
    
            $newCount = $endCount - $startCount
    
            Write-Host "`n `r "
    
            Write-Host - "$newMembersCount users have been added to group $destinationGroup" -ForegroundColor White -BackgroundColor Green
            Write-Host - "$newCount NET TOTAL + $destinationGroup" -ForegroundColor White -BackgroundColor Green
    
            Write-Host "`n `r "
                
    }
    
    
    Function functionAD4 {
    
    
    
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '**ENSURE RELEVANT PERMISSIONS HAVE BEEN SOUGHT BEFORE PROCEEDING**' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host - '******************************************************************' -ForegroundColor White -BackgroundColor Red
            Write-Host "`n `r "
            Read-Host -Prompt "PROCEED WITH CAUTION - PRESS ENTER TO CONTINUE"
            Write-Host "`n `r "
    
            Write-Host "  AD Add all Members to a group from .txt" -ForegroundColor Black -BackgroundColor Green
            Write-Host "`n `r "
            Write-Host "  Create a .txt file in c:\temp named 'users.txt' with usernames in a column" -ForegroundColor White -BackgroundColor Blue
    
            try {
                $users = Get-Content c:\temp\users.txt
                $destinationGroup = Read-Host "Group Name"
        
                $startCount = (Get-ADGroupMember -Identity $destinationGroup).Count
                $newMembersCount = $users.Count
        
                foreach ($user in $users) { 
                    $userAdd = Get-ADUser $user
                    Add-ADGroupMember -ID $destinationGroup -Members $userAdd 
        
                }
        
                $endCount = (Get-ADGroupMember -Identity $destinationGroup).Count
        
                $newCount = $endCount - $startCount
        
                Write-Host "$newMembersCount users have been added to group $destinationGroup" -ForegroundColor White -BackgroundColor Green
                Write-Host "$newCount Net total + $destinationGroup" -ForegroundColor White -BackgroundColor Green
            }
            catch [EXCEPTION]{
                Write-Host "Cannot find 'c:\temp\users.txt'" -ForegroundColor White -BackgroundColor Red
            }
    
    }


    function functionAD6 {

        Write-Host "`n `r "
        Write-Host "  All locked out users " -ForegroundColor Black -BackgroundColor Green
        Write-Host "`n `r "

        Search-ADAccount -SearchBase "OU=GBR,OU=GBR,DC=group,DC=wan" –LockedOut | Get-ADUser -Properties lockoutTime,mail | Select-Object @{Name="Username";Expression={$_.sAMAccountName.ToUpper()}},@{Name="Name";Expression={$_.Name}},@{Name="Lockout Time";Expression={([datetime]::FromFileTime($_.lockoutTime).ToLocalTime())}},@{Name="Email";Expression={$_.mail}} | Sort-Object LockoutTime -Descending | Format-Table -AutoSize | Out-Host


    }

    function functionAD7 {

        Write-Host "`n `r "
        Write-Host "  Search for machine in Active Directory  " -ForegroundColor Black -BackgroundColor Green
        Write-Host "`n `r "


        $machineNumber = Read-Host "Machine"

        $result = Get-ADComputer -SearchBase "OU=GBR,OU=SK,DC=group,DC=wan" -Properties Name,Enabled,Description,OperatingSystemVersion,CanonicalName -Filter *|  Where-Object {$_.Name -like "*$machineNumber*"} | Select-Object Name,Description,Enabled,OperatingSystemVersion,CanonicalName | Format-List

        Write-Output $result



        $input9 = Read-Host "Enable machine [y/n]" 
        switch($input9){
                  y{ Enable-ADAccount -Identity $result
                  }
                  n{continue}
                  default{write-warning "Y or N only."}
                }
        
        Write-Host "`n `r "



        <#
                $search = Read-Host "Machine"

        (Get-ADComputer -SearchBase "OU=GBR,OU=SK,DC=group,DC=wan" -Properties Name -Filter *|  Where-Object {$_.Name -like "*$search*"} | Select-Object -ExpandProperty Name -OutVariable $P).Name

        Get-ADComputer -Identity $p.Name | Select-Object Name,Description,Enabled,OperatingSystemVersion,CanonicalName | Format-List
   


        $input9 = Read-Host "Enable machine [y/n]" 
        switch($input9){
                  y{ Enable-ADAccount -Identity $result
                  }
                  n{continue}
                  default{write-warning "Y or N only."}
                }
        
        Write-Host "`n `r "
#>


    }
    
    
    #----------------------------------------------------------------------------------------#
    #    Menu key bindings
    
    do
    {
         Show-ADHome
         #$keyPress = $host.UI.RawUI.ReadKey().character        Does not work in ISE
         $keyPress = Read-Host
         switch ($keyPress)
         {
               '1' {
                    Clear-Host
                    # 1 and 5 swap
                    functionAD1
                } '2' {
                    Clear-Host
                    functionAD6
                } '3' {
                    Clear-Host
                    functionAD2   
                } '4' {
                    Clear-Host
                    functionAD3
                } '5' {
                    Clear-Host 
                    functionAD4
                } '6' {
                    Clear-Host 
                    # 1 and 5 swap
                    functionAD5
                } '7' {
                    Clear-Host 
                    functionAD7
               } 'q' {
                    return
               }
         }
         pause
    }
    until ($keyPress -eq 'q')
    }
    

#----------------------------------------------------------------------------------------#
#   Landing

function Get-Weather {

    param([string]$GeoLocation = "") #Add location <
    $dest = "http://wttr.in/${GeoLocation}?format=3"
    $proxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy($dest)
    (Invoke-WebRequest -Proxy $proxy -ProxyUseDefaultCredentials $dest -UserAgent "curl" ).Content
}

function Show-Landing {

    param([int]$Seconds = 10)

    $weatherGet = Get-Weather

	for ([int]$i = 0; $i -lt $Seconds; $i++) {
		CLS
		Write-Output ""
		$CurrentTime = Get-Date -format "dddd dd-MM-yyyy HH:mm:ss" 
    }
        CLS

        Write-Host "`n `r "
        Write-Host "`n `r "
        Write-Host " _____________________________"

        Write-Host ""$CurrentTime
        Write-Host ""$weatherGet -NoNewline

        # Display name
        # $dom = $env:userdomain
        # $usr = $env:username
        # $usrFull = ([adsi]"WinNT://$dom/$usr,user").fullname
        # Gets Display name
        
        $Hour = (Get-Date).Hour
        If ($Hour -lt 12) {Write-Host " Good morning, $usr"-ForegroundColor White -BackgroundColor Black}
        ElseIf ($Hour -gt 16) {Write-Host " Good evening, $($Env:UserName)"
        Else {Write-Host " Good afternoon, $($Env:UserName)"}

        $machineNamefull = $(Write-Host "" -NoNewLine) + $(Write-Host " Target:" "" -NoNewLine; Read-Host).ToUpper()
        $script:machineName = $machineNamefull.Trim()
        

        Write-Host "`n `r "


        if(!(Test-Connection $machineName -Count 2 -Quiet)) {
            [System.Console]::Beep(200,400)
            [System.Console]::Beep(200,400)
            Start-Sleep -m 400
            Write-Host "             DOWN             " -ForegroundColor White -BackgroundColor Red

        }
        else {
            [System.Console]::Beep(658,125)
            [System.Console]::Beep(1320,500)
            #[Console]::Beep(658, 125); [Console]::Beep(1320, 500)
            Start-Sleep -m 100
            Write-Host "              UP              " -ForegroundColor Black -BackgroundColor Green

            }

    Start-Sleep -S 2


}

Show-Landing

#----------------------------------------------------------------------------------------#
#   Menu bulk landing

function Show-Home
{



     cls 

    param (
            [string]$Title = $machineName
          )

     Clear-Host
     Write-Host "`n `r "
     Write-Host "    $Title    " -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "
     Write-Host "    1 - Ping"
     Write-Host "    2 - PaExec"
     Write-Host "    3 - PSSession"
     Write-Host "    4 - Uptime & users"
     Write-Host "    5 - Tracert" 
     Write-Host "    6 - Telnet" 
     Write-Host "    7 - C$"
     Write-Host "    8 - Program list"
     Write-Host "    9 - Shutdown finder" 
     Write-Host "    D - DHCP Search" 
     Write-Host "    F - File sizes"
     Write-Host "    X - Outlook profile kill"
     Write-Host "    M - McAffee & Snow"
     Write-Host "    L - LSpush"
     Write-Host "    S - SCCM RC Tweak"
     Write-Host "    P - Remove Print UAC"
     Write-Host "`n `r "
     Write-Host "    Y - Active Directory Tools Menu"
     Write-Host "`n `r "
     Write-Host "    Z - Choose new target"
     Write-Host "    Q - Quit"
     Write-Host "`n `r "
}

#----------------------------------------------------------------------------------------#
#   Functions

function Start-Ping {

     Write-Host "`n `r "
     Write-Host "  Pinging" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "
     ping.exe $machinename
     Write-Host "`n `r "

}

function Start-PaExec {

Write-Host "`n `r "
    Write-Host "  PaExec opening for" $machineName -ForegroundColor Black -BackgroundColor Green
    Write-Host "`n `r "

    $argumentList = "/k c:\temp\paexec.exe \\$machineName -s cmd.exe"
    Start-Process cmd.exe $argumentList
    Write-Host "`n `r "
}

function Start-PSSession {

     Write-Host "`n `r "
     Write-Host "  Starting PS-Session with" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "

     .\psservice.exe \\$machineName -accepteula start winrm

     if(!(Test-Connection $machineName -Count 2 -Quiet)) {
          "$machineName is not reachable." 
     }
     else {
          Start-Process -FilePath 'PowerShell.exe' -ArgumentList '-NoExit',"-command `"Enter-PSSession -ComputerName $machineName`""
     }

     Write-Host "`n `r "
}

function Get-Users {

     Write-Host "`n `r "
     Write-Host "  Uptime and users on" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "
     query user /server:$machineName
     Write-Host "`n `r "

}

function Start-RouteTrace {

     Write-Host "`n `r "
     Write-Host "  Tracing route to" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "
     tracert $machineName 
     Write-Host "`n `r "
}

function Start-Telnet {

     Write-Host "`n `r "
     Write-Host "  Telnet check on" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "

     $ip = Read-Host = "IP"
     $portNo = Read-Host = "Port"

     ###### replace with Test-NetConnection

     Test-NetConnection -ComputerName $ip -Port $portNo 
     #Start-Process -FilePath 'telnet' -ArgumentList $ip,$portNo

     Write-Host "`n `r "
          
}

function Start-RemoteExplorer {

     Write-Host "`n `r "
     Write-Host "  Explorer opening on" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "

     explorer.exe \\$machineName\c$
     Write-Host "`n `r "
}

function Get-InstalledApps {

     Write-Host "`n `r "
     Write-Host "  Installed programs on" $machineName -ForegroundColor Black -BackgroundColor Green
     Write-Host "`n `r "

     Invoke-Command -ComputerName $machineName -ScriptBlock {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object Displayname, publisher, installdate} | Format-table -AutoSize

     Write-Host "`n `r "
}

function Get-ShutdownLogs {

     TRY{
     
          Write-Host "  Shutdown logs" $machineName -ForegroundColor Black -BackgroundColor Green
      
          $properties = @(
              @{n='When?';e={$_.timeCreated}},
              @{n='Who?';e={$_.properties[6].Value.ToUpper()}},
              @{n='How?';e={$_.properties[4].Value.ToUpper()}},
              @{n='What?';e={$_.properties[0].Value}}
          )
      
          Get-WinEvent -ComputerName $machineName -FilterHashTable @{LogName='System'; ID=1074} | 
          Select-Object $properties | Sort-Object "$_.timeCreated" -Descending | Format-Table -AutoSize # | Out-GridView
          Start-Sleep -Seconds 1.5
      
      }
      
      CATCH [Exception]
      {
          if ($_.Exception.GetType().Name -ne "RPC")
          {
              Write-Host "`n"
              Write-Host " :(  $machineName isn't reachable (RPC is unavailable) - try locally instead." -ForegroundColor White -BackgroundColor Red
              Write-Host "`n"
          }
      
      }
}

function Get-DHCPHostname {

    ## Add reservation search
    ## Add new DHCP reservation

    Write-Host "  Searching DHCP by hostname on YOUR_DHCP_SERVER" -ForegroundColor Black -BackgroundColor Green

    Write-Host "`r`n"

    $dhcpHN = Read-Host "Hostname"

    Write-Host "`r`n"

    Get-DhcpServerv4Lease -ComputerName YOUR_DHCP_SERVER-ScopeID 0 | Where-Object {$_.Hostname -like "*$dhcpHN*"}

    Write-Host "`r`n"


}


function Get-FileSize {

    Write-Host "  File size report on " $machineName -ForegroundColor Black -BackgroundColor Green

    Write-Host "`r`n"

    $location = Read-Host "Path to search down from"

    Invoke-Command -ComputerName $machineName -ScriptBlock {

                    
                $folders = Get-ChildItem -Path $using:location -Recurse -Directory
                
                $array = @()
                
                foreach ($folder in $folders)
                {
                $foldername = $folder.FullName
                
                $files = Get-ChildItem $foldername -Attributes !Directory
                
                
                $size = $Null
                $files | ForEach-Object -Process {
                $size += $_.Length
                }
                
                $sizeinmb = [math]::Round(($size / 1mb), 1)
                
                $array += [pscustomobject]@{
                Folder = $foldername
                Count = $files.count
                'Size(MB)' = $sizeinmb
                }
                }
                
                Write-Output $array | Sort-Object -Descending 'Size(MB)' | Format-Table -AutoSize

                Write-Output "Export has been saved in \\$using:machineName\c$\temp\file_report.csv"
                $array | Export-Csv -Path C:\Temp\file_report.csv -NoTypeInformation


            }

        #$outputCSV | Export-Csv -Path C:\Temp\file_report.csv -NoTypeInformation



    Write-Host "`r`n"

}
      
function Get-LargestFiles {

    Write-Host "  Largest files on" $machineName -ForegroundColor Black -BackgroundColor Green

    .\psservice.exe \\$machineName -accepteula start winrm

     Start-Sleep -Seconds 5  

     Write-Host "`r`n"
     $userName = Read-Host "User profile to query - C:\Users\"
     Write-Host "`r`n"
     $recipientEmail = Read-Host "Recipient email address ('@smurfitkappa.co.uk' not required)"
     Write-Host "`r`n"
     $senderEmail = Read-Host "Sender email address ('@smurfitkappa.co.uk' not required)"
     $fileName = "File Size Report-$userName-$(Get-Date -Format 'dd-MM-yyyy').csv"

     Invoke-Command -ComputerName $machineName -ScriptBlock {Get-ChildItem c:\users\$using:userName\ -Recurse -ErrorAction SilentlyContinue | Sort-Object -Descending -Property Length | Select-Object -first 100 FullName, @{Name="Size (MB) ";Expression={[Math]::Round($_.length / 1MB, 2)}}} | Export-CSV -Path C:\temp\$fileName -NoTypeInformation

     $htmlBody = "<html>
     <p>Hello, </p>
     <p>Please find attached a report detailing the largest files on your <em>C:\</em> drive.</p>
     <p>Consider the largest files that are no longer required for deletion, or by right-clicking the file and de-selecting <i>'Always keep on device'</i> so that it is stored in the OneDrive cloud instead. </p>
     </html>
     "

     Send-MailMessage -From $senderEmail@email.co.uk -To $recipientEmail@email.co.uk -CC $senderEmail@email.co.uk  -Subject "Largest Files on $clientName for $userName" -BodyAsHtml $htmlBody -Attachments c:\temp\$fileName -DeliveryNotificationOption OnFailure -Credential (Get-Credential -Message "Enter the credentials for SENDER") -SmtpServer 'smtp.server.com' -Port 25

     Write-Host "`r`n"
     Write-Host "******************************************************************************" -ForegroundColor White -BackgroundColor Black
     Write-Host "Finished - Results are located c:\temp\$filename" -ForegroundColor White -BackgroundColor Black
     Write-Host "Sender will receive notification of successful sending via email.             " -ForegroundColor White -BackgroundColor Black
     Write-Host "******************************************************************************" -ForegroundColor White -BackgroundColor Black

     Write-Host "`r`n"

}


function Start-OSTkill {

    Write-Host "  Kill Outlook profile on" $machineName -ForegroundColor Black -BackgroundColor Green
    Write-Host "`n `r "
    
     $userName = Read-Host "Username"

     Invoke-Command -ComputerName $machineName -ScriptBlock {

     Get-Process Lync* | Stop-Process -f
     Stop-Process -Name Outlook -Force
     taskkill /f /im ucmapi.exe

     Start-Sleep -S 5
     Move-Item -Path "C:\Users\$using:userName\AppData\Local\Microsoft\Outlook\*" -Destination 'C:\temp\' -Force

     Remove-Item -Path "C:\Users\$using:userName\AppData\Local\Microsoft\Outlook\*" 
     }
}


function Invoke-MVandSnow {

    Write-Host "  Updating McAffee and Snow inventory on" $machineName -ForegroundColor Black -BackgroundColor Green
    Write-Host "`n `r "

    $argumentList2 =  "\\$machineName cmd /C ping -n 2 127.0.0.1 >NUL & echo Running McAffee Update & echo ------------------------ & cd C:\Program Files (x86)\McAfee\Endpoint Security\Threat Prevention & amcfg.exe /update & echo -- & echo -- & echo Running SnowAgent Inventory Scan & echo ------------------------ & cd C:\Program Files\Snow Software\Inventory\Agent & snowagent.exe scan & ping -n 10 127.0.0.1 >NUL & echo Running SnowAgent Inventory Send & echo ------------------------ & echo Sent & snowagent.exe send & ping -n 10 127.0.0.1 >NUL & echo ------------------------ & echo Commands completed. & ping -n 10 127.0.0.1 >NUL"

    Start-Process C:\temp\paexec.exe -ArgumentList $argumentList2
    
    Write-Host "`n `r "

}

function Invoke-Lspush {

    Write-Host "  LanSweeper push on" $machineName -ForegroundColor Black -BackgroundColor Green

    $argumentList3 = "\\$machineName -c lspush.exe"
    Start-Process C:\temp\paexec.exe -ArgumentList $argumentList3

    Write-Host "`n `r "

}

function Add-SCCMRedKey {

    Write-Host "  Changing SCCM no approval for 2 minutes" $machineName -ForegroundColor Black -BackgroundColor Green

    .\psservice.exe \\$machineName -accepteula start winrm

    Invoke-Command -ComputerName $machineName -ScriptBlock {

        function Start-RevertTimer {

            # 2 mins to revert
        
            [int]$time = 120
            $length = $time / 100
            for ($time; $time -gt 0; $time--) {
                 $min = [int](([string]($time/60)).split('.')[0])
                 $text = " " + $min + " minutes " + ($time % 60) + " seconds left."
                 Write-Progress -Activity "Reverting SCCM registry key in" -Status $text -PercentComplete ($time / $length)
                 Start-Sleep 1
            }
        }

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" -Name "Permission Required" -Value 0

    Start-RevertTimer

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" -Name "Permission Required" -Value 1
    Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" -Name "Permission Required" | Select-Object -Property "Permission required"

        <#reg.exe Add "HKLM\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" /v "Permission Required" /t REG_DWORD /d 0 /f#>
        <#reg.exe Add "HKLM\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control" /v "Permission Required" /t REG_DWORD /d 1 /f#>


    }
}
    function Add-PrintKey {

        Write-Host "  Removing print UAC for 30 minutes" $machineName -ForegroundColor Black -BackgroundColor Green
    
        .\psservice.exe \\$machineName -accepteula start winrm
    
        Invoke-Command -ComputerName $machineName -ScriptBlock {
    
            function Start-RevertTimer {
    
                # 30 mins to revert
            
                [int]$time = 120
                $length = $time / 100
                for ($time; $time -gt 0; $time--) {
                     $min = [int](([string]($time/60)).split('.')[0])
                     $text = " " + $min + " minutes " + ($time % 60) + " seconds left."
                     Write-Progress -Activity "Reverting SCCM registry key in" -Status $text -PercentComplete ($time / $length)
                     Start-Sleep 1
                }
            }
    
        New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" -Name "RestrictDriverInstallationToAdministrators" -Value 0
    
        Start-RevertTimer
    
        Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" -Name "RestrictDriverInstallationToAdministrators" -Value 1
        Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" -Name "RestrictDriverInstallationToAdministrators"
    
        }

    <#
    $argumentList4 = "\\$machineName cmd /c reg.exe Add ""HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control"" /v ""Permission Required"" /t REG_DWORD /d 0 /f"
    
    Start-Process C:\temp\paexec.exe -ArgumentList $argumentList4

    Start-RevertTimer
    Write-Host "`n `r "

    $argumentList5 = "\\$machineName cmd /c reg.exe Add ""HKLM\SOFTWARE\Microsoft\SMS\Client\Client Components\Remote Control"" /v ""Permission Required"" /t REG_DWORD /d 1 /f"
    Start-Process C:\temp\paexec.exe -ArgumentList $argumentList5
    #>

}



#----------------------------------------------------------------------------------------#
#    Menu key bindings

#    Notes on ('NoEcho,IncludeKeyUp') - this is currently dead when ran via ISE / WinTerm - dependent key combo for ISE.

do
{
     Show-Home
     #$keyPress = $host.UI.RawUI.ReadKey().character     ^
     $keyPress = Read-Host
     switch ($keyPress)
     {
           '1' {
                Clear-Host
                Start-Ping
                pause
            } '2' {
                Clear-Host
                Start-PaExec   
            } '3' {
                Clear-Host
                Start-PSSession
            } '4' {
                Clear-Host 
                Get-Users
                pause
            } '5' {
                Clear-Host 
                Start-RouteTrace
                pause
            } '6' {
                Clear-Host 
                Start-Telnet
                pause
            } '7' {
                Clear-Host 
                Start-RemoteExplorer
            } '8' {
                Clear-Host 
                Get-InstalledApps
                pause
            } '9' {
                Clear-Host 
                Get-ShutdownLogs
                pause
            } 'D' {
                Clear-Host 
                Get-DHCPHostname
                pause
            } 'F' {
                Clear-Host 
                Get-FileSize
                pause
            } 'X' {
                Clear-Host 
                Start-OSTkill
                pause
            } 'M' {
                Clear-Host 
                Invoke-MVandSnow
            } 'L' {
                Clear-Host 
                Invoke-Lspush
            } 'S' {
                Clear-Host 
                Add-SCCMRedKey
            } 'P' {
                Clear-Host 
                Add-PrintKey
            } 'Y' {
                Clear-Host 
                Show-ActiveDirectoryMenu
            } 'Z' {
                Show-Landing 
            }
              'Q' {
                return
            }
     }
     #pause
}
until ($keyPress -eq 'q')


#----------------------------------------------------------------------------------------#
#   Scraps


#----------------------------------------------------------------------------------------##

# Functions to add

# WMIC tools
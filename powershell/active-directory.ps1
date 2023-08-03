###  Author:  Daibel Inle Martinez Sanchez [Konrad Zuse]
###  E-mail:  konradzuse.dm@gmail.com
###  Date  :  2022-08-1 
#Import-Module activedirectory

Import-Csv "C:\test\luserslist.csv"  -Delimiter ";" | Select-Object  name,lname,mac,model,path,pass,adgroup | ForEach-Object {
    $fname = $_.Name	
    #echo 1-$fname
	$lname = $_.lname	
	#echo  2-$lname
	$mac = $_.mac	
	#echo 3-$mac
	$path = $_.path
	#echo 4-$path

	$passwd = $_.pass
	#echo 5-$passwd

    $adgroup = $_.adgroup
    #echo 6-$adgroup
    $model = $_.model
	#echo 7-$model
    $name = "$($fname) $($lname) (movil $($model) APX)"  
	#echo 8-$name
	$gname = $fname
	#echo 9-$gname
    $dname = $name 
    #echo 10-$dname 
	$sname = $mac
	#echo 11-$dname 
	$upname = $mac
    #echo 12-$upname
	$saname = $mac
    #echo 13-$saname
	$desc = $mac   
    #echo 14-$desc
    $str1 = $fname+' '+ $lname+'"Mac: '+$mac+' "Group:'+$adgroup+'"'
    #echo $usr
    #Creating New User 
    echo 'Creating user :'$str1

     #Creating user with Abc123 Auth
 New-ADUser -Name $name -GivenName $gname -DisplayName $dname -Surname $lname -UserPrincipalName $upname -SamAccountName $sname -Path "OU=Clientes WIFI,DC=cim,DC=sld,DC=cu" -Description $mac  -AccountPassword (ConvertTo-SecureString -String "Abc123" -AsPlainText -Force) -Enabled $true 
     Start-Sleep -Seconds 1  
    #Setting user to AD Group 
      echo "Adding user to Group: "$adgroup
      Add-ADGroupMember -Identity $adgroup -Members $mac
      #Give final Wifi auth with NOPASSWORD key
      
      Start-Sleep -Seconds 2   
        echo "-- Setting default password "
        Set-ADAccountPassword -Identity $mac -NewPassword (ConvertTo-SecureString -AsPlainText "NOPASSWORD" -Force) -Reset  
      #Set user-aduser do not let users change password / sett never expires / no request change password at logon
      Start-Sleep -Seconds 1       
        echo "-- Activating user"
        Set-ADUser -Identity $mac -Enabled:$true -CannotChangePassword:$true -PasswordNeverExpires:$true -ChangePasswordAtLogon:$false
      Start-Sleep -Seconds 2
      
    
}
<#
PS C:\> New-ADUser -Name "Daibel Inle Martinez Sanchez (movil Samsung A10S APX)" -GivenName "Daibel" -DisplayName "Daibel Inle Martinez Sanchez (movil Samsung A10S )" -Surname "Martinez Sanchez" -UserPrincipalName "MacAddress" -SamAccountName "MacAddress" -Path "OU=Clientes WIFI,DC=cim,DC=sld,DC=cu" -Description "MacAddress"  -AccountPassword (ConvertTo-SecureString -String "Abc123" -AsPlainText -Force) -Enabled $true 
PS C:\> Add-ADGroupMember -Identity "Clientes WIFI" -Members "MacAddress" 
PS C:\> Set-ADAccountPassword -Identity "MacAddress" -NewPassword (ConvertTo-SecureString -AsPlainText "PASSWORD" -Force)  -Reset
PS C:\> Set-ADUser -Identity "MacAddress" -Enabled $true -CannotChangePassword:$true -PasswordNeverExpires:$true -ChangePasswordAtLogon:$false
#>    





    #     New-ADUser -Name $name -GivenName $gname -DisplayName $name -Surname $lname -UserPrincipalName $mac -SamAccountName $mac -Path $path -PasswordNeverExpires $true -ChangePasswordAtLogon $false -PasswordNotRequired $true -CannotChangePassword $true -Description $mac -Enabled $true -PassThru | % {Add-ADGroupMember -Identity $adgroup -Members $mac } 
    #Add USer Passwd
	
    <#
    $usr = ' -Name "'
    $usr += $name
    $usr += '" -GivenName "'
    $usr += $gname
    $usr += '" -DisplayName "'
    $usr += $name
    $usr += '" -Surname "'
    $usr += $lname
    $usr += '" -UserPrincipalName "'
	$usr += $mac 
	$usr += '" -SamAccountName "' 
    $usr += $mac
    $usr += '" -Path "'
    $usr += $path
	$usr += '" -PasswordNeverExpires $true -ChangePasswordAtLogon $false -PasswordNotRequired $true -CannotChangePassword $true -Description "'
	$usr += $mac
    $usr += '" -Enabled $true -PassThru | % {Add-ADGroupMember -Identity "'
	$usr += $adgroup 
	$usr += '" -Members "'
	$usr += $mac 
	$usr += '" }'   
	New-ADUser $usr
    echo " "
    $reset =' -Identity "'+$mac+'" -NewPassword (ConvertTo-SecureString -AsPlainText "'+$passwd+'" -Force) -Reset'
    echo 'Creating the new user: '+$str1
   
	#echo $reset
    # Ressetting the WIFI passwd
      Set-ADAccountPassword $reset
      
	
	 #echo $str1
  #>    


#Import-Csv "C:\test\import.csv"| Select-Object Name | Format-Table
<#Import-Csv "C:\test\import.csv" | ForEach-Object {
    Write-Host "Hola"+$_.Name
}
#>



<#
# echo "New-ADUser -Name " $name "-GivenName "$gname" -DisplayName "$name" -Surname "$lname" -UserPrincipalName "$mac" -SamAccountName "$mac" -Path "$path" -PasswordNeverExpires "$true"  -ChangePasswordAtLogon "$false" -PasswordNotRequired "$true" -Description "$mac"  -Enabled "$false" -PassThru | % {Add-ADGroupMember -Identity "$adgroup" -Members $_}"
 
 Set-ADAccountPassword -Identity $mac -NewPassword (ConvertTo-SecureString -AsPlainText $passwd -Force) -Reset
 #>

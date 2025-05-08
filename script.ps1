# Create OU for lab users
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq 'OSCP_Users'")) {
    New-ADOrganizationalUnit -Name "OSCP_Users" -Path (Get-ADDomain).DistinguishedName
}

# Crackable passwords (rockyou.txt)
$rockyou_passwords = @(
    "Password123!",
    "Summer2020",
    "letmein!",
    "qwerty123"
)

# Non-crackable passwords
$strong_passwords = @(
    "Bl0ckM@g!c!",
    "Sp@c3Sh1p!",
    "TAKOstuesday!",
    "R3xRul3z!"
)

function Create-OSCPUser {
    param (
        $Name,
        $SamAccountName,
        $Password,
        $Kerberoastable = $false,
        $ASREPRoastable = $false
    )
    $ou = (Get-ADOrganizationalUnit -Filter "Name -eq 'OSCP_Users'").DistinguishedName
    $userParams = @{
        Name              = $Name
        SamAccountName    = $SamAccountName
        UserPrincipalName = "$SamAccountName@oscp.lab"
        AccountPassword   = (ConvertTo-SecureString -AsPlainText $Password -Force)
        Enabled           = $true
        Path              = $ou
    }
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'")) {
        New-ADUser @userParams
        Set-ADUser -Identity $SamAccountName -PasswordNeverExpires $true
        if ($Kerberoastable) {
            Set-ADUser -Identity $SamAccountName -ServicePrincipalNames "HTTP/$SamAccountName"
        }
        if ($ASREPRoastable) {
            Set-ADAccountControl -Identity $SamAccountName -DoesNotRequirePreAuth $true
        }
    }
}

# Create users
Create-OSCPUser -Name "IIS Service" -SamAccountName "svc_iis" -Password $rockyou_passwords[0] -Kerberoastable $true
Create-OSCPUser -Name "MetalBeard" -SamAccountName "metalbeard" -Password $strong_passwords[0] -ASREPRoastable $true
Create-OSCPUser -Name "Emmet Brickowski" -SamAccountName "emmet" -Password $strong_passwords[1]
Create-OSCPUser -Name "Wyldstyle" -SamAccountName "wyldstyle" -Password $rockyou_passwords[1]
Create-OSCPUser -Name "Lord Business" -SamAccountName "lord_business" -Password $rockyou_passwords[2]
Create-OSCPUser -Name "Vitruvius" -SamAccountName "vitruvius" -Password $strong_passwords[2]

# Add users to privileged groups
Add-ADGroupMember -Identity "Domain Admins" -Members "lord_business"
Add-ADGroupMember -Identity "Enterprise Admins" -Members "lord_business"

# Create security groups and add members
if (-not (Get-ADGroup -Filter "Name -eq 'Service Accounts'")) {
    New-ADGroup -Name "Service Accounts" -GroupScope Global -Path (Get-ADOrganizationalUnit -Filter "Name -eq 'OSCP_Users'").DistinguishedName
}
Add-ADGroupMember -Identity "Service Accounts" -Members "svc_iis"

if (-not (Get-ADGroup -Filter "Name -eq 'IT Admins'")) {
    New-ADGroup -Name "IT Admins" -GroupScope Global -Path (Get-ADOrganizationalUnit -Filter "Name -eq 'OSCP_Users'").DistinguishedName
}
Add-ADGroupMember -Identity "IT Admins" -Members "emmet", "lord_business"

Write-Host "[+] Created OSCP lab users with mixed password strengths"
Write-Host "[!] Rockyou-crackable passwords: $($rockyou_passwords -join ', ')"

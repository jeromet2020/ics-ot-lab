# Scripts for Setting up the Services

## Setting up Active Directory, Domain, and DNS server

This script installs the Active Directory Domain, and DNS server features of Windows 2019.

```
# ----------------------------- PARAMETERS -----------------------------
$DomainName = "team1.local"
$SafeModePasswordPlain = "xsecTeam1!"  # Change this to a strong password

# Convert the SafeMode password to a SecureString
$SafeModePassword = ConvertTo-SecureString $SafeModePasswordPlain -AsPlainText -Force

# ----------------------------- INSTALL ROLES -----------------------------
Write-Host "Installing AD-Domain-Services and DNS..." -ForegroundColor Cyan
Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools

# ----------------------------- PROMOTE DC -----------------------------
Write-Host "Promoting server to Domain Controller for $DomainName..." -ForegroundColor Cyan
Install-ADDSForest `
    -DomainName $DomainName `
    -SafeModeAdministratorPassword $SafeModePassword `
    -InstallDNS `
    -Force `
    -NoRebootOnCompletion:$false

# ----------------------------- END -----------------------------
Write-Host "Installation and promotion complete. The server will reboot now." -ForegroundColor Green
```

## Join a computer to the domain



```
# --------------------------- CONFIGURATION ---------------------------
$DomainName = "team1.local"            # Your target domain
$DomainUser = "Administrator"               # Domain user with join rights
$DomainPasswordPlain = "xsecTeam1!"          # Domain password
$OU = "" # Optional, or leave empty
$DNSServer = "10.21.5.10"                   # Desired DNS Server

# Convert plain password to secure string
$SecurePassword = ConvertTo-SecureString $DomainPasswordPlain -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("$DomainName\$DomainUser", $SecurePassword)

# --------------------------- SET DNS ---------------------------
Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" } | ForEach-Object {
    Set-DnsClientServerAddress -InterfaceAlias $_.Name -ServerAddresses $DNSServer
}
Write-Host "DNS server set to $DNSServer." -ForegroundColor Green

# --------------------------- JOIN DOMAIN ---------------------------
try {
    if ([string]::IsNullOrEmpty($OU)) {
        Add-Computer -DomainName $DomainName -Credential $Credential -Force -ErrorAction Stop
    } else {
        Add-Computer -DomainName $DomainName -Credential $Credential -OUPath $OU -Force -ErrorAction Stop
    }

    Write-Host "Successfully joined to domain $DomainName." -ForegroundColor Green

    Write-Host "Restarting in 5 seconds..."
    Start-Sleep -Seconds 5
    Restart-Computer -Force

} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

```


# Setting up Template VMs

## Windows 10/2016 and higher versions

* Create VM with virtio devices (network, disk) with VirtIO and Windows ISO images mounted.
* Boot the VM and install the OS. Load the driver from the VirtIO disk when asked for a driver.
* Enable RDP
* Disable hibernation/standby (For Windows 10/11 installations)
* Clone machine to prevent reinstallation if something is not working correctly.
* Add keyboard layout suitable to your language.
* Install virtio drivers
* Install Guest Agent.
* Install Google Chrome.
* Install cloudbase init (Use the Continous Build: https://cloudbase.it/downloads/CloudbaseInitSetup_x64.msi)
Choose Run CloudInit-base as Local System Account, and Administrator as username.
* Replace the C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf contents with the following:
```
[DEFAULT]
username=Administrator
groups=Administrators
inject_user_password=true
first_logon_behaviour=no
first_logon_behavior=no
config_drive_raw_hhd=true
config_drive_cdrom=true
config_drive_vfat=true
bsdtar_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\bsdtar.exe
mtools_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\bin\
verbose=true
debug=true
log_dir=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\log\
log_file=cloudbase-init.log
default_log_levels=comtypes=INFO,suds=INFO,iso8601=WARN,requests=WARN
logging_serial_port_settings=
mtu_use_dhcp_config=true
ntp_use_dhcp_config=true
local_scripts_path=C:\Program Files\Cloudbase Solutions\Cloudbase-Init\LocalScripts\
check_latest_version=false
metadata_services=cloudbaseinit.metadata.services.configdrive.ConfigDriveService
```

* Launch sysprep with these commands
```
cd "C:\Program Files\Cloudbase Solutions\Cloudbase-Init\conf"
C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /unattend:Unattend.xml
```

* Remove cdrom devices
* Add CloudInit Drive
* Save the VM as template
* Test the template by doing the following:
    * Clone the template VM.
    * Go to the VM's Cloud-Init configuration and set the username as Administrator, set the password, IP, and DNS settings.
    * Start the newly created VM.
    * Verify if the configuration has taken effect on the OS.


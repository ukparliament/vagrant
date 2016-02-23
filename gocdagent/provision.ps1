Set-ExecutionPolicy RemoteSigned -force
# Install necessary packages for the agent
#------------------------------------------
# Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))	# Install Chocolatey if not installed
# Git
cinst git.install -y
# Java (not needed in general, we use the JRE inside the agent package)
# cinst jre8 -y

# Download, install, and run GoCD agent
$agentFolder = "C:\GoCD\"
If (!(Test-Path $agentFolder)){
    mkdir $agentFolder
}
cd $agentFolder

$agentExe = "go-agent-16.2.1-3027-setup.exe"
If (!(Test-Path $agentFolder$agentExe)){
	curl "https://download.go.cd/binaries/16.2.1-3027/win/go-agent-16.2.1-3027-setup.exe" -OutFile $agentExe
}

#$serverIp = "gocd.ukpds.org"
$serverIp = "192.168.0.3"
iex "./$agentExe /S /SERVERIP=$serverIp /D=${agentFolder}agent"

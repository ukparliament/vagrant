Set-ExecutionPolicy RemoteSigned -force
# Install necessary packages for the agent
#------------------------------------------
# Chocolatey
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))	# Install Chocolatey if not installed
# Git
cinst git.install -y
# Java (not needed in general, we use the JRE inside the agent package)
cinst jre8 -y

# Download, install, and run Bamboo agent
$agentFolder = "C:\bamboo-agent-home\"
If (!(Test-Path $agentFolder)){
    mkdir $agentFolder
}
cd $agentFolder

$server = "bamboo.ukpds.org:8085"
$serverAgentDownloadFolder = "/agentServer/agentInstaller/"
$agentExe = "atlassian-bamboo-agent-installer-5.10.1.1.jar" 
If (!(Test-Path $agentFolder$agentExe)){
    # Disable IE Enhanced Security Configuration
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force
    # Download the agent executable from the Bamboo server    
	curl "http://$server$serverAgentDownloadFolder$agentExe" -OutFile $agentExe
}

iex "java -jar $agentExe http://${server}/agentServer installntservice"
iex "java -jar $agentExe http://${server}/agentServer start"

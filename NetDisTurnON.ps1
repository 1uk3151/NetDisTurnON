$pcname = $env:COMPUTERNAME
$timestamp = Get-Date -Format yyyyMMddHHmm
$filename = "./NetDisTurnON_${pcname}_${timestamp}.txt"


Start-Transcript -Path $filename


##### NETWORK DISCOVERY #####


# Set NetDis variable to either True or False. Sets to True if NETDIS-NB_Name-In-UDP-NoScope firewall rule is enabled. 
$NetDis = (Get-NetFirewallRule -Name NETDIS-NB_Name-In-UDP-NoScope).Enabled


# If NETDIS-NB_Name-In-UDP-NoScope is not enabled, try to enable all firewall rules in the Network Discovery group. 
if ($NetDis -ne 'True') {
    try {
        Get-NetFirewallRule -DisplayGroup 'Network Discovery' | Set-NetFirewallRule -Profile Domain -Enabled True
        echo "Network Discovery: Enabled"
    } 
    

    # NETDIS-NB_Name-In-UDP-NoScope is only one of several firewall rules that are enabled by Network Discovery. 
    # For errors, try to manually enable Network Discovery. 
    catch {
        echo "Unable to automatically set Network Discovery rule. Manually configure."
    }

} 


# If NETDIS-NB_Name-In-UDP-NoScope is enabled, it could mean that Network Discovery is already enabled.
# If there are issues pinging other hosts, manually check Network Discovery.
else {
    echo "Network Discovery is possibly already enabled. Manually confirm."
}





##### FILE AND PRINTER SHARING #####


# Set FaPS variable to either True or False. Sets to True if FPS-SMB-In-TCP-NoScope firewall rule is enabled. 
$FaPS = (Get-NetFirewallRule -Name FPS-SMB-In-TCP-NoScope).Enabled


# If FPS-SMB-In-TCP-NoScope is not enabled, try to enable all firewall rules in the File and Printer Sharing group. 
if ($FaPS -ne 'True') {
    try {
        Get-NetFirewallRule -DisplayGroup 'File and Printer Sharing' | Set-NetFirewallRule -Profile Domain -Enabled True
        echo "File and Printer Sharing: Enabled" 
    } 
    

    # FPS-SMB-In-TCP-NoScope is only one of several firewall rules that are enabled by File and Printer Sharing. 
    # For errors, try to manually enable File and Printer Sharing.
    catch {
        echo "Unable to automatically set File and Printer Sharing rule. Manually configure."
    }

}


# If FPS-SMB-In-TCP-NoScope is enabled, it could mean that File and Printer Sharing is already enabled.
# If there are issues pinging other hosts, manually check File and Printer Sharing.
else {
    echo "File and Printer Sharing is possibly already enabled. Manually confirm."
}


Stop-Transcript

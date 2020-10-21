## Introduction 

PolyLogyx Monitoring Agent (PolyMon) is a Windows software that leverages the [osquery](https://osquery.io/) tool and the PolyLogyx Extension to osquery, to provide a view into detailed information about process creations, network connections, file system changes and many other activities on the system. For a detailed list of activities captured [check here](https://github.com/polylogyx/osq-ext-bin)

The software can be used for various threat monitoring and forensic purposes on a standalone system and does not mandate burden of having a server to manage the agents. It provides a graphical user interface that allows a user to navigate through the activities and events happening on the endpoint device.

## Install

Download the **PolyMon_Setup.exe** or clone the repository. The software can be installed by right click and 'Run as Administrator' on the binary executable. The current version is supported only on Windows 10 x64 Platform.

![Installation_Setup](Images/setup.png)
  
![Installation_1](Images/install-wel.png)

The setup wizard guides through the rest of the process.

![Installation_2](Images/install-wiz.png)

The tool can be provisioned with an optional [VirusTotal](https://www.virustotal.com/) free API key. Provisioning with VirusTotal key allows the tool to fetch the reputation of file hashes automatically from it and alert in case a malicious (or supicious) detection.

![Installation_3](Images/install-vt.png)

At the end of the installation, the monitoring agent registers as a tray app and gets launched. Later you can close the tool window (it will keep running as tray app) or maximize the tool window by clicking on tray icon.

![Installation_4](Images/install-complete.png)

![Installation_5](Images/tray-icon.png)


## Configuration

PolyMon is built with a default set of configurations for the underlying osquery agent as well as the [PolyLogyx Extension](https://github.com/polylogyx/osq-ext-bin). This provides an extremely low touch experience for the end user. The advanced users who wish to view/edit the configuration can do so by launching the PolyMon's front end application as shown below.

![Configuration](Images/mon-config.png)

PolyMon configuration follows the similar syntax as provided for PolyLogyx Extension and osquery. 

![Configuration2](Images/mon-config2.png)

## Use cases 

PolyMon tool can be used for a variety of use cases.

# Detection and monitoring

Under the hood, the PolyMon tool leverages a combination of technologies to record, query and display these activities. The most important use case is to provide a view into the activities of your system that are often not visible to naked eyes. These activities provide interesting insights for a system which can be used to root cause issues like a system breach, application misbehavior or any other unwarranted activity. Additionally, the tool can be utilized to query the properties of an endpoint. Each type of activity (or endpoint property) is provided under a tab that describes the type of activity. Each tab is a wrapper on a table provided by osquery core agent or PolyLogyx Extension. The default tabs are the 'activity monitoring' tabs. These activities include "File Events", "Process Events", "DNS Lookup", "HTTP Events" among others. The "search" box and the options on the right pane can assist with filtering the data for customizing the views.

![ProcEvents](Images/proc-events.png)

![DnsEvents](Images/dns-events.png)

If the tool was provisioned with VirusTotal key, it would look up the reputation of file hashes from VirusTotal database, maintaining a rate quota associated with free API keys, and trigger an alert on a match found. 

![FileEventsVt](Images/mon-data-vt-red.png)

![TrayNotification](Images/tray-notif.png)





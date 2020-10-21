## Introduction 

PolyLogyx Monitoring Agent (PolyMon) is a Windows software that leverages the osquery tool and the PolyLogyx Extension to osquery, to provide a view into detailed information about process creations, network connections, file system changes and many other activities on the system. For a detailed list of activities captured [check here](https://github.com/polylogyx/osq-ext-bin)

The software can be used for various threat monitoring and forensic purposes on a standalone system and does not mandate burden of having a server to manage the agents. It provides a graphical user interface that allows a user to navigate through the activities and events happening on the endpoint device.

## Install

Download the **PolyMon_Setup.exe** or clone the repository. The software can be installed by right click and 'Run as Administrator' on the binary executable. The current version is supported only on Windows 10 x64 Platform.

![Installation_Setyp](../Images/setup.png)
  
![Installation_1](../Images/install-wel.png)

The setup wizard guides through the rest of the process.

![Installation_2](../Images/install-wiz.png)

The tool can be provisioned with an optional [VirusTotal](https://www.virustotal.com/) free API key. Provisioning with VirusTotal key allows the tool to fetch the reputation of file hashes automatically from it and alert in case a malicious (or supicious) detection.

![Installation_3](../Images/install-vt.png)

At the end of the installation, the monitoring agent registers as a tray app and gets launched. Later you can close the tool window (it will keep running as tray app) or maximize the tool window by clicking on tray icon.

![Installation_4](../Images/install-complete.png)

![Installation_5](../Images/tray-icon.png)





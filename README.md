# threats checker

# threats checker – PowerShell Script

This PowerShell script performs a quick system security audit on a Windows machine, helping identify potential threats or anomalies.

## Features

- **Startup Programs**
  - Lists all programs configured to launch at startup.

- **Active Network Connections**
  - Shows currently active TCP connections with `ESTABLISHED` state.

- **Running Processes with Signature Info**
  - Displays running processes and their digital signature status.
  - Highlights unsigned or invalidly signed executables.

- **Windows Defender Status**
  - Checks if core antivirus and real-time protection features are enabled.

- **Recent Failed Login Attempts**
  - Displays the 5 latest failed login attempts (Event ID 4625).

- **Active Remote Desktop Sessions**
  - Lists currently connected RDP sessions using the `query session` command.

## Usage

1. Open PowerShell **as Administrator**.
2. Run the script:

```powershell
.\threats.ps1
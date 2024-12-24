# Remote System Automation and Anonymous Scanning Project

## Overview
This project provides a suite of scripts for automating the setup and execution of security and networking tools on both local and remote systems. It facilitates anonymous browsing, remote control, and scanning, leveraging tools such as `Nipe`, `GeoIP`, `SSH`, and `Nmap`. The project includes two main scripts:
- **Local Script (`project.sh`)**: Automates tool installation, configures anonymity, connects to a remote server, and executes scans.
- **Remote Script (`remot_install.sh`)**: Sets up necessary tools on the remote server for scanning and anonymity.

## Features
- Automated installation of required tools (`Nipe`, `GeoIP`, `SSHPass`, etc.).
- Anonymity checks using the `Nipe` tool.
- Remote connection to a server using `SSH` and `SSHPass`.
- Remote execution of scans using `Nmap` and `Whois`.
- Log generation for activities and scan results.
- File organization and storage of scan results.

## Requirements
- **Operating System**: Linux (Debian-based distribution preferred).
- **Dependencies**:
  - `SSH`
  - `SSHPass`
  - `Nipe`
  - `GeoIP`
  - `Nmap`
  - `Whois`
  - `Figlet`

## Usage
### 1. Prepare Your Environment
Ensure you have `bash` installed and permissions to execute scripts. 

### 2. Running the Local Script
1. Copy `project.sh` and `remot_install.sh` to the local system.
2. Make both scripts executable:
   ```bash
   chmod +x project.sh remot_install.sh

  Overview

This penetration testing lab is designed for hands-on practice 
with Active Directory attacks, privilege escalation, 
and exploitation of common vulnerabilities.
The environment consists of multiple virtual machines (VMs) running on VirtualBox, including:

- Kali Linux (KALI): Attacker machine
- Metasploitable 2 (DB01): Vulnerable Linux target
- Ubuntu (UB01): General Linux target
- Windows 11 (MS01, MS02): Windows targets, with MS01 dual-homed
- Windows Server 2022 (DC01): Active Directory Domain Controller

The lab uses two NAT networks to simulate internal and external segments, with MS01 bridging both networks.

---

  Setup Instructions

1. Download/Import VMs
- Download the .ova file (pre-configured lab) or set up each VM manually.
  https://drive.google.com/file/d/1RDDekAlvuziZbPVByqvVnlpQ_ysJ7wQl/view?usp=sharing
- In VirtualBox: File > Import Appliance, select the .ova, and follow prompts.

2. Configure Networks
- Create two NAT Networks in VirtualBox:
  - oscp-outside: 192.168.15.0/24
  - oscp-inside: 10.0.2.0/24
- Assign VMs to networks as follows:

| VM     | oscp-outside IP     | oscp-inside IP     |
|--------|---------------------|--------------------|
| KALI   | 192.168.15.x        | -                  |
| DB01   | 192.168.15.200      | -                  |
| UB01   | 192.168.15.50       | -                  |
| MS01   | 192.168.15.101      | 10.0.2.101         |
| MS02   | -                   | 10.0.2.201         |
| DC01   | -                   | 10.0.2.200         |

- Set DC01 as the DNS server for the 'oscp-inside' network (10.0.2.200).

3. Windows Configuration (skip this step if you've downloaded the .ova file)
- Install vulnerable software on MS01 (e.g., XAMPP from ExploitDB).
- Enable auto-logon and disable sleep/tamper protection in Windows Defender on MS01/MS02[2].

4. Active Directory Setup (skip this step if you've downloaded the .ova file)
- Use the provided PowerShell script to create users, groups, and set passwords with varying strengths and vulnerabilities (e.g., Kerberoastable, AS-REP roastable).
- Refer to the script for user/group details and password assignments.

5. Finalize and Test
- Ensure all VMs can communicate as per their assigned networks.
- Confirm DNS and domain join for Windows machines.

---

  Usage

- Use Kali to launch attacks against the lab targets (e.g., enumeration, exploitation, privilege escalation).
- Practive pivoting to get into the second network (e.g., ligolo-ng)
- Practice AD attacks (Kerberoasting, AS-REP Roasting, password cracking) using the created users and groups.
- Metasploitable 2 and Ubuntu offer additional Linux and web exploitation practice.
- Reset or restore VMs as needed to repeat exercises.

Tip: For detailed step-by-step setup, see the attached PDF and DOCX for network diagrams and configuration.

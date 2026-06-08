# SOC Blue Team Project: Detecting Brute Force & Kerberoasting with Wazuh Active Response

> **TL;DR**: My little experiment for an enterprise lab that doesn't just *detect* attacks. It **blocks them automatically**. Suggestions are encouraged. 
>
> Wazuh SIEM for detection + Active Response on pfSense for mitigation = Full SOC workflow.

[[License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[[Wazuh](https://img.shields.io/badge/SIEM-Wazuh_4.x-blue)](https://wazuh.com/)
[[pfSense](https://img.shields.io/badge/Firewall-pfSense_CE_2.7.2-red)](https://www.pfsense.org/)

## Project Overview: From Detection to Automated Response

This project simulates a segmented enterprise environment to study the complete defensive kill chain: **Attack → Detect → Respond**.

Unlike classic SIEM labs, this one implements a custom **SOAR** layer: when Wazuh detects an attack, it automatically instructs the pfSense firewall to ban the attacker's IP. **Zero human intervention**.

**Goal**: Replicate the capabilities of a modern SOC, from log collection to automated response.

## Core Capabilities

| Phase | Technology | Role in the Lab |
| --- | --- | --- |
| **1. Network Segmentation** | pfSense CE 2.7.2 | Isolates the attacker network `10.0.20.0/24` from the corporate LAN `10.0.10.0/24` |
| **2. Endpoint Monitoring** | Wazuh Agent 4.x | Collects Event ID 4625, 4769 from Windows Server 2012 R2 Domain Controller |
| **3. SIEM & Correlation** | Wazuh Manager | Centralizes logs and correlates with Rule 60122 to detect bruteforce |
| **4. SOAR / Active Response** | Custom Script + pfSense API | Bans the attacker's IP on pfSense via SSH in < 3 seconds from detection |

## Attack Scenarios Implemented

1. **[Brute Force / Password Spraying](./docs/attacks/bruteforce.md)**
   - **Tool**: Hydra from Kali Linux `10.0.20.102`
   - **Target**: Windows DC `10.0.10.10`
   - **Detection**: 164 Event ID 4625 in 2 minutes
   - **Response**: Auto-block of the attacker IP on pfSense via `easyrule`

2. **[Kerberoasting](./docs/attacks/Kerberoasting_overview.md)**
   - **Tool**: `GetSPNs.py` + `GetUserSPNs.py`
   - **Target**: Service accounts with SPNs
   - **Detection**: Event ID 4769 with `Ticket Encryption Type: 0x17` (RC4)

## Lab Architecture
[ Kali Linux ]      [   pfSense Firewall   ]      [ Windows DC + Wazuh Agent ]
10.0.20.102  <---->      10.0.10.1 / .20.1      <---->      10.0.10.10
   Attacker                    |                            Victim + Endpoint
                               |
                      [ Wazuh Manager 4.x ]
                         10.0.10.100
                         SIEM + SOAR Brain

**SOAR Flow**: `DC generates 4625` → `Agent forwards to Wazuh` → `Rule 60122 triggers` → `Wazuh executes pfblock.sh` → `pfSense blocks IP`

## Key Results & Takeaways

1. **Defense-in-Depth Validated**: Network-level mitigation reduced attack duration and prevented continued authentication attempts.
2. **MTTR ≈ 3s**: Mean Time to Respond. Less than 3 seconds from first alert to firewall block.
3. **SIEM ≠ Just Logging**: Without the SOAR part, the SIEM would only generate alerts. Here, the system defends itself.
4. **End-to-End Visibility**: Full host + network coverage. If pfSense blocks, Wazuh stops seeing 4625: proof that mitigation works.

## Tech Stack

- **Firewall**: pfSense CE 2.7.2
- **SIEM/SOAR**: Wazuh 4.x
- **Attacker**: Kali Linux 2024
- **Target**: Windows Server 2012 R2 Domain Controller
- **Hypervisor**: Oracle VirtualBox 7.0

## Future Improvements

- [ ] **MITRE ATT&CK mapping for each scenario**
- [ ] **Integration with TheHive for case management**
- [ ] **Response playbook for Kerberoasting**
- [ ] **Grafana dashboard for MTTD/MTTR metrics**

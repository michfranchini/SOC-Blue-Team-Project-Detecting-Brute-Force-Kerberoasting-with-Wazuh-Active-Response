## Enterprise Detection & Monitoring Lab 

Enterprise detection and monitoring lab designed to simulate a segmented enterprise network with centralized logging, endpoint monitoring, and threat detection capabilities.

## Project Overview

This project simulates a small enterprise environment to study:

Network segmentation and firewall policies
Attack simulation in a controlled lab
Centralized logging and SIEM correlation
Endpoint detection and alerting

The goal is to replicate a realistic SOC-like environment for defensive security analysis.

## Project Goals

Implement defense-in-depth using pfSense firewall segmentation
Simulate brute-force and credential-based attacks
Monitor and correlate events using Wazuh SIEM
Analyze detection effectiveness and logging coverage

## Lab Architecture

The environment is composed of a segmented virtual network:

OPT Network (10.0.20.0/24): Attacker machine (Kali Linux)
LAN Network (10.0.10.0/24): Windows Domain Controller + client machines
Firewall: pfSense managing all inter-network traffic

Architecture diagram:
docs/network-architecture.md

## Technologies Used

Firewall: pfSense CE 2.7.2
SIEM: Wazuh 4.x
Attacker VM: Kali Linux 2024
Target: Windows Server 2012 R2 (Domain Controller)
Hypervisor: Oracle VirtualBox 7.0
5. Network Topology

The lab is based on a segmented architecture:

OPT1 (10.0.20.0/24) → Attack simulation network
LAN (10.0.10.0/24) → Domain infrastructure

Topology diagram:
screenshots/network-topology.png

## Security Monitoring Configuration

Wazuh agents deployed on Windows endpoints
Centralized log collection on Wazuh manager
Event forwarding and correlation enabled
Custom detection rules for authentication failures (Event ID 4625)

Configuration details:
docs/siem-configuration.md

## Attack Simulation

The following attack scenarios were executed in a controlled environment:

Brute-force attack from Kali Linux against Domain Controller
Authentication attempts using Hydra and manual testing
Kerberoasting attempt using GetSPNs.py

References:

docs/attack-simulation.md
docs/kerberoasting.md

## Detection Results

Key observations from monitoring:

pfSense successfully blocked unauthorized traffic
screenshots/pfsense-deny-log.png
No Event ID 4625 generated in Wazuh for blocked attempts
→ Attack was prevented at network level (before reaching endpoint logging)

## Key Takeaways
Firewall segmentation effectively reduced attack surface
SIEM visibility depends on where the attack is stopped
Endpoint logging alone is not sufficient without network monitoring
Importance of layered detection strategy (network + host)

## Future Improvements
Add ELK stack comparison with Wazuh
Automate attack simulation with scripts
Introduce persistence and lateral movement scenarios
Add MITRE ATT&CK mapping for each scenario

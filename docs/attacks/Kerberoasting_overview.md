# Kerberoasting Attack Simulation
## Objective
Test detection of Kerberoasting attack targeting domain service accounts.

## Tools & Commands Used
- **Tool**: `impacket-GetSPNs.py` (Kali Linux)
- **Command**:
bash
python3 GetSPNs.py -request -dc-ip 10.0.10.10 enterprise.local/Administrator

- *Target*: `DC.enterprise.local` (10.0.10.10)
- *Goal*: Request TGS tickets for service accounts (SPNs).

*Attack Details*

Execution of impacket-GetUserSPNs against EVILCORP.LOCAL to request a TGS for the svc-iis service account. The tool returned a Kerberos TGS hash ready for offline cracking.
see: ![KERB_ATTACK.png](KERB_ATTACK.png) 

Successful offline cracking of the TGS hash with hashcat using rockyou.txt and toggles1.rule. Status Cracked confirms the service account password was recovered: Password123!.
see: ![KERB_RESULT.PNG](KERB_RESULT.png)

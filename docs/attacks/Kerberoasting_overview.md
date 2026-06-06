## Kerberoasting Attack
Kerberoasting exploits service accounts with SPNs to request TGS tickets encrypted with the account's password. The hash can be cracked offline without generating logs on the Domain Controller.

### 1. SPN Enumeration and TGS Request
We use `impacket-GetUserSPNs` to enumerate accounts with SPNs and request a TGS for the `svc-iis` account. The authentication user is a low-privilege domain user.

bash
impacket-GetUserSPNs EVILCORP.LOCAL/Orazio.Grinzosi:'Password123!' -dc-ip 10.0.10.10 -request -request-user svc-iis


!KERB_ATTACK.png[KERB_ATTACK.png](KERB_ATTACK.png)
_Figure 1: Output of `impacket-GetUserSPNs`. The request for `svc-iis` succeeds and returns a Kerberos TGS hash type `$krb5tgs$23$. This hash is ready for offline cracking with hashcat. Note: the`svc-iis`account has`ADMIN_COUNT=1` but is not protected by a complex password._

2. *Offline Cracking with Hashcat*
The extracted hash is saved to `svc-iis.hash` and cracked using `hashcat` in mode 13100. We use the `rockyou.txt` wordlist + `toggles1.rule` rules to handle common password variants.


bash
hashcat -m 13100 svc-iis.hash /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/toggles1.rule --force
hashcat -m 13100 svc-iis.hash --show


!KERB_RESULT.png[KERB_RESULT.png](KERB_RESULT.png)
Figure 2: Result of `hashcat --show`. Status `Cracked` indicates the hash was broken. The plaintext password for the `svc-iis` service account is `Password123!`. This demonstrates the account used a weak password present in rockyou.txt.

*Detection*
This activity generates event `4769` on the Domain Controller with `Ticket Encryption Type: 0x17` = RC4. Filtering for TGS requests without a corresponding TGT request may indicate Kerberoasting.


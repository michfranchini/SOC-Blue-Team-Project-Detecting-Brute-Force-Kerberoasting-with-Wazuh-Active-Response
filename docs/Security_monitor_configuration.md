Security Monitoring Configuration

To provide centralized monitoring and endpoint visibility, a Wazuh deployment was integrated into the lab architecture.

Wazuh Architecture

The monitoring stack consisted of:

Wazuh Manager deployed on AlmaLinux server
Wazuh agents installed on monitored Windows endpoints
Centralized log collection and event correlation
Detection rules focused on authentication activity

Architecture flow:

Windows Endpoint
       │
Wazuh Agent
       │
Wazuh Manager (Linux)
       │
Detection / Alerting
Wazuh Manager Deployment

The Wazuh Manager was deployed on a dedicated Linux server within the internal network.

Configuration tasks included:

Wazuh manager installation and initialization
Agent enrollment configuration
Connectivity validation between manager and endpoints
Dashboard accessibility verification

Screenshot:

screenshots/wazuh/wazuh-manager-installation.png

Endpoint Monitoring Configuration

A Wazuh agent was deployed on the monitored Windows system to collect security events.

Collected telemetry included:

Authentication events
Windows Security logs
System activity
Authentication failures and successes

Screenshot:

screenshots/wazuh/windows-agent-installed.png

Detection Logic

The monitoring configuration focused primarily on authentication-based attack scenarios.

Implemented detection objectives:

Detect failed authentication attempts
Observe brute-force activity
Validate log forwarding from endpoints
Verify correlation between endpoint and network controls
Validation Results

Following deployment, connectivity between the manager and monitored endpoints was verified successfully.

The environment was then used to validate:

Agent communication
Event forwarding
Detection pipeline functionality
Visibility during attack simulation

This setup provided centralized visibility across the monitored infrastructure and enabled threat hunting activities within the lab environment.

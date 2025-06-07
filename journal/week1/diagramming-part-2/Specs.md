# Corporate LAN & Public WiFi with VLANs, Captive Portal, OpenWISP, and Redundant WAN

VLAN-isolated LAN configuration for providing both **corporate internal networking (wired and wireless)** and **public WiFi** with **captive portal access**. The network uses **OpenWISP to centrally manage OpenWRT APs**, supports **redundant WAN links with load balancing**, and enforces **VLAN-based traffic segmentation** for security.

---

## Network Topology

```plaintext
                                      +-----------------------------+
                                      |     OpenWISP Management     |
                                      |     (Cloud/VPS Hosted)      |
                                      +-------------+---------------+
                                                |
                                         VPN Tunnel (WireGuard)
                                                |
                                                v
                                      +------------------------------+
                                      |        OpenWRT Access Point  |
                                      |     (Broadcasts SSIDs & VPN) |
                                      +------------------------------+
                                                |
                              +-----------------+-----------------+
                              |                                   |
                +------------------------+           +------------------------+
                | VLAN 10 - Guest WiFi   |           | VLAN 50 - Corp WiFi     |
                | SSID: Free_Public_WiFi|           | SSID: Corp_Secure_WiFi  |
                | Captive Portal Enforced|          | WPA2, Internal Services |
                +-----------+------------+           +-----------+------------+
                            |                                    |
                            +------------------+-----------------+
                                               |
                                   +-----------------------------+
                                   |    VLAN-Capable Core Switch |
                                   +-----------------------------+
                                               |
               +------------+------------+-------------+------------+
               |                         |                          |
   VLAN 20 - Corporate LAN   VLAN 40 - Management VLAN   VLAN 30 - Infrastructure
   Workstations, Servers     APs, Printers, SNMP Mgmt     Routers, Firewall, VPN

                                               |
                                               v
                                   +-----------------------------+
                                   | Redundant Internet Uplinks |
                                   |  WAN1 + WAN2 via Load Bal. |
                                   +-------------+---------------+
                                                 |
                                     +--------------------------+
                                     |  Dual-WAN Load Balancer  |
                                     +--------------------------+
```

---

## Components

### OpenWISP (Cloud Controller)
- Centralized management of OpenWRT APs
- Cloud/VPS hosted with a public IP
- Pushes config, firmware, captive portal pages
- Secures control path via VPN

### OpenWRT Access Points
- Broadcast three SSIDs on separate VLANs:
  - **Free_Public_WiFi (VLAN 10)** – Captive portal enforced
  - **Corp_Secure_WiFi (VLAN 50)** – Internal wireless access
- VLAN tagging via trunk port
- NAT, DHCP, and firewall roles per VLAN
- VPN connection to OpenWISP

---

## VLAN Structure

| VLAN ID | Purpose             | Description                                               |
|---------|---------------------|-----------------------------------------------------------|
| 10      | Guest WiFi (Public) | Internet-only access, Captive Portal sign-up enforced     |
| 20      | Corporate LAN       | Wired internal workstations and servers                   |
| 40      | Management          | Admin access to printers, switches, APs                   |
| 50      | Corporate WiFi      | Isolated wireless access for staff only                   |

---

## Captive Portal (VLAN 10 - Public WiFi)

- **Enforced for all public WiFi users**
- Hosted locally on OpenWRT device or remotely via OpenWISP
- **Portal workflow**:
  1. User connects to `Free_Public_WiFi`
  2. Redirected to captive portal
  3. Required to **register/sign in**
  4. On success, access granted to internet only
- Optional integrations:
  - Email verification
  - Rate limiting
  - Terms of service acceptance

---

## Corporate WiFi (VLAN 50)

- Separate from Corporate LAN (VLAN 20)
- VLAN 50 mapped to `Corp_Secure_WiFi` SSID
- Access controlled via WPA2-Enterprise (optional RADIUS)
- Firewall restricts access only to corporate services
- Isolation from public VLANs enforced

---

## VPN Architecture

- VPN (WireGuard/OpenVPN) tunnel from AP to OpenWISP
- Used for:
  - Central config and firmware updates
  - Pulling telemetry and logs
  - Hosting captive portal content if remote

---

## WAN Redundancy

- Dual ISPs (WAN1 + WAN2) connected to a **Load Balancer**
- Provides:
  - Automatic failover on outage
  - Load distribution (e.g., weighted round-robin)
- Default route updated dynamically based on link health

---

## Security Measures

- VLAN isolation prevents inter-network traffic
- Captive portal authentication for public access
- WPA2/WPA3 enterprise access for corporate SSID
- Management VLAN (40) restricted to IT/admin subnets
- All control-plane traffic encrypted via VPN

---

## Summary Table

| Component               | Function                                | Network Scope               |
|------------------------|-----------------------------------------|-----------------------------|
| OpenWISP               | AP config and monitoring                | VPN-secured mgmt channel    |
| OpenWRT AP             | SSID broadcast, VLAN trunking           | Local only                  |
| VLAN 10 - Guest WiFi   | Internet via Captive Portal             | No access to LAN            |
| VLAN 20 - Corp LAN     | Wired access to internal services       | Full access, firewalled     |
| VLAN 40 - Mgmt         | APs, printers, SNMP devices             | Admin-only                  |
| VLAN 50 - Corp WiFi    | Secure corporate wireless               | Isolated from public WiFi   |
| WAN1 + WAN2            | Redundant internet links                | Load-balanced/failover      |

---

## Requirements

- Public IP & DNS for OpenWISP server
- Valid SSL certificate installed on OpenWISP
- VLAN-capable managed switches
- OpenWRT-compatible APs
- Dual-WAN router/load balancer
- Captive portal software (OpenWISP modules)
- VPN service (WireGuard)

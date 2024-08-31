{
    "policies": [
        "netsh advfirewall firewall add rule name=\"Allow SSH\" protocol=TCP dir=in localport=22 action=allow",
        "netsh advfirewall firewall add rule name=\"Allow HTTP\" protocol=TCP dir=in localport=80 action=allow",
        "netsh advfirewall firewall add rule name=\"Allow HTTPS\" protocol=TCP dir=in localport=443 action=allow",
        "netsh advfirewall firewall add rule name=\"Allow DNS\" protocol=UDP dir=in localport=53 action=allow",
        "netsh advfirewall firewall add rule name=\"Block ICMP\" protocol=ICMPv4:8,any dir=in action=block",
        "netsh advfirewall firewall add rule name=\"Allow Established Connections\" protocol=TCP dir=in state=ESTABLISHED,RELATED action=allow",
        "netsh advfirewall set currentprofile firewallpolicy blockinbound,allowoutbound",
        "netsh advfirewall set allprofiles state on"
    ]
}

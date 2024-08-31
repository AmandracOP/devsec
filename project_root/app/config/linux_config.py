{
    "policies": [
        "iptables -A INPUT -p tcp --dport 22 -j ACCEPT",
        "iptables -A INPUT -p tcp --dport 80 -j ACCEPT",
        "iptables -A INPUT -p tcp --dport 443 -j ACCEPT",
        "iptables -A INPUT -p udp --dport 53 -j ACCEPT",
        "iptables -A INPUT -p icmp -j DROP",
        "iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT",
        "iptables -P INPUT DROP",
        "iptables -P FORWARD DROP",
        "iptables -P OUTPUT ACCEPT"
    ]
}

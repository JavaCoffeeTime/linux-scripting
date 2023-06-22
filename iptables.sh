#!/bin/sh

# Install persistent package
sudo apt-get install iptables-persistent

# Create file
sudo touch iptables_firewall.sh
sudo chmod +x iptables_firewall.sh

# Clear IPTables rules:
iptables -P INPUT ACCEPT
iptables -F
iptables -X
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH connections from YOUR_IP 
iptables -A INPUT -p tcp -m tcp -m state -m comment -s YOUR_IP --dport 22 --state NEW -j ACCEPT --comment "SSH"

# Allow HTTP/HTTPS 
iptables -A INPUT -p tcp -m tcp -m state -m comment -s 0.0.0.0/0 --dport 80 --state NEW -j ACCEPT --comment " HTTP "
iptables -A INPUT -p tcp -m tcp -m state -m comment -s 0.0.0.0/0 --dport 443 --state NEW -j ACCEPT --comment " HTTPS "

# Allow PING's
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Save rules
iptables-save

# Execute script
sudo ./iptables_firewall.sh

# Check status
iptables -L -n

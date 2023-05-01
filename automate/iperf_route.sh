echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/proxy_arp
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

sudo iptables -t nat -A POSTROUTING -d 192.168.1.110 -s 10.88.81.0/24 -j SNAT --to-source      10.88.81.110
sudo iptables -t nat -A PREROUTING  -d 192.168.1.110 -i ens18           -j DNAT --to-destination 192.168.1.100
sudo iptables -t nat -A POSTROUTING -d 10.88.81.110 -s 192.168.1.0/24 -j SNAT --to-source      192.168.1.110
sudo iptables -t nat -A PREROUTING  -d 10.88.81.110 -i ens19           -j DNAT --to-destination 10.88.81.100
sudo iptables -t nat -A POSTROUTING -d 192.168.1.110 -s 192.168.2.0/24 -j SNAT --to-source      192.168.2.110
sudo iptables -t nat -A PREROUTING  -d 192.168.1.110 -i ens18           -j DNAT --to-destination 192.168.1.100
sudo iptables -t nat -A POSTROUTING -d 192.168.2.110 -s 192.168.1.0/24 -j SNAT --to-source      192.168.1.110
sudo iptables -t nat -A PREROUTING  -d 192.168.2.110 -i ens20           -j DNAT --to-destination 192.168.2.100

sudo -S ip ro a 10.88.81.110 via 192.168.1.1 dev ens18
sudo -S ip ro a 192.168.2.110 via 192.168.1.1 dev ens18
sudo -S ip ro a 192.168.1.110 via 192.168.2.1 dev ens20

sudo arp -i ens18 -Ds 192.168.1.110 ens18 pub
sudo arp -i ens19 -Ds 10.88.81.110 ens19 pub
sudo arp -i ens20 -Ds 192.168.2.110 ens20 pub


#iperf3 -c 192.168.2.110 -B 192.168.1.100 -P8 -R
#iperf3 -c 192.168.2.110 -B 192.168.1.100 -P8
#iperf3 -c 10.88.81.110 -B 192.168.1.100 -P8 -R
#iperf3 -c 10.88.81.110 -B 192.168.1.100 -P8



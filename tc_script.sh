
 # Setting Updown Link 

tc qdisc del dev eth0 root
tc qdisc add dev eth0 root handle 1:0 htb r2q 2
tc class add dev eth0 parent 1:0 classid 1:1 htb rate 10240kbit

 # Setting Updown Link 

tc qdisc del dev eth1 root
tc qdisc add dev eth1 root handle 1:0 htb r2q 2
tc class add dev eth1 parent 1:0 classid 1:1 htb rate 10240kbit

 # Setting Uplink 

tc class add dev eth0 parent 1:1 classid 1:2 htb rate 10240kbit ceil 10240kbit
tc qdisc add dev eth0 parent 1:2 handle 20: sfq
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip src  flowid 1:2

# Setting Client's Information 
tc class add dev eth1 parent 1:1 classid 1:3 htb rate 256kbit ceil 256kbit
tc qdisc add dev eth1 parent 1:3 handle 3: sfq 
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 192.168.0.2 flowid 1:3

tc class add dev eth1 parent 1:1 classid 1:4 htb rate 123kbit ceil 195kbit
tc qdisc add dev eth1 parent 1:4 handle 4: sfq 
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 192.168.0.5 flowid 1:4

tc class add dev eth1 parent 1:1 classid 1:5 htb rate 233kbit ceil 333kbit
tc qdisc add dev eth1 parent 1:5 handle 5: sfq 
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 192.168.0.10 flowid 1:5


# Executing Settings for Non listed ips. 
tc class add dev eth1 parent 1:1 classid 1:6 htb rate 1kbit ceil 1kbit
tc qdisc add dev eth1 parent 1:6 handle 6: sfq 
tc filter add dev eth1 parent 1:0 protocol ip prio 1 u32 match ip dst 192.168.0.0/24 flowid 1:6


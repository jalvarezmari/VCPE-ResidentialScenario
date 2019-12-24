#/bin/vbash
run="/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper"
$run begin
$run set nat source rule 100 outbound-interface 'eth2'
$run set nat source rule 100 source address '10.10.0.0/24'
$run set nat source rule 100 translation address '10.2.3.1'

$run set nat destination rule 10 description 'Port Forward: SSH to 10.10.0.50'
$run set nat destination rule 10 destination port '22'
$run set nat destination rule 10 inbound-interface 'eth2'
$run set nat destination rule 10 protocol 'tcp'
$run set nat destination rule 10 translation address '10.10.0.50'

$run set nat destination rule 23 description 'Port Forward: HTTP to 10.10.0.51'
$run set nat destination rule 23 destination port '80'
$run set nat destination rule 23 inbound-interface 'eth2'
$run set nat destination rule 23 protocol 'tcp'
$run set nat destination rule 23 translation address '10.10.0.51'

$run set service dhcp-server shared-network-name dhcpexample authoritative enable
$run set service dhcp-server shared-network-name dhcpexample subnet 10.10.0.0/24 default-router 10.10.0.1
$run set service dhcp-server shared-network-name dhcpexample subnet 10.10.0.0/24 dns-server 1.1.1.1
$run set service dhcp-server shared-network-name dhcpexample subnet 10.10.0.0/24 lease 86400
$run set service dhcp-server shared-network-name dhcpexample subnet 10.10.0.0/24 start 10.10.0.50 stop 10.10.0.51

$run set firewall name eth1-local default-action 'drop'
$run set firewall name eth1-local rule 10 action accept
$run set firewall name eth1-local rule 10 description 'Allow established and related packets'
$run set firewall name eth1-local rule 10 state established enable
$run set firewall name eth1-local rule 10 state related enable
$run set firewall name eth1-local rule 20 action accept
$run set firewall name eth1-local rule 20 description 'Allow icmp'
$run set firewall name eth1-local rule 20 icmp type-name echo-request
$run set firewall name eth1-local rule 20 protocol icmp
$run set firewall name eth1-local rule 30 action accept
$run set firewall name eth1-local rule 30 description 'Allow ssh'
$run set firewall name eth1-local rule 30 destination port 22
$run set firewall name eth1-local rule 30 protocol tcp
$run set firewall name eth1-local rule 40 action accept
$run set firewall name eth1-local rule 40 description 'Allow http'
$run set firewall name eth1-local rule 40 destination port 80
$run set firewall name eth1-local rule 40 protocol tcp
$run set interfaces ethernet eth2 firewall in name 'eth1-local'
$run commit
$run save

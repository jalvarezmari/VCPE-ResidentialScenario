#!/bin/sh
echo  "ready"
opt=$(sudo ovs-vsctl get Bridge QOS datapath-id)
temp="${opt%\"}"
QOS="${temp#\"}"

opt2=$(sudo ovs-vsctl get Bridge home1net datapath-id)
temp2="${opt2%\"}"
BR1="${temp2#\"}"


curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/$QOS/ovsdb_addr
curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/$BR1/ovsdb_addr
sleep 1
curl -X POST -d '{"port_name": "h11-e1", "type": "linux-htb", "max_rate": "5000000", "queues": [{"max_rate": "5000000"}, {"max_rate": "4000000"}]}' http://localhost:8080/qos/queue/$BR1
sleep 1
curl -X POST -d '{"port_name": "vcpe-e1", "type": "linux-htb", "max_rate": "100000000", "queues": [{"max_rate": "100000000"}, {"max_rate": "100000000"}]}' http://localhost:8080/qos/queue/$QOS

curl -X POST -d '{"match": {"nw_src": "10.10.0.50"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/$BR1
curl -X POST -d '{"match": {"nw_src": "10.10.0.51"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/$BR1
curl -X POST -d '{"match": {"nw_dst": "10.10.0.50"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/$QOS
curl -X POST -d '{"match": {"nw_dst": "10.10.0.51"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/$QOS


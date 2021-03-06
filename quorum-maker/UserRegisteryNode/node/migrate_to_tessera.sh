#!/bin/bash

tessera="java -jar /tessera/tessera-app.jar"
tessera_data_migration="java -jar /tessera/data-migration-cli.jar"
tessera_config_migration="java -Djavax.xml.bind.JAXBContextFactory=org.eclipse.persistence.jaxb.JAXBContextFactory -Djavax.xml.bind.context.factory=org.eclipse.persistence.jaxb.JAXBContextFactory -jar /tessera/config-migration-cli.jar"

OTHER_NODES_EMPTY=$(sed -n '/othernodes/p' UserRegisteryNode.conf)
if [[ -z "$OTHER_NODES_EMPTY" && -z "$1" ]]; then
    echo "No Peer defined: Run ./migrate_to_tessera.sh <URL> Eg. ./migrate_to_tessera.sh http://10.50.0.3:22002/"
    exit
fi

killall geth
killall constellation-node

mv qdata/UserRegisteryNode.mv.db qdata/UserRegisteryNode.mv.db.bak

sed -i "s|h2url|jdbc:h2:file:/home/node/qdata/UserRegisteryNode;AUTO_SERVER=TRUE|" qdata/tessera-migration.properties

${tessera_data_migration} -storetype dir -inputpath qdata/storage/payloads -dbuser -dbpass -outputfile qdata/UserRegisteryNode -exporttype JDBC -dbconfig qdata/tessera-migration.properties >> /dev/null 2>&1

if [ ! -f qdata/UserRegisteryNode.mv.db ]; then
    mv qdata/UserRegisteryNode.mv.db.bak qdata/UserRegisteryNode.mv.db
fi

${tessera_config_migration} --tomlfile="UserRegisteryNode.conf" --outputfile tessera-config.json --workdir= >> /dev/null 2>&1

sed -i "s|jdbc:h2:mem:tessera|jdbc:h2:file:/home/node/qdata/UserRegisteryNode;AUTO_SERVER=TRUE|" tessera-config.json
sed -i "s|/home/node/qdata/home|/home|" tessera-config.json
sed -i "s|/.*.ipc|/home/node/qdata/UserRegisteryNode.ipc|" tessera-config.json

LOCAL_NODE_IP="$(ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"

PORT=$(var="$(grep -F -m 1 'port" : ' tessera-config.json)"; var="${var#*:}"; echo $var | awk '{print substr($1, 1, length($1)-1)'})

#sed  -i "s|\"hostName\".*,|\"hostName\" : \"http://$LOCAL_NODE_IP\",|" tessera-config.json

sed  -i "s|\"communicationType\" : \"REST\",|\"bindingAddress\": \"http://$LOCAL_NODE_IP:$PORT\",\n      \"communicationType\" : \"REST\", |" tessera-config.json

sed -i "s|Starting Constellation node|Starting Tessera node|" start_UserRegisteryNode.sh
sed -i "s|qdata/constellationLogs/constellation_|qdata/tesseraLogs/tessera_|" start_UserRegisteryNode.sh
sed -i "s|constellation-node.*conf|\$tessera -configfile tessera-config.json|" start_UserRegisteryNode.sh

if [ ! -z "$1" ]; then
    sed -i "s|\"peer\" : \[ \]|\"peer\" : \[ {\n      \"url\" : \"$1\"\n   } \]|" tessera-config.json     
fi

mkdir -p qdata/tesseraLogs

echo "Completed Tessera migration. Restart node to complete take effect."
# Sphinx Search Docker Image

## Cloud OS

Add custom patch:
```
<?xml version="1.1" encoding="utf-8"?>
<patch>
  <operations>
    <operation type="replace">
      <path>/template/yaml/services/_var_app_name_/environment/SPHINX_CONF</path>
      <value>
<SPHINX_CONF>
source test
{
    type = mysql
    sql_host = hostname
    sql_user = user
    sql_pass = password
    sql_db = database
    sql_port = 3306
    sql_query_pre = SET NAMES utf8
    sql_query_pre = SET CHARACTER SET utf8
    
    # Another SQL settings
}

index test_index
{
    source = test
    path = /var/lib/sphinxsearch/data/test
}
</SPHINX_CONF>
      </value>
    </operation>
  </operations>
</patch>
```

If container is first run, enter to container and run:
```
indexer --all
supervisorctl restart sphinx
```

## Docker compose

Create docket network
```
docker network create -d bridge --subnet=172.20.0.0/16 dockernet -o "com.docker.network.bridge.name"="dockernet"
```

Create sphinxsearch.yaml
```
version: "3.3"

services:
    
    sphinxsearch:
        image: bayrell/sphinxsearch:2.2
        hostname: "sphinxsearch.local"
        volumes:
            - "sphinxsearch:/data"
        environment:
            SPHINX_CONF: >
                source test
                {
                    type = mysql
                    sql_host = hostname
                    sql_user = user
                    sql_pass = password
                    sql_db = database
                    sql_port = 3306
                    sql_query_pre = SET NAMES utf8
                    sql_query_pre = SET CHARACTER SET utf8

                    # Another SQL settings
                }

                index test_index
                {
                    source = test
                    path = /var/lib/sphinxsearch/data/test
                }
        restart: unless-stopped
        networks:
            dockernet:
                ipv4_address: 172.20.0.10
        logging:
            driver: journald
    
volumes:
    sphinxsearch:
    
networks:
    dockernet:
        external: true
```

Run container:
```
docker-compose -f sphinxsearch.yaml -p "app" up -d
```

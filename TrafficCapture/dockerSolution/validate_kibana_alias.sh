#!/bin/bash

# Configuration
ES_SOURCE="http://localhost:19200"  # ES5.6 source
OS_TARGET="https://localhost:29200"  # OS2.15 target
AUTH="-ku admin:myStrongPassword123! --insecure"

# Wait for OpenSearch Dashboards to be ready
echo "Waiting for OpenSearch Dashboards..."
until curl -s http://localhost:5601/app/home >/dev/null; do
  echo "OpenSearch Dashboards not ready yet..."
  sleep 10
done

# 1. Create .kibana-migrations index
curl -X PUT "$OS_TARGET/.kibana-migrations" -H 'Content-Type: application/json' -d'{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}' $AUTH

# 2. Reindex from ES5.6
curl -X POST "$OS_TARGET/_reindex" -H 'Content-Type: application/json' -d'{
  "source": {
    "remote": {
      "host": "'$ES_SOURCE'"
    },
    "index": ".kibana"
  },
  "dest": {
    "index": ".kibana-migrations"
  }
}' $AUTH

# 3. Verify document count
curl -X GET "$OS_TARGET/.kibana-migrations/_count" $AUTH

# 4. Create alias
curl -X POST "$OS_TARGET/_aliases" -H 'Content-Type: application/json' -d'{
  "actions": [
    {
      "add": {
        "index": ".kibana-migrations",
        "alias": ".kibana"
      }
    }
  ]
}' $AUTH

# 5. Final verification
curl -X GET "$OS_TARGET/_alias/.kibana" $AUTH
echo -e "\nCheck OpenSearch Dashboards at http://localhost:5601"

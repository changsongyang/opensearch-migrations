#!/bin/bash
# Script to restart services while preserving data volumes

cd /Users/jugaldc/Desktop/paint/ma/opensearch-migrations/TrafficCapture/dockerSolution/src/main/docker

# Stop and remove only the necessary services without removing volumes
docker-compose stop migration-console rfs-service opensearch opensearch-dashboards
docker-compose rm -f migration-console rfs-service

# Start the services
docker-compose up -d

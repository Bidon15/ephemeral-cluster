#!/bin/bash

# Ensure key permissions are setup
chmod 0600 celestia-node/bridge/*/nodekey*
chmod 0600 celestia-node/light/*/nodekey*
chmod 0600 dalc/celestia-light/keys/*

# Start core nodes
docker compose -f docker/core-docker-compose.yml up -d 

echo "Waiting 40s for core nodes to produce a block"
sleep 40s

# Start bridge nodes
docker compose -f docker/bridge-docker-compose.yml up -d

# echo "Waiting 30s for bridge nodes to sync a block"
sleep 30s

# Start light nodes
docker compose -f docker/light-docker-compose.yml up -d

echo "Waiting 10s for light nodes to perform DA sampling"
sleep 10s

# Start the DALC node
docker compose -f docker/dalc-docker-compose.yml up -d

# Fund the DALC node
scripts/fund-dalc.sh

echo "Sleeping 10s to wait for DALC funding tx to go through"
sleep 10s

# Start the ethermint node
echo "Creating Ethermint node(s)"
docker compose -f docker/ethermint-docker-compose.yml up -d

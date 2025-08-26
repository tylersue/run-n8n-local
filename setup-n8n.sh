#!/bin/bash

# n8n Local Setup Script
# This script provides multiple options for setting up n8n locally

echo "=== n8n Local Setup Script ==="
echo "Choose your setup option:"
echo "1. Basic setup (SQLite database)"
echo "2. PostgreSQL setup (requires database credentials)"
echo "3. Basic setup with timezone configuration"
echo "4. Exit"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo "Setting up n8n with basic configuration (SQLite)..."
        docker volume create n8n_data
        docker run -it --rm \
            --name n8n \
            -p 5678:5678 \
            -v n8n_data:/home/node/.n8n \
            docker.n8n.io/n8nio/n8n:1.107.4
        ;;
    2)
        echo "Setting up n8n with PostgreSQL..."
        echo "Please provide your PostgreSQL credentials:"
        read -p "Database name: " POSTGRES_DATABASE
        read -p "Host: " POSTGRES_HOST
        read -p "Port (default 5432): " POSTGRES_PORT
        POSTGRES_PORT=${POSTGRES_PORT:-5432}
        read -p "Username: " POSTGRES_USER
        read -p "Schema (default public): " POSTGRES_SCHEMA
        POSTGRES_SCHEMA=${POSTGRES_SCHEMA:-public}
        read -s -p "Password: " POSTGRES_PASSWORD
        echo ""
        
        docker volume create n8n_data
        docker run -it --rm \
            --name n8n \
            -p 5678:5678 \
            -e DB_TYPE=postgresdb \
            -e DB_POSTGRESDB_DATABASE="$POSTGRES_DATABASE" \
            -e DB_POSTGRESDB_HOST="$POSTGRES_HOST" \
            -e DB_POSTGRESDB_PORT="$POSTGRES_PORT" \
            -e DB_POSTGRESDB_USER="$POSTGRES_USER" \
            -e DB_POSTGRESDB_SCHEMA="$POSTGRES_SCHEMA" \
            -e DB_POSTGRESDB_PASSWORD="$POSTGRES_PASSWORD" \
            -v n8n_data:/home/node/.n8n \
            docker.n8n.io/n8nio/n8n
        ;;
    3)
        echo "Setting up n8n with timezone configuration..."
        docker volume create n8n_data
        docker run -it --rm \
            --name n8n \
            -p 5678:5678 \
            -e GENERIC_TIMEZONE="America/Los_Angeles" \
            -e TZ="America/Los_Angeles" \
            -v n8n_data:/home/node/.n8n \
            docker.n8n.io/n8nio/n8n
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1-4."
        exit 1
        ;;
esac

echo ""
echo "n8n setup complete!"
echo "You can access n8n at: http://localhost:5678" 
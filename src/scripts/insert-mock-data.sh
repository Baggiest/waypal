#!/bin/bash

# Load environment variables
source .env

# Run the SQL file
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -f src/mock-data.sql 
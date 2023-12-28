#!/bin/bash

# Exit script on any error
set -e

# Environment variable for the PostgreSQL password
export PGPASSWORD="${POSTGRES_PASSWORD}"

# Function to create a user and database if they do not exist
create_user_and_db() {
    local user=$1
    local db=$2
    local pw=$3

    # log message
    echo "Creating user '$user' and database '$db'"

    # Create user if it doesn't exist
    psql -v ON_ERROR_STOP=1 -c "DO \$\$
       BEGIN
           IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$user') THEN
               CREATE USER $user WITH PASSWORD '$pw';
           END IF;
       END
       \$\$;"

    # Create database if it doesn't exist
    psql -v ON_ERROR_STOP=1 -c "SELECT 1 FROM pg_database WHERE datname = '$db'" | grep -q 1 || psql -v ON_ERROR_STOP=1 -c "CREATE DATABASE $db"

    # Grant all privileges on the database to the user
    psql -v ON_ERROR_STOP=1 -c "GRANT ALL PRIVILEGES ON DATABASE $db TO $user;"

    # Grant privileges to the user on the 'public' schema
    psql -v ON_ERROR_STOP=1 --dbname "$db" -c "GRANT ALL PRIVILEGES ON SCHEMA public TO $user;"
}

# Create 'flyte' user and database
create_user_and_db "flyte" "flyte" "${FLYTE_POSTGRES_PW}"

# Create 'mlflow' user and database
create_user_and_db "mlflow" "mlflow" "${MLFLOW_POSTGRES_PW}"

# Create 'keycloak' user and database
create_user_and_db "keycloak" "keycloak" "${KEYCLOAK_POSTGRES_PW}"


echo "PostgreSQL databases and schemas prepared."

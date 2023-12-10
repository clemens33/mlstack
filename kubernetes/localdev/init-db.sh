#!/bin/bash

# Exit script on any error
set -e

# Environment variable for the PostgreSQL password
export PGPASSWORD="${POSTGRES_PASSWORD}"

# Check if 'flyte' user exists and create if not
# Check if 'flyte' database exists and create if not
psql -v ON_ERROR_STOP=1 <<-EOSQL
     DO
     \$do\$
     BEGIN
         IF NOT EXISTS (
             SELECT FROM pg_roles
             WHERE  rolname = 'flyte') THEN

             CREATE USER flyte WITH PASSWORD '${FLYTE_POSTGRES_PW}';
         END IF;
         IF NOT EXISTS (
             SELECT FROM pg_database
             WHERE  datname = 'flyte') THEN

             CREATE DATABASE flyte;
         END IF;
     END
     \$do\$;
     GRANT ALL PRIVILEGES ON DATABASE flyte TO flyte;
EOSQL

# Grant privileges to the 'flyte' user on the 'public' schema
psql -v ON_ERROR_STOP=1 --dbname "flyte" <<-EOSQL
     GRANT ALL PRIVILEGES ON SCHEMA public TO flyte;
EOSQL

# Check if 'mlflow' user exists and create if not
# Check if 'mlflow' database exists and create if not
psql -v ON_ERROR_STOP=1 <<-EOSQL
     DO
     \$do\$
     BEGIN
         IF NOT EXISTS (
             SELECT FROM pg_roles
             WHERE  rolname = 'mlflow') THEN

             CREATE USER mlflow WITH PASSWORD '${MLFLOW_POSTGRES_PW}';
         END IF;
         IF NOT EXISTS (
             SELECT FROM pg_database
             WHERE  datname = 'mlflow') THEN

             CREATE DATABASE mlflow;
         END IF;
     END
     \$do\$;
     GRANT ALL PRIVILEGES ON DATABASE mlflow TO mlflow;
EOSQL

# Grant privileges to the 'mlflow' user on the 'public' schema
psql -v ON_ERROR_STOP=1 --dbname "mlflow" <<-EOSQL
     GRANT ALL PRIVILEGES ON SCHEMA public TO mlflow;
EOSQL

echo "PostgreSQL databases and schemas prepared."

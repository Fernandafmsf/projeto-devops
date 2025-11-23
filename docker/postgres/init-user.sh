#!/bin/bash
set -e

echo "🔧 Iniciando criação de usuário e banco com permissões limitadas..."

echo "📌 Criando usuário '$DB_USERNAME' e banco '$DB_DATABASE'..."

# Conecta no banco padrão "postgres"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<-EOSQL

    -- Cria o usuário da aplicação
    CREATE USER $DB_USERNAME WITH PASSWORD '$DB_PASSWORD';

    -- Cria o banco e define ownership para o usuário da aplicação
    CREATE DATABASE $DB_DATABASE OWNER $DB_USERNAME;

EOSQL

echo "🔐 Configurando permissões mínimas do schema..."

# Agora conecta no banco criado e ajusta permissões
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$DB_DATABASE" <<-EOSQL

    -- Remove permissões default que qualquer user teria
    REVOKE ALL ON SCHEMA public FROM PUBLIC;

    -- Permite apenas o necessário: uso + criação de tabelas (para migrations)
    GRANT USAGE, CREATE ON SCHEMA public TO $DB_USERNAME;

    -- Libera CRUD em tabelas existentes
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $DB_USERNAME;

    -- Define permissões padrão para tabelas futuras (criadas pelas migrations)
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $DB_USERNAME;

    -- Permissões para sequências (necessário para IDs autoincrement)
    GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO $DB_USERNAME;
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO $DB_USERNAME;

EOSQL

echo "✅ Banco e usuário configurados com sucesso!"
echo "Usuário limitado: $DB_USERNAME"
echo "Banco: $DB_DATABASE"

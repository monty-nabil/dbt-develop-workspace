#!/bin/bash
# DBT Environment Switcher
# Usage: source switch-env.sh dev   OR   source switch-env.sh prod

set -e

ENV_TARGET="$1"

if [ -z "$ENV_TARGET" ]; then
    echo "❌ Error: Please specify environment (dev or prod)"
    echo "Usage: source switch-env.sh dev"
    echo "       source switch-env.sh prod"
    return 1 2>/dev/null || exit 1
fi

if [ "$ENV_TARGET" != "dev" ] && [ "$ENV_TARGET" != "prod" ]; then
    echo "❌ Error: Invalid environment '$ENV_TARGET'"
    echo "Valid options: dev, prod"
    return 1 2>/dev/null || exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "Please create .env from .env.example first"
    return 1 2>/dev/null || exit 1
fi

# Load all variables from .env
set -a
source .env
set +a

# Export common variables
export AZURE_DEVOPS_PAT
export DBT_TARGET="$ENV_TARGET"

# Export environment-specific variables based on target
if [ "$ENV_TARGET" = "dev" ]; then
    export DBT_REDSHIFT_HOST="$DBT_DEV_REDSHIFT_HOST"
    export DBT_REDSHIFT_USER="$DBT_DEV_REDSHIFT_USER"
    export DBT_REDSHIFT_PASSWORD="$DBT_DEV_REDSHIFT_PASSWORD"
    export DBT_REDSHIFT_DATABASE="$DBT_DEV_REDSHIFT_DATABASE"
    export DBT_REDSHIFT_SCHEMA="$DBT_DEV_REDSHIFT_SCHEMA"
    export DBT_REDSHIFT_PORT="${DBT_DEV_REDSHIFT_PORT:-5439}"
    
    echo "✅ Switched to DEV environment"
    echo ""
    echo "Environment Variables Set:"
    echo "  DBT_TARGET: dev"
    echo "  DBT_REDSHIFT_HOST: $DBT_REDSHIFT_HOST"
    echo "  DBT_REDSHIFT_DATABASE: $DBT_REDSHIFT_DATABASE"
    echo "  DBT_REDSHIFT_SCHEMA: $DBT_REDSHIFT_SCHEMA"
    echo "  DBT_REDSHIFT_USER: $DBT_REDSHIFT_USER"
    
elif [ "$ENV_TARGET" = "prod" ]; then
    export DBT_REDSHIFT_HOST="$DBT_PROD_REDSHIFT_HOST"
    export DBT_REDSHIFT_USER="$DBT_PROD_REDSHIFT_USER"
    export DBT_REDSHIFT_PASSWORD="$DBT_PROD_REDSHIFT_PASSWORD"
    export DBT_REDSHIFT_DATABASE="$DBT_PROD_REDSHIFT_DATABASE"
    export DBT_REDSHIFT_SCHEMA="$DBT_PROD_REDSHIFT_SCHEMA"
    export DBT_REDSHIFT_PORT="${DBT_PROD_REDSHIFT_PORT:-5439}"
    
    echo "✅ Switched to PROD environment"
    echo ""
    echo "⚠️  WARNING: You are now using PRODUCTION credentials!"
    echo ""
    echo "Environment Variables Set:"
    echo "  DBT_TARGET: prod"
    echo "  DBT_REDSHIFT_HOST: $DBT_REDSHIFT_HOST"
    echo "  DBT_REDSHIFT_DATABASE: $DBT_REDSHIFT_DATABASE"
    echo "  DBT_REDSHIFT_SCHEMA: $DBT_REDSHIFT_SCHEMA"
    echo "  DBT_REDSHIFT_USER: $DBT_REDSHIFT_USER"
fi

echo ""
echo "🚀 You can now run dbt commands:"
echo "   dbt run"
echo "   dbt test"
echo "   dbt debug"

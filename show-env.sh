#!/bin/bash
# Quick DBT Environment Info
# Shows current environment variables

echo "📊 Current DBT Environment Configuration"
echo "=========================================="
echo ""

if [ -n "$DBT_TARGET" ]; then
    echo "🎯 Target Environment: $DBT_TARGET"
else
    echo "⚠️  DBT_TARGET not set (use: source switch-env.sh dev|prod)"
fi

echo ""
echo "Database Connection:"
echo "  Host:     ${DBT_REDSHIFT_HOST:-'Not set'}"
echo "  Database: ${DBT_REDSHIFT_DATABASE:-'Not set'}"
echo "  Schema:   ${DBT_REDSHIFT_SCHEMA:-'Not set'}"
echo "  User:     ${DBT_REDSHIFT_USER:-'Not set'}"
echo "  Port:     ${DBT_REDSHIFT_PORT:-'Not set'}"

echo ""
echo "Azure DevOps:"
if [ -n "$AZURE_DEVOPS_PAT" ]; then
    echo "  PAT: ✅ Set (${#AZURE_DEVOPS_PAT} characters)"
else
    echo "  PAT: ❌ Not set"
fi

echo ""
echo "Available Environments:"
if [ -f .env ]; then
    if grep -q "DBT_DEV_REDSHIFT_HOST=" .env 2>/dev/null; then
        echo "  ✅ DEV (configured)"
    else
        echo "  ⚠️  DEV (not configured)"
    fi
    
    if grep -q "DBT_PROD_REDSHIFT_HOST=" .env 2>/dev/null; then
        echo "  ✅ PROD (configured)"
    else
        echo "  ⚠️  PROD (not configured)"
    fi
else
    echo "  ❌ .env file not found"
fi

echo ""
echo "💡 To switch environments:"
echo "   source switch-env.sh dev"
echo "   source switch-env.sh prod"

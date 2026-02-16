#!/bin/bash

echo "==> DevContainer Post-Create Script Started"

# Check if AZURE_DEVOPS_PAT is set
if [ -z "$AZURE_DEVOPS_PAT" ]; then
    echo "WARNING: AZURE_DEVOPS_PAT environment variable is not set!"
    echo "Please add it as a GitHub Codespaces secret to clone the Azure DevOps repository."
    echo "Skipping repository clone..."
else
    echo "==> Configuring Git credential helper for Azure DevOps..."
    git config --global credential.helper store
    echo "https://PAT:${AZURE_DEVOPS_PAT}@visionblue.visualstudio.com" > ~/.git-credentials
    
    echo "==> Cloning DBT repository from Azure DevOps..."
    if [ ! -d "/workspaces/DBT" ]; then
        cd /workspaces
        git clone https://visionblue.visualstudio.com/AryzaDataPlatform/_git/DBT
        echo "✓ DBT repository cloned successfully!"
    else
        echo "DBT repository already exists, skipping clone."
    fi
fi

# Only proceed with dependency installation if the repo was cloned
if [ -d "/workspaces/DBT" ]; then
    echo "==> Installing DBT dependencies from requirements.txt..."
    if [ -f "/workspaces/DBT/requirements.txt" ]; then
        cd /workspaces/DBT
        pip install -r requirements.txt || {
            echo "⚠️  requirements.txt installation failed"
            echo "💡 You can install manually later with: pip install -r requirements.txt"
        }
    else
        echo "requirements.txt not found, skipping..."
    fi

    echo "==> Installing DBT dev dependencies from models/Pipfile..."
    if [ -f "/workspaces/DBT/models/Pipfile" ]; then
        cd /workspaces/DBT/models
        pipenv install --dev || {
            echo "⚠️  Dev dependencies installation failed"
            echo "💡 You can install manually later with: cd models && pipenv install --dev"
        }
    else
        echo "models/Pipfile not found, skipping..."
    fi

    echo "==> Installing dbt packages..."
    if [ -f "/workspaces/DBT/packages.yml" ]; then
        cd /workspaces/DBT
        dbt deps || {
            echo "⚠️  dbt deps failed (dbt may not be installed yet)"
            echo "💡 You can run manually later with: dbt deps"
        }
    else
        echo "packages.yml not found, skipping dbt deps..."
    fi

    echo "==> Setting up pre-commit hooks..."
    if [ -f "/workspaces/DBT/.pre-commit-config.yaml" ]; then
        cd /workspaces/DBT
        pre-commit install
        pre-commit install --hook-type commit-msg
        echo "✓ Pre-commit hooks installed"
    else
        echo "Pre-commit config not found, skipping..."
    fi
fi

echo "==> Verifying Python installation..."
echo "Python 3.11: $(python3.11 --version 2>/dev/null || echo 'Not found')"
echo "Default Python: $(python --version 2>/dev/null || python3 --version)"

echo "==> Verifying dbt installation..."
dbt --version 2>/dev/null || echo "⚠️  dbt not found - install with: pip install dbt-core dbt-redshift"

echo ""
echo "==> Dev container setup complete!"
echo ""
echo "📂 DBT repository location: /workspaces/DBT"
echo "🐍 Python version: $(python --version)"
echo "📦 Common commands:"
echo "   • dbt run - Run models"
echo "   • dbt test - Run tests"
echo "   • dbt deps - Install dbt packages"
echo "   • dbt debug - Check connection and configuration"

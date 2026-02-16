# GitHub Codespaces Setup Guide

## Required Secrets Configuration

Before launching your Codespace, you **must** configure the following secrets:

### 1. Add AZURE_DEVOPS_PAT Secret

1. Go to your GitHub repository: https://github.com/monty-nabil/dbt-develop-workspace
2. Click **Settings** (repository settings, not your profile)
3. In the left sidebar, expand **Secrets and variables** → Click **Codespaces**
4. Click **New repository secret**
5. Enter the following:
   - **Name**: `AZURE_DEVOPS_PAT`
   - **Value**: Your Azure DevOps Personal Access Token
6. Click **Add secret**

### 2. Optional: Add Database Credentials (if needed for dbt operations)

Repeat the same process for database credentials if you want them available in Codespaces:
- `DBT_REDSHIFT_HOST` - Your Redshift cluster endpoint
- `DBT_REDSHIFT_USER` - Database username
- `DBT_REDSHIFT_PASSWORD` - Database password
- `DBT_REDSHIFT_DATABASE` - Database name
- `DBT_REDSHIFT_SCHEMA` - Target schema

**Note**: You can also configure these locally in the Codespace after it starts.

## Launch Codespace

Once secrets are configured:

1. Go to your repository on GitHub
2. Click the green **Code** button
3. Select the **Codespaces** tab
4. Click **Create codespace on develop** (or your preferred branch)
5. Wait for the container to build (3-5 minutes first time)
6. The post-create script will automatically:
   - Clone the DBT repository from Azure DevOps
   - Install Python dependencies
   - Install dbt packages
   - Set up pre-commit hooks
   - Verify Python 3.11 installation

## Verify Setup

After the Codespace starts, run these commands to verify:

```bash
# Check repository was cloned
ls -la /workspaces/DBT

# Verify Python version
python --version  # Should show Python 3.11.x

# Check dbt installation
dbt --version

# Check other tools
sqlfluff --version
pre-commit --version
```

## Configure DBT Profile

Create or edit your dbt profile to connect to your database:

```bash
# Create profiles directory
mkdir -p ~/.dbt

# Edit profiles.yml
nano ~/.dbt/profiles.yml
```

Example `profiles.yml` for Redshift:

```yaml
default:
  target: dev
  outputs:
    dev:
      type: redshift
      host: "{{ env_var('DBT_REDSHIFT_HOST') }}"
      user: "{{ env_var('DBT_REDSHIFT_USER') }}"
      password: "{{ env_var('DBT_REDSHIFT_PASSWORD') }}"
      database: "{{ env_var('DBT_REDSHIFT_DATABASE') }}"
      schema: "{{ env_var('DBT_REDSHIFT_SCHEMA') }}"
      port: 5439
      threads: 4
```

Test your connection:

```bash
cd /workspaces/DBT
dbt debug
```

## Security Best Practices

✅ **DO:**
- Store all secrets as GitHub Codespaces secrets
- Use environment variables in dbt profiles
- Rotate PATs regularly
- Keep database credentials secure

❌ **DON'T:**
- Commit secrets to the repository
- Share PATs in chat, email, or documentation
- Store credentials in `.env` files that get committed
- Commit `profiles.yml` with hardcoded credentials

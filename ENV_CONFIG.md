# Environment Configuration Guide

This project supports separate configurations for **DEV** and **PROD** environments.

## Quick Start

### Option 1: Use Main .env File (Recommended for Development)
```bash
# Copy the example file
cp .env.example .env

# Edit .env and set DBT_TARGET=dev or DBT_TARGET=prod
# Then configure the corresponding environment variables
```

### Option 2: Use Environment-Specific Files
```bash
# For development
cp .env.dev.example .env.dev
# Edit .env.dev with your dev credentials

# For production
cp .env.prod.example .env.prod
# Edit .env.prod with your prod credentials

# Load the appropriate file
source .env.dev  # or source .env.prod
```

## Environment Variables

### Required for Both Environments
- `AZURE_DEVOPS_PAT` - Azure DevOps Personal Access Token (required to clone DBT repo)
- `DBT_TARGET` - Set to `dev` or `prod` to control which database to use

### DEV Environment Variables
- `DBT_DEV_REDSHIFT_HOST` - Development Redshift cluster endpoint
- `DBT_DEV_REDSHIFT_USER` - Development database username
- `DBT_DEV_REDSHIFT_PASSWORD` - Development database password
- `DBT_DEV_REDSHIFT_DATABASE` - Development database name
- `DBT_DEV_REDSHIFT_SCHEMA` - Development target schema
- `DBT_DEV_REDSHIFT_PORT` - Development port (default: 5439)

### PROD Environment Variables
- `DBT_PROD_REDSHIFT_HOST` - Production Redshift cluster endpoint
- `DBT_PROD_REDSHIFT_USER` - Production database username
- `DBT_PROD_REDSHIFT_PASSWORD` - Production database password
- `DBT_PROD_REDSHIFT_DATABASE` - Production database name
- `DBT_PROD_REDSHIFT_SCHEMA` - Production target schema
- `DBT_PROD_REDSHIFT_PORT` - Production port (default: 5439)

## DBT Profiles Configuration

The environment variables can be used in your `~/.dbt/profiles.yml`:

```yaml
default:
  target: "{{ env_var('DBT_TARGET', 'dev') }}"
  outputs:
    dev:
      type: redshift
      host: "{{ env_var('DBT_DEV_REDSHIFT_HOST') }}"
      user: "{{ env_var('DBT_DEV_REDSHIFT_USER') }}"
      password: "{{ env_var('DBT_DEV_REDSHIFT_PASSWORD') }}"
      database: "{{ env_var('DBT_DEV_REDSHIFT_DATABASE') }}"
      schema: "{{ env_var('DBT_DEV_REDSHIFT_SCHEMA') }}"
      port: "{{ env_var('DBT_DEV_REDSHIFT_PORT', 5439) }}"
      threads: 4
      
    prod:
      type: redshift
      host: "{{ env_var('DBT_PROD_REDSHIFT_HOST') }}"
      user: "{{ env_var('DBT_PROD_REDSHIFT_USER') }}"
      password: "{{ env_var('DBT_PROD_REDSHIFT_PASSWORD') }}"
      database: "{{ env_var('DBT_PROD_REDSHIFT_DATABASE') }}"
      schema: "{{ env_var('DBT_PROD_REDSHIFT_SCHEMA') }}"
      port: "{{ env_var('DBT_PROD_REDSHIFT_PORT', 5439) }}"
      threads: 8
```

## Switching Between Environments

### Method 1: Change DBT_TARGET in .env
```bash
# Edit .env and change:
DBT_TARGET=dev  # or DBT_TARGET=prod
```

### Method 2: Override with Command Line
```bash
# Run dbt with dev environment
DBT_TARGET=dev dbt run

# Run dbt with prod environment
DBT_TARGET=prod dbt run
```

### Method 3: Use dbt --target flag
```bash
# This works with the profiles.yml configuration above
dbt run --target dev
dbt run --target prod
```

## GitHub Codespaces Secrets

For Codespaces, add these as repository secrets:

**Required:**
- `AZURE_DEVOPS_PAT`

**DEV Environment:**
- `DBT_DEV_REDSHIFT_HOST`
- `DBT_DEV_REDSHIFT_USER`
- `DBT_DEV_REDSHIFT_PASSWORD`
- `DBT_DEV_REDSHIFT_DATABASE`
- `DBT_DEV_REDSHIFT_SCHEMA`

**PROD Environment:**
- `DBT_PROD_REDSHIFT_HOST`
- `DBT_PROD_REDSHIFT_USER`
- `DBT_PROD_REDSHIFT_PASSWORD`
- `DBT_PROD_REDSHIFT_DATABASE`
- `DBT_PROD_REDSHIFT_SCHEMA`

## Security Best Practices

1. ✅ **Never commit** `.env`, `.env.dev`, or `.env.prod` files
2. ✅ Use **different credentials** for dev and prod
3. ✅ Limit **prod access** to authorized personnel only
4. ✅ Rotate credentials regularly
5. ✅ Use **read-only** credentials when possible for dev
6. ✅ Set `DBT_TARGET=dev` as default to prevent accidental prod changes

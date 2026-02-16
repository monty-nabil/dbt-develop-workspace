# Environment Configuration Guide

This project supports separate configurations for **DEV** and **PROD** environments using a single `.env` file.

## Quick Start

```bash
# Copy the example file
cp .env.example .env

# Edit .env and add your credentials
# Set DBT_TARGET=dev or DBT_TARGET=prod to control which environment to use
```

## Environment Variables

### Required
- `AZURE_DEVOPS_PAT` - Azure DevOps Personal Access Token (required to clone DBT repo)
- `DBT_TARGET` - Set to `dev` or `prod` to control which database to use (default: `dev`)

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
DBT_TARGET=dev  # for development
DBT_TARGET=prod # for production
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
- `DBT_TARGET` (set to `dev` or `prod`)

**DEV Environment:**
- `DBT_DEV_REDSHIFT_HOST`
- `DBT_DEV_REDSHIFT_USER`
- `DBT_DEV_REDSHIFT_PASSWORD`
- `DBT_DEV_REDSHIFT_DATABASE`
- `DBT_DEV_REDSHIFT_SCHEMA`

**PROD Environment (if needed):**
- `DBT_PROD_REDSHIFT_HOST`
- `DBT_PROD_REDSHIFT_USER`
- `DBT_PROD_REDSHIFT_PASSWORD`
- `DBT_PROD_REDSHIFT_DATABASE`
- `DBT_PROD_REDSHIFT_SCHEMA`

## Security Best Practices

1. ✅ **Never commit** `.env` file - it's gitignored
2. ✅ Use **different credentials** for dev and prod
3. ✅ Limit **prod access** to authorized personnel only
4. ✅ Rotate credentials regularly
5. ✅ Use **read-only** credentials when possible for dev
6. ✅ Set `DBT_TARGET=dev` as default to prevent accidental prod changes
7. ✅ All credentials are in ONE file - easier to manage and secure

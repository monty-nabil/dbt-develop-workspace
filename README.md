# Aryza DBT Platform - DevContainer Workspace

This repository contains the DevContainer configuration for working with the Aryza DBT Platform codebase in GitHub Codespaces.

## 🚀 Quick Start

### Prerequisites
- GitHub account with access to this repository
- Azure DevOps Personal Access Token (PAT) with read access to the DBT repository

### Setup Instructions

1. **Add GitHub Codespaces Secret**
   - Go to your GitHub repository Settings
   - Navigate to: Settings → Secrets and variables → Codespaces
   - Click "New repository secret"
   - Name: `AZURE_DEVOPS_PAT`
   - Value: Your Azure DevOps Personal Access Token
   - Click "Add secret"

2. **Launch Codespace**
   - Click the green "Code" button in this repository
   - Select "Codespaces" tab
   - Click "Create codespace on develop"
   - Wait for the container to build and the post-create script to run

3. **Verify Setup**
   - Check that `/workspaces/DBT` directory exists
   - Verify Python version:
     ```bash
     python --version  # Should show Python 3.11.x
     ```
   - Check installed tools:
     ```bash
     dbt --version
     sqlfluff --version
     pre-commit --version
     ```

## 🐍 Python Version

This devcontainer uses **Python 3.11** (matching the DBT repository requirements).

```bash
# Check Python version
python --version  # Python 3.11.x
```

## 📁 Repository Structure

```
/workspaces/
├── dbt-develop-workspace/        # This GitHub repo (DevContainer config)
│   ├── .devcontainer/
│   │   ├── Dockerfile
│   │   ├── devcontainer.json
│   │   └── post-create.sh
│   ├── .claude/                  # Claude AI skills and settings
│   └── README.md
└── DBT/                          # Cloned Azure DevOps repo
    ├── models/
    ├── dbt_project.yml
    ├── requirements.txt
    ├── packages.yml
    └── .pre-commit-config.yaml
```

## 🔧 Common DBT Commands

### Development Workflow
```bash
cd /workspaces/DBT

# Install dbt packages
dbt deps

# Run all models
dbt run

# Run specific model
dbt run --select model_name

# Run tests
dbt test

# Compile models (check for errors)
dbt compile

# Debug connection and configuration
dbt debug

# Generate and serve documentation
dbt docs generate
dbt docs serve
```

### SQL Formatting and Linting
```bash
# Format SQL files with sqlfmt
sqlfmt models/

# Lint SQL files with sqlfluff
sqlfluff lint models/
sqlfluff fix models/

# Run black formatter on Python code
black models/
```

### Pre-commit Hooks
```bash
# Run pre-commit hooks on all files
pre-commit run --all-files

# Run specific hook
pre-commit run sqlfluff-lint --all-files
```

## 🛠️ Installed Tools

- **Python**: 3.11
- **DBT**: Core and Redshift adapter
- **SQL Tools**: sqlfluff, sqlfmt (with jinjafmt)
- **Formatters**: black (Python)
- **Development**: Git, pre-commit, pipenv
- **VS Code Extensions**: 
  - dbt Power User
  - dbt Core
  - Better Jinja
  - SQL Tools
  - Python (Pylance, Black formatter, Pylint)
  - GitHub Copilot
  - YAML, Docker, GitLens

## 🔐 Security Notes

- **DBT Profiles**: Configure your `profiles.yml` separately (not included in devcontainer for security)
- **Database Credentials**: Set as Codespaces secrets or configure after container starts
- **Azure DevOps PAT**: Must be set as `AZURE_DEVOPS_PAT` Codespaces secret
- **Never commit** `.env` files or credentials to the repository

**Note**: This devcontainer is optimized for GitHub Codespaces and does **not** mount local credentials directories.

## 🐛 Troubleshooting

### DBT repository not cloned
- Verify `AZURE_DEVOPS_PAT` is set as a Codespaces secret
- Check the post-create script output in the terminal
- Manually run: `bash .devcontainer/post-create.sh`

### Python dependencies not installed
- Check that the repository was cloned successfully
- Manually install: `cd /workspaces/DBT && pip install -r requirements.txt`
- Install dev dependencies: `cd /workspaces/DBT/models && pipenv install --dev`

### dbt packages not installed
- Run manually: `cd /workspaces/DBT && dbt deps`
- Verify `packages.yml` exists in the repository

### Database connection issues
- Configure your `~/.dbt/profiles.yml` with connection details
- Test connection: `dbt debug`
- Verify database credentials are correct

## 📚 Additional Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [DevContainers Documentation](https://containers.dev/)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
- [Azure DevOps PAT Guide](https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate)

## 🤝 Contributing

This devcontainer configuration is maintained alongside the Aryza DBT Platform project. For issues or improvements, please contact the platform team.

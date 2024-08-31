#!/bin/bash

# Create project directories
mkdir -p project_root/{app/{agents/{windows_agent,linux_agent},models,web_console,database,dashboard,config,utils},docker,tests/{test_agents,test_web_console,test_database},scripts}

# Create necessary files
touch project_root/{.gitignore,README.md,requirements.txt,docker/{Dockerfile.web_console,Dockerfile.windows_agent,Dockerfile.linux_agent,docker-compose.yml},scripts/{start_agents.sh,start_web_console.sh}}

echo "Project structure created successfully."

# Add initial content to files
cat <<EOL > project_root/.gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Packages
*.egg
*.egg-info/
dist/
build/
eggs/
parts/
var/
sdist/
develop-eggs/
.installed.cfg
lib/
lib64/
*.lock

# Docker
docker-compose.override.yml
docker-compose.yml
Dockerfile.*
/docker

# Appwrite
appwrite/config/

# Logs and databases
*.log
*.sql
*.sqlite
*.db

# PyQt5
*.qrc
*.pyc

# Other files
*.DS_Store
.vscode/
EOL

cat <<EOL > project_root/README.md
# Application Firewall Project

This project involves developing an application firewall for endpoints that can identify and restrict access to external networks/hosts.
The firewall provides granular control, allowing restrictions based on domains, IP addresses, and protocols for each application.
A centralized web console manages policies, and agents monitor network usage and detect anomalies using AI/ML.

## Components
- Firewall agents (Windows/Linux)
- Central Web Console (Streamlit and Flask)
- AI/ML Models for anomaly detection
- Appwrite for database management
- Real-time network monitoring

## Setup
Run \`setup.sh\` to create the project structure and initialize the environment.

## Docker
Use Docker to manage your environment and containers.
EOL

cat <<EOL > project_root/requirements.txt
# Requirements for the project
streamlit
flask
pyqt5
appwrite
xgboost
scikit-learn
numpy
pandas
docker
EOL

cat <<EOL > project_root/docker/docker-compose.yml
version: '3.8'

services:
  web_console:
    build:
      context: ..
      dockerfile: docker/Dockerfile.web_console
    ports:
      - "8000:8000"
    environment:
      - APPWRITE_ENDPOINT=http://appwrite:80/v1
    depends_on:
      - appwrite
      - database

  windows_agent:
    build:
      context: ..
      dockerfile: docker/Dockerfile.windows_agent
    depends_on:
      - web_console

  linux_agent:
    build:
      context: ..
      dockerfile: docker/Dockerfile.linux_agent
    depends_on:
      - web_console

  database:
    image: appwrite:latest
    ports:
      - "80:80"
    environment:
      - APPWRITE_DB_HOST=db
      - APPWRITE_DB_PORT=27017

  db:
    image: mongo
    ports:
      - "27017:27017"
EOL

cat <<EOL > project_root/docker/Dockerfile.web_console
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app/web_console /app/web_console

CMD ["streamlit", "run", "web_console/main.py"]
EOL

cat <<EOL > project_root/docker/Dockerfile.windows_agent
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app/agents/windows_agent /app/agents/windows_agent

CMD ["python", "agents/windows_agent/main.py"]
EOL

cat <<EOL > project_root/docker/Dockerfile.linux_agent
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY app/agents/linux_agent /app/agents/linux_agent

CMD ["python", "agents/linux_agent/main.py"]
EOL

cat <<EOL > project_root/scripts/start_agents.sh
#!/bin/bash
echo "Starting Windows and Linux Agents..."
docker-compose up -d windows_agent linux_agent
EOL

cat <<EOL > project_root/scripts/start_web_console.sh
#!/bin/bash
echo "Starting Web Console..."
docker-compose up -d web_console
EOL

echo "Setup script completed. Project is ready."

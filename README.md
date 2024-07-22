# Devopsfetch

## Installation

Run the following command to install the necessary dependencies and set up the systemd service:

```bash
sudo ./install.sh
```

## Usage

### Display all active ports and services

```bash
devopsfetch -p
```

### Display detailed information about a specific port

```bash
devopsfetch -p 80
```

### List all Docker images and containers

```bash
devopsfetch -d
```

### Display detailed information about a specific container

```bash
devopsfetch -d container_name
```

### Display all Nginx domains and their ports

```bash
devopsfetch -n
```

### Display detailed configuration information for a specific domain

```bash
devopsfetch -n domain.com
```

### List all users and their last login times

```bash
devopsfetch -u
```

### Display detailed information about a specific user

```bash
devopsfetch -u username
```

### Display activities within a specified time range

```bash
devopsfetch -t "last 24 hours"
```

## Logging

Logs are stored in `/var/log/devopsfetch.log` with log rotation managed by `logrotate`.
```

This setup ensures that you have a functioning `devopsfetch` tool with installation, continuous monitoring, and comprehensive documentation.

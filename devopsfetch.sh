#!/bin/bash

# Function to display help
function show_help() {
    echo "Usage: $0 [OPTION] [ARGUMENT]"
    echo "Options:"
    echo "  -p, --port [PORT_NUMBER]      Display active ports and services or details of a specific port"
    echo "  -d, --docker [CONTAINER_NAME] List Docker images and containers or details of a specific container"
    echo "  -n, --nginx [DOMAIN]          Display Nginx domains and ports or details of a specific domain"
    echo "  -u, --users [USERNAME]        List all users and last login times or details of a specific user"
    echo "  -t, --time [TIME_RANGE]       Display activities within a specified time range"
    echo "  -h, --help                    Show this help message"
}

# Function to display all active ports and services
function display_ports() {
    if [ -n "$1" ]; then
        sudo netstat -tuln | grep ":$1"
    else
        sudo netstat -tuln
    fi
}

# Function to list Docker images and containers
function display_docker() {
    if [ -n "$1" ]; then
        sudo docker inspect "$1"
    else
        sudo docker ps -a
        sudo docker images
    fi
}

# Function to display Nginx domains and ports
function display_nginx() {
    if [ -n "$1" ]; then
        sudo nginx -T | grep -A 10 "server_name $1"
    else
        sudo nginx -T | grep -E 'server_name|listen'
    fi
}

# Function to list users and last login times
function display_users() {
    if [ -n "$1" ]; then
        sudo lastlog -u "$1"
    else
        sudo lastlog
    fi
}

# Function to display activities within a specified time range (dummy implementation)
function display_time() {
    echo "Displaying activities from $1"
    # Add your custom time range handling code here
}

# Parse command-line arguments
case "$1" in
    -p|--port)
        display_ports "$2"
        ;;
    -d|--docker)
        display_docker "$2"
        ;;
    -n|--nginx)
        display_nginx "$2"
        ;;
    -u|--users)
        display_users "$2"
        ;;
    -t|--time)
        display_time "$2"
        ;;
    -h|--help)
        show_help
        ;;
    *)
        show_help
        ;;
esac

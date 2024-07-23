#!/bin/bash

# Function to display help
function show_help() {
    echo "Usage: $0 [OPTION] [ARGUMENT]"
    echo "Options:"
    echo "  -p, --port [PORT_NUMBER]      Display active ports and services or details of a specific port"
    echo "  -d, --docker [CONTAINER_NAME] List Docker images and containers or details of a specific container"
    echo "  -n, --nginx [DOMAIN]          Display Nginx domains and where they are proxied to"
    echo "  -u, --users [USERNAME]        List all users and last login times or details of a specific user"
    echo "  -t, --time [START_DATE END_DATE] Display activities within a specified time range"
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

# Function to display Nginx domains and where they are proxied to
function display_nginx() {
    if [ -n "$1" ]; then
        sudo nginx -T | awk -v domain="$1" '
            $1 == "server_name" && $2 == domain {
                getline;
                while ($1 != "}") {
                    if ($1 == "proxy_pass") {
                        print "Domain: " domain " is proxied to " $2;
                    }
                    getline;
                }
            }
        '
    else
        sudo nginx -T | awk '
            $1 == "server_name" {
                domain = $2;
                getline;
                while ($1 != "}") {
                    if ($1 == "proxy_pass") {
                        print "Domain: " domain " is proxied to " $2;
                    }
                    getline;
                }
            }
        '
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

# Function to display activities within a specified time range
function display_time() {
    if [ -n "$2" ]; then
        start_date=$(date -d "$1" +"%Y-%m-%d")
        end_date=$(date -d "$2" +"%Y-%m-%d")
        echo "Displaying activities from $start_date to $end_date"
        sudo journalctl --since "$start_date" --until "$end_date"
    else
        specific_date=$(date -d "$1" +"%Y-%m-%d")
        echo "Displaying activities on $specific_date"
        sudo journalctl --since "$specific_date" --until "$specific_date 23:59:59"
    fi
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
        display_time "$2" "$3"
        ;;
    -h|--help)
        show_help
        ;;
    *)
        show_help
        ;;
esac


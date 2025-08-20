#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default values
PLAYBOOK="site.yaml"
ENVIRONMENT="all"
CHECK_MODE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--playbook)
            PLAYBOOK="$2"
            shift 2
            ;;
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -c|--check)
            CHECK_MODE="--check"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -p, --playbook PLAYBOOK    Specify playbook (default: site.yaml)"
            echo "  -e, --environment ENV      Target environment (default: all)"
            echo "  -c, --check               Run in check mode (dry run)"
            echo "  -h, --help                Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                         # Deploy everything"
            echo "  $0 -p deploy.yml           # Run deployment playbook"
            echo "  $0 -e webservers           # Target only web servers"
            echo "  $0 -c                      # Dry run"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_status "Starting Ansible deployment..."
print_status "Playbook: $PLAYBOOK"
print_status "Target: $ENVIRONMENT"

# Check if inventory file exists
if [[ ! -f "inventory.yaml" ]]; then
    print_error "inventory.yaml not found!"
    exit 1
fi

# Check if playbook exists
if [[ ! -f "$PLAYBOOK" ]]; then
    print_error "Playbook '$PLAYBOOK' not found!"
    exit 1
fi

# Syntax check
print_status "Checking playbook syntax..."
if ansible-playbook "$PLAYBOOK" --syntax-check; then
    print_status "Syntax check passed!"
else
    print_error "Syntax check failed!"
    exit 1
fi

# Connectivity test
print_status "Testing connectivity..."
if ansible "$ENVIRONMENT" -m ping; then
    print_status "All hosts reachable!"
else
    print_error "Some hosts are not reachable!"
    exit 1
fi

# Run the playbook
print_status "Running playbook..."
if ansible-playbook "$PLAYBOOK" --limit "$ENVIRONMENT" $CHECK_MODE --diff; then
    print_status "Deployment completed successfully!"
else
    print_error "Deployment failed!"
    exit 1
fi

# Health check
if [[ "$CHECK_MODE" == "" && "$PLAYBOOK" == "site.yaml" ]]; then
    print_status "Running health checks..."
    
    # Check web servers
    print_status "Checking web servers..."
    for host in $(ansible webservers --list-hosts | tail -n +2 | tr -d ' '); do
        host_ip=$(ansible-inventory --host "$host" | grep ansible_host | cut -d'"' -f4)
        if curl -s "http://$host_ip/health" > /dev/null; then
            print_status "✓ $host ($host_ip) is healthy"
        else
            print_warning "✗ $host ($host_ip) health check failed"
        fi
    done
    
    # Check load balancers
    print_status "Checking load balancers..."
    for host in $(ansible loadbalancers --list-hosts | tail -n +2 | tr -d ' '); do
        host_ip=$(ansible-inventory --host "$host" | grep ansible_host | cut -d'"' -f4)
        if curl -s "http://$host_ip/health-lb" > /dev/null; then
            print_status "✓ Load balancer $host ($host_ip) is healthy"
        else
            print_warning "✗ Load balancer $host ($host_ip) health check failed"
        fi
    done
fi

print_status "All done! 🚀"
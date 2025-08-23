# Multi-Server Environment Deployment with Ansible

![Ansible](https://img.shields.io/badge/Ansible-EE0000?style=for-the-badge&logo=ansible&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)

## 📋 Table of Contents
- [Problem Statement](#-problem-statement)
- [Solution Overview](#-solution-overview)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Setup Instructions](#-setup-instructions)
- [Running the Project](#-running-the-project)
- [Testing & Verification](#-testing--verification)
- [Troubleshooting](#-troubleshooting)

## 🎯 Problem Statement

### The Challenge
Modern web applications require:
- **High Availability**: Applications must remain accessible even when individual servers fail
- **Scalability**: Ability to handle increasing traffic by distributing load across multiple servers
- **Consistent Deployment**: Manual server configuration leads to configuration drift and human errors
- **Infrastructure Management**: Managing multiple servers manually is time-consuming and error-prone
- **Load Distribution**: Single server setups create bottlenecks and single points of failure

### Real-World Scenario
Imagine you're running an e-commerce website that experiences:
- Varying traffic loads throughout the day
- Need for zero-downtime deployments
- Requirement for multiple server instances across different regions
- Need for automated configuration management
- Consistent environment setup across development, staging, and production

## 🚀 Solution Overview

This project implements an **Infrastructure as Code (IaC)** solution using Ansible to:

### ✅ Automated Multi-Server Deployment
- **Consistent Configuration**: All servers are configured identically using Ansible playbooks
- **Version Control**: Infrastructure configuration is stored in version control
- **Repeatable Deployments**: Same configuration can be deployed across multiple environments

### ✅ Load Balancing & High Availability
- **Nginx Load Balancer**: Distributes incoming requests across multiple web servers
- **Health Monitoring**: Automatic health checks ensure traffic only goes to healthy servers
- **Fault Tolerance**: If one server fails, others continue serving traffic

### ✅ Scalable Architecture
- **Horizontal Scaling**: Easy to add more web servers to handle increased load
- **Modular Design**: Separate roles for web servers and load balancers
- **Dynamic Configuration**: Load balancer automatically discovers and configures backend servers

## 🛠 Tech Stack

### Infrastructure & Automation
- **Ansible 2.9+**: Configuration management and automation
- **Ubuntu 20.04/22.04**: Base operating system for servers
- **AWS EC2**: Cloud infrastructure hosting

### Web Stack
- **Nginx**: Web server and load balancer
- **HTML5**: Frontend markup language
- **CSS3**: Styling with modern features (glassmorphism, gradients)
- **JavaScript**: Client-side interactivity and animations

### DevOps Tools
- **Bash Scripting**: Deployment automation scripts
- **SSH**: Secure server communication
- **Systemd**: Service management
- **JSON/YAML**: Configuration file formats

## 🏗 Architecture

### High-Level Architecture Diagram
```
                    ┌─────────────────┐
                    │   Internet      │
                    └─────────┬───────┘
                              │
                    ┌─────────▼───────┐
                    │  Load Balancer  │
                    │    (Nginx)      │
                    │  43.205.118.208 │
                    └─────────┬───────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
    ┌─────▼─────┐      ┌─────▼─────┐      ┌─────▼─────┐
    │Web Server 1│      │Web Server 2│      │Web Server 3│
    │   (Flask)  │      │   (Flask)  │      │   (Flask)  │
    │43.205.118.208│   │13.235.135.179│   │13.201.91.97│
    └───────────┘      └───────────┘      └───────────┘
```

### Component Architecture

#### 1. **Control Node** (Your Local Machine)
- Runs Ansible playbooks
- Manages SSH connections to target servers
- Coordinates deployment across all servers

#### 2. **Load Balancer Layer**
```
┌─────────────────────────────────────┐
│          Load Balancer              │
│  ┌─────────────────────────────────┐│
│  │         Nginx Proxy             ││
│  │  - Round-robin load balancing   ││
│  │  - Health checks (/health)      ││
│  │  - SSL termination (optional)   ││
│  │  - Request routing              ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

#### 3. **Web Server Layer**
```
┌─────────────────────────────────────┐
│           Web Servers               │
│  ┌─────────────────────────────────┐│
│  │         Nginx Server            ││
│  │  ┌─────────────────────────────┐││
│  │  │      Static HTML App        │││
│  │  │  - Dynamic server info      │││
│  │  │  - Interactive UI           │││
│  │  │  - Modern CSS styling       │││
│  │  │  - JavaScript animations    │││
│  │  └─────────────────────────────┘││
│  │                                 ││
│  │      Web Server Features        ││
│  │  ┌─────────────────────────────┐││
│  │  │         Nginx               │││
│  │  │  - Static content serving   │││
│  │  │  - Health check endpoints   │││
│  │  │  - Security headers         │││
│  │  │  - Gzip compression         │││
│  │  └─────────────────────────────┘││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### Network Flow
1. **Client Request** → Load Balancer (Port 80)
2. **Load Balancer** → Web Server (Round-robin distribution)
3. **Web Server Nginx** → Static HTML Application (Direct serving)
4. **HTML Application** → Dynamic content with server info displayed to client

## 📁 Project Structure

```
ansible-project/
├── 📄 README.md                          # Project documentation
├── ⚙️  ansible.cfg                        # Ansible configuration
├── 📋 inventory.yaml                      # Server inventory definition
├── 🎭 site.yaml                           # Main orchestration playbook
├── 🚀 deploy.yaml                         # Deployment-specific playbook
├── 🔧 deploy.sh                           # Automated deployment script
│
├── 📂 group_vars/                         # Group-specific variables
│   ├── 🌐 all.yaml                       # Variables for all hosts
│   ├── 💻 webservers.yaml                # Web server specific config
│   └── ⚖️  loadbalancers.yaml             # Load balancer specific config
│
├── 📂 roles/                              # Ansible roles directory
│   ├── 📂 webserver/                     # Web server role
│   │   ├── 📂 tasks/
│   │   │   └── main.yaml                 # Web server tasks
│   │   ├── 📂 handlers/
│   │   │   └── main.yaml                 # Service restart handlers
│   │   └── 📂 templates/
│   │       ├── app.j2                    # Application config template
│   │       └── nginx.conf.j2             # Nginx config template
│   │
│   └── 📂 loadbalancer/                  # Load balancer role
│       ├── 📂 tasks/
│       │   └── main.yaml                 # Load balancer tasks
│       ├── 📂 handlers/
│       │   └── main.yaml                 # Service restart handlers
│       └── 📂 templates/
│           └── nginx.conf.j2             # Nginx LB config template
```

## 📋 Prerequisites

### System Requirements
- **Control Machine**: Linux/macOS with Ansible installed
- **Target Servers**: Ubuntu 20.04/22.04 LTS
- **Network**: SSH access to all target servers
- **Resources**: Minimum 1GB RAM per server

### Required Software
```bash
# On Control Machine (your local system)
- Ansible >= 2.9
- SSH client
- curl (for testing)

# On Target Servers (automatically installed by playbook)
- Nginx
- curl, htop, net-tools
- systemd
```

### AWS Infrastructure
- **3 EC2 Instances** (Ubuntu 20.04/22.04)
- **Security Groups** allowing ports 22, 80, 443
- **SSH Key Pair** for server access
- **Elastic IPs** (optional but recommended)

## 🔧 Setup Instructions

### Step 1: Clone and Prepare the Project

```bash
# Clone the repository
git clone <repository-url>
cd ansible-project

# Make deployment script executable
chmod +x deploy.sh

# Verify project structure
ls -la
```

### Step 2: Install Ansible (Ubuntu/Debian)

```bash
# Update package index
sudo apt update

# Install Ansible
sudo apt install ansible -y

# Verify installation
ansible --version
```

### Step 3: Install Ansible (macOS)

```bash
# Using Homebrew
brew install ansible

# Using pip
pip3 install ansible

# Verify installation
ansible --version
```

### Step 4: Configure SSH Access

```bash
# Copy your private key to the project directory
cp ~/path/to/your/key.pem ./key1.pem

# Set proper permissions
chmod 600 key1.pem

# Test SSH connection to servers
ssh -i key1.pem ubuntu@43.205.118.208
ssh -i key1.pem ubuntu@13.235.135.179
ssh -i key1.pem ubuntu@13.201.91.97
```

### Step 5: Update Inventory Configuration

Edit `inventory.yaml` with your server details:

```yaml
all:
  children:
    webservers:
      hosts:
        web1:
          ansible_host: YOUR_SERVER_1_IP
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /path/to/your/key.pem
        web2:
          ansible_host: YOUR_SERVER_2_IP
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /path/to/your/key.pem
        web3:
          ansible_host: YOUR_SERVER_3_IP
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /path/to/your/key.pem

    loadbalancers:
      hosts:
        lb1:
          ansible_host: YOUR_LOADBALANCER_IP
          ansible_user: ubuntu
          ansible_ssh_private_key_file: /path/to/your/key.pem
```

### Step 6: Configure Variables

Review and modify `group_vars/all.yaml`:

```yaml
---
app_name: myapp
domain_name: your-domain.com  # or use IP address

common_packages:
  - curl
  - wget
  - vim
  - htop
  - git

allowed_ports:
  - 22
  - 80
  - 443
```

## 🚀 Running the Project

### Method 1: Using the Deployment Script (Recommended)

```bash
# Full deployment with health checks
./deploy.sh

# Deploy specific playbook
./deploy.sh -p deploy.yaml

# Target specific environment
./deploy.sh -e webservers

# Dry run (check mode)
./deploy.sh -c

# Show help
./deploy.sh -h
```

### Method 2: Manual Ansible Commands

```bash
# Test connectivity to all servers
ansible all -m ping

# Run syntax check
ansible-playbook site.yaml --syntax-check

# Deploy everything
ansible-playbook site.yaml

# Deploy only web servers
ansible-playbook site.yaml --limit webservers

# Deploy only load balancers
ansible-playbook site.yaml --limit loadbalancers

# Dry run mode
ansible-playbook site.yaml --check

# Verbose output
ansible-playbook site.yaml -vvv
```

### Method 3: Specific Deployment Tasks

```bash
# Deploy application updates only
ansible-playbook deploy.yaml

# Deploy to specific server
ansible-playbook site.yaml --limit web1

# Deploy with specific variables
ansible-playbook site.yaml -e "app_name=mywebapp"
```

## ✅ Testing & Verification

### Automated Health Checks

The deployment script automatically runs health checks:

```bash
# Health checks are included in the deployment script
./deploy.sh
# Will show:
# ✓ web1 (43.205.118.208) is healthy
# ✓ web2 (13.235.135.179) is healthy  
# ✓ web3 (13.201.91.97) is healthy
# ✓ Load balancer lb1 (43.205.118.208) is healthy
```

### Manual Testing

#### 1. Test Individual Web Servers
```bash
# Test web server health endpoints
curl http://43.205.118.208/health
curl http://13.235.135.179/health
curl http://13.201.91.97/health

# Expected response:
# OK - Server: web1, IP: 43.205.118.208

# Test static content serving
curl http://43.205.118.208/
curl http://13.235.135.179/
curl http://13.201.91.97/
```

#### 2. Test Load Balancer
```bash
# Test load balancer health
curl http://43.205.118.208/health-lb

# Test load balancing (should rotate between servers)
for i in {1..6}; do
  echo "Request $i:"
  curl http://43.205.118.208/ | grep server
  echo
done
```

#### 3. Test Web Application
```bash
# Access the main HTML application
curl http://43.205.118.208/

# Check server status endpoint
curl http://43.205.118.208/status

# Check server info endpoint
curl http://43.205.118.208/server-info.json

# View in browser (you'll see the beautiful multi-server demo page)
open http://43.205.118.208/  # macOS
xdg-open http://43.205.118.208/  # Linux
```

### Performance Testing
```bash
# Simple load test using Apache Bench
ab -n 100 -c 10 http://43.205.118.208/

# Monitor server resources
ansible all -m shell -a "htop -n 1"
```

## 🔍 Monitoring & Logs

### Check Application Logs
```bash
# View web server access logs
ansible webservers -m shell -a "tail -f /var/log/nginx/access.log"

# View web server error logs
ansible webservers -m shell -a "tail -f /var/log/nginx/error.log"

# View load balancer logs
ansible loadbalancers -m shell -a "tail -f /var/log/nginx/access.log"

# Check application directory
ansible webservers -m shell -a "ls -la /var/www/multi-server-demo/"
```

### System Status
```bash
# Check service status
ansible all -m shell -a "systemctl status nginx"

# Check server resources
ansible all -m shell -a "df -h && free -m"

# Check network connections
ansible all -m shell -a "netstat -tuln | grep :80"
```

## 🐛 Troubleshooting

### Common Issues & Solutions

#### 1. SSH Connection Issues
```bash
# Problem: Permission denied (publickey)
# Solution: Check SSH key permissions
chmod 600 key1.pem
ssh-add key1.pem  # Add key to SSH agent

# Test SSH connection manually
ssh -i key1.pem -vvv ubuntu@server-ip
```

#### 2. Ansible Connection Failures
```bash
# Problem: Ansible cannot connect to servers
# Solution: Test connectivity
ansible all -m ping -vvv

# Check inventory configuration
ansible-inventory --list
ansible-inventory --host web1
```

#### 3. Service Not Starting
```bash
# Problem: Nginx or application won't start
# Solution: Check logs and configuration

# Check nginx configuration
ansible webservers -m shell -a "nginx -t"

# Check service status
ansible all -m shell -a "systemctl status nginx"

# View error logs
ansible all -m shell -a "tail -20 /var/log/nginx/error.log"
```

#### 4. Load Balancer Not Working
```bash
# Problem: Load balancer not distributing requests
# Solution: Verify backend server connectivity

# Check if web servers are accessible from load balancer
ansible loadbalancers -m shell -a "curl -s http://43.205.118.208/health"
ansible loadbalancers -m shell -a "curl -s http://13.235.135.179/health"
ansible loadbalancers -m shell -a "curl -s http://13.201.91.97/health"

# Check nginx upstream configuration
ansible loadbalancers -m shell -a "nginx -T | grep upstream -A 10"
```

#### 5. Port Conflicts
```bash
# Problem: Port already in use
# Solution: Kill conflicting processes

# Find processes using port 80
ansible all -m shell -a "lsof -i :80"

# Kill nginx processes
ansible all -m shell -a "pkill nginx"

# Restart services
ansible all -m shell -a "systemctl restart nginx"
```

### Debug Mode Deployment
```bash
# Run with maximum verbosity
ansible-playbook site.yaml -vvv

# Run with step-by-step execution
ansible-playbook site.yaml --step

# Run specific tasks only
ansible-playbook site.yaml --start-at-task="Install nginx"
```

### Recovery Procedures

#### Reset Environment
```bash
# Stop all services
ansible all -m shell -a "systemctl stop nginx"

# Clean up application directories
ansible webservers -m shell -a "rm -rf /var/www/multi-server-demo"

# Remove custom nginx configs
ansible all -m shell -a "rm -f /etc/nginx/sites-enabled/multi-server-demo.conf"

# Redeploy
./deploy.sh
```

#### Individual Server Recovery
```bash
# Recover single web server
ansible-playbook site.yaml --limit web1

# Recover load balancer only  
ansible-playbook site.yaml --limit loadbalancers
```

---

## 📚 Additional Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Nginx Load Balancing Guide](https://nginx.org/en/docs/http/load_balancing.html)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using Infrastructure as Code principles**

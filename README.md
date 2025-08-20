# Ansible Project

## Overview
This project is designed to automate the deployment and configuration of a web application using Ansible. It includes playbooks, roles, and configuration files necessary for managing web servers and load balancers.

## Project Structure
```
ansible-project
├── ansible.cfg
├── inventory.yaml
├── site.yaml
├── deploy.yaml
├── deploy.sh
├── group_vars
│   ├── all.yaml
│   ├── webservers.yaml
│   └── loadbalancers.yaml
├── roles
│   ├── webserver
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   ├── handlers
│   │   │   └── main.yaml
│   │   └── templates
│   │       └── app.j2
│   └── loadbalancer
│       ├── tasks
│       │   └── main.yaml
│       ├── handlers
│       │   └── main.yaml
│       └── templates
│           └── nginx.conf.j2
└── README.md
```

## Files Description

- **ansible.cfg**: Configuration settings for Ansible, including inventory paths and roles paths.
- **inventory.yaml**: Defines the inventory of hosts for Ansible, specifying groups of servers and their connection details.
- **site.yaml**: The main playbook file that orchestrates the deployment and configuration of the application across the defined hosts.
- **deploy.yaml**: Responsible for deploying application updates to the web servers, including tasks for stopping existing processes, updating code, and starting the application.
- **deploy.sh**: Shell script to facilitate deployment, such as running Ansible playbooks or other deployment-related tasks.
- **group_vars/all.yaml**: Variables applicable to all hosts in the inventory.
- **group_vars/webservers.yaml**: Variables specific to the web server group, such as application settings and configurations.
- **group_vars/loadbalancers.yaml**: Variables specific to the load balancer group, such as load balancing settings.
- **roles/webserver/tasks/main.yaml**: Tasks defining actions to be performed on web servers, such as installing packages and configuring services.
- **roles/webserver/handlers/main.yaml**: Handlers triggered by tasks in the web server role, typically for restarting services.
- **roles/webserver/templates/app.j2**: Jinja2 template file used to generate configuration files for the web application dynamically.
- **roles/loadbalancer/tasks/main.yaml**: Tasks defining actions to be performed on load balancers, such as configuring Nginx or HAProxy.
- **roles/loadbalancer/handlers/main.yaml**: Handlers triggered by tasks in the load balancer role, typically for restarting load balancer services.
- **roles/loadbalancer/templates/nginx.conf.j2**: Jinja2 template file used to generate the Nginx configuration for the load balancer dynamically.

## Setup Instructions
1. Clone the repository to your local machine.
2. Update the `inventory.yaml` file with your server details.
3. Modify the `group_vars` files to set the necessary variables for your environment.
4. Run the playbooks using the command:
   ```
   ansible-playbook site.yaml
   ```

## Usage
This project can be used to deploy and manage a web application and its load balancer. Ensure that you have Ansible installed and configured on your control machine before running the playbooks.
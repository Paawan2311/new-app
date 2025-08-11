# Two-Tier Microservices Application CI/CD Pipeline on AWS

## Project Overview

This project automates the deployment of a two-tier microservices application on AWS using Terraform, Docker, Ansible, and GitHub Actions.

* **Services**:

  * **frontend-web**: Public-facing static web server container.
  * **backend-api**: Private REST API container communicating with PostgreSQL database.
* **Database**: Amazon RDS PostgreSQL instance.
* **Infrastructure**: AWS VPC with public/private subnets, Bastion host, EC2 instances running containers, Application Load Balancer.
* **Environments**: Separate `dev` and `prod` environments with different instance sizes and RDS HA.
* **CI/CD**: Automated build, push, and deployment via GitHub Actions.
* **Container Registry**: Amazon ECR.

---

## Architecture

```
Internet
   |
   v
[Application Load Balancer (ALB)]  <-- Public subnet, allows HTTP access
   |
   v
[frontend-web EC2 instances]       <-- Private subnet, running frontend Docker containers
   |
   v
[backend-api EC2 instances]        <-- Private subnet, running backend Docker containers
   |
   v
[Amazon RDS PostgreSQL]            <-- Private subnet, database accessible only by backend-api
```

* Bastion host in public subnet allows secure SSH access to private EC2 instances.
* Security groups restrict access:

  * ALB allows HTTP from anywhere.
  * Frontend instances allow HTTP from ALB only.
  * Backend instances allow traffic only from frontend instances.
  * RDS allows PostgreSQL connections only from backend instances.

---

## Components

### 1. Terraform

* Provisions complete AWS infrastructure: VPC, subnets, internet gateway, NAT gateway, security groups, EC2 instances, ALB, RDS with multi-AZ for production.
* Parameterized for `dev` and `prod` environments via variables.
* EC2 instances configured to install Docker on boot with user data.
* Creates key pairs, routes, and all networking components.

### 2. Docker

* Dockerfiles for `frontend-web` and `backend-api` optimized with multi-stage builds to produce minimal images.
* Images are built and pushed to dedicated Amazon ECR repositories.

### 3. Ansible

* Playbook connects to EC2 instances via Bastion host SSH proxy.
* Pulls the latest Docker images.
* Stops and removes existing containers gracefully.
* Starts new containers with environment-specific configurations (like DB endpoint, credentials).
* Ensures backend API service is healthy.

### 4. GitHub Actions Workflow

* Triggered on push to `develop` or `main` branch.
* Builds and pushes Docker images for frontend and backend.
* Deploys application to the appropriate environment (`dev` for `develop`, `prod` for `main`).
* Performs health checks via cURL on ALB endpoint.
* Uses secrets for AWS credentials, SSH keys, and host IPs.

---

## Setup & Usage

### Prerequisites

* AWS Account with IAM user permissions for ECR, EC2, RDS, VPC.
* SSH key pair created locally.
* Docker installed locally for building/testing images.
* GitHub repository with the code and workflow.
* Install Terraform CLI.
* Install Ansible on the machine running deployments (or use GitHub runner).

### Steps

1. **Configure Variables**

   * Update `variables.tf` and `terraform.tfvars` for your environment.
   * Provide your public SSH key path.
   * Specify instance types and DB credentials.

2. **Provision Infrastructure**

   ```bash
   terraform init
   terraform plan -var-file="terraform.tfvars"
   terraform apply -var-file="terraform.tfvars"
   ```

3. **Prepare ECR Repositories**

   Create two ECR repositories in AWS for frontend and backend images or let Terraform handle it.

4. **Set GitHub Secrets**

   In your GitHub repo, add these secrets:

   * `AWS_ACCESS_KEY_ID`
   * `AWS_SECRET_ACCESS_KEY`
   * `BASTION_SSH_PRIVATE_KEY` (contents of your PEM private key)
   * `BASTION_HOST` (Public IP/DNS of Bastion host)
   * `DEV_TARGET_HOSTS` (private IPs or DNS of dev EC2s)
   * `PROD_TARGET_HOSTS` (private IPs or DNS of prod EC2s)

5. **Push Code**

   Push your code to:

   * `develop` branch → deploys to dev environment.
   * `main` branch → deploys to prod environment.

6. **Verify Deployment**

   * Access the ALB URL to test frontend.
   * The frontend calls backend API securely.
   * Use Bastion host to SSH into EC2 for logs or troubleshooting.
   * Check container status with `docker ps`.

---

## Logs & Monitoring

* Application logs are accessible by SSH-ing into EC2 instances (via Bastion).
* Use `docker logs <container_name>` to view logs.
* For better log aggregation, consider integrating CloudWatch Logs or ELK stack (not included here).

---

## Notes & Best Practices

* Secrets management uses GitHub Secrets and environment variables; consider AWS Secrets Manager for production.
* Bastion host restricts SSH access, only from your IP.
* EC2 instances run Docker containers directly for simplicity; consider ECS or EKS for larger scale.
* The Ansible playbook uses SSH ProxyCommand to connect through Bastion.
* Health checks ensure only healthy targets get traffic via ALB.

---

## Future Enhancements

* Automate database migrations.
* Add monitoring dashboards and alerting.
* Implement centralized logging.
* Add blue/green or canary deployment strategies.
* Use AWS Systems Manager Parameter Store or Secrets Manager instead of GitHub secrets.

---



**Your Name**  Pawan Gupta
Email: pawan2gupta@gmail.com
GitHub: https://github.com/Paawan2311/new-app

---

This README covers architecture, setup, usage, and operations for your full CI/CD pipeline project. If you want, I can help generate the Ansible playbook or Dockerfiles next!

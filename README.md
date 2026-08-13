# DevOps Pipeline Project

A complete, end-to-end DevOps pipeline built from scratch — from a simple Node.js app to a fully automated, monitored deployment on real cloud infrastructure.

This project was built as a hands-on learning exercise covering the core tools used in modern DevOps workflows: version control, containerization, CI/CD, infrastructure as code, configuration management, container orchestration, and observability.

## Architecture

```
Code (Node.js/Express)
   │
   ▼
Git + GitHub  ──────────────▶  GitHub Actions (CI)
   │                                 │
   ▼                                 ▼
Docker Image  ◀──────────────  Build & Test
   │
   ├──────────────────────────────────────────┐
   ▼                                           ▼
Terraform (provisions AWS EC2)         Kubernetes (Minikube)
   │                                           │
   ▼                                           ▼
Ansible (configures server,             Deployment (2 replicas)
installs Docker, deploys app)           + Service + self-healing
   │                                           │
   ▼                                           ▼
App running on AWS                    Prometheus (metrics scraping)
                                                │
                                                ▼
                                       Grafana (live dashboards)
```

## Tech Stack

| Category | Tool | Purpose |
|---|---|---|
| Application | Node.js + Express | Simple REST API with a `/health` and `/metrics` endpoint |
| Version Control | Git + GitHub | Source control and remote repository |
| Containerization | Docker | Packaging the app into a portable, reproducible image |
| Local Orchestration | Docker Compose | Running the app alongside a MongoDB container |
| CI/CD | GitHub Actions | Automated build and validation on every push to `main` |
| Infrastructure as Code | Terraform | Provisioning an AWS EC2 instance, security group, and key pair |
| Configuration Management | Ansible | Installing Docker and deploying the app to the EC2 server |
| Container Orchestration | Kubernetes (Minikube) | Running the app as a self-healing, multi-replica deployment |
| Monitoring | Prometheus + Grafana | Scraping app metrics and visualizing them in real time |

## Project Structure

```
devops-project/
├── .github/workflows/
│   └── ci.yml                  # GitHub Actions CI pipeline
├── k8s/
│   ├── deployment.yaml         # Kubernetes Deployment (2 replicas)
│   ├── service.yaml            # Kubernetes Service (NodePort)
│   └── servicemonitor.yaml     # Prometheus scrape config
├── terraform/
│   └── main.tf                 # AWS EC2 + security group + key pair
├── app.js                      # Express app with Prometheus metrics
├── Dockerfile                  # Container image definition
├── docker-compose.yml          # Local app + MongoDB setup
├── playbook.yml                # Ansible playbook for server setup
├── inventory.ini               # Ansible inventory (target server)
├── package.json
└── README.md
```

## What This Project Demonstrates

- **Containerizing an application** with a multi-stage-ready `Dockerfile` and `.dockerignore`
- **Local multi-container development** using Docker Compose (app + database)
- **Continuous Integration** that automatically installs dependencies and builds the Docker image on every push
- **Infrastructure as Code** — an AWS EC2 instance, its networking rules, and SSH key pair are all defined declaratively in Terraform and can be recreated identically at any time
- **Configuration management** — Ansible playbooks install Docker and deploy the app to a fresh server with zero manual steps
- **Container orchestration** — a Kubernetes Deployment runs 2 replicas of the app behind a Service; killing a pod manually demonstrates Kubernetes automatically replacing it (self-healing)
- **Observability** — the app exposes a Prometheus-compatible `/metrics` endpoint (request counts, memory, CPU, event loop lag), scraped via a Kubernetes `ServiceMonitor` and visualized in a live Grafana dashboard

## Running It Locally

```bash
# Clone the repo
git clone https://github.com/Sumit-dev-coder/devops-project.git
cd devops-project

# Run with Docker Compose (app + MongoDB)
docker-compose up

# App available at http://localhost:3000
# Health check: http://localhost:3000/health
# Metrics: http://localhost:3000/metrics
```

## Deploying to Kubernetes (Minikube)

```bash
minikube start --driver=docker
minikube docker-env --shell powershell | Invoke-Expression
docker build -t devops-project:latest .

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/servicemonitor.yaml

kubectl port-forward service/devops-project-service 3000:3000
```

## Provisioning AWS Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Deploying to AWS with Ansible

```bash
ansible -i inventory.ini app_server -m ping
ansible-playbook -i inventory.ini playbook.yml
```

Built as a hands-on learning project to understand how core DevOps tools fit together in a real pipeline.

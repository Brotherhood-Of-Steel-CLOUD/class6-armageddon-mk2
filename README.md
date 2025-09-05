# Step-by-Step AWS EKS Terraform Deployment Guide

## 1. Project Overview
This guide walks you through deploying a highly available AWS EKS cluster using Terraform, and deploying three externally accessible, self-healing web apps in Kubernetes pods. Each app uses a unique Docker image and port, following best practices.

## 2. Prerequisites
- AWS account with appropriate permissions
- AWS CLI configured and authenticated
- Terraform installed
- Docker installed
- kubectl installed
- Git for version control

## 3. Infrastructure Setup
### a. Clone the Repository
```bash
git clone <your-repo-url>
cd aws-task2
```

### b. Initialize Terraform
```bash
cd terraform
terraform init
```

### c. Review and Edit Variables
Edit `variables.tf` to set your AWS region and cluster name as needed.

### d. Plan and Apply Infrastructure
```bash
terraform plan
terraform apply
```
Confirm resource creation when prompted.

### e. Destroy Infrastructure (when done)
```bash
terraform destroy
```

## 4. EKS Node Group Creation

The `nodegroup.tf` file defines the managed node group for your EKS cluster. This step provisions EC2 worker nodes that will run your Kubernetes pods.

**Key resources in `nodegroup.tf`:**
- `aws_eks_node_group`: Creates the node group and configures scaling, instance type, and SSH access.
- `aws_iam_role` and `aws_iam_role_policy_attachment`: Set up IAM permissions for the nodes to interact with EKS and other AWS services.

**Step-by-step:**
1. Review `nodegroup.tf` and update values if needed (e.g., SSH key name, instance type, scaling config).
2. Run the following commands to create the node group:
   ```bash
   cd terraform
   terraform plan
   terraform apply
   ```
   Confirm resource creation when prompted.
3. Verify node group creation in the AWS Console (EKS > Clusters > Your Cluster > Compute > Node Groups).
4. Once complete, your cluster will be ready to schedule pods.

## 5. Configure kubectl for EKS Cluster Access

After your EKS cluster and node group are created, configure `kubectl` to access the cluster:

1. **Update kubeconfig:**
   ```bash
   aws eks --region us-west-2 update-kubeconfig --name demo-eks-cluster
   ```
   This command sets up your local kubeconfig to connect to the EKS cluster.

2. **Verify cluster access:**
   ```bash
   kubectl get nodes
   ```
   You should see your worker nodes listed. This confirms your cluster is ready for deployments.

## 6. Dockerized App Deployment
### a. Build and Push Docker Images
- Create three simple Next.js apps.
- Build Docker images and push to Docker Hub.

### b. Kubernetes Manifests
- Write Deployment and Service YAML files for each app.
- Use `LoadBalancer` service type for external access.
- Apply manifests:
```bash
kubectl apply -f <manifest>.yaml
```

## 7. Create and Dockerize Three Next.js Apps

### a. Scaffold App Structure
- Create an `apps/` folder in your project root.
- Inside `apps/`, create three subfolders: `app1/`, `app2/`, `app3/`.

### b. Initialize Next.js TypeScript Apps
- In each subfolder, run:
  ```bash
  npx create-next-app@latest --typescript
  ```
- Follow prompts for linter, Tailwind CSS, src directory, App Router, Turbopack, and import alias as desired.

### c. Customize Home Pages
- Edit `src/app/page.tsx` in each app to:
  - Set a unique background color.
  - Display a unique label (e.g., "Hello World from App 1").

### d. Add Dockerfiles
- Add a `Dockerfile` to each app folder with the following content:
  ```Dockerfile
  FROM node:20-alpine AS builder
  WORKDIR /app
  COPY . .
  RUN npm install --frozen-lockfile
  RUN npm run build

  FROM node:20-alpine AS runner
  WORKDIR /app
  COPY --from=builder /app .
  EXPOSE 3000
  CMD ["npm", "start"]
  ```

### e. Version Control
- Add, commit, and push all changes:
  ```bash
  git add .
  git commit -m "Initialized three Next.js TypeScript apps and added Dockerfiles"
  git push
  ```

## 8. Build, Test, and Push Docker Images

### a. Build Docker Images
- For each app, run:
  ```bash
  docker build --no-cache -t oafleming/app1:latest ./apps/app1
  docker build --no-cache -t oafleming/app2:latest ./apps/app2
  docker build --no-cache -t oafleming/app3:latest ./apps/app3
  ```

### b. Test Locally
- Run each app locally to verify the custom Hello World screens:
  ```bash
  docker run -p 3000:3000 oafleming/app1:latest
  docker run -p 3001:3000 oafleming/app2:latest
  docker run -p 3002:3000 oafleming/app3:latest
  ```
- Visit `http://localhost:3000`, `http://localhost:3001`, and `http://localhost:3002` in your browser.

### c. Push to Docker Hub
- After verifying, push each image:
  ```bash
  docker push oafleming/app1:latest
  docker push oafleming/app2:latest
  docker push oafleming/app3:latest
  ```

All images are now available on Docker Hub for Kubernetes deployment.

## 9. Deploy Apps to EKS and Access Them

### a. Apply Kubernetes Manifests
- Deploy all three apps:
  ```bash
  kubectl apply -f apps/app1-deployment.yaml
  kubectl apply -f apps/app2-deployment.yaml
  kubectl apply -f apps/app3-deployment.yaml
  ```

### b. Verify Pods and Services
- Check that all pods are running:
  ```bash
  kubectl get pods
  ```
- Check services and note the `EXTERNAL-IP` for each app:
  ```bash
  kubectl get svc
  ```

### c. Access Your Apps
- Open a browser and visit the external endpoints for each app:
  - App 1: `http://<app1 EXTERNAL-IP>`
  - App 2: `http://<app2 EXTERNAL-IP>`
  - App 3: `http://<app3 EXTERNAL-IP>`
- You should see each app’s custom Hello World screen.

## 10. Version Control
- Commit changes after each major step:
```bash
git add .
git commit -m "Describe your change"
git push
```

## 11. Troubleshooting & Best Practices
- Check AWS Console for resource status.
- Use `kubectl get pods` and `kubectl logs` for debugging.
- Follow Kubernetes best practices: probes, resource limits, RBAC.

## 12. References
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

---
Update this guide as you progress and customize steps for your environment.

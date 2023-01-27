# Google Cloud Project
## Project Info.

This project contains:
*  Infrastructure as code using [Terraform](https://www.terraform.io/) that builds an environment on the google cloud platform
* Demo app with Dockerfile
* [Kubernetes](https://kubernetes.io) YAML files for deploying the demo app

## Tools Used

* [Terraform](https://www.terraform.io/)
* [GCP](https://cloud.google.com)
* [Docker](https://www.docker.com/)
* [kubernetes](https://kubernetes.io)
* [python](https://www.python.org)


## Get Started

### Get The Code 
* Using [Git](https://git-scm.com/), clone the project.

    ```
    git clone https://github.com/AmrTarek17/GCP-Terraform.git
    ```
### Setup Infra
* First setup your GCP account, create new project and change the value of "project_name" variable in terraform.tfvars with your PROJECT-ID.

* Second build the infrastructure by run

    ```bash
    cd GCP-Terraform/
    ```

    ``` 
    terraform init
    terraform apply
    ```
    that will build:
    
    * VPC named "vpc-network"
    * 2 Subnets "management-sub", "restricted-sub"
    * 3 Service Accounts
        * "gke-sa" used by Kubernetes cluster
        * "gke-management-sa" used by Management VM 
        * "docker-gcr-sa" we will use it to push the image to GCR

    * NAT in "management-sub"
    * Private Virtual Machine in "management-sub" subnet to manage the cluster.
    * Private Kubernetes cluster in "restricted-sub" with 3 worker nodes.

        ```bash
        # NOTE
        Only VMs in "management-sub" subnet can access the Kubernetes cluster.
        ```
    you can change some variables values in "terraform.tfvars"
    
### Build & Push Docker Image to GCR
* Build the Docker Image by run

    ```bash
    docker build -t eu.gcr.io/<PROJECT-ID>/my-app:1.0 src/
    ```
* pull Redis image and tag it
    ```bash
    docker pull redis:5.0
    docker tag redis:5.0 eu.gcr.io/<PROJECT-ID>/redis:5.0
    ```
* Setup credentials for docker to Push to GCR using "docker-gcr-sa" Service Account

    ```
    gcloud auth activate-service-account docker-gcr-sa --key-file=KEY-FILE
    gcloud auth configure-docker
    ```
* Push the Images to GCR

    ```
    docker push eu.gcr.io/<PROJECT-ID>/my-app:1.0
    docker push eu.gcr.io/<PROJECT-ID>/redis:5.0
    ```

### Deploy
* After the infrastructure got built, now you can login to the "management-vm" VM using SSH then:
    
    * setup cluster credentials
        ```
        gcloud container clusters get-credentials app-cluster --zone europe-west1-c --project <PROJECT-ID>
        ```
    * Change image in "k8s-yaml-files/deployments/app-deployment.yaml" with your image

    * Change image in "k8s-yaml-files/deployments/redis-pod.yaml" with your image

    * Upload the "k8s-yaml-files" dir to the VM and run
    
        ```
        kubectl apply -f k8s-yaml-files/
        ```

        that will deploy:
        
        * Config Map for environment variables used by demo app
        * Redis Pod and Exopse the pod with ClusterIP service
        * Demo App Deployment and Exopse it with NodePort service
        * Ingress to create HTTP loadbalancer

---
Now, you can access the Demo App by hitting the Ingress IP 

You can try my deployed demo from [here](http://34.160.145.6/)
And you can brows my Demo ScreenShots folder from GCP-Terraform/ScreenShots
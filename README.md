# Jenkinsfile
plugins we use
Terraform Plugin

CloudBees Docker Build and Publish plugin

Docker API Plugin

Docker Pipeline

Google Container Registry Auth Plugin

Google Kubernetes Engine Plugin

Google OAuth Credentials plugin
##############################################################################################
Plugins installation
Docker cli installation
https://docs.docker.com/engine/install/ubuntu/
or sudo apt install docker.io -y
-----------
getent group docker [verify if present]
sudo su jenkins
sudo groupadd docker
sudo usermod -aG docker $USER
sudo ls -l /var/run/docker.sock
sudo ls -l /var/run/docker.sock
sudo systemctl status docker
sudo systemctl start docker
getent group docker [verify if jenkins is added to the group]
Add docker & Jenkins into sudoers
vi /etc/sudoers
jenkins ALL=(ALL) NOPASSWD:ALL
docker ALL=(ALL) NOPASSWD:ALL
Ensure to logout & log back into jenkins for changes to apply. Both from CLI & GUI
#Note: Mandatrory to restart Jenkins
Still getting authentication error for pushing docker image
gcloud auth login
gcloud auth configure-docker us-central1-docker.pkg.dev
---------------
gcloud CLI installation
https://cloud.google.com/sdk/docs/install#versioned
Kubectl installation	
https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#apt
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
GitHub code for mvn-project
https://github.com/shantanu-da/mvn-project
GitHub code for pipelines
https://github.com/shantanu-da/Jenkinsfile
GithUb code for helm chart
-----------------
Performed these commands on Jenkins CLI after CI-CD Pipeline worked fine.
Problem is: Helm chart is getting deployed but Image pull fromGCR gives authentication error
kubectl create secret docker-registry gcr-access-token \
  --docker-server=us.gcr.io \
  --docker-username=oauth3accesstoken \
  --docker-password="$(gcloud auth print-access-token)" \
  --docker-email=priyanka2313rc.balidkar@gmail.com
  kubectl delete secret gcr-access-token
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "gcr-access-token"}]}'
[seviceaccount is of kubernetes, not GCP serviceaccount]
Reference documentation: https://blog.container-solutions.com/using-google-container-registry-with-kubernetes
Docker DocumentationDocker Documentation
Install Docker Engine on Ubuntu
Jumpstart your client-side server applications with Docker Engine on Ubuntu. This guide details prerequisites and multiple methods to install Docker Engine on Ubuntu.
Jan 31st (37 kB)
https://docs.docker.com/engine/install/ubuntu/

Google CloudGoogle Cloud
Install the gcloud CLI  |  Google Cloud CLI Documentation (17 kB)
https://cloud.google.com/sdk/docs/install#versioned

Google CloudGoogle Cloud
Install kubectl and configure cluster access  |  Google Kubernetes Engine (GKE)  |  Google Cloud (17 kB)
https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#apt

GitHubGitHub
GitHub - shantanu-da/mvn-project
Contribute to shantanu-da/mvn-project development by creating an account on GitHub. (36 kB)
https://github.com/shantanu-da/mvn-project

GitHubGitHub
GitHub - shantanu-da/Jenkinsfile
Contribute to shantanu-da/Jenkinsfile development by creating an account on GitHub. (32 kB)

pipeline {
    agent any
    tools {
        dockerTool 'docker'
        git 'Default'
        maven 'maven'
        terraform 'terraform'
    }
    environment {
        GCR_REGISTRY = "us-central1-docker.pkg.dev"
        PROJECT_NAME = "terraform-414406"
        repo_name = "demo"
        image_name = "demo-app"
        DEMO_IMAGE_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT}"
        MYSQL_IMAGE_TAG = "mysql-${env.BUILD_NUMBER}-${env.GIT_COMMIT}"
        DOCKERFILES_PATH = "/var/lib/jenkins/workspace/test-gcr-mysql"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shantanu-da/mvn-project.git'
            }
        }
        stage('Checkout-helmchart') {
            steps {
                git branch: 'main', url: 'https://github.com/shantanu-da/helm-chart.git'
            }
        }
        stage('Build MySQL Image') {
            steps {
                script {
                    docker.build("${GCR_REGISTRY}/${PROJECT_NAME}/${repo_name}/${image_name}-mysql:${MYSQL_IMAGE_TAG}", "-f Dockerfile.mysql .")
                }
            }
        }
        stage('Push MySQL Image to GCR') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp-terraform-creds', variable: 'GCR_CREDENTIALS')]) {
                        sh "gcloud auth activate-service-account --key-file=\$GCR_CREDENTIALS"
                    }
                    sh "docker push ${GCR_REGISTRY}/${PROJECT_NAME}/${repo_name}/${image_name}-mysql:${MYSQL_IMAGE_TAG}"
                }
            }
        }
        stage('Build DemoApp Image') {
            steps {
                script {
                    docker.build("${GCR_REGISTRY}/${PROJECT_NAME}/${repo_name}/${image_name}:${DEMO_IMAGE_TAG}")
                }
            }
        }
        stage('Push DemoApp Image to GCR') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'gcp-terraform-creds', variable: 'GCR_CREDENTIALS')]) {
                        sh "gcloud auth activate-service-account --key-file=\$GCR_CREDENTIALS"
                    }
                    sh "docker push ${GCR_REGISTRY}/${PROJECT_NAME}/${repo_name}/${image_name}:${DEMO_IMAGE_TAG}"
                }
            }
        }
        stage('Update Helm Chart Values') {
            steps {
                script {
                    // Remove the existing temp_repo directory if it exists
                    sh 'rm -rf temp_repo'
                    // Clone the repository to a temporary directory
                    sh 'git clone https://Snaatak-priya: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@github.com/shantanu-da/helm-chart.git temp_repo'
                    // Fetch the values.yaml file
                    def valuesFile = readFile('temp_repo/demo-app/values.yaml')
                    // Update the image tag in the values.yaml file
                    sh 'sed -i "11s/tag:.*/tag: ${DEMO_IMAGE_TAG}/" temp_repo/demo-app/values.yaml'
                    sh 'sed -i "91s/tag:.*/tag: ${MYSQL_IMAGE_TAG}/" temp_repo/demo-app/values.yaml'
                    // Commit the changes
                    dir('temp_repo') {
                        sh 'git add .'
                        sh 'git commit -m "Update image tag"'
                        sh 'git push origin main'
                    }
                }
            }
        }
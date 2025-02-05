pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the repository
                    git branch: 'main', url: 'https://github.com/Meghabetageri/Terraform-Jenkins.git'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Run terraform init command
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run terraform plan command
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Run terraform apply command
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}


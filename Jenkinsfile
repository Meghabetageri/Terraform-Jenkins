pipeline {
    agent any

    environment {
        // Use AWS credentials stored in Jenkins
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout code from GitHub
                    git branch: 'main', url: 'https://github.com/Meghabetageri/Terraform-Jenkins.git'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform (downloads required plugins)
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Run terraform apply to create EC2 instance
                    // This automatically approves the plan to apply the changes
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy (Optional)') {
            steps {
                script {
                    // Run terraform destroy if you want to clean up after testing
                    // Uncomment below line if you want to destroy resources after testing
                    // sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo 'EC2 instance created successfully!'
        }
        failure {
            echo 'Something went wrong!'
        }
    }
}

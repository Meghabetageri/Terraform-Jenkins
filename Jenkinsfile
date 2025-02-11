pipeline {
    agent any

    environment {
       aws_access_key     = credentials('aws_access_key')
        secret_key = credentials('secret_key')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    dir("terraform") {
                        // Checkout the code from the GitHub repository
                        git branch: 'main', url: 'https://github.com/Meghabetageri/Terraform-Jenkins.git'
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'cd terraform && terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run terraform plan and output the plan to a file
                    sh 'cd terraform && terraform plan -out=tfplan'
                    sh 'cd terraform && terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    // Read the plan file and ask for user input
                    def plan = readFile('terraform/tfplan.txt')
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply the terraform plan with correct arguments
                    sh 'cd terraform && terraform apply -input=false --auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Please check the error logs above for more details.'
        }
    }
}

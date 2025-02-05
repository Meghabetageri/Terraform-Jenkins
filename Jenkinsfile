pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // You do not need `dir("terraform")` here unless you want to checkout into that directory
                    // The Git checkout command will work as expected
                    git branch: 'main', url: 'https://github.com/Meghabetageri/Terraform-Jenkins.git'
                }
            }
        }
    }
}

pipeline {
    agent any
    options {
        timestamps()
        ansiColor('xterm')
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr:'20'))
    }

    parameters {
        choice(
name:'ENV',
choices:['dev', 'staging', 'prod'],
description:'Environment'
)

        choice(
name:'ACTION',
choices:['plan', 'apply', 'destroy'],
description:'Terraform Action'
)
    }

    environment {
        AWS_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Format') {
            steps {
                sh '''
                terraform fmt -recursive
                '''
            }
        }
        stage('Terraform Validate') {
            steps {
                dir("environments/${params.ENV}") {
                    sh '''
                    terraform init -backend=false
                    terraform validate
                    '''
                }
            }
        }
        stage('TFLint') {
            steps {
                sh 'tflint --recursive'
            }
        }
        stage('Checkov') {
            steps {
                sh 'checkov -d .'
            }
        }
        stage('Terraform Init') {
            steps {
                dir("environments/${params.ENV}") {
                    sh '''
                    terraform init \
                    -backend-config=backend.hcl
                    '''
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir("environments/${params.ENV}") {
                    sh '''
                    terraform plan \
                    -out=tfplan
                    ''' 
                }
            }
        }
        stage('Approval') {
            when {
                expression {
                    params.ACTION == 'apply' &&
                    params.ENV != 'dev'
                }
            }
            steps {
                input "Deploy to ${params.ENV} ?"
            }
        }
        stage('Terraform Apply') {
            when {
                expression {
                    params.ACTION == 'apply'
                }
            }
            steps {
                dir("environments/${params.ENV}") {
                    sh '''

                    terraform apply -auto-approve tfplan

                    '''
                }
            }
        }
        stage('Terraform Destroy') {
            when {
                expression {
                    params.ACTION == 'destroy'
                }
            }
            steps {
                dir("environments/${params.ENV}") {
                    sh '''

                    terraform destroy -auto-approve

                    '''
                }
            }
        }
    }
    post {
        success {
            echo 'Deployment Successful'
        }

        failure {
            echo 'Deployment Failed'
        }

        always {
            cleanWs()
        }
    }
}

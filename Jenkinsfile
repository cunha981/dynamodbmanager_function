pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [[$class: 'CleanCheckout']], userRemoteConfigs: [[url: 'https://github.com/cunha981/dynamodbmanager_function']]])            
          }
        }
        stage ('Unit Test') {
            steps {
                sh ('pip3 install -r requirements.txt')
                sh ('python3 -m unittest src/test/python/test_handler.py -v')
            }
        }
        stage ("Terraform init") {
            steps {
                dir("terraform"){
                    sh ('terraform init -reconfigure') 
                }
            }
        }
        stage ("Terraform plan") {
            steps {
                dir("terraform"){
                    sh ('terraform plan') 
                }
            }
        }
        
        stage ("Terraform apply") {
            steps {
                input("Deseja executar o apply?")
                dir("terraform"){
                    sh ('terraform apply --auto-approve') 
                }
           }
        }
        stage ("Terraform destroy?") {
            steps {
                input("Destroy?")
                dir("terraform"){
                    sh ('terraform destroy --auto-approve') 
                }
            }
        }
    }
}
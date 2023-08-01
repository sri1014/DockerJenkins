pipeline {
    agent any

    stages {
        stage('Git Cloning..') {
            steps {
              git 'https://github.com/javahometech/python-app.git'
            }
        }
        stage('Docker image ') {
            steps {
              sh 'docker build -t srikanth1014/pyapp:0.1 .'
            }
        }
        stage('DockerPush Image ') {
            steps {
              withCredentials([usernamePassword(credentialsId: 'docker', passwordVariable: 'pwd', usernameVariable: 'user')]) { 
                    sh "docker login -u ${user} -p ${pwd}"
                     sh "docker push srikanth1014/pyapp:0.1"
                        
                }
            }
        }
        stage('Deploy Docker image ') {
            steps {
             sshagent(['dockerkey']) {
                 
                 sh "ssh -o StrictHostKeyChecking=no ec2-user@15.206.158.76 docker rm -f pyapp"
                 
                 sh "ssh ec2-user@15.206.158.76 docker run -d -p 9090:5000 --name pyapp srikanth1014/pyapp:0.1"
    
                }
            }
        }
    }
}


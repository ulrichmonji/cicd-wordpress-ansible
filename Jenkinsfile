pipeline {
     environment {
       ID_DOCKER = "choco1992"
       IMAGE_NAME = "static-website-ib"
       IMAGE_TAG = "v1"  
       DOCKERHUB_PASSWORD = credentials('dockerhubpassword')
     }
     agent none
     stages {
         stage('Build image') {
             agent any
             steps {
                script {
                  sh 'docker build -t ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG .'
                }
             }
        }
        stage('Run container based on builded image') {
            agent any
            steps {
               script {
                 sh '''
                    docker run --name $IMAGE_NAME -d -p 80:80 -e PORT=80 ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
                    sleep 5
                 '''
               }
            }
       }
       stage('Test image') {
           agent any
           steps {
              script {
                sh '''
                    curl http://jenkins | grep -i "dimension"
                '''
              }
           }
      }
      stage('Clean Container') {
          agent any
          steps {
             script {
               sh '''
                 docker stop $IMAGE_NAME
                 docker rm $IMAGE_NAME
               '''
             }
          }
     }
     
     stage ('Login and Push Image on docker hub') {
          agent any
          steps {
             script {
               sh '''
                   echo $DOCKERHUB_PASSWORD | docker login -u $ID_DOCKER --password-stdin
                   docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
               '''
             }
          }
      }     
     
     
     stage('Prepare ansible environment') {
            agent any
            environment {
                PRIVATE_KEY = credentials('private_keys_jenkins')
            }
            steps {
                sh '''
                     cp  $PRIVATE_KEY  devops-ulrich.pem
                     chmod 600 devops-ulrich.pem
                '''
            }
     }          
          
     stage('Push image in staging and deploy it') { 
          when {
              expression { GIT_BRANCH == 'origin/live_07-12-2023' } 
          }          
           agent any
           steps {
               script {
                 sh '''
                     cd $WORKSPACE/ansible && ansible-playbook playbooks/deploy_app.yml  --private-key ../devops-ulrich.pem -e env=staging                   
                 '''
               }
           }
     }
     stage('Push image in production and deploy it') {
          when {
              expression { GIT_BRANCH == 'origin/master' }
          }
          agent any
          steps {
               script {
                 sh '''
                     cd $WORKSPACE/ansible && ansible-playbook playbooks/deploy_app.yml  --private-key ../devops-ulrich.pem -e env=prod
                 '''
               }
          }
     }
          
     stage('Remove temp files') {
            agent any
            steps {
                sh '''
                     rm -fr $WORKSPACE/ansible/devops-ulrich.pem
                '''
            }
     }            
  }
}

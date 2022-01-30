pipeline {
    agent any
    
    environment {
    scannerHome=tool name: 'sonar_scanner_java'
    PROJECT_ID='fleet-diagram-339515'
    CLUSTER_NAME = 'cluster-1'
    LOCATION = 'us-central1-c'
    CREDENTIALS_ID = 'kubernetes'    

    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "Maven3"
    }
    
    options {
    timeout(10)
    timestamps()
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '')
}

stages {
 /* stage('checkout') {
    steps {
      git credentialsId: 'gitHub', url: 'https://github.com/jitulabhi/spring-boot-rest-example.git', branch: 'develop'
    }
  }
    
    

  stage('build') {
    steps {
      sh 'mvn clean install'
    }
  }

  stage('test') {
    steps {
      sh 'mvn test'
    }
  }
    
    stage('sonarqube analysis'){
        steps{
            withSonarQubeEnv('Test_Sonar'){                
                     sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
             }
            
        }
    }
    
    stage('Docker Build'){
        steps {
            sh 'docker build -t jitulabhi/i-jitendralabhi-develop:latest -t jitulabhi/i-jitendralabhi-develop:${BUILD_NUMBER} .'
        }
    }
    
    stage('push docker build'){    
        steps {
            script{
                withDockerRegistry(credentialsId: 'dockerHub', toolName: 'docker'){
                sh 'docker push  jitulabhi/i-jitendralabhi-develop:${BUILD_NUMBER}'
                sh 'docker push  jitulabhi/i-jitendralabhi-develop:latest'
                }
            }
        }
    }*/
    
   /* stage('remove previos container'){
        steps{
            script{
                try{
                    sh 'docker rm -f $(docker ps --filter "name=spring-boot-rest-example" -aq)'
                }catch(err){
                echo err.getMessage() 
                }
            }
        }
    }
    
    stage('Docker start container'){
        steps {
            sh 'docker run -d --name spring-boot-rest-example -p 8090:8090 jitulabhi/spring-boot-rest-example:${BUILD_NUMBER}'
        }
    }*/
    
    stage('Deploy on kubernetes'){
          steps {
           // sh 'gcloud config set account jitulabhi@gmail.com'
           // sh 'gcloud container clusters get-credentials cluster-1 --zone us-central1-c --project fleet-diagram-339515'
            //sh 'kubectl apply -f deployment.yaml'
            //sh 'kubectl apply -f configmap.yaml'
            //sh 'kubectl apply -f secrets.yaml'
            //sh 'kubectl apply -f deployment.yaml'
              
            step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, location: env.LOCATION, clusterName: env.CLUSTER_NAME, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID]) ; 
         step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, location: env.LOCATION, clusterName: env.CLUSTER_NAME, manifestPattern: 'configmap.yaml', credentialsId: env.CREDENTIALS_ID]) ;
              step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, location: env.LOCATION, clusterName: env.CLUSTER_NAME, manifestPattern: 'secrets.yaml', credentialsId: env.CREDENTIALS_ID]) ;
              step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, location: env.LOCATION, clusterName: env.CLUSTER_NAME, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID]) ;
          }
    }

}

 post {
      always {
        junit 'target/surefire-reports/*.xml'
      }
   } 
    
}

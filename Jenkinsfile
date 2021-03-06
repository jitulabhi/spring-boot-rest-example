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
  stage('checkout') {
    steps {
      git credentialsId: 'gitHub', url: 'https://github.com/jitulabhi/spring-boot-rest-example.git', branch: 'master'
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
            sh 'docker build -t jitulabhi/i-jitendralabhi-master:latest -t jitulabhi/i-jitendralabhi-master:${BUILD_NUMBER} .'
        }
    }
    
    stage('push docker build'){    
        steps {
            script{
                withDockerRegistry(credentialsId: 'dockerHub', toolName: 'docker'){
                sh 'docker push  jitulabhi/i-jitendralabhi-master:${BUILD_NUMBER}'
                sh 'docker push  jitulabhi/i-jitendralabhi-master:latest'
                }
            }
        }
    }
    
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

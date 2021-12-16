pipeline {
    agent any
    
    environment {
    scannerHome=tool name: 'sonar_scanner'
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven3"
    }
    
    options {
    timeout(10)
    timestamps()
    buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '')
}

stages {
  stage('checkout') {
    steps {
      git credentialsId: 'gitHub', url: 'https://github.com/jitulabhi/spring-boot-rest-example.git'
    }
  }
    
    stage('start sonarqube analysis'){
        steps{
            withSonarQubeEnv('Test_Sonar'){                
                     sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
             }
            
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
    
    stage('Docker Build'){
        steps {
            sh 'docker build -t jitulabhi/spring-boot-rest-example:${BUILD_NUMBER} .'
        }
    }
    
    stage('push docker build'){    
        steps {
            script{
                withDockerRegistry(credentialsId: 'dockerHub', toolName: 'docker'){
                sh 'docker push jitulabhi/spring-boot-rest-example:${BUILD_NUMBER}'
                }
            }
        }
    }
    
    stage('remove previos container'){
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
    }

}

 post {
      always {
        junit 'target/surefire-reports/*.xml'
      }
   } 
    
}

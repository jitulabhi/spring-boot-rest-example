pipeline {
    agent any

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
            sh 'docker build -t spring-boot-rest-example:${BUILD_NUMBER}'
        }
    }

}

 post {
      always {
        junit 'target/surefire-reports/*.xml'
      }
   } 
    
}

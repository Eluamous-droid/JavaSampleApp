pipeline {
  environment {
    registry = "nesmid/cictestapp"
    registryCredential = 'dockerhub'
    dockerImage = ''
    mvnHome = ''
  }
  agent any
  stages {
    stage('Preparation') {
        steps{
            git 'https://github.com/Eluamous-droid/JavaSampleApp'
            mvnHome = tool 'M3'
        }
    }
    stage('Build') {
        steps{
        // Run the maven build
        withEnv(["MVN_HOME=$mvnHome"]) {
                if (isUnix()) {
                    sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean package'
                } else {
                    bat(/"%MVN_HOME%\bin\mvn" -Dmaven.test.failure.ignore clean package/)
                    }
                }
            }
        }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
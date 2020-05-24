node {
   def mvnHome
   environment {
       registry = "nesmid/cictestapp"
       registryCredential = 'dockerhub'
     }
   stage('Preparation') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/Eluamous-droid/JavaSampleApp'
      // Get the Maven tool.
      // ** NOTE: This 'M3' Maven tool must be configured
      // **       in the global configuration.
      mvnHome = tool 'M3'
   }
   stage('Build') {
      // Run the maven build
      withEnv(["MVN_HOME=$mvnHome"]) {
         if (isUnix()) {
            sh '"$MVN_HOME/bin/mvn" -Dmaven.test.failure.ignore clean package'
         } else {
            bat(/"%MVN_HOME%\bin\mvn" -Dmaven.test.failure.ignore clean package/)
         }
      }
   }
   stage('Building image') {
             docker.build registry + ":$BUILD_NUMBER"
         }
   stage('Push image'){
   docker.push registry + ":$BUILD_NUMBER"
   }
}
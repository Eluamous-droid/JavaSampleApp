try {
             timeout(time: 20, unit: 'MINUTES') {
                def appName="${APP_NAME}"
                def project=""

                node {
                  stage("Initialize") {
                    project = env.PROJECT_NAME
                  }
                }

                node("maven") {
                  stage("Checkout") {
                    git url: "${GIT_SOURCE_URL}", branch: "${GIT_SOURCE_REF}"
                  }
                  stage("Build JAR") {
                    sh "mvn clean package -Popenshift"
                    stash name:"jar", includes:"target/app.jar"
                  }
                }

                node {
                  stage("Build Image") {
                    unstash name:"jar"
                    def status = sh(returnStdout: true, script: "oc start-build ${appName}-docker --from-file=target/app.jar -n ${project}")

                    def result = status.split("\n").find{ it.matches("^build.*started") }
                    
                    if(!result) {
                      echo "ERROR: No started build found for ${appName}"
                      currentBuild.result = 'FAILURE'
                      return
                    }
                    
                    // result can be:
                    // - build "build-name" started
                    // - build build.build.openshift.io/build-name started
                    // - build "build.build.openshift.io/build-name" started
                    // Goal is to isolate "build-name"
                    def startedBuild = result.replaceAll("build [^0-9a-zA-Z]*", "").replaceAll("[^0-9a-zA-Z]* started", "").replaceFirst("^.*/", "")
                    echo "Build ${startedBuild} has started. Now watching it ..."
                    
                    timeout(time: 20, unit: 'MINUTES') {
                      openshift.withCluster() {
                        openshift.withProject() {
                          def build = openshift.selector('builds', "${startedBuild}")
                          build.untilEach {
                            def object = it.object()
                            if(object.status.phase == "Failed") {
                              error("Build ${startedBuild} failed")
                            }
                            return object.status.phase == "Complete"
                          }
                        }
                      }  
                    }
                  }
                  stage("Deploy") {
                    openshift.withCluster() {
                      openshift.withProject() {
                        def dc = openshift.selector('dc', "${appName}")
                        dc.rollout().status()
                      }
                    }
                  }
                }
             }
          } catch (err) {
             echo "in catch block"
             echo "Caught: ${err}"
             currentBuild.result = 'FAILURE'
             throw err
          }
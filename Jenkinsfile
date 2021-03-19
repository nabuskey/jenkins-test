pipeline {
  agent {
    kubernetes {
      yaml """\
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: docker
            image: docker:19.03.1-dind
            securityContext:
              privileged: true
            env:
              - name: DOCKER_TLS_CERTDIR
                value: ""
        """.stripIndent()
    }
  }
  stages {
    stage('Clone repository') {
      steps {
        checkout scm
        script {
          gitTag=sh(returnStdout: true, script: "git tag --contains | head -1").trim()
        }
      }
    }
    stage('Build image release') {
      environment {
        TAG_NAME = gitTag
      }
      when { buildingTag() }
      steps {
        container('docker'){
          sh 'echo build release'
          script {
            app = docker.build("nabuskey/jenkins-test")
            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                app.push("${env.TAG_NAME}")
            }
          }      
        }
      }
    }
    stage('Build image') {
      environment {
        TAG_NAME = gitTag
      }
      when { not { buildingTag() }}
      steps {
        container('docker'){
          sh 'echo build'
          script {
            app = docker.build("nabuskey/jenkins-test")
            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
              app.push("${env.BUILD_NUMBER}")
              app.push("latest")
            }
          }      
        }
      }
    }
  }
}





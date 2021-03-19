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
      }
    }
    stage('Build image release') {
      when { buildingTag() }
      steps {
        container('docker'){
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
      when { not { buildingTag() }}
      steps {
        container('docker'){
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





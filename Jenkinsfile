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
          sh "echo ${gitTag}"
          env.TAG_NAME=sh(returnStdout: true, script: "git tag --contains | head -1").trim()
          sh "echo ${env.Tag_NAME}"
        }
      }
    }
    stage('Build image release') {
      when { buildingTag() }
      steps {
        container('docker'){
          sh 'echo build release'
          script {
            app = docker.build("nabuskey/jenkins-test", "--build-arg jobName=${env.JOB_NAME} .")
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
          sh 'echo build'
          script {
            app = docker.build("nabuskey/jenkins-test", "--build-arg jobName=${env.JOB_NAME} --label buildNumber=${env.BUILD_NUMBER} --label commitId=${env.GIT_COMMIT} --label branch=${env.GIT_BRANCH} .")
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





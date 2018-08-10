pipeline {
  agent any
  stages {
    stage('do thing') {
      when { branch 'master' }
      steps {
        script {
          sh "echo 'hello world'"
        }
      }
    }
  }
}

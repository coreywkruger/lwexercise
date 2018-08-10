pipeline {
  agent any
  stages {
    stage('do thing') {
      when { branch 'master' }
      steps {
        script {
          sh "exit 1"
        }
      }
    }
  }
}

@Library("Shared") _

pipeline{
    agent any;
    environment {
        DOCKERHUB_USER = 'sagar4work'
        IMAGE_NAME     = 'bankapp'
        IMAGE_TAG      = 'v2'
       /* SONAR_HOME = tool "Sonar"  */
    }

    stages {
        stage("Clone Code") {
            steps {
                script {
                    gitClone("https://github.com/sagardas02/Springboot-BankApp.git", "dev")
                }
            }
        }

        stage("Trivy"){
            steps{
                sh "trivy fs ."
            }
        }

       /* stage("SonarQube Quality"){
            steps{
                withSonarQubeEnv("SONAR_HOME"){
                sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=bankapp -Dsonar.projectKey=bankapp -X"
                }
            }
        }  */

 stage("Build Docker Image") {
            steps {
                script {
                    docker_build(env.DOCKERHUB_USER, env.IMAGE_NAME, env.IMAGE_TAG)
                }
            }
        }

        stage("Push to Docker Hub") {
            steps {
                script {
                    docker_push(env.DOCKERHUB_USER, env.IMAGE_NAME, env.IMAGE_TAG)
                }
            }
        }
    }
}

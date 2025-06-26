@Library("Shared") _

pipeline{
    agent any;
    environment {
        dockerhubuser = 'sagar4work'  
        imagename = 'bankapp'   
        imagetag = "v${BUILD_NUMBER}"   
        
        gitBranch = "prd"
        
    }

    stages{
        stage("code clone"){
            steps{
                script{
                    gitClone("https://github.com/sagardas02/Springboot-BankApp.git","prd")
                }
            }
        }

        stage("Build"){
            steps{
                script{
                    docker_build(env.dockerhubuser,env.imagename,env.imagetag)
                }
            }
        }

        stage("push to docker hub"){
            steps{
                script{
                    docker_push(env.dockerhubuser,env.imagename,env.imagetag)
                }
            }
        }
                stage('Update Kubernetes Manifests') {
            steps {
                script {
                    update_k8s_manifests(
                        imageTag: env.imagetag,
                        manifestsPath: 'kubernetes',
                        gitCredentials: 'githubCredentials',
                        gitUserName: 'sagardas02',
                        gitUserEmail: 'sagardas4work@gmail.com',
                        gitBranch: env.gitBranch
                    )
                }
            }
        }
    }
}
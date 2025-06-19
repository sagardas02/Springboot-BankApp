@Library("Shared") _

pipeline{
    agent any;
    environment {
        dockerhubuser = 'your-dockerhub-username'  // Replace with actual username or use a parameter
        imagename = 'your-image-name'   
        imagetag = "image tag dew bro"           // Replace with actual image name
    }

    stages{
        stage("code clone"){
            steps{
                script{
                    gitClone("url","branch")
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
    }
}
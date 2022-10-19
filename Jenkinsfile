pipeline {
    agent any

    environment {
        REPOSITORY_URI = 'tommytran2804/k8spipelineapp'
        HELM_REPOSITORY = 'https://github.com/TranThang-2804/k8s-manifest-for-simple-java-app.git'
        CI = 'false'
        dockerhub=credentials('dockerhub')
    }
    
    // tools {
    //     maven 'maven-3.8.6' 
    // }

    stages {
        // stage('Pre build') {
        //     steps {
        //         sh 'sudo snap yq'
        //     }
        // }
        stage('Build') {
            steps {
                echo 'pulled git repo'
                // Run Maven on a Unix agent.
                echo 'Start building project'

                sh 'mvn clean package'

                echo 'finished building'
                // To run Maven on a Windows agent, use
                // bat "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }
        stage('Create Docker Image') {
            steps {
                echo 'CREATING DOCKER IMAGE'
                // sh 'sudo usermod -aG docker jenkins'
                // sh 'newgrp docker'
                sh 'docker build --platform linux/amd64 -t ${REPOSITORY_URI}:latest .'
            }

        }
        stage('Push to registry') {
            steps {
                sh 'echo $dockerhub_PSW | docker login -u $dockerhub_USR --password-stdin'
                sh '''#!/bin/bash
                    export IMAGE_TAG=$(echo build_$(echo `date -d '+7 hours' +%F`)_$(echo `date -d '+7 hours' +%T`) | awk ' { gsub (":", ".")} 1 ')
                    docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
                    docker push ${REPOSITORY_URI}:latest
                    docker push ${REPOSITORY_URI}:$IMAGE_TAG
                    echo $IMAGE_TAG > tagnamefile
                '''
            }
        }
        stage('Update Helm manifest file') {
            steps {
                sh 'cat tagnamefile'
                sh 'rm -rf ./k8s-manifest-for-simple-java-app'
                sh 'git clone ${HELM_REPOSITORY}'
                sh "yq -i '.deployment.tag = \"demo\"' ./k8s-manifest-for-simple-java-app.git/charts/helm-demo/values.yaml"

                echo 'update helm manifest'
            }
        }
    }
}

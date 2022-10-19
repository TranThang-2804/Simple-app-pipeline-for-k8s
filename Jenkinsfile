pipeline {
    agent any

    environment {
        REPOSITORY_URI = 'tommytran2804/k8spipelineapp'
        CI = 'false'
        dockerhub=credentials('dockerhub')
    }
    
    // tools {
    //     maven 'maven-3.8.6' 
    // }

    stages {
        // stage('Pre build') {
        //     steps {
        //         echo 'INSTALL ENVIRONMENT'
        //         sh 'sudo npm install -g npm@8.13.2'
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
                sh '''#!/bin/bash
                    IMAGE_TAG=$(echo build_$(echo `date -d '+7 hours' +%F`)_$(echo `date -d '+7 hours' +%T`) | awk ' { gsub (":", ".")} 1 ')
                    echo $IMAGE_TAG
                '''
                echo $IMAGE_TAG
                sh 'docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG'
                sh 'echo $dockerhub_PSW | docker login -u $dockerhub_USR --password-stdin'
                sh 'docker push ${REPOSITORY_URI}:latest'
                sh 'docker push ${REPOSITORY_URI}:$IMAGE_TAG'
            }
        }
        stage('Update Helm manifest file') {
            steps {
                echo 'update helm manifest'
            }
        }
    }
}

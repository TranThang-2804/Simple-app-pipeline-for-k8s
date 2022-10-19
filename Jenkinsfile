pipeline {
    agent any

    environment {
        CI = 'false'
        dockerhub=credentials('dockerhub')
    }

    stages {
        stage('Pre build') {
            steps {
                echo 'INSTALL ENVIRONMENT'
                sh 'sudo npm install -g npm@8.13.2'
            }
        }
        stage('Build') {
            steps {
                echo 'pulled git repo'
                // Run Maven on a Unix agent.
                echo 'Start building project'

                echo 'INSTALLING DEPENDENCIES'
                sh 'npm install'
                echo 'DEPENDENCIES INSTALLED'

                echo 'BUILDING ARTIFACT'
                sh 'npm run build'
                echo 'ARTIFACT BUILT'

                echo 'finished building'
                // To run Maven on a Windows agent, use
                // bat "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }
        stage('Create Docker Image') {
            steps {
                echo 'CREATING DOCKER IMAGE'
                sh 'sudo usermod -aG docker jenkins'
                sh 'newgrp docker'
                sh 'docker build -t webservice:current .'
            }

        }
        stage('Push to registry') {
            steps {
                sh 'docker image tag webservice:current tranthang2804/webservice:current'
                sh 'echo $dockerhub_PSW | docker login -u $dockerhub_USR --password-stdin'
                sh 'docker image push tranthang2804/webservice:current'
            }
        }
        stage('Deploy on Docker Swarm') {
            steps {
                echo 'DEPLOY ON DOCKER SWARM'
                sh 'docker service update \
                    --update-parallelism 1 \
                    --update-delay 10s \
                    --image tranthang2804/webservice:current \
                    --force \
                    webapp'
                sh 'echo UPDATED IMAGE FOR SERVICE ON DOCKER SWARMM'
            }
        }
    }
}

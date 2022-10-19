version: 0.2

phases:
  pre_build:
    commands:
      - echo Connecting to Amazon ECR...
      - ECR_URI=515515786789.dkr.ecr.ap-southeast-1.amazonaws.com
      - aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin $ECR_URI
      - REPOSITORY_URI=$ECR_URI/sandbox-java-registry
      - IMAGE_TAG=$(echo build_$(echo `date -d '+7 hours' +%F`)_$(echo `date -d '+7 hours' +%T`) | awk ' { gsub (":", ".")} 1 ')

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - mvn clean package
      - docker build --platform linux/amd64 -t $REPOSITORY_URI:latest .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"cdg-zig-mobile-backend-container","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
      - cat imagedefinitions.json

reports:
  jacoco-report:
    files:
    - '**/*'
    base-directory: 'target/surefire-reports'

cache:
  paths:
  - '/root/.m2/**/*'

artifacts:
  files: imagedefinitions.json
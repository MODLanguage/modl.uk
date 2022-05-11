def SHORT_COMMIT
def SCM_REPO

podTemplate(
    imagePullSecrets: ['dockerhub-imagepull'],
    containers: [
        containerTemplate(
            name: 'docker',
            image: 'docker:20.10.15-alpine3.15',
            ttyEnabled: true,
            command: 'cat',
            resourceRequestCpu: '200m',
            resourceLimitCpu: '200m',
            resourceRequestMemory: '512Mi',
            resourceLimitMemory: '512Mi'),
    ],
    volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    ]) {

      node(POD_LABEL) {
        SCM_REPO = checkout scm
        DOCKERHUB_REPO = "numtechnology/modl-uk-ruby"

        try {
            stage('Build Container') {
                container('docker') {
                    SHORT_COMMIT = "${SCM_REPO.GIT_COMMIT[0..6]}"
                    sh 'docker build --network=host -t modl-uk-ruby .'
                }
            }

            stage('Tag Latest') {
                container('docker') {
                    sh "docker tag modl-uk-ruby ${DOCKERHUB_REPO}:${env.BRANCH_NAME}-${SHORT_COMMIT}"
                    if(env.BRANCH_NAME == 'master') {
                        sh "docker tag num-uk-ruby ${DOCKERHUB_REPO}:latest"
                    }
                }
            }

            stage('Push Container') {
                container('docker') {
                    script {
                        withDockerRegistry([credentialsId: "docker", url: ""]) {
                            sh "docker push ${DOCKERHUB_REPO}:${env.BRANCH_NAME}-${SHORT_COMMIT}"
                            if(env.BRANCH_NAME == 'master') {
                                sh "docker push ${DOCKERHUB_REPO}:latest"
                            }
                        }
                    }
                }
            }


         } catch (e) {
            slackSend (
                color: '#FF0000',
                message: '`modl-uk-ruby` build has failed on branch `' + env.BRANCH_NAME + '`\n' + \
                         'more info on ' + env.BUILD_URL,
                channel: '#ruby-websites')
            throw e
        }
    }
}

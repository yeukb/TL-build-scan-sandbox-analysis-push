node("${env.slave}") {

    def image

    stage('Startup Clean') {
        sh 'rm -f -r -d *'
        sh 'rm -f -r -d .[!.]* ..?*'
    }

    stage('cloneRepository') {
        checkout scm
    }

    stage('buildImage') {
        image = docker.build("${env.image_name}:${env.BUILD_NUMBER}", "-f ${env.dockerfile} .")
    }

    stage('scanImage') {
        try {
            prismaCloudScanImage ca: '', cert: '', dockerAddress: 'unix:///var/run/docker.sock', ignoreImageBuildTime: true, image: "${env.image_name}:${env.BUILD_NUMBER}", key: '', logLevel: 'debug', podmanPath: '', project: '', resultsFile: 'prisma-cloud-scan-results.json'
        }
        finally {
            prismaCloudPublish resultsFilePattern: 'prisma-cloud-scan-results.json'
        }
    }

    stage("Remote Sandbox Analysis with twistcli") {
        withCredentials([usernamePassword(credentialsId: 'twistlock_creds', passwordVariable: 'TL_PASS', usernameVariable: 'TL_USER')]) {
            try {
                sh "sudo twistcli sandbox -u $TL_USER -p $TL_PASS --address https://${env.tl_console} --analysis-duration 30s ${env.image_name}:${env.BUILD_NUMBER} ${env.entrypoint} | tee -a output && grep -i 'Sandbox analysis verdict: PASS' output"
            }
            catch(error) {
                sh "docker image rm ${env.image_name}:${env.BUILD_NUMBER}"
                sh "exit 1"
            }
        }
    }

    stage('pushImage') {
        try {
            docker.withRegistry('', 'docker_creds') {
                image.push("${env.BUILD_NUMBER}")
            }
        }
        catch(error) {
            echo "1st push failed, retrying..."
            retry(3) {
                docker.withRegistry('', 'docker_creds') {
                    image.push("${env.BUILD_NUMBER}")                
                }
            }
        }
    }

    stage('deleteImage') {
        sh "docker image rm ${env.image_name}:${env.BUILD_NUMBER}"
    }
}

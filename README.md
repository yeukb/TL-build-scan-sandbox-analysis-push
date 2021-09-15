# Prisma Cloud Compute - Build, Scan, Sandbox Analysis and Push 

This demo is to use a Jenkins pipeline running on a slave (which is also the sandbox VM) to build a container and scan it with Compute. If the scan pass, performs sandbox analysis on the image. If the sandbox analysis verdict is pass, push the image to registry. 

Reference: https://docs.paloaltonetworks.com/prisma/prisma-cloud/21-08/prisma-cloud-compute-edition-admin/runtime_defense/image_analysis_sandbox.html


## Prerequisites
1. Setup a Jenkins slave and sandbox VM
    - https://docs.paloaltonetworks.com/prisma/prisma-cloud/21-08/prisma-cloud-compute-edition-admin/runtime_defense/image_analysis_sandbox.html#_setup_the_sandbox_machine
    - or by using the following terraform templates
        - https://github.com/yeukb/TL-sandbox-vm

2.  Install and configure Prisma Cloud Compute Jenkins plugin
    - https://docs.paloaltonetworks.com/prisma/prisma-cloud/21-08/prisma-cloud-compute-edition-admin/continuous_integration/jenkins_plugin.html


## Jenkins configuration
1. Add a slave to Jenkins
    - require docker, git, java and twistcli
2. Create a pipeline project
3. Configure the pipeline project to use pipeline script from SCM (Git)
    - https://github.com/yeukb/TL-build-scan-sandbox-analysis-push
4. Create the following parameters for the pipeline project:
    - tl_console (e.g. default vaule: y.y.y.y:8083)
    - image_name (e.g. default vaule: repo/image)
    - entrypoint (e.g. default vaule: /init-fail.sh)
    - slave (e.g. default vaule: slave01)
    - dockerfile (e.g. default vaule: Dockerfile.fail)
5. Create credentials:
    - twistlock_creds - username/password used to access Prisma Cloud Compute console (Sandbox user)
    - docker_creds - username/password to login to docker registry
6. Build with Parameters


## Note
On point 4 above,
    - Dockerfile.pass and /init-pass.sh should be used when a sandbox analysis pass is desired.
    - Dockerfile.fail and /init-fail.sh should be used when a sandbox analysis fail is desired.
 
# TL-build-scan-sandbox-analysis-push
Jenkins pipeline running on slave (which is also the sandbox VM) to build a container, scan it with Compute. If the scan pass, perform sandbox analysis. If the sandbox analysis verdict is pass, push the image to registry. 

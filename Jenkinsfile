pipeline{
	agent any

environment
{
    scannerToolPath = tool name: 'sonar_scanner_dotnet', type: 'hudson.plugins.sonar.MsBuildSQRunnerInstallation'  
	//You can use below path by uncommenting it. But i configured under 'Global Tool Configuration' using the below mentioned path and setting MSTest with the same.
	//MSTest = "C:/Program Files (x86)/Microsoft Visual Studio/2017/Professional/Common7/IDE/CommonExtensions/Microsoft/TestWindow/vstest.console.exe"
	MSTest = tool name: 'msbuild15ForTest'	
	sonarScanner = "${scannerToolPath}/SonarScanner.MSBuild.dll"
}
	
options
{
    timeout(time: 1, unit: 'HOURS')
      
    // Discard old builds after 5 days or 5 builds count.
    buildDiscarder(logRotator(daysToKeepStr: '5', numToKeepStr: '5'))
	  
	//To avoid concurrent builds to avoid multiple checkouts
	disableConcurrentBuilds()
}
   
  
     
stages
{
	
	stage ('Stop Running Container If Any')
	{
		steps
        {
				//Remove By Port
				bat """set ContainerIDByPort = docker ps | grep 5435 | cut -d " " -f 1 && (docker stop %ContainerIDByPort% && docker rm -fv %ContainerIDByPort%) || true """
				
				
				
        }

	}
	stage ('Docker Deployment')
	{
	    steps
	    {
	       bat label: '', script: 'docker run --name vipulchohan_devopscoreapp -d -p 5435:80 vipulchohan_coreapp:8'
	    }
	}
	
}

 post {
         always 
		{
			emailext attachmentsPattern: 'report.html', body: '${JELLY_SCRIPT,template="health"}', mimeType: 'text/html', recipientProviders: [[$class: 'RequesterRecipientProvider']], replyTo: 'vipul.chohan@nagarro.com', subject: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS!', to: 'vipul.chohan@nagarro.com'
        }
    }
}

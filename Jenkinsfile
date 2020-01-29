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
	stage ('Building Docker Image')
	{
		steps
		{
		    bat """docker build --no-cache -t vipulchohan_coreapp:${BUILD_NUMBER} ."""
		}
	}
	
	stage ('Stop Running Container If Any')
	{
	    steps
	    {
	        bat """set ContainerIDByPort=docker ps | grep 5435 | cut -d " " -f 1
				echo %ContainerIDByPort
                IF (%ContainerIDByPort) (
					docker stop %ContainerIDByPort
                    docker rm -f %ContainerIDByPort
                )			
            """
	    }
	}
	stage ('Docker Deployment')
	{
	    steps
	    {
	       bat """docker run --name devopscoreapp -d -p 5435:80 vipulchohan_coreapp:${BUILD_NUMBER}"""
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

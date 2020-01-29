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
	        bat """set ContainerIDByPort=docker ps | grep 5435 | cut -d " " -f 1
				if (%ContainerIDByPort%=="") (echo password is %ContainerIDByPort% , right?) ELSE (echo nothing) """
	    }
	}
	
}
}

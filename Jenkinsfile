pipeline{
	agent any

environment
{
    scannerToolPath = 'C:/Program Files (x86)/Jenkins/tools/hudson.plugins.sonar.MsBuildSQRunnerInstallation/sonar_scanner_dotnet' 
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
	stage ('Branch Checkout')
    {
		steps
		{
		    checkout scm	 
		}
    }
	stage ('Restoring Nuget')
    {
		steps
		{
			sh "dotnet restore"	 
		}
    }
	stage ('Clean Code')
    {
		steps
		{
			sh "dotnet clean"	 
		}
    }
	stage ('Starting Sonarqube Analysis')
	{
		steps
		{
			withSonarQubeEnv('SonarTestServer')
			{
				sh 'dotnet "${sonarScanner}" begin /key:$JOB_NAME /name:$JOB_NAME /version:1.0'
			}
		}
	}
	stage ('Building Code')
	{
		steps
		{
			sh "dotnet build -c Release -o Binaries/app/build"
		}	
	}
	
	stage ('Ending SonarQube Analysis')
	{	
		steps
		{
		    withSonarQubeEnv('SonarTestServer')
			{
				sh 'dotnet "${sonarScanner}" end'
			}
		}
	}
	stage ('Publishing Release Artifacts')
	{
	    steps
	    {
	        sh "dotnet publish -c Release -o Binaries/app/publish"
	    }
	}
	
	stage ('Building Docker Image')
	{
		steps
		{
		    sh returnStdout: true, script: 'docker build --no-cache -t vipulchohan_coreapp:${BUILD_NUMBER} .'
		}
	}
	
	stage ('Stop Running Container If Any')
	{
	    steps
	    {
	        sh '''
                ContainerID=$(docker ps | grep 5435 | cut -d " " -f 1)
                if [  $ContainerID ]
                then
                    docker stop $ContainerID
                    docker rm -f $ContainerID
                fi
            '''
	    }
	}
	stage ('Docker Deployment')
	{
	    steps
	    {
	       sh 'docker run --name devopscoreapp -d -p 5435:80 vipulchohan_coreapp:${BUILD_NUMBER}'
	    }
	}
	
}

 post {
        always 
		{
			echo "*********** Executing post tasks like Email notifications *****************"
        }
    }
}

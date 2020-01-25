pipeline{
	agent any

environment
{
    scannerDirectory = 'D:/SonarQube'   
	MSTest = tool name: 'msbuild15ForTest'	
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
	stage ('Starting Sonarqube analysis')
	{
		steps
		{
			withSonarQubeEnv('SonarTestServer')
			{
				sleep(time:1,unit:"SECONDS")
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
	stage('Unit test')
	{
		steps
		{
		  dir('Binaries/app/build')
		  {
			bat "'''${MSTest} /testcontainer:CoreAppMSTest.dll /resultsfile:Results.trx'''"
		  }
		}
	}
	stage ('Ending SonarQube Analysis')
	{	
		steps
		{
		    withSonarQubeEnv('SonarTestServer')
			{
				sleep(time:1,unit:"SECONDS")
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
	
	stage ('Stop container if running')
	{
	    steps
	    {
	        sh '''
                ContainerIDByPort=$(docker ps | grep 5435 | cut -d " " -f 1)
                if [  $ContainerIDByPort ]
                then
                    docker stop $ContainerIDByPort
                    docker rm -f $ContainerIDByPort
                fi
				
				ContainerIDByName=$(docker ps -all | grep devopscoreapp | cut -d " " -f 1)
                if [  $ContainerIDByName ]
                then
                    docker stop $ContainerIDByName
                    docker rm -f $ContainerIDByName
                fi
            '''
	    }
	}
	stage ('Docker deployment')
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

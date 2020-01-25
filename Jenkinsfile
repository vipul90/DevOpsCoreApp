pipeline{
	agent any

environment
{
    scannerHome = tool name: 'sonar_scanner_dotnet', type: 'hudson.plugins.sonar.MsBuildSQRunnerInstallation'   
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
	stage ('Building Code')
	{
		steps
		{
			sh "dotnet build -c Release -o DevopsAppPublish/app/build"
		}	
	}
	stage ('Release Artifacts')
	{
	    steps
	    {
	        sh "dotnet publish -c Release -o DevopsAppPublish/app/publish"
	    }
	}
	
	stage ('Docker Image')
	{
		steps
		{
		    sh returnStdout: true, script: 'docker build --no-cache -t vipulchohan_devopsapp:${BUILD_NUMBER} .'
		}
	}
	
	stage ('Stop Running container')
	{
	    steps
	    {
	        sh '''
                ContainerID=$(docker ps | grep 5401 | cut -d " " -f 1)
                if [  $ContainerID ]
                then
                    docker stop $ContainerID
                    docker rm -f $ContainerID
                fi
				
				ContainerIDByName=$(docker ps -all | grep devopsAppNetCore | cut -d " " -f 1)
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
	       sh 'docker run --name devopsAppNetCore -d -p 5401:90 vipulchohan_devopsapp:${BUILD_NUMBER}'
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

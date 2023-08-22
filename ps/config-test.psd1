@{
	Version = 1
	Tree = @{
		'MyProject.Build' = @{
			Repository = 'foo'
			Artifactory = 'bar'
		}
		SomeModule = @{
			SomeSetting = '1'
			SomeSetting2 = 2
		}
		SomeModule2 = @{
			SomeSetting = '3'
			SomeSetting2 = $true
		}
	}
}
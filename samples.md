## outputs and matrix
- https://brunoscheufler.com/blog/2021-10-09-generating-dynamic-github-actions-workflows-with-the-job-matrix-strategy

```
name: build
on: push
jobs:
  job1:
    runs-on: ubuntu-latest
    outputs:
			# This needs to match your step's id and name parameters
      matrix: ${{ steps.set-matrix.outputs.matrix }}
    steps:
			# Important: Do not forget the id!
      - id: set-matrix
        run: echo "::set-output name=matrix::{\"node\":[10, 12, 14]}"
  job2:
    needs: job1
    runs-on: ubuntu-latest
    strategy:
			# This needs to match the first job's name and output parameter
      matrix: ${{fromJSON(needs.job1.outputs.matrix)}}
    steps:
      - run: build
```
sample-2

```
name: Sample Run Include Syntax Json Format
on: push
# The Trigger event
jobs:
  job1:
    runs-on: ubuntu-latest
    outputs:
	# Making use of job.output
       matrix: ${{ steps.setmatrix.outputs.matrix }}
    steps:
      - name: Set Dynamic Matrix
        id: setmatrix
        run: |
           matrixStringifiedObject="{\"include\":[{\"run\":\"run1\"},{\"run\":\"run2\"}]}"
           echo "::set-output name=matrix::$matrixStringifiedObject"
  job2:
    needs: job1
    runs-on: ubuntu-latest
    strategy:
		# Making use of fromJson (JSON syntax)
      matrix: ${{ fromJson(needs.job1.outputs.matrix) }}
    steps:
    - run: echo Run ${{ matrix.run }}
    - run: date
    - run: sleep 1
    - run: date
```


## if

```
update-backend-preview:
  if: ${{ github.event.action == 'synchronize' && contains(github.event.pull_request.labels.*.name, 'preview-backend') }}

```

## matrix secrets and env variables


I found a trick to make the secrets tokens work:

Create your secrets and call them token1, token2, etc
Create your matrix configuration using the tokens i.e. the names of the secrets:
```
strategy:
  matrix:
    token: [token1, token2]
```
In your job's env, create the following environment variable:
```
env:
  token: ${{secrets[matrix.token]}}
```
Now the actual value for the token for each build matrix is stored inside the environment variable ${{env.token}} (when operating within an expression context) or $token (in bash).
The environment variable will still remain a secret, so you don't loose anything.


## Runs-on

```
jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
```

### Environment

```
...
jobs:
  deploy:
    strategy:
      matrix:
        stage: ['development', 'integration', 'production']
        os:    ['ubuntu','windows-latest']
      fail-fast: true
      max-parallel: 1
    runs-on: ${{ matrix.os }}
    environment:
      name: ${{ matrix.stage }}
    steps:
    # use environment specific secrets here for each stage
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-session-token: ${{ secrets.AWS_SESSION_TOKEN }}
          aws-region: wonderland-central-1
      - name: do some stuff
        uses: ...
        with: ...
```

sample-2

```
deploy-prod:
    name: Deploy prod
    runs-on: linux
    needs: deploy-staging
    strategy:
      matrix:
        include:
          - environment: dev
            os: ubuntu-latest
            varfile: dev
          - environment: tst
            os: windows-latest
            varfile: tst
          - environment: prod
            os: ubunutu-latest
            varfile: prod
    environment:
      name: ${{ matrix.environment }}
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v2
  - name: deploy
    uses: ./.github/actions/deployments
    with:
      version: ${{ needs.deploy-staging.outputs.version }}
      environment: ${{ matrix.environment }}
```

## if

```
name: If

on: push

jobs:
  if:
    name: If
    runs-on: ubuntu-20.04
    strategy:
      matrix:
        node: [4, 6, 8, 10, 12]
    steps:
    - run: echo ${{ (matrix.node > 8 && 'foo') || 'bar' }}
  ```

  sample-2: startswith

  ```
      name: Print if starts with 'He'
        if: ${{ startsWith(matrix.greeting, 'He') }}
        run: echo "greeting starts with He"
  ```


## Expressions
Use equality operators to get a boolean result; in this case we are only running the step when the greeting is “Hello”. Note the use of single quotes for the string literal. You can use ==, !=, <, <=, >, >=, &&, ||, and ( ... ). Learn more about operators here

```
name: expressions-example
on:
  push:
  pull:
jobs:
  use-expressions:
    strategy:
      matrix:
        greeting: [Hello, Howdy, Hey]
    runs-on: ubuntu-latest
    steps:
      -
        name: Print if 'Hello'
        if: ${{ matrix.greeting == 'Hello' }}
        run: echo "greeting is Hello"
      -
        name: Print if starts with 'He'
        if: ${{ startsWith(matrix.greeting, 'He') }}
        run: echo "greeting starts with He"
      -
        name: Print if ends with 'y'
        if: ${{ endsWith(matrix.greeting, 'y') }}
        run: echo "greeting ends with y"
      -
        name: Print if contains 'ow'
        if: ${{ contains(matrix.greeting, 'ow') }}
        run: echo "greeting contains ow"
      -
        name: Print formatted greeting
        run: |
          echo "${{ format('{0} says {1}', github.actor, matrix.greeting) }}"
      -
        name: To JSON
        run: echo 'Job context is ${{ toJSON(job) }}'
      -
        name: From JSON
        env: ${{ fromJSON('{"FAVORITE_FRUIT": "APPLE", "FAVORITE_COLOR": "BLUE"}') }}
        run: echo "I would like a ${FAVORITE_COLOR} ${FAVORITE_FRUIT}"
      -
        name: Success
        if: ${{ success() }}
        run: echo "Still running..."
      -
        name: Always
        if: ${{ always() }}
        run: echo "You will always see this"
      -
        name: Canceled
        if: ${{ canceled() }}
        run: echo "You canceled the workflow"
      -
        name: Failure
        if: ${{ failure() }}
        run: echo "Something went wrong..."
```


## format operator

```
on: push
jobs:
    Test2:
        if: ${{contains(github.event.commits[0].message, format('autorelease{0} pending', ':'))}}
        runs-on: ubuntu-latest
        steps:
        - run: echo ${{github.event.commits[0].message}}
```
or

```
on: pull_request
jobs:
    Test2:
        if: "${{ contains(github.event.pull_request.labels.*.name, 'autorelease: pending') }}"
        runs-on: ubuntu-latest
        steps:
        - run: echo Hello World
```

or

```
on: push
jobs:
    Test2:
        if: |
            ${{ contains(github.event.pull_request.labels.*.name, "autorelease: pending") }}
        runs-on: ubuntu-latest
        steps:
        - run: echo ${{github.event.commits[0].message}}
```


## Escape curly braces

```
${{ '${{VAR}}' }}
```

## Composite Action

```
# yaml-language-server: $schema=https://json.schemastore.org/github-action.json
name: 'Publish to OpenVSIX Gallery'
description: 'Publishes a Visual Studio extension (VSIX) to the OpenVSIX Gallery'
branding:
  icon: upload-cloud
  color: purple
inputs:
  readme:
    description: 'Path to readme file'
    required: false
    default: ''
  vsix-file:
    description: 'Path to VSIX file'
    requried: true
runs:
  using: "composite"
  steps:
    - name: Publish to Gallery
      id: publish_gallery
      shell: pwsh
      run: |
        $repo = ""
        $issueTracker = ""

        # If no readme URL was specified, default to "<branch_name>/README.md"
        if (-not "${{ inputs.readme }}") {
          $readmeUrl = "$Env:GITHUB_REF_NAME/README.md"
        } else {
          $readmeUrl = "${{ inputs.readme }}"
        }

        $repoUrl = "$Env:GITHUB_SERVER_URL/$Env:GITHUB_REPOSITORY/"

        [Reflection.Assembly]::LoadWithPartialName("System.Web") | Out-Null
        $repo = [System.Web.HttpUtility]::UrlEncode($repoUrl)
        $issueTracker = [System.Web.HttpUtility]::UrlEncode(($repoUrl + "issues/"))
        $readmeUrl = [System.Web.HttpUtility]::UrlEncode($readmeUrl)

        # $fileNames = (Get-ChildItem $filePath -Recurse -File)
        $vsixFile = "${{ inputs.vsix-file }}"
        $vsixUploadEndpoint = "https://www.vsixgallery.com/api/upload"

        [string]$url = ($vsixUploadEndpoint + "?repo=" + $repo + "&issuetracker=" + $issueTracker + "&readmeUrl=" + $readmeUrl)
        [byte[]]$bytes = [System.IO.File]::ReadAllBytes($vsixFile)

        try {
            $webclient = New-Object System.Net.WebClient
            $webclient.UploadFile($url, $vsixFile) | Out-Null
            'OK' | Write-Host -ForegroundColor Green
        }
        catch{
            'FAIL' | Write-Error
            $_.Exception.Response.Headers["x-error"] | Write-Error
        }
```


## define env vars

```
jobs:
  terraform:
    name: "Terraform"
    runs-on: ubuntu-latest
    env:
         AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
         AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         AWS_DEFAULT_REGION: eu-central-1

    steps:
      - name: Checkout
        uses: actions/checkout@v2

```
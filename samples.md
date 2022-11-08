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
          - environment: tst
            os: windows-latest
          - environment: prod
            os: ubunutu-latest
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
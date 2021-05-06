# Meltano Module - Dockerfile

This Dockerfile will be used to generate the image which will be built and deployed
to the cloud for serverless execution.

## `gitenv-init.sh`

Meltano needs to be git aware in order to dynamically adapt to
projects' changes in real time. I've written the initial git bootstraping
logic generic in a new [`gitenv-init`](https://github.com/dataops-tk/gitenv-init/blob/main/gitenv-bootstrap.sh)
tool which can be applied to any similar scenario where a runtime
environment needs to be seeded by a specific git asset.

## Example usage

### Test locally

Initialize environment variables:

```bash
export GIT_REPO=gitlab.com/meltano/singerhub
export GIT_REF=meltano-project
export GIT_USER=username
export GIT_EMAIL=username@example.com

# Only one of these is required:
export GIT_ACCESS_TOKEN=<token-secret>
export GIT_SSH_PRIVATE_KEY="$(cat /path/to/keyfile)"  # SSH not yet supported
```

Build and run the image:

```bash
docker build -t mymelt . && docker run -it --rm -p 5000:5000 -e GIT_REPO -e GIT_REF -e GIT_USER -e GIT_EMAIL --name meltui mymelt

# Or if you have a `.env` file:
docker build -t mymelt . && docker run -it --rm -p 5000:5000 --env-file=./.env --name meltui mymelt
```

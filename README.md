# Configure docker container with Terraform and volume mount

## Scenario

If you are using `Terraform` inside your `Docker` cotnainer, you might run in a scenario where you generate some files from terraform, but since they run inside the container, you do not have access to them to investigate their content. How can you somehow get those files locally, while they are still generated inside the `Docker` cotnainer?

## Prerequisites

A Linux or MacOS machine for local development. If you are running Windows, you first need to set up the *Windows Subsystem for Linux (WSL)* environment.

You need `docker cli` and `docker-compose` on your machine for testing purposes, and/or on the machines that run your pipeline.
You can check both of these by running the following commands:
```sh
docker --version
docker-compose --version
```

## Implementation

A solution to this issue is to mount your repository, or a part of it as a volume mount.

Your `Terraform` code that generates some file can look like:
```sh
resource "local_file" "someLocalFile" {
  content  = <<EOF
myContent:
  - something: 'aaa'
  - something2: ${timestamp()}'
EOF
  filename = "myLocalFile.yml"
}
```

If you copyed your code inside the container
```sh
COPY ./../terraform /infrastructure
```
you need to remove that part and do a volume mount in your `docker-compose` file:
```sh
    volumes:
      - ./../terraform:/infrastructure
```

When you run the the code in a `ci/cd` pipeline you probably want to avoid the volume mount. You only might want to use if only for investigating some issues on your local machine. This way you will probably end up with 2 ways to run your code: a debug version with vlume mount and a production version where the necessary code is copyed in the container via your `dockerfile`.

## Usage

For **development**, navigate to the root of the git repository and run the following command:

```sh
sh scripts/update.sh
```
to update the infrastructure. This will run fully in docker and will not generate any files on your machine.

If you want to have the generated files provided via a volume mount, to investigate any potential places of errors, run:
```sh
sh scripts/updateDebug.sh
```

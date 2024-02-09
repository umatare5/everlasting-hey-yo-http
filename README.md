# everlasting-hey-yo-http

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]
[![Hey, Yo!](https://img.shields.io/badge/Hey-Yo!-orange.svg?style=flat-square)][hey-yo]

[license]: https://github.com/umatare5/everlasting-hey-yo-http/blob/master/LICENSE
[hey-yo]: https://github.com/topics/hey-yo

A simple HTTP server that everlasting says "Hey, Yo!" every second in the background.

> [!NOTE]
> This application is heavily inspired by [toricls/everlasting-hey-yo](https://github.com/toricls/everlasting-hey-yo).
>
> - `everlasting-hey-yo` was created to test signal reception from an ECS Task.
> - `everlasting-hey-yo-http` was created to test signal reception from a Cloud Run Service.

## Installation

```shell
docker run ghcr.io/umatare5/everlasting-hey-yo-http
```

then, you'll see everlasting "Hey, Yo!" every second.

```shell
Hey, Yo!
Hey, Yo!
...
```

> [!TIP]
> This application is also available the binaries.
>
> Download from [release page](https://github.com/umatare5/everlasting-hey-yo-http/releases).
>
> - The application works on `linux_amd64`, `linux_arm64`, `darwin_amd64`, `darwin_arm64` and `windows_amd64`.
>
> Run the application with the following command.
> 
> ```shell
> ./hey-yo-http
> ```

## Signal Handling

The application traps a `SIGTERM` and a `SIGKILL`.

### `SIGTERM`

- When receive a `SIGTERM`, the application repeats "Hey" 3 times as follows.

  ```shell
  ...
  Hey, Yo!
  Hey, Hey, Hey, Yo!!!  # << Send "SIGTERM"
  Hey, Yo!
  ...
  ```

### `SIGKILL`

- When receive a `SIGKILL`, the application will be stopped.

  ```shell
  ...
  Hey, Yo!
  Hey, Yo!
  'hey-yo-http' terminated by signal SIGKILL (Forced quit)  # << Send "SIGKILL"
  ```

## Supported Environment Variables

The application supports the following environment variables:

| Name              | Description                                                                         |
| ----------------- | ----------------------------------------------------------------------------------- |
| `BE_QUIET`        | If set to any value, the application silences "Hey, Yo!" every second.              |
| `GIVE_ME_PATTERN` | If set to any value, the application says "Check It Out! Yo!" with 50% of the time. |

- For Example,

  ```shell
  $ docker run -e GIVE_ME_PATTERN=1 ghcr.io/umatare5/everlasting-hey-yo-http
  Starting HTTP server on port 8080
  Check It Out! Yo!
  Hey, Yo!
  Hey, Yo!
  Hey, Yo!
  Hey, Yo!
  Check It Out! Yo!
  Hey, Yo!
  Check It Out! Yo!
  ```

## Development

### Motivation

Cloud Run automatically restarts the instance by `SIGKILL` 10 seconds after sending a `SIGTERM`.

- [https://cloud.google.com/run/docs/container-contract#instance-shutdown](https://cloud.google.com/run/docs/container-contract#instance-shutdown)

I needed to measure the differences by each region and the resources assigned to it, using an application that continues to batch process.

### Commands

| Command             |                                                   |
| ------------------- | ------------------------------------------------- |
| `make build`        | Build the application in the `./dist/` directory. |
| `make docker-image` | Build a container image within the application.   |

### Deploy the code to Cloud Run

Please use [./scripts/deploy_to_cloud_run.sh](./scripts/deploy_to_cloud_run.sh).

- This script deploys a service to the active project in gcloud.
- The service will be launched in both `asia-northeast1` and `asia-northeast2`.
- 10 services per region will be set up with a minimum resource allocation.
- 1 service per region will be set up with 4 CPU cores and 16GB of memory.

As a result, the services are created as follows:

![](https://github.com/umatare5/everlasting-hey-yo-http/blob/images/run_overview.gif)

## Release

I'm manually releasing the application.

- Set and push a tag.

  ```shell
  git tag vX.Y.Z && git push --tags
  ```

- Run the release workflow.

  - [GitHub Actions: release workflow](https://github.com/umatare5/everlasting-hey-yo-http/actions/workflows/release.yaml)

## Contribution

1. Fork ([https://github.com/umatare5/everlasting-hey-yo-http/fork](https://github.com/umatare5/everlasting-hey-yo-http/fork))
1. Create a feature branch
1. Commit your changes
1. Rebase your local changes against the master branch
1. Create a new Pull Request

## Licence

[MIT](LICENSE)

## Author

[umatare5](https://github.com/umatare5)

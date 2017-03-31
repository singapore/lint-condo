# lint-condo

A Lint Container for Docker

## Introduction

We built this container to provide an easy way to centralise and run linting on any project where you have Docker available. To paraphrase:

> The best time to start linting your project was when you started it, but the second best time is today.

Linting can be contagious once you start, so with this all-in-one image you can conveniently add additional linters (markdown linting, yaml linting, etc). Our goal is to support popular linters while still keeping a reasonably small Docker image (~100MB according to [Docker Hub](https://hub.docker.com/r/singapore/lint-condo/tags/)).

## How it Works

You will need to run the image while pointing it to your source code and providing a `lint-condo.yaml` or `.lint-condo.yaml` file to tell it which lint commands to run. You can see an example of this file in this repository [here](https://github.com/singapore/lint-condo/blob/master/.lint-condo.yaml). As you'll probably observe, it's a list of shell commands.

You can then run it like this:

```sh
docker run -v `pwd`:/src/ singapore/lint-condo
```

## Continuous Integration

Perhaps the best way to run linting is part of Continuous Integration. If you already use such a service, running `lint-condo` should be as simple as adding the `lint-condo.yaml` file and adding an extra `test` line to your CI script. It's recommended to put linting first as that is often the common cause of test failures once you add it. If you don't already use such a service, the easiest to set up for linting is [CircleCI](https://circleci.com/) and you can use this example `circle.yml`:

```yaml
machine:
  services:
    - docker

dependencies:
  override:
    - echo true

test:
  override:
    - docker run -v `pwd`:/src/ singapore/lint-condo
```

This project itself also tests with [SemaphoreCI](https://semaphoreci.com/) and [Shippable](https://shippable.com) and both work well once you configure them.

## Versioning and Tags

For our own project linting, we use the `latest` version of the image (so we can be the canary in a coal mine) but we also endeavour to tag commits/releases so you can "pin" to these if you like. We use the great service [Doppins](https://doppins.com/) to keep our `package.json` and `requirements.txt` up-to-date. Also note that the Docker Hub generates images from automated builds of the `singapore/lint-condo` repository for your peace of mind.

## Included Linters

- [scss_lint](https://github.com/brigade/scss-lint)
- [gometalinter](https://github.com/alecthomas/gometalinter)
- [proselint](https://github.com/amperser/proselint)
- [yamllint](https://github.com/adrienverge/yamllint)
- [bootlint](https://github.com/twbs/bootlint)
- [coffeelint](https://github.com/clutchski/coffeelint)
- csslint
- dependency-lint
- dockerfile_lint
- doiuse
- eslint + plugins
- jscs
- jshint
- jslint
- markdownlint
- pug-lint
- remark-lint
- sass-lint
- stylelint
- tern-lint
- write-good
- xo

## Example Output

`lint-condo` echoes the stdout of each linter, followed by a summary of test results. An example of this summary is below:

```sh
Summary:
✔ eslint
✔ jscs
✔ jshint
✔ yamllint
✔ markdownlint
✔ proselint
✔ remark
✔ write-good
✔ scss-lint
✔ sass-lint
✔ csslint
✔ stylelint
✔ doiuse
✔ sh test/colors.sh
```

You can note two important points from the above:

1. For brevity, the summary strips out the parameters from any "known" commands such as `eslint`, `csslint`, etc.
2. You can add any custom commands/scripts of your own too, such as the above `sh test/colors.sh`. In our own projects we additional internal "linting" scripts that enforce project guidelines.

## Contributing/Collaborating

If we're missing any linters you'd like, please raise an issue. If you'd like to collaborate or contribute code, please do so as well.

# lint-condo

A Lint Container for Docker

## Introduction

We built this container to provide an easy way to centralise and run linting on any project where you have Docker available. To paraphrase: 

> The best time to start linting your project was when you started it, but the second best time is today. 

Linting can be quite contagious once you start, so with this all-in-one image you can easily add many (markdown linting, yaml linting, etc). Our goal is to support as many linters as possible while still keeping a reasonably small Docker image (currently about 104MB according to [Docker Hub](https://hub.docker.com/r/singapore/lint-condo/tags/)).

## How it Works

You will need to run the image while pointing it to your source code and providing a `lint-condo.yml` or `.lint-condo.yml` file to tell it which lint commands to run. You can see an example of this file in this very repository [here](https://github.com/singapore/lint-condo/blob/master/.lint-condo.yaml). As you'll probably observe, it's essentially just a list of shell commands.

You can then run it simply like this:
```sh
docker run -v `pwd`:/src/ singapore/lint-condo
```

## Continuous Integration

Perhaps the best way to run linting is part of Continuous Integration. If you already use such a service, running `lint-condo` should be as simple as adding the `lint-condo.yml` file and adding an extra `test` line to your CI script. It's recommended to put linting first as that is often the common cause of test failures once you add it. If you don't currently use such a service, the easiest to set up for linting-only is [CircleCI](https://circleci.com/) and you can use this example `circle.yml`:

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

This project itself also tests with [SemaphoreCI](https://semaphoreci.com/) and [Shippable](https://shippable.com) and both work well once they are configured.

## Versioning and Tags

For our own project linting, we use the `latest` version of the image (so we can be the canary in a coal mine) but we also endeavour to tag releases regularly so you can "pin" to these if you like. We use the great service [Doppins](https://doppins.com/) to keep our `package.json` and `requirements.txt` up-to-date. Also note that the Docker Hub image is based on automated builds of the `singapore/lint-condo` repository for your peace of mind.

## Included Linters

- scss_lint
- gometalinter
- proselint 
- yamllint
- bootlint
- coffeelint
- csslint
- dependency-lint
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

Currently, `lint-condo` essentially echos the output of each linter as you would normally expect, followed by a summary of test results. An example of this summary is below:

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

You can note two important things in the above:

1. For brevity, the summary strips out the parameters from any "known" commands such as `eslint`, `csslint`, etc.
2. You can add any custom commands/scripts of your own too, such as the above `sh test/colors.sh`. In our own projects we have several "linting" scripts that enforce internal guidelines.

## Contributing/Collaborating

If we're missing any linters you'd like, please raise an issue. If you'd like to collaborate or contribute code, please do so as well.

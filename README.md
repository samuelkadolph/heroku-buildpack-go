# heroku-buildpack-go

heroku-buildpack-go is a [buildpack](https://devcenter.heroku.com/articles/buildpacks) for [Heroku](http://www.heroku.com/)
to compile Go applications.

## Description

a

## Installation

If you have an existing Heroku application, add the buildpack to your configuration:

    heroku config:add BUILDPACK_URL=https://github.com/samuelkadolph/heroku-buildpack-go

Otherwise create a Heroku application with the buildpack:

    heroku create myapp --buildpack https://github.com/samuelkadolph/heroku-buildpack-go

## Usage

Create a `Gofile` in the root of your repository and specify the name of your repostiory like you would in a source file for
packages. *This is required because heroku does not have knowledge of your repository's name and as such trying to import
directories under it will not work nor will the name of the executable be controllable.*

```go
package "github.com/samuelkadolph/someapp"
```

Then just push normally to your `heroku` remote and it should detect it as a `Go` application.

## Limitations

Currently the buildpack is limited to producing a single executable from the root of your repository.

## Contributing

Fork, branch & pull request.

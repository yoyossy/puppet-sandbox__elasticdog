# Melang

__An open source static website deployment platform.__

Inspired by [Travis-CI] and [Github Pages], Melang aims to be a 
framework-agnostic tool for distributed build and deployment
of precompiled webapps and other static sites. Initially
Melang will support only [ruby frameworks].


# How does it work?

## Distributed Build

1. The system checks out the git commit to be deployed.
2. Use [Bundler] to install the project's dependencies.
3. Run the specified build command.
4. The build output folder is published to distributed storage.

## Distributed Deployment

1. Each compiled site is placed in an object storage bucket.
   Currently [Google Cloud Storage] is supported.
2. Files are distributed via CDN.


# Why build this?

Because ftp-ing to shared hosting isn't much fun. 
See [HN discussion] on other static hosting options.


# Code Status

* [![Build Status](https://secure.travis-ci.org/ent-io/melang.png)](http://travis-ci.org/ent-io/melang)
* [![Dependency Status](https://gemnasium.com/ent-io/melang.png?travis)](http://travis-ci.org/ent-io/melang)


# License

Melang is released under the [MIT License].


[Travis-CI]: http://about.travis-ci.org/docs/
[Github Pages]: http://pages.github.com/
[ruby frameworks]: https://www.ruby-toolbox.com/categories/static_website_generation
[Bundler]: http://gembundler.com/
[Google Cloud Storage]: https://cloud.google.com/products/cloud-storage?utm_source=google&utm_medium=cpc&utm_campaign=cloudstorage-search
[HN discussion]: http://news.ycombinator.com/item?id=4060491
[MIT License]: http://www.opensource.org/licenses/MIT

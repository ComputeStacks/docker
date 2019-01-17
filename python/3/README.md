# Python 3 Docker Image

## Features:

  - gunicorn
  - nginx
  - cron

## Prepare your application

_Please see the `sample` directory for an example._

Create the following files:

  - [requirements.txt](https://github.com/ComputeStacks/docker/tree/master/python/3/sample/requirements.txt)  -- _(optional)_ List any packages that should exist with `pip`.

  - [crontab]((https://github.com/ComputeStacks/docker/tree/master/python/3/sample/crontab)) -- _(optional)_ include any cron jobs.

  - [gunicorn.conf]((https://github.com/ComputeStacks/docker/tree/master/python/3/sample/gunicorn.conf)) -- Provide your `gunicorn` configuration for `nginx`.

    **_NOTE_**: Pay close attention to the `command` line. This _must_ be changed for your application.

  - [nginx.conf]((https://github.com/ComputeStacks/docker/tree/master/python/3/sample/gunicorn.conf)) -- nginx settings for your application.

    **_NOTE_**: Update the `root` directory to match your application.
    

## How to use with docker

```
docker run -d -v /path/to/local/app:/usr/src/app -p 80:80 cmptstks/python:3
```
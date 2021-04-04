## What is this project

It's an alpine-based docker image containing SQUID5 configured for https traffic caching.

## Usage

```
make all
```

Build the container, create the self-signed certificates (mounted in `squid-certs/*`), initialize squid cache (mounted in `squid-cache/*`), and run the container, exposing port 3128 to the localhost.

The self-signed root authority to add to your browser is `myCA.der`, copied at the root of the repo.

## Configuration

Modify variables at the top of the makefile to customize cert or image name.

## What is this project

It's an alpine-based docker image containing SQUID5 configured for https trafic cachine.

## Usage

```
make all
```

build the container, create the self-signed certificates (mounted in `squid-certs/*`), initialize squid cache (mounted in `squid-cache/*`), and run the container, exposing port 3128 to the localhost.

The self-signed root autority to add to your browser is `myCA.der`, copied at the root of the repo.

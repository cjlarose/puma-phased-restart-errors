# Puma `RuntimeError: Unable to add work while shutting down` low-level error

This project reproduces an issues related to phased restarts in Puma. Specifically, it demonstrates that if the Puma reactor finishes buffering a request after a worker shutdown has been initiated, the request is essentially rejected (the low-level handler is invoked).

## Usage

```sh
docker build -t puma-reactor-error .
docker run -it puma-reactor-error
```

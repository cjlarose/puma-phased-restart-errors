# Puma phased restart errors

This project reproduces issues related to phased restarts in Puma. Specifically, it demonstrates that during a phased restart, some clients do not get successful responses from the server.

See the [issue](https://github.com/puma/puma/issues/2337) on the puma repo.

## Usage

```sh
docker build -t puma-phased-restart-errors .
docker run -it puma-phased-restart-errors
```

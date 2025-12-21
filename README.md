packrat386.com
---

This is the static site that lives at [https://packrat386.com]. This
lived hand edited on the box for many years.

## Development

The site is generated using pandoc. `src/` contains the markdown files
for the individual pages. `assets/` contains images, stylesheets, and
other assets that require no transformation. `templates/` hosts the
pandoc templates for rendering the pages.

To generate the static site for local use, run `make`. `make serve`
will serve that on `http://localhost:8080`. `make clean` cleans up.

For release versions, the build is done entirely within docker. These
builds use `Dockerfile.release` rather than `Dockerfile`. You can test
this behaviour with `make release` but the actual release of the build
is done via github actions.

## Deployment

Pull the image at `ghcr.io/packrat386/packrat386.com:latest` then run
it like you would any other docker image. The default exposed port is
`:8080`. The image doesn't support HTTPS so you probably want some
sort of load balancer.

## License

All contents licensed under the MIT License, see `LICENSE.txt` for
details.

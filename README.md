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
will serve that on localhost:8080. `make clean` cleans up.

For release versions, the build is done entirely within docker. These
builds use `Dockerfile.release` rather than `Dockerfile`. You can test
this behaviour with `make release` but the actual release of the build
is done via github actions.

## License

All contents licensed under the MIT License, see `LICENSE.txt` for
details.

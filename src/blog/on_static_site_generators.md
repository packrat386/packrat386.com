---
title: "On Static Site Generators"
author: "packrat386"
date: "2025-12-22"
css:
  - "/assets/styles.css"
...

# On Static Site Generators

I recently decided to retool my personal website on which you're
reading this blog. For many years the small amount of content on here
was just hand-written HTML that lived on a small DigitalOcean droplet
and was served by nginx. A fairly stone age setup but to be honest it
worked shockingly well. The only major complaint that I had is that
with all the content living on the server itself I had no backups and
I had to ssh in to edit anything. I probably could have fixed that
with a tiny bash script but in the proud tradition of my vocation I
decided to over-complicate things.

I thought about using a static site generator because I have always
found the concept enticing. HTML is a bit fiddly and I would rather be
able to write something more legible and then convert it. I'm
familiar with both [Jekyll][] and [Hugo][] but both of them seemed a
bit heavyweight for what I had in mind. I'm not terribly interested in
a complex custom theme or anything involving fancy JavaScript.

I've used [Pandoc][] quite a bit for converting Markdown into other
formats. My main use has been making PDFs but I knew that HTML was one
of the options and I quite like being able to write Markdown as it's
legible right in my editor. So I decided, why not see if I can get
what I want just using Pandoc to write my site in Markdown and then
generate HTML from there?

Pandoc makes it pretty straightforward to transform a document from
one format into another, but by default the HTML it generates has no
styling applied. The CSS on my site was already extremely minimal, but
I do want to have _some_ styling to make it more pleasing to the
eyes. I was gifted a few lines of CSS some years by a grumpy front-end
engineer who was tired of my horrifically ugly internal tools, and I
am forever in his debt.

```css
body {
  margin: 50px auto;
  padding: 10px;
  max-width: 800px;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  background: #eeeeee;
}
````

Pandoc has both the concept of metadata variables and templates that
will use those variables to do the actual rendering of a specific
document format. For setting metadata variables in a Markdown document
you can use a YAML block like so\:

```yaml
---
title: "On Static Site Generators"
author: "packrat386"
date: "2025-12-22"
css:
 - "/assets/styles.css"
...
````

It turns out that the default HTML template for Pandoc already
supports the `css` variable in its metadata. I made some slight
adjustments to the template (mostly removing things I didn't need) and
then I used a Makefile to convert all input Markdown files to their
output HTML files.

```make
out/%.html: src/%.md
        mkdir -p $(@D)
        pandoc -s -i $< -r markdown -w html --template=templates/article -o $@
````

Then I packaged up the HTML (converted from Markdown) and my static
assets (CSS, images) and put them in a docker container (I said I was
going to over-complicate) running [Caddy][] as a fileserver.

```Dockerfile
CMD ["caddy", "file-server", "--listen", "0.0.0.0:8080"]
````

Having it as a docker container gives me a simple "pipeline" whereby
tagging a release runs a GitHub action to push to GitHub Container
Registry, and then all I need to do is pull the latest image on the
server.

I'm pretty happy with the results here. Everything is [checked into
git][site-gh] and I get to write Markdown instead of HTML. It all uses
off the shelf tools and the end result is realistically no less stable
than nginx serving plain HTML files off my disk. Not a bad way to
spend a train ride through central IL.

---

[Blog](/blog/)

[Home](/)

[Jekyll]: https://github.com/jekyll/jekyll
[Hugo]: https://github.com/gohugoio/hugo
[Pandoc]: https://github.com/jgm/pandoc
[Caddy]: https://github.com/caddyserver/caddy
[site-gh]: https://github.com/packrat386/packrat386.com

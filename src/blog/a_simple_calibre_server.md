---
title: "A Simple Calibre Server"
author: "packrat386"
date: "2026-01-14"
css:
  - "/assets/styles.css"
...

# A Simple Calibre Server

I have been doing a bit of digital homesteading recently. I have a
couple of NUCs that I have set up as servers and I figure as long as I
have them I might as well use them to host some things that could be
of use to me instead of just silly art projects.

I have begun to try to read more ebooks in an attempt to wean myself
off of social media as a boredom crutch. A server to upload/download
ebooks seemed like a great addition to the fleet so I searched around
and [Calibre][] came up a lot. Calibre is really a whole suite of
tools for working with ebooks. It can handle reading, editing,
publishing, backups, archiving, etc. One part of it is the
[calibre-server][] which supports uploading and downloading
ebooks. Great!

However Calibre doesn't really have great documentation around using
it as a "pure" server. The application seems like it's mostly designed
for use on a daily driver personal workstation, and in that world the
server element is just a way to transfer from the computer to other
devices. However in my case I would really like to run _just_ the
server without worrying about the other parts.

Another complication is that Calibre being a fairly long lived Python
application has a somewhat gnarly set of dependencies. This isn't
necessarily a bad thing (I tend to prefer long lived projects) but it
would make it a bit of a mess to install directly on my server. The
immediate solution that comes to mind is to run it in a container
(which I prefer to do for anything I'm hosting if I can) but there
doesn't appear to be a container image distributed as part of the
project in any way. I found a repo by some folks calling themselves
[linuxserver.io][] called [docker-calibre][] but it seems again to be
geared towards running as a desktop application.

So at the risk of reinventing the wheel I decided to just build my own
container image that runs calibre-server and as little else as I can
get by with. As a kicking off point I started with a plain Debian
image and just ran `apt install -y calibre`. Calibre's documentation
recommends against this:

> Please do not use your distribution provided calibre package, as
> those are often buggy/outdated.

What I got is indeed relatively outdated. Debian 13 is pretty new but
still I got version 8.5 (from June of 2025) when version 8.16 is the
latest stable. Still, we're on the newest major version and it isn't
obviously buggy (the Debian package management folks are pretty
anal). So we press on.

Trying to just naively run `calibre-server` yields an error that a
library is required, and running it with an empty directory or file
gives a similar error that there is no calibre library to be found
there. There once again isn't any great documentation for initializing
a calibre library without the desktop application. There is a
[calibredb][] command but no conspicuous `init` command or
anything. After a bit of tinkering I found that just running a `list`
command against an empty directory will initialize an empty database
in that directory, and with that empty database there the server will
happily start.

Next on the list is setting up authentication. Here the docs are a
little more straightforward. We can provide a `--userdb` flag that
points the server to a SQLite DB storing user data. The
`calibre-server` program comes with a `--manage-users` subcommand of a
sort that lets you CRUD user accounts. Those user accounts are then
used for HTTP Basic Auth. HTTP Basic Auth is pretty basic, but it'll
do.

So three basic things I need done once calibre is installed. I have to
initialize the calibre library, create a user, and then run the
server. I created some very simple shell scripts to do all three of
those things, passing in the library and userdb paths as environment
variables. Then I packaged those up in a container. To run I created
named volumes for both the library and the userdb and mounted them at
the location those environment variables point to.

The result is an instance of `calibre-server` serving over HTTP. I
prefer to expose services like this behind a load balancer (which
means I can terminate SSL there and just do HTTP over the local docker
network) so that's sufficient for my needs. I put the source code for
the container [on github][calibre-tainer] for posterity.

Overall I would say I give the experience a B-. It definitely seems
like this is not how the calibre authors expect me to use their tool,
which explains why it's not terribly well documented to use like
this. It's also rather limited (HTTP Basic Auth kinda sucks, user
permissions are not terribly granular, etc.), and I don't personally
care for the UI design. However it's been stable enough thus far and
uploading a couple hundred books worked just fine. Once I exposed it
behind the load balancer I could download books onto my phone for
convenient train reading. Sometimes good is good enough.

[Calibre]: https://calibre-ebook.com/
[calibre-server]: https://manual.calibre-ebook.com/generated/en/calibre-server.html
[linuxserver.io]: https://www.linuxserver.io/
[docker-calibre]: https://github.com/linuxserver/docker-calibre
[calibredb]: https://manual.calibre-ebook.com/generated/en/calibredb.html
[calibre-tainer]: https://github.com/packrat386/calibre-tainer

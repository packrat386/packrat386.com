---
title: "On GitHub"
author: "packrat386"
date: "2026-04-06"
css:
  - "/assets/styles.css"
...

# On Github

The slow enshittification of GitHub has had me thinking about trying
to move off of it for my personal projects. I don't think it's
entirely likely that they're going to yoink my ability to have simple
repos hosted there, but the experience of doing so just keeps getting
worse.

But whenever I start pondering a move like this it occurs to me just
how many things GitHub provides these days. Their business plan seems
to be the one stop shop for everything in your SDLC, and they've
gotten pretty far. In terms of features GitHub offers you've got:

 * "Core" Git: create, pull from, and push to git repositories
   over ssh or https.
 * Git Web UI: browse source code and repo history in your web
   browser.
 * Identity Management: users can be part of groups and organizations
   with fairly fine-grained RBAC.
 * Event Stream: webhooks for various repo events can be used to
   trigger other events.
 * Ticketing/Project Planning: Issues can be used for bug triage and
   feature requests. The "Projects" feature-set also give you a sort
   of "agile" view built on top of Issues.
 * Contribution Workflow: pull requests, code reviews, automated and
   human approval workflows. This feels like where GitHub cornered the
   market first. Basically everything that's come after it wants to
   take this.
 * CI/CD: Actions is their own semi-proprietary engine for pipelines.
 * Artifact Management: Repo releases can ahve artifacts attached to
   them, but there's also GitHub Packages which supports a whole bunch
   of different artifact publishing. Notably has a container registry
   that's a competitor to Docker Hub and the like.
 * Pastebin: I do love gists.
 * Wiki: It's nothing to write home about but per wiki repos are convenient.
 * Hosting: Pages is static hosting.
 * Discovery/Engagement: You can search for repos, follow users, star
   repos and filter by stars.
 * Funding: They have a product for sponsoring open source devs now.
 * AI frontend: with Copilot it seems like where GitHub is happiest is
   being a gateway for different models. I haven't used this much so I
   don't really know why it's better than just running the model
   directly but I guess people use it.
 * Security Scanning: I forget sometimes that Dependabot is a GitHub
   product.
 * Plugin system through apps: I also don't find myself using this
   much but it's an option.

That's a lot of functionality to replace. Even if I don't use all of
that stuff, I use enough of it to make it hard to find a drop-in
replacement. There are a couple platforms out there that are basically
clones of GitHub, but that seems like I get all the same problems plus
the cost of switching.

So I decided to take inspiration from Moneyball.

> Guys, you're still trying to replace Giambi. I told you we can't do
> it, and we can't do it. Now, what we might be able to do is
> re-create him. Re-create him in the aggregate.

Is there a single platform that will commit to all the principles of
openness and sound UI that I value and also support all of the
functionality that GitHub provides? No. Can I use a reasonable
collection of such platforms/tools to get the functionality I truly
need? Probably.

I think the convenience of a GitHub-style workflow for contributions
is probably too practical to pass up. I have romantic ideas about old
school distributed workflows with mailing lists and such, but there's
a reason very few new projects choose that model anymore. Plus,
precious little of what I publish gets any attention from would-be
contributors anyway, so it's probably best to make it simple and
recognizable for anybody that does want to send a patch.

Hosting an instance of something like [Forgejo][] or [SourceHut][] is
feasible, but it's a big lift and these kinds of platforms benefit
from a network effect. It seems better to find one whose principles
are in line with my own and chip in for the hosting costs and such. I
think that [Codeberg][] is attractive in that regard as they have a
governance structure that seems like it's designed for longevity and
FOSS. However, being designed for open source, Codeberg does not
generally allow private repos, which I _do_ use for some things
(infrastructure repos where I might have left secrets lying around,
interview questions, a couple for private writing). For most of those
the git repo is really just about having a backup, so I'd probably
have to look into some alternative place to store those (or continue
to store them on GitHub for the time being).

So an alternative forge gives me my "core" git operations, web UI,
ticketing, and contibutor workflow. The next big feauture I cannot
live without is some kind of CI/CD pipeline. I probably would like to
bring my own worker(s) because the compute resources to run the jobs
is usually what you end up paying for anyway. [Woodpecker][] seems
promising, but if it's too much of a PITA to set up I might cave and
run a personal Jenkins node. Either way the main need for me is just
to make sure that things don't get to run jobs unless I approve them,
which both of these have the power to do.

Artifact publishing is prickly because it's very much necessary but
there's a whole bunch of ways to do it and they tend to vary depending
on what it is you're building. Languages tend to have repositories for
packaged libraries and sometimes packaged tools/binaries, like for
example gems in Ruby. And then there's also projects that can be
distributed by language-agnostic means like container images, OS
packages, and so on. Most of these boil down to some kind of binary
file + metadata so it seems like it should be possible to distribute
from one central service but there aren't a ton of options. There's
some proprietary vendor products that support many different formats
like [Artifactory][] and then there's the likes of GitHub which offer
a similar service but hosted.

I think for this the best way forward is again to find existing stable
platforms with a commitment to open principles. For now what I mostly
need is publishing for gems and for container images (Go modules and
Homebrew formulae both install straight from source control by
default, which is nice). [rubygems.org][] and [DockerHub][] are not
without issues but they have wide support and they allow free public
hosting with minimal restrictions so they'll do for now.

This is already my longest blog post yet and it's really more of a
plan for what I want to do than anything I have actually already
done. It is nice to lay things out and see that what I truly need
is doable though. More thoughts to come on implementation.

---

[Blog](/blog/)

[Home](/)

[Forgejo]: https://forgejo.org/
[SourceHut]: https://sourcehut.org/
[Codeberg]: https://codeberg.org/
[Woodpecker]: https://woodpecker-ci.org/
[Artifactory]: https://jfrog.com/artifactory/
[rubygems.org]: https://rubygems.org/
[DockerHub]: https://hub.docker.com

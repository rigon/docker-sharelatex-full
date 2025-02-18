# Docker Sharelatex-full

![](https://img.shields.io/github/tag/rigon/docker-sharelatex-full.svg "Latest version")
![](https://img.shields.io/docker/image-size/rigon/sharelatex-full.svg "Docker image size")
![](https://img.shields.io/docker/pulls/rigon/sharelatex-full.svg "Pulls from DockerHub")

ShareLatex with all Latex packages installed by default.


## What is

This is an extension of the [official sharelatex](https://hub.docker.com/r/sharelatex/sharelatex/).

The goal is to create an image with many Latex packages as possible, so you do not have (hopefully) to worry about missing packages. The downside is the large size of the image.

The [tlmgr](https://www.tug.org/texlive/tlmgr.html) [full scheme](https://tex.stackexchange.com/questions/234749/downloading-every-package-with-tex-live) is installed on top of Sharelatex, plus additional external tools required by common LaTeX packges:

 - [`latexminted`](https://pypi.org/project/latexminted/) for [Code Highlighting with minted](https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted)

And with shell-escape enabled:

 - [Inkscape](https://inkscape.org/) to support [SVG images](https://en.wikipedia.org/wiki/SVG)
 - [Graphviz](https://graphviz.org/) using [`dot2tex`](https://pypi.org/project/dot2tex/) package
 - [Asymptote](https://asymptote.sourceforge.io/) using `asypictureB` package
 - [gnuplot](http://www.gnuplot.info/) using `gnuplottex` package

> [!WARNING]
> Be aware that using `-shell-escape` or `-enable-write18` allows LATEX to run potentially arbitrary commands on your system. These should only be used when necessary, with documents from trusted sources. If you understand the implications use the docker image `rigon/sharelatex:latest-shell-escape` instead.

## How to run

Using the provided [docker-compose.yml](https://github.com/rigon/docker-sharelatex-full/blob/master/docker-compose.yml) file, you should only need to run:

    docker compose up

Then open the page to start using:

 - http://localhost:8080/launchpad

## How to build

To avoid cloning multiple times the TeX Live repositories, you can [Downloading/mirroring the TeX Live repository](https://www.tug.org/texlive/acquire-mirror.html) locally:

    wget -c --mirror --no-parent ftp://tug.org/historic/systems/texlive/2023/tlnet-final/

Or you can [Acquiring TeX Live as an ISO image](https://tug.org/texlive/acquire-iso.html) and extract it in the current directory.

Then, build the image with local repository. You have to dit `Dockerfile` to use local instance of nginx:

    docker network create build_sharelatex
    docker run --network build_sharelatex --name nginx -v ${PWD}:/usr/share/nginx/html:ro -d nginx
    docker build --network build_sharelatex -t sharelatex-full .

### Troubleshooting

The default for the overlay config metacopy was switched from N to Y in kernel 4.19. The following should do the trick to get you going:

    echo N | sudo tee /sys/module/overlay/parameters/metacopy

## How to use

This image can be used in the same way as the official image.

Since Sharelatex requires MongoDB and Redis, it is easier to setup via [docker-compose.yml](https://github.com/rigon/docker-sharelatex-full/blob/master/docker-compose.yml)
(just the sharelatex image needs to be changed to [rigon/sharelatex-full](https://hub.docker.com/r/rigon/sharelatex-full/)).

## Contribute

Contributions to this project are very welcome, by reporting issues or just by sharing your support. That means the world to me!

Please help me maintaining this project, only with your support I can take the time to make it even better. Look here for more info https://www.rigon.uk/#contribute
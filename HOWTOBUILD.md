# How to build

## Build image

TeX Live repositories are pretty slow, you can clone it locally (https://www.tug.org/texlive/acquire-mirror.html):

    wget -c --mirror --no-parent ftp://tug.org/historic/systems/texlive/2017/tlnet-final/

Or download the ISO image: ftp://tug.org/historic/systems/texlive/2017/texlive.iso

Then, build the image with local repository:

    docker network create build_sharelatex
    docker run --network build_sharelatex --name nginx -v $PWD:/usr/share/nginx/html:ro -d nginx
    docker build --network build_sharelatex -t sharelatex-full .


## Troubleshooting

The default for the overlay config metacopy was switched from N to Y in kernel 4.19. The following should do the trick to get you going:

    echo N | sudo tee /sys/module/overlay/parameters/metacopy

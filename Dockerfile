FROM sharelatex/sharelatex:v0.6.3

# This must be before install texlive-full
RUN set -x \
    && tlmgr init-usertree \
    # Select closest mirror automatically: http://tug.org/texlive/doc/install-tl.html
    && tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet/ \
    && tlmgr update --self \
    # https://tex.stackexchange.com/questions/340964/what-do-i-need-to-install-to-make-more-packages-available-under-sharelatex
    && tlmgr install scheme-full

RUN set -x \
    && apt-get update \
    && apt-get install -y xzdec texlive-full

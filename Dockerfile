FROM sharelatex/sharelatex

RUN set -x \
    && tlmgr init-usertree \
    # https://tex.stackexchange.com/questions/313768/why-getting-this-error-tlmgr-unknown-directive
    # && tlmgr option repository ftp://tug.org/historic/systems/texlive/2016/tlnet-final \
    && tlmgr update --self \
    # https://tex.stackexchange.com/questions/340964/what-do-i-need-to-install-to-make-more-packages-available-under-sharelatex
    && tlmgr install scheme-full

RUN set -x \
    && apt-get update \
    && apt-get install -y xzdec texlive-full

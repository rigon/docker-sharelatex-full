FROM sharelatex/sharelatex

# Install TeX Live: metapackage pulling in all components of TeX Live
RUN set -x && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt install -y texlive-full

# This must be before install texlive-full
RUN set -x && \
    # tlmgr init-usertree \
    ## Select closest mirror automatically: http://tug.org/texlive/doc/install-tl.html
    #
    ## Use latest TeX Live repository
    # tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet/ && \
    #
    ## Use year specific TeX Live repository
    # tlmgr option repository ftp://tug.org/historic/systems/texlive/2017/tlnet-final && \
    #
    ## Use local TeX Live repository from nginx
    # tlmgr option repository http://nginx/ && \
    #
    tlmgr update --self && \
    # https://tex.stackexchange.com/questions/340964/what-do-i-need-to-install-to-make-more-packages-available-under-sharelatex
    tlmgr install scheme-full


# Code Highlighting with minted
# https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted
RUN set -x && \
    # Install Pygments for minted
    apt-get install -y xzdec python3-pygments python3-pip && \
    pip install latexminted

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt

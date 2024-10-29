FROM sharelatex/sharelatex

# # Install TeX Live: metapackage pulling in all components of TeX Live
# RUN set -x && \
#     apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt install -y texlive-full

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
    tlmgr update --all && \
    # https://github.com/overleaf/toolkit/blob/master/doc/ce-upgrading-texlive.md
    tlmgr install scheme-full && \
    # Symlink all the binaries into the system path
    tlmgr path add

# Install additional tools used by TeX packages
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3-pip && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt

# Code Highlighting with minted
# https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted
RUN set -x && \
    pip install latexminted

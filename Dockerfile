FROM sharelatex/sharelatex:5.5.4 AS base

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
    tlmgr update --self && \
    tlmgr update --all && \
    # https://github.com/overleaf/toolkit/blob/master/doc/ce-upgrading-texlive.md
    tlmgr install scheme-full && \
    # Symlink all the binaries into the system path
    tlmgr path add

# Install additional tools used by TeX packages
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends pipx && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt

# Code Highlighting with minted
# https://www.overleaf.com/learn/latex/Code_Highlighting_with_minted
RUN pipx install latexminted

####################
# Stage shell-escape
####################
FROM base AS shell-escape

# Tools mentioned by the community:
# https://tex.stackexchange.com/questions/598818/how-can-i-enable-shell-escape

# Enable shell-escape
RUN printf "\n%% Enable shell-escape\nshell_escape = t\n" | \
        /bin/bash -c "tee -a /usr/local/texlive/*/texmf.cnf"

# Install additional tools used by TeX packages
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends graphviz gnuplot inkscape asymptote && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt

RUN pipx install dot2tex

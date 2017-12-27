FROM sharelatex/sharelatex

RUN set -x \
	&& apt-get update \
	&& apt-get install -y xzdec \
	&& tlmgr init-usertree \
	\
	# https://tex.stackexchange.com/questions/313768/why-getting-this-error-tlmgr-unknown-directive
	# && tlmgr option repository ftp://tug.org/historic/systems/texlive/2016/tlnet-final \
	&& tlmgr update --self \
	&& tlmgr install scheme-full

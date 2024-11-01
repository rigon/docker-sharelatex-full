FROM sharelatex/sharelatex AS base

RUN apt-get update
RUN echo "################ BASE"

###########################
# Stage Enable shell-escape
###########################
FROM base AS shell-escape

RUN echo "################ SHELL-ESCAPE"

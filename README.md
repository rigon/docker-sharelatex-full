# Docker Sharelatex-full

[![](https://images.microbadger.com/badges/image/rigon/sharelatex-full.svg)](https://microbadger.com/images/rigon/sharelatex-full "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/rigon/sharelatex-full.svg)](https://microbadger.com/images/rigon/sharelatex-full "Get your own version badge on microbadger.com")

ShareLatex with all Latex packages installed by default. 


## What is

This is an extension of the [official sharelatex](https://hub.docker.com/r/sharelatex/sharelatex/).

The [texlive-full](https://packages.ubuntu.com/xenial/texlive-full) package and [tlmgr](https://www.tug.org/texlive/tlmgr.html) [full scheme](https://tex.stackexchange.com/questions/234749/downloading-every-package-with-tex-live) are installed on top of Sharelatex.

The is to create an image with many Latex packages as possible, so you do not have (hopefully) to worry about missing packages. The downside is the large size of the image.

## How to build

TeX Live repositories are pretty slow, you can clone it locally (https://www.tug.org/texlive/acquire-mirror.html):

    wget -c --mirror --no-parent ftp://tug.org/historic/systems/texlive/2017/tlnet-final/

Or download the ISO image and extract: [ftp://tug.org/historic/systems/texlive/2017/texlive.iso](ftp://tug.org/historic/systems/texlive/2017/texlive.iso)

Then, build the image with local repository:

    docker network create build_sharelatex
    docker run --network build_sharelatex --name nginx -v $PWD:/usr/share/nginx/html:ro -d nginx
    docker build --network build_sharelatex -t sharelatex-full .


### Troubleshooting

The default for the overlay config metacopy was switched from N to Y in kernel 4.19. The following should do the trick to get you going:

    echo N | sudo tee /sys/module/overlay/parameters/metacopy

## How to use

This image can be used in the same way as the official image.

Since Sharelatex requires MongoDB and Redis, it is easier to setup via [docker-compose](https://github.com/sharelatex/sharelatex/blob/master/docker-compose.yml)
(just the sharelatex image needs to be changed to [rigon/sharelatex-full](https://hub.docker.com/r/rigon/sharelatex-full/)):


	version: '2'
	services:
		sharelatex:
		    restart: always
		    image: rigon/sharelatex-full
		    container_name: sharelatex
		    depends_on:
		        - mongo
		        - redis
		    privileged: true
		    ports:
		        - 80:80
		    links:
		        - mongo
		        - redis
		    volumes:
		        - ~/sharelatex_data:/var/lib/sharelatex
		    environment:
		        SHARELATEX_MONGO_URL: mongodb://mongo/sharelatex
		        SHARELATEX_REDIS_HOST: redis
		        SHARELATEX_APP_NAME: Our ShareLaTeX
		        
		        #Set for SSL via nginx-proxy
		        #VIRTUAL_HOST: 103.112.212.22

		        # SHARELATEX_SITE_URL: http://sharelatex.mydomain.com
		        # SHARELATEX_NAV_TITLE: Our ShareLaTeX Instance
		        # SHARELATEX_HEADER_IMAGE_URL: http://somewhere.com/mylogo.png
		        # SHARELATEX_ADMIN_EMAIL: support@it.com

		        # SHARELATEX_LEFT_FOOTER: '[{"text": "Powered by <a href=\"https://www.sharelatex.com\">ShareLaTeX</a> 2016"},{"text": "Another page I want to link to can be found <a href=\"here\">here</a>"} ]'
		        # SHARELATEX_RIGHT_FOOTER: '[{"text": "Hello I am on the Right"} ]'

		        # SHARELATEX_EMAIL_FROM_ADDRESS: "team@sharelatex.com"

		        # SHARELATEX_EMAIL_AWS_SES_ACCESS_KEY_ID: 
		        # SHARELATEX_EMAIL_AWS_SES_SECRET_KEY: 

		        # SHARELATEX_EMAIL_SMTP_HOST: smtp.mydomain.com
		        # SHARELATEX_EMAIL_SMTP_PORT: 587
		        # SHARELATEX_EMAIL_SMTP_SECURE: false
		        # SHARELATEX_EMAIL_SMTP_USER: 
		        # SHARELATEX_EMAIL_SMTP_PASS: 
		        # SHARELATEX_EMAIL_SMTP_TLS_REJECT_UNAUTH: true
		        # SHARELATEX_EMAIL_SMTP_IGNORE_TLS: false
		        # SHARELATEX_CUSTOM_EMAIL_FOOTER: "<div>This system is run by department x </div>"

		        ################
		        ## Server Pro ##
		        ################

		        # SANDBOXED_COMPILES:true

		        # SHARELATEX_LDAP_HOST: 'ldap://ldap.forumsys.com' 
		        # SHARELATEX_LDAP_DN: 'uid=:userKey,dc=example,dc=com' 
		        # SHARELATEX_LDAP_BASE_SEARCH: 'dc=example,dc=com'
		        # SHARELATEX_LDAP_FILTER: '(uid=:userKey)'
		        # SHARELATEX_LDAP_ADMIN_DN: 'cn=read-only-admin,dc=example,dc=com' 
		        # SHARELATEX_LDAP_ADMIN_PW: password'
		        # SHARELATEX_LDAP_ANONYMOUS: "false"
		        # SHARELATEX_LDAP_EMAIL_ATT: "mail"
		        # SHARELATEX_LDAP_NAME_ATT: "name"
		        # SHARELATEX_LDAP_LAST_NAME_ATT: "secondname"
		        # SHARELATEX_LDAP_PLACEHOLDER: "Username"
		        # SHARELATEX_LDAP_TLS: "true"
		        # SHARELATEX_LDAP_TLS_OPTS_REJECT_UNAUTH:
		        # SHARELATEX_LDAP_TLS_OPTS_CA_PATH: '["/var/one.pem", "/var/two.pem"]'

		        # SHARELATEX_TEMPLATES_USER_ID: "578773160210479700917ee5"

		        # SHARELATEX_PROXY_LEARN: "true"

		mongo:
		    restart: always
		    image: mongo
		    container_name: mongo
		    expose:
		        - 27017
		    volumes:
		        - ~/mongo_data:/data/db

		redis:
		    restart: always
		    image: redis
		    container_name: redis
		    expose:
		        - 6379
		    volumes:
		        - ~/redis_data:/data
		        
	# nginx-proxy:
	#     image: jwilder/nginx-proxy
	#     container_name: nginx-proxy
	#     ports:
	#       #- "80:80"
	#       - "443:443"
	#     volumes:
	#       - /var/run/docker.sock:/tmp/docker.sock:ro
	#       - /home/sharelatex/tmp:/etc/nginx/certs



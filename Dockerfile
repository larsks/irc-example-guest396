FROM alpine

RUN apk add --update \
	bash \
	python3 \
	python3-dev \
	gcc \
	build-base \
	linux-headers \
	pcre-dev \
	nodejs \
	musl-dev \
	libxml2-dev \
	libxslt-dev \
	curl \
	supervisor \
	py3-virtualenv

RUN addgroup -g 8000 -S framework-service
RUN adduser -S django -u 8000 -G framework-service
RUN adduser -S uwsgi-process -H -u 7999 -G framework-service
USER django

WORKDIR /home/django
COPY requirements.txt .
# install uwsgi and create react app before any further changes, since these take a while
RUN virtualenv projectenv
RUN . projectenv/bin/activate; pip install uwsgi
RUN . projectenv/bin/activate; pip install -r requirements.txt

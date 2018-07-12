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
	supervisor && \
	python3 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip3 install --upgrade pip setuptools && \
	rm -r /root/.cache && \
	pip3 install --upgrade pip setuptools && \
	rm -r /root/.cache

# install uwsgi and create react app before any further changes, since these take a while
RUN pip3 install uwsgi

RUN addgroup -g 8000 -S framework-service
RUN adduser -S django -u 8000 -G framework-service
RUN adduser -S uwsgi-process -H -u 7999 -G framework-service
USER django

WORKDIR /home/django
ENV PATH=/home/django/.local/bin:/bin:/usr/bin:/usr/local/bin
COPY requirements.txt .
RUN pip3 install -r requirements.txt --user

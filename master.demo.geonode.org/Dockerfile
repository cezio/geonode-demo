FROM geonode/geonode:latest
MAINTAINER GeoNode development team

# COPY requirements.txt /usr/src/app/
# RUN pip install -r requirements.txt --no-deps
RUN pip install --upgrade setuptools pip

# use latest master geonode
RUN git clone --depth=1 git://github.com/GeoNode/geonode.git --branch master /usr/src/geonode
RUN cd /usr/src/geonode/; pip install -r requirements.txt; pip install -e .
COPY uwsgi.ini /usr/src
COPY . /usr/src/app
RUN pip install -e /usr/src/app


EXPOSE 8000
CMD ["uwsgi", "--ini", "/usr/src/uwsgi.ini"]

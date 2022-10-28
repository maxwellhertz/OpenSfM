FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Install apt-getable dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        libeigen3-dev \
        libopencv-dev \
        libceres-dev \
        python3-dev \
        python3-numpy \
        python3-opencv \
        python3-pip \
        python3-pyproj \
        python3-scipy \
        python3-yaml \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --recursive https://github.com/maxwellhertz/OpenSfM

WORKDIR /OpenSfM

RUN git checkout gcp-annotation-tool

RUN pip3 install -r requirements.txt && python3 setup.py build

# Install GCP annotation tool
RUN  apt update && \
     apt -y install software-properties-common && \
     add-apt-repository -y ppa:ubuntugis/ppa && \
     apt-get update && \
     apt-get install -y python-numpy gdal-bin libgdal-dev && \
     pip3 install rasterio && \
     pip3 install -r ./annotation_gui_gcp/requirements.txt && \
     pip3 install pyproj==2.6.0

ENTRYPOINT ['export PYTHONPATH="${PYTHONPATH}:/OpenSfM" && python3 annotation_gui_gcp/main.py']
ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=library
ARG FROM_IMG_NAME="centos"
ARG FROM_IMG_TAG="7.6.1810"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

RUN yum update -y
# pick an installation prefix to install EasyBuild to (change this to your liking)
WORKDIR /opt/easybuild
ENV EASYBUILD_PREFIX=/opt/easybuild
# download script
RUN curl -O https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py
RUN adduser easybuild
RUN chown -R easybuild: /opt/easybuild
RUN yum install -y epel-release
RUN yum install -y Lmod
RUN ln -s /usr/share/lmod/lmod/libexec/lmod /usr/bin/lmod
RUN yum install -y python2-pip
RUN pip install vcs
RUN yum install -y which
USER easybuild
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/easybuild/software/EasyBuild/3.9.2/bin/
RUN python bootstrap_eb.py $EASYBUILD_PREFIX
ENV MODULEPATH=/opt/easybuild/modules/all/
# update $MODULEPATH, and load the EasyBuild module
RUN lmod use $EASYBUILD_PREFIX/modules/all
RUN lmod load EasyBuild
CMD ['eb', '--version']

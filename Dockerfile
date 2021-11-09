ARG IMAGE=python
ARG VERSION=latest
FROM $IMAGE:$VERSION
MAINTAINER Martin Winter

ENV FROM_DIR="/data"
ENV TO_DIR="/data"
ENV DEBUG="false"
ENV TOCED_INDEX="true"
ENV TOC_ATTRS="{\"maxdepth\": \"3\", \"hidden\": \"\"}"

COPY files/ /install/

RUN chmod a+x /install/install.sh && \
    /install/install.sh && \
    rm -rf /install

# ENTRYPOINT [ "entrypoint" ]
CMD [ "prepareGuides" ]

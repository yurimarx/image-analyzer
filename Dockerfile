FROM intersystemsdc/iris-community

USER root

ENV DEBIAN_FRONTEND noninteractive


#####
RUN apt-get -y update \
    && apt-get -y install apt-utils \
    && apt-get install -y build-essential unzip pkg-config \
        zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev \
        libssl-dev libreadline-dev libffi-dev wget \
    && apt-get install -y ffmpeg libsm6 libxext6  


RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install --target /usr/irissys/mgr/python tensorflow==2.4.0
RUN pip3 install --target /usr/irissys/mgr/python keras==2.4.3 numpy==1.19.3 pillow==8.1.1 scipy==1.4.1 h5py==2.10.0 matplotlib==3.3.2 opencv-python keras-resnet==0.2.0
RUN pip3 install --target /usr/irissys/mgr/python imageai --upgrade


USER root   
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/irisbuild
COPY  python python
COPY input input
COPY output output
COPY models models
COPY  src src
COPY module.xml module.xml
COPY iris.script iris.script

USER root
RUN chmod 777 input
RUN chmod 777 output

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly

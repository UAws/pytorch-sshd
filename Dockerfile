FROM nvcr.io/nvidia/pytorch:23.03-py3
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_22-02.html#rel_22-02
# pytroch 2.0 cuda 12.1.0 ubuntu 20.04
RUN export DEBIAN_FRONTEND=noninteractive && export TZ=Etc/UTC && apt-get update  \
    && apt install software-properties-common ca-certificates -y \
    && add-apt-repository ppa:flexiondotorg/nvtop \
    && apt install -y nvtop \
    && apt-get -y install git aria2 byobu \
    && git config --global http.sslverify "false"  \
    && apt -y install build-essential \
    && apt-get install ffmpeg libsm6 libxext6 unzip -y \
    && pip install openmim \
    && apt install cmake libncurses5-dev libncursesw5-dev git -y 
# Install ubuntu packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        git \
        byobu \
        zip \
        wget \
        curl \
        ca-certificates \
        locales \
        openssh-server \
        ffmpeg \
        libsm6 \
        libxext6 \
        vim && \
    # Remove the effect of `apt-get update`
    rm -rf /var/lib/apt/lists/* && \
    # Make the "en_US.UTF-8" locale
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
# Setup timezone
ENV TZ=Australia/Adelaide
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY requirements.txt requirements.txt
RUN pip install -U openmim && \
    mim install 'mmcv==2.0.0rc4' && \
    pip install -r requirements.txt 

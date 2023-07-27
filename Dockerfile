FROM nvcr.io/nvidia/pytorch:23.05-py3
ENV FORCE_CUDA="1"
ENV MMCV_WITH_OPS=1
ENV TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.2;7.5;8.0;8.6;9.0"
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-05.html#undefined
# pytroch 2.0 cuda 12.1.1 ubuntu 22.04
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
RUN export TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.2;7.5;8.0;8.6;9.0" && \
    export FORCE_CUDA=1 && \
    pip install git+https://github.com/rodrigo-castellon/jukemirlib.git && \
    pip install "git+https://github.com/facebookresearch/pytorch3d.git@stable" && \
    pip install https://github.com/UAws/pytorch-sshd/releases/download/v0.0.2/xformers-0.0.20+1dc3d7a.d20230605-cp310-cp310-linux_x86_64.whl && \
    pip install -r requirements.txt 
RUN pip install -U openmim && \
    mim install 'mmcv==2.0.1'

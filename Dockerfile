FROM nvcr.io/nvidia/pytorch:23.12-py3
ENV FORCE_CUDA="1"
ENV MMCV_WITH_OPS=1
ENV TORCH_CUDA_ARCH_LIST="7.0;7.2;7.5;8.0;8.6;8.7"
# https://stackoverflow.com/questions/68496906/pytorch-installation-for-different-cuda-architectures
# https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#gpu-feature-list
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-12.html#rel-23-12
# pytroch 2.2 cuda 12.3.2 ubuntu 22.04
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
        rsync  \
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

# install brew due to HPC environment creates read-only root file system
# https://stackoverflow.com/a/58293459/14207562
RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"


COPY requirements.txt requirements.txt
RUN pip install ninja && \
    pip install git+https://github.com/rodrigo-castellon/jukemirlib.git && \
    export CFLAGS="-std=c++17" && \
    pip install -r requirements.txt
RUN pip install -v -U --pre git+https://github.com/facebookresearch/xformers.git@v0.0.24#egg=xformers
RUN pip install -U openmim && \
    pip install git+https://github.com/open-mmlab/mmcv.git@d9e10e11846d911e8354cd024967d3a17a88083c # for torch 2.1 require a c++17 compiler

#    pip install https://github.com/UAws/pytorch-sshd/releases/download/v0.0.2/xformers-0.0.20+1dc3d7a.d20230605-cp310-cp310-linux_x86_64.whl && \


# ngc-pytorch-2.2-xformers-0.0.24--mmcv-2.1
FROM nvcr.io/nvidia/pytorch:22.02-py3
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_22-02.html#rel_22-02
# pytroch 1.11 cuda 11.6 ubuntu 20.04
RUN export DEBIAN_FRONTEND=noninteractive && export TZ=Etc/UTC && apt-get update  \
    && apt install software-properties-common \
    && add-apt-repository ppa:flexiondotorg/nvtop \
    && apt install -y nvtop \
    && apt-get -y install git wget aria2 byobu \
    && git config --global http.sslverify "false"  \
    && apt -y install build-essential \
    && apt-get install ffmpeg libsm6 libxext6 unzip -y \
    && pip install openmim \
    && apt install cmake libncurses5-dev libncursesw5-dev git -y 
RUN pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu113/torch1.11.0/index.html \
   && pip install coolgpus \
    &&  pip install matplotlib \
    && pip install prettytable \
    && pip install wandb \
    && pip install kornia \
    && pip install einops \
    && pip install pytorch_memlab \
    && git clone https://github.com/open-mmlab/mmrazor.git \
    && cd mmrazor \
    && git checkout 8b57a07b5e6033dbd0052aeaf0f72668bdaecd00 \
    && pip install -v -e . \
    && mim install mmsegmentation==0.26.0 \
    && pip install DriveDownloader==1.4.0.post1 \
    && pip install cityscapesscripts

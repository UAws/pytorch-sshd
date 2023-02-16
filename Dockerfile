FROM nvcr.io/nvidia/pytorch:23.01-py3
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_22-02.html#rel_22-02
# pytroch 1.14 cuda 11.8.0 ubuntu 20.04
RUN export DEBIAN_FRONTEND=noninteractive && export TZ=Etc/UTC && apt-get update  \
    && apt install software-properties-common -y \
    && add-apt-repository ppa:flexiondotorg/nvtop \
    && apt install -y nvtop \
    && apt-get -y install git wget aria2 byobu \
    && git config --global http.sslverify "false"  \
    && apt -y install build-essential \
    && apt-get install ffmpeg libsm6 libxext6 unzip -y \
    && pip install openmim \
    && apt install cmake libncurses5-dev libncursesw5-dev git -y 
COPY requirements.txt requirements.txt
RUN MMCV_WITH_OPS=1 pip install mmcv-full==1.4.4 \ 
    && pip install -r requirements.txt 

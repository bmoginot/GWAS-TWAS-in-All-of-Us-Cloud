#!/bin/bash

#install and initialize miniconda if not present
if [ ! -d ~/miniconda3 ]; then
    mkdir -p ~/miniconda3
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
    rm ~/miniconda3/miniconda.sh
    eval "$(~/miniconda3/bin/conda shell.bash hook)"
    conda init bash
fi

#use the user-level conda
export PATH=~/miniconda3/bin:$PATH
eval "$(conda shell.bash hook)"

#accept terms of service
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

#set strict channel priority and configure channels
conda config --set channel_priority strict
conda config --remove-key channels 2>/dev/null || true
conda config --add channels conda-forge

#clone MetaXcan repo if needed
if [ ! -d MetaXcan ]; then
    git clone https://github.com/hakyimlab/MetaXcan
fi

#create or recreate imlabtools environment with compatible versions
if conda env list | grep -q imlabtools; then
    echo "imlabtools environment exists, activating..."
    conda activate imlabtools
    # Fix NumPy version if needed
    conda install "numpy<2.0" scipy=1.10.1 -y
else
    echo "Creating imlabtools environment with compatible package versions..."
    conda create -n imlabtools python=3.8 "numpy<2.0" pandas scipy=1.10.1 h5py -y
fi
        
#download databases
if [ ! -d eqtl ]; then
    wget https://zenodo.org/records/3518299/files/mashr_eqtl.tar -O mashr_eqtl.tar
    tar -xvpf mashr_eqtl.tar
    rm mashr_eqtl.tar
fi

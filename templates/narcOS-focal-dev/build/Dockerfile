FROM jackgray/narc-os:blue


USER root

RUN apt install python3-venv python3-dev build-essential \
    libgtk2.0-dev libgtk-3-dev libwebkitgtk-6.0-dev libjpeg-turbo8-dev \
    libtiff5-dev libsdl1.2-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libnotify-dev freeglut3-dev


# Install miniconda
# ENV CONDA_DIR /opt/conda
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /opt/conda

# # Put conda in path so we can use conda activate
# ENV PATH=$CONDA_DIR/bin:$PATH

# RUN conda update conda
# RUN conda install -c anaconda spyder






# USER 1000


# ARG USER=1000


# USER ${USER}
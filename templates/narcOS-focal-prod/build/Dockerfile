FROM jackgray/narc-os:blue


USER root

# Install miniconda
# ENV CONDA_DIR /opt/conda
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /opt/conda

# # Put conda in path so we can use conda activate
# ENV PATH=$CONDA_DIR/bin:$PATH

# RUN conda update conda
# RUN conda install -c anaconda spyder

# RUN apt-get update && \ 
# 	apt-get install -y \
		# spyder3 \
		# spyder-common \
		# python3-spyder \
		# python3-spyder-kernels \
		# python3-spyder-line-profiler \
		# python3-pyls-spyder \
		# python3-spyder-memory-profiler \
		# python3-spyder-unittest \
	# 	curl \
	# 	golang \	
	# 	vim \
	# 	xfce4-terminal \
	# 	python3-rope \
	# 	python3-sphinx \
	# 	pyqt5-dev-tools \
	# 	wget && \ 
	# rm -rf /var/lib/apt/lists/*

# RUN python3 -m pip install \
# 	PySide2 \
# 	PyQt5 \
# 	qtconsole \
# 	pyflakes \
# 	Pygments \
# 	pylint \
# 	sympy \
# 	cython


# USER 1000


# ARG USER=1000

# RUN useradd --groups sudo --no-create-home --shell /bin/bash ${KASM_USER} \
# 	&& echo "${KASM_USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${KASM_USER} \
# 	&& chmod 0440 /etc/sudoers.d/${KASM_USER}
# USER ${KASM_USER}
# WORKDIR /home/${KASM_USER}

# USER ${USER}
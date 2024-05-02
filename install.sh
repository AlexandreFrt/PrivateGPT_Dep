#!/bin/bash
apt -y install wget curl make build-essential

# Sleep | Suspend | Hibernate | Hybrid-sleep configuration
read -p "Sleep | Suspend | Hibernate | Hybrid-sleep (enable/disable) : " sleep
if [ $sleep == "enable" ]
then
	sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
elif [ $sleep == "disable" ]
then
	sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
fi

# Install Wi-Fi drivers
read -p "Install Wi-Fi drivers ? (y/n) : " wifi
if [ $wifi == "y" ]
then
	lspci -nnkd ::280
	apt -y install firmware-iwlwifi
fi

# Install cuda
read -p "Install cuda 11.8 ? (y/n) : " cuda
if [ $cuda == "y" ]
then
	wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb
	dpkg -i cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb
	cp /var/cuda-repo-debian11-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
	add-apt-repository contrib
	apt update
	apt -y install cuda
fi

# Install git
read -p "Install git ? (y/n) : " git
if [ $git == "y" ]
then
	apt -y install git
fi

# Install python3.11
read -p "Install python3.11 ? (y/n) : " python
if [ $python == "y" ]
then
	apt -y install software-properties-common build-essential libnss3-dev zlib1g-dev libgdbm-dev libncurses5-dev libssl-dev libffi-dev libreadline-dev libsqlite3-dev libbz2-dev lzma liblzma-dev python-tk python3-tk tk-dev llvm libncursesw5-dev xz-utils libxml2-dev libxmlsec1-dev
	wget https://www.python.org/ftp/python/3.11.7/Python-3.11.7.tgz
	tar xvf Python-3.11.7.tgz
	cd Python-3.11.7
	./configure --enable-optimizations
	make altinstall
	python3.11 --version
	cd ..
	rm Python-3.11.7.tgz
	rm -rd Python-3.11.7
fi

# Install pyenv
read -p "Install pyenv ? (y/n) : " pyenv
if [ $pyenv == "y" ]
then
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
	echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(pyenv init -)"' >> ~/.bashrc
	echo 'export PATH="$PATH:/usr/sbin"' >> ~/.bashrc
	exec "$SHELL"
fi

# Install poetry
read -p "Install poetry ? (y/n) : " poetry
if [ $poetry == "y" ]
then
	curl -sSL https://install.python-poetry.org | python3.11 -
	export PATH="$HOME/.local/bin:$PATH"
	exec "$SHELL"
fi

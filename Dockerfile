from ubuntu:18.04

RUN apt update -y && apt install build-essential gfortran cmake wget  -y

RUN cd /tmp && wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
	&& apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

# Add MKL
RUN sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'

RUN apt update

RUN apt install intel-mkl-2019.3-062 -y

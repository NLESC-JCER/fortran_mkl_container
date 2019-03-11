FROM ubuntu:18.04

RUN apt update -y && apt install build-essential gfortran cmake git wget python3  python3-numpy -y

RUN cd /tmp && wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB \
	&& apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

# Add MKL
RUN sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'

RUN apt update

RUN apt install intel-mkl-2019.3-062 -y

# Make MKL default for BLAS and LAPACk
RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so \
	libblas.so-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
	update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3  \
	libblas.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
	update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so \
	liblapack.so-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50 && \
	update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 \
	liblapack.so.3-x86_64-linux-gnu  /opt/intel/mkl/lib/intel64/libmkl_rt.so 50

# Update the linker
RUN echo "/opt/intel/lib/intel64" >  /etc/ld.so.conf.d/mkl.conf && \
	echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf && ldconfig

CMD source /opt/intel/bin/compilervars.sh intel64 -platform linux

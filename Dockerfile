FROM alpine:3.11

ARG NJOBS=4

# Install some Alpine packages
RUN apk add --no-cache \
    autoconf \
    bash \
    build-base \
    cmake \
    wget \
    python3-dev \
    libx11-dev \
    mesa-dev \
    mesa-osmesa    

# RUN wget -q https://mesa.freedesktop.org/archive/mesa-20.0.2.tar.xz  && \
#     tar -xf mesa-20.0.2.tar.xz && \
#     cd mesa-20.0.2 && \
#     ./configure CXXFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31" CFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31"--disable-xvmc --disable-dri --with-dri-drivers="" --with-gallium-drivers="swrast" --enable-texture-float --disable-egl --with-egl-platforms="" --enable-gallium-osmesa --enable-gallium-llvm=yes --with-llvm-shared-libs --prefix=/usr/ && \
#     make -j $NJOBS &&  make install && \
#     cd .. && rm -rf mesa-20.0.2 && rm mesa-20.0.2.tar.xz

# Download and extract VTK source, then configure and build VTK
RUN wget -q https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz && \
    tar -xzf VTK-8.2.0.tar.gz && \
    mkdir build && cd build && \ 
    cmake -DCMAKE_BUILD_TYPE=Release -DVTK_WRAP_PYTHON=ON -DVTK_USE_X=OFF -DBUILD_SHARED_LIBS=ON \
    -DOSMESA_LIBRARY=/usr/lib/libOSMesa.so.8 \
    -DOSMESA_INCLUDE_DIR=/usr/include/GL/ \
    -DVTK_OPENGL_HAS_OSMESA=ON -DVTK_USE_OFFSCREEN=ON \
    -DOPENGL_gl_LIBRARY=/usr/lib/libglapi.so -DCMAKE_INSTALL_PREFIX=/usr/ ../VTK-8.2.0 && \
    make -j $NJOBS && \
    make install && \
    cd .. && \
    rm -rf VTK-8.2.0 && rm -rf build && \
    rm VTK-8.2.0.tar.gz

# Install imagemagick (and possibly more later) to compare images
RUN apk add --no-cache \
    imagemagick

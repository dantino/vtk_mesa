FROM alpine:3.5

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


ENV PYTHON_LIBRARY=/usr/lib/python3.8/config-3.8-x86_64-linux-gnu/libpython3.8.a
ENV PYTHON_INCLUDE_DIR=/usr/include/python3.8

# Download and extract VTK source, then configure and build VTK
RUN wget -q https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz && \
    tar -xzf VTK-8.2.0.tar.gz && \
    mkdir build && cd build && \ 
    cmake -DCMAKE_BUILD_TYPE=Release -DVTK_USE_X=OFF -DBUILD_SHARED_LIBS=ON \
    -DOSMESA_LIBRARY=/usr/lib/libOSMesa.so.8 \
    -DOSMESA_INCLUDE_DIR=/usr/include/GL/ \
    -DVTK_OPENGL_HAS_OSMESA=ON -DVTK_USE_OFFSCREEN=ON \
    -DVTK_Group_MPI:BOOL=OFF \
    -DVTK_Group_StandAlone:BOOL=OFF \
    -DVTK_Group_Rendering:BOOL=ON \
    -DVTK_MODULE_ENABLE_VTK_PythonInterpreter:BOOL=OFF \
    -D VTK_WRAP_PYTHON=ON \
    -D VTK_PYTHON_VERSION:STRING=3 \    
    -DOPENGL_gl_LIBRARY=/usr/lib/libglapi.so -DCMAKE_INSTALL_PREFIX=/usr/ ../VTK-8.2.0 && \
    make -j $NJOBS && \
    make install && \
    cd .. && \
    rm -rf VTK-8.2.0 && rm -rf build && \
    rm VTK-8.2.0.tar.gz

# Install imagemagick (and possibly more later) to compare images
RUN apk add --no-cache \
    imagemagick

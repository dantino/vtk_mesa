FROM alpine:3.11

ARG NJOBS=2

# Install some Alpine packages
RUN apk add --no-cache \
    bash \
    build-base \
    cmake \
    wget \
    mesa-dev \
    mesa-osmesa \
    python3-dev

# Download and extract VTK source, then configure and build VTK
RUN wget -nv -O- https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz | \
    tar xz && \
    cd VTK-8.2.0 && \
    cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:STRING=/usr \
    -D BUILD_DOCUMENTATION:BOOL=OFF \
    -D BUILD_EXAMPLES:BOOL=OFF \
    -D BUILD_TESTING:BOOL=OFF \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D VTK_USE_X:BOOL=OFF \
    -D VTK_OPENGL_HAS_OSMESA:BOOL=ON \
    -D OSMESA_LIBRARY=/usr/lib/libOSMesa.so.8 \
    -D OSMESA_INCLUDE_DIR=/usr/include/GL/ \
    -D VTK_RENDERING_BACKEND:STRING=OpenGL \
    -D VTK_Group_MPI:BOOL=OFF \
    -D VTK_Group_StandAlone:BOOL=OFF \
    -D VTK_Group_Rendering:BOOL=ON \
    -D VTK_WRAP_PYTHON=ON \
    -D VTK_PYTHON_VERSION:STRING=3 \
    . && \
    make -j $NJOBS && \
    make install && \
    cd .. && rm -rf VTK-8.2.0

# Install imagemagick (and possibly more later) to compare images
RUN apk add --no-cache \
    imagemagick

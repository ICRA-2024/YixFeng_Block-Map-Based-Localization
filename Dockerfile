# Start from an official ROS base image that supports Ubuntu 18.04 or later
FROM osrf/ros:melodic-desktop

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install necessary packages and dependencies for ROS and the required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        build-essential \
        cmake \
        git \
        libpcl-dev \
        ros-melodic-pcl-ros \
        ros-melodic-tf2-sensor-msgs && \
    rm -rf /var/lib/apt/lists/*

# Create a catkin workspace
RUN mkdir -p /workspace/src

# Clone the required repositories
WORKDIR /workspace/src
RUN git clone https://github.com/koide3/ndt_omp && \
    git clone https://github.com/SMRT-AIST/fast_gicp --recursive && \
    git clone https://github.com/koide3/hdl_global_localization && \
    git clone https://github.com/ICRA-2024/YixFeng_Block-Map-Based-Localization

# Install GTSAM manually since it's not available in rosdep
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common && \
    rm -rf /var/lib/apt/lists/*
    
RUN add-apt-repository ppa:borglab/gtsam-release-4.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgtsam-dev libgtsam-unstable-dev && \
    rm -rf /var/lib/apt/lists/*
    
# Build the workspace
WORKDIR /workspace
SHELL ["/bin/bash", "-c"]
#RUN source /opt/ros/melodic/setup.bash && rosdep update && \
#    rosdep install --from-paths src -y --ignore-src
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libboost-all-dev \
        ros-melodic-map-server && \
    rm -rf /var/lib/apt/lists/*
    
RUN source /opt/ros/melodic/setup.bash && catkin_make

# Source the workspace setup
RUN echo "source /workspace/devel/setup.bash" >> ~/.bashrc

# Set the default command to bash
CMD ["bash"]


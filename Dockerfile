FROM nvidia/cudagl:11.0-devel-ubuntu20.04

# Set the working directory
WORKDIR /root

# Update and install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ubuntu-desktop \
    gnome-panel \
    gnome-settings-daemon \
    vnc4server \
    xfce4-panel \
    xfce4-settings \
    xfwm4 \
    xfdesktop4 \
    tightvncserver \
    nano \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install xrdp
RUN apt-get update && apt-get install -y xrdp

# Create user and set password
RUN useradd -m -d /home/ubuntu -s /bin/bash ubuntu \
    && echo "ubuntu:password" | chpasswd

# Add user to sudoers
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Allow remote connection
RUN echo "gnome-session --session=xfce" >> /etc/xrdp/startwm.sh

# Allow remote connection
RUN echo "gnome-session --session=xfce" >> /etc/xrdp/startwm.sh

# Create shared folder
RUN mkdir /home/shared
RUN chmod -R 755 /home/shared
RUN chown -R ubuntu:ubuntu /home/shared

# Copy python script for GPU information
COPY gpu-info.py /Users/mehmet.sinc/vs_code/oleks/gpu-info.py

# Expose ports for remote desktop and ssh
EXPOSE 22
EXPOSE 3389
EXPOSE 6080

# Run the command on container startup
CMD ["/usr/sbin/xrdp", "-nodaemon"]


# Code

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
    COPY gpu-info.py /root/gpu-info.py

    # Expose ports for remote desktop and ssh
    EXPOSE 22
    EXPOSE 3389
    EXPOSE 6080

    # Run the command on container startup
    CMD ["/usr/sbin/xrdp", "-nodaemon"]

The script "gpu-info.py" needs to be copied to the same directory as the Dockerfile, and it should be in the container in the "/root" directory.

Example Python code 

    import os

    os.system('nvidia-smi')

You will have to build the container using the Dockerfile and you can run the container using the following command

# Build
Building the container
Make sure you have Docker installed on your system. You can follow the official Docker documentation for installation instructions.
Clone this repository or download the files in it.
Open a terminal and navigate to the directory where the Dockerfile is located.
Run the following command to build the container:

    docker build -t container_name .

The "-t" option is used to specify the name of the container, and the "." at the end specifies the current directory as the build context.

# Running the container

Once the container is built, you can run it by using the following command:

    docker run -p 22:22 -p 3389:3389 -p 6080:6080 -v /path/to/host/shared:/home/shared --privileged -it container_name

This command maps the ports from the host to the container, and the -v flag maps the host directory "/path/to/host/shared" to the container directory "/home/shared" so that you can access files in the shared folder.

If you want to run the container in detached mode(without opening the terminal) you can use -d flag

    docker run -p 22:22 -p 3389:3389 -p 6080:6080 -v /path/to/host/shared:/home/shared --privileged -d container_name

You can now access the container via VNC on port 6080, RDP on port 3389, or via SSH on port 22.
The default username and password is ubuntu:password
The shared folder is available at /home/shared
You can check the GPU information by running the command 'nvidia-smi'

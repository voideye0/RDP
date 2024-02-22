# Use a Linux base image
FROM ubuntu:latest

# Update package lists and install necessary tools
RUN apt-get update && apt-get install -y \
    shellinabox \
    xrdp \
    xfce4 \
    xfce4-goodies \
    firefox \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Download and install Ngrok
RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz && \
    tar -xvf ngrok-stable-linux-amd64.tgz && \
    mv ngrok /usr/local/bin/ngrok && \
    rm ngrok-stable-linux-amd64.tgz

# Copy xrdp.ini file for RDP configuration
COPY xrdp.ini /etc/xrdp/xrdp.ini

# Expose ports
EXPOSE 4200 # Shell In A Box
EXPOSE 3389 # RDP
EXPOSE 4040 # Ngrok web interface

# Start services
CMD [ "/usr/sbin/service", "shellinabox", "start" ] && \
    [ "/usr/sbin/service", "xrdp", "start" ] && \
    [ "/bin/bash", "-c", "ngrok http -auth=\"your_username:your_password\" 4200" ] && \
    sleep infinity

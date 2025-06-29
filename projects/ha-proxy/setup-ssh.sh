#!/bin/bash
apt-get update
apt-get install -y openssh-server sudo bash nano
mkdir -p /run/sshd
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create user with bash as default shell
useradd -m -s /bin/bash demo
echo 'demo:demo' | chpasswd
usermod -aG sudo demo

# Create a basic .bashrc file for demo user
cat > /home/demo/.bashrc << 'EOF'
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
alias ls='ls --color=auto'
alias ll='ls -la'
EOF

# Set proper ownership
chown demo:demo /home/demo/.bashrc

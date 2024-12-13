---
title: Hardening SSH login on your VPS
subtitle: Secure your VPS against unauthorized access
summary: Secure your VPS by hardening the SSH login
date: 2024-10-01
categories:
    - security
    - ssh
    - vps
tags:
    - security
    - ssh
    - vps
authors:
    - Finn Artmann: author.jpeg
cardImage: hardening_ssh_card.webp
---

### Introduction

In this guide, I will walk you through hardening the SSH login on your VPS to secure it against unauthorized access. Typically, attackers target SSH services often via brute-force attacks to gain access to your server. Credit to [Dreams of Code](https://www.youtube.com/watch?v=F-9KWQByeU0) as I mainly only compiled the information from this video, but I highly recommend watching it for a more in-depth explanation.

### Prequisites

- A VPS with SSH access: For this guide we will assume you have a VPS with SSH access reachable via an example IP address `1.2.3.4`.


### Step 1: Disable root login

#### 1.1 Login to your VPS

```bash
ssh root@1.2.3.4
```
Enter your password provided by your VPS provider when prompted.

#### 1.2 Add a new non-root user

```bash
adduser mynewuser
```
Set 'mynewuser' as your preferred username and provide a password for the new user when prompted.

#### 1.3 Add the new user to the sudo group

This step is required to allow the new user to execute commands with root privileges when needed.
    
```bash
usermod -aG sudo mynewuser
```

#### 1.4 Test the new user

Test the new user by switching to it and running a command with sudo.
```bash
su - mynewuser
sudo ls /
```

### Step 2: Disable password authentication

#### 2.1 Set up SSH key-based authentication

Exit the vps and make sure your new user has a copy of your ssh key.
```bash
exit
```
On your local machine, copy your public ssh key to the new user on the vps.
```bash
ssh-copy-id mynewuser@1.2.3.4
```

#### 2.2 Test key-based authentication

Try to login to your VPS with the new user. The login should not prompt you for a password.
```bash
ssh mynewuser@1.2.3.4
```


### Step 3: Disable password authentication

#### 3.1 Modify the SSH configuration file to disable password authentication

Modify the SSH configuration file to disable password authentication.
Log back into your VPS as the new user and open the SSH configuration file in a text editor.

```bash
sudo vi /etc/ssh/sshd_config
```

Uncomment the following line in the file and change the value to `no`.
```bash
PasswordAuthentication no
```

Disable root login by uncommenting the following line and changing the value to `no`.
```bash
PermitRootLogin no
```

Disable PAM authentication by uncommenting the following line and changing the value to `no`.
```bash
UsePAM no
```

Depending on your VPS provider, there might be additional configurations files for password authentication that you need to modify.


#### 3.2 Restart the SSH service

Reload the SSH service to apply the changes.
```bash
sudo systemctl reload sshd
```

### 3.3 Test the changes

Exit the VPS and try to log back in with the root user. The login should fail and output a message indicating 'Permission denied'.

```bash
ssh root@1.2.3.4
Output: root@1.2.3.4: Permission denied (publickey).
```


### Step 4: Configure SSH port (optional)

An additional step you might consider is changing the default SSH port to a custom port to reduce the number of automated attacks on your server.
Keep in mind to take note of the custom port as other services you configure might need to know it.

This is especially important when you configure a firewall on your VPS, as you need to allow the custom port for SSH access. Whether or not you change the port, it is crucial to configure a firewall to allow traffic to the SSH port (the default porrt 22 or your custom port), otherwise you will have trouble logging back into your VPS!

In case you did lock yourself out though, usually the VPS provider provides a console access to your VPS or other recovery options to regain access.

The change can also be made in the SSH configuration file.

```bash
sudo vi /etc/ssh/sshd_config
```

Change the port number in the file to your desired custom port.

```bash
Port 2222
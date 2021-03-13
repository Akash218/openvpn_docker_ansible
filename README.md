# OPENVPN CONTAINER #

* Base image: ubuntu
* version: 20.04

## ADDITIONAL PACKAGES ##

1. package_name: supervisord
   * version: 4.1.0

   * uses: supervisord is a process monitoring tool,To manage multiple services (openssh and openvpn) in single container.

2. package_name: openssh
   * version: 8.2

   * uses: SSH is typically used to log into a remote machine and execute commands securely.

3. package_name: openvpn
   * version: 2.4.7

   * uses: OpenVPN is a virtual private network (VPN) system that implements techniques to create secure point-to-point or site-to-site connections between server and clients.

## IMAGE CONFIGURATIONS ##

* supervisord.conf file placed under "/etc/supervisor/conf.d/" directory, which tells supervisor daemon to handle services, it keeps "openvpn" log files in /var/log/openvpn/ directory. 

* vpn_script file placed under "/bin" directory, script_file runs based on our vpn requirements(eg: config file[must], private key file[optional], password file[optional] ).

* supervisord running as a root then openvpn and openssh running as a sudo user.
  sudo_username: Athira

* sudo access only provided to run vpn and ssh services.

## DEPENDENCIES FOR RUNNING CONTAINERS STANDALONE ##

1. [install docker](https://docs.docker.com)

2. start docker-engine service

3. change environment variables in "env.list" file and keeps required openvpn files in a specific diretory.

4. docker run -itd -env-file env.list --cap-add=NET_ADMIN --publish 1055:22 --device /dev/net/tun --sysctl net.ipv6.conf.all.disable_ipv6=0 -v <path_to_openvpn_file_directory>:/client <image_name>

## OVERVIEW OF DOCKER RUN COMMAND ##

### 1.) environment variables ###

1. ovpn_file="sample.ovpn" [must]
     * ovpn offer an easy way to configure OpenVPN on your computer to work with our servers. These files contain the correct cipher types, Certificate Authority, Certificate, and Private Keys.
  
2. pkcs12_file="sample.p12" [optional]
     * A p12 file contains a digital certificate that uses PKCS#12 (Public Key Cryptography Standard #12) encryption. It is used as a portable format for transferring personal private keys and other sensitive information.

3. pass_file="sample.pass" [optional]
     * pass file containes username and password to connect the openvpn server.

4. username="example" [optional]
     * provide username directly instead of giving in pass file

5. password="example@123" [optional]
     * provide password directly instead of giving in pass file

### 2.) cap_add ###

* Using cap-add=NET_ADMIN to modify the network interfaces. To reduce syscall attacks it's good practice to give the container only required privileges

### 3.) devices /dev/net/tunnel ###

* If you want to create persistent devices and give ownership of them to unprivileged users, then you need the /dev/net/tun device to be usable by those users.

### 4.) sysctl net.ipv6.conf.all.disable_ipv6=0 ###

* If you are not using IPv6, or at least knowingly using IPv6, then you should turn off IPv6 and only enable it again when you need to deploy services on IPv6. If you have IPv6 enabled but you are not using it, the security focus is never on IPv6 or vulnerablities associated with it.

### 5.) publish ###

* By default ssh port inside the container is 22 [static], using "--publish" to do port forwarding based on available ports in our local machine. [eg: 1032:22], here "1032" is our local machine port. [make sure to provide available port].

## Autobots ##

NOTE: Ansible playbook [available](https://github.com/Akash218/openvpn_docker_ansible/tree/feature/ansible) for installing and running openvpn containers in a "Single Command".for more information, please visit [here](https://github.com/Akash218/openvpn_docker_ansible/blob/feature/ansible/roles/ovpn/README.md).

## COMMANDS FOR VALIDATE CONTAINER AND OPENVPN SERVICES ##

* " docker container ls -a " { To check whether the container is running or not and healthy or unhealthy }

* " docker logs <container_name> " { To validate openvpn and openssh process are in running state }

* " docker exec -it <container_name> cat /var/log/openvpn/vpn_out.log " { To validate connection established between server to client(vice-versa) }

* " docker exec -it <container_name> cat /var/log/openvpn/vpn_err.log " { use this command to check the error,if any output not shown by vpn_out.log }

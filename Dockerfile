FROM ubuntu:20.04

ENV OVPN_FILE=""
ENV PKCS12_FILE=""
ENV PASS_FILE=""
ENV OVPN_USERNAME=""
ENV OVPN_PASSWORD=""

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server\
    supervisor\
    openssl\
    sudo\
    openvpn &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd /var/log/supervisor /var/log/openvpn /etc/supervisor/conf.d/

RUN echo 'root:mydbops123' | chpasswd

RUN useradd -m -d "/client" -p $(openssl passwd mydbops) Admin

RUN echo "Athira ALL=(root) NOPASSWD:/usr/sbin/sshd,/usr/sbin/openvpn" >> /etc/sudoers && \
          chmod 0440 /etc/sudoers

ADD supervisord.conf /etc/supervisor/conf.d/ 
ADD vpn_script.sh /bin/
RUN chmod +x /bin/vpn_script.sh 

#USER Athira

HEALTHCHECK CMD supervisorctl status | grep -i openvpn | grep -o RUNNING && \
            tail -1 /var/log/openvpn/vpn_out.log | grep -i 'Initialization Sequence Completed'  || exit 1

#ENTRYPOINT ["sudo"]
CMD ["/usr/bin/supervisord"]

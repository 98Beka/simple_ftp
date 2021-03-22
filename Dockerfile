FROM alpine:3.12

RUN apk update && apk upgrade
RUN	apk add openrc vsftpd openssl
RUN rc-update add vsftpd default
RUN openssl req -new -x509 -days 365 -nodes -out /etc/ssl/private/vsftpd.cert.pem -keyout /etc/ssl/private/vsftpd.key.pem -subj '/CN=localhost'

RUN echo -e "\
adduser admin --disabled password\n\
echo \"admin:admin\" | chpasswd\n\
mkdir /home/admin/ftp\n\
chown nobody:nogroup /home/admin/ftp\n\
chmod a-w /home/admin/ftp\n\
mkdir /home/admin/ftp/files\n\
chown admin:admin /home/admin/ftp/files\n\
echo \"vsftpd test file\" | tee /home/admin/ftp/files/test.txt\n\
echo \"admin\" | tee -a /etc/vsftpd/vsftpd.userlist\n\
vsftpd /etc/vsftpd/vsftpd.conf\n\
" > run.sh
        
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN chmod +x /run.sh
EXPOSE 21 21000
CMD	 /run.sh
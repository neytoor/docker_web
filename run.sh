#!/bin/bash
rutaftp=/etc/vsftpd/vsftpd.conf
rutaapache=/etc/httpd/conf/httpd.conf
#APACHE
grep root@localhost $rutaapache
buscar=$(echo $?)

if [ "$buscar" -eq "0" ]; then
sed -i 's/root@localhost/yonieer13@gmail.com/' $rutaapache
else
echo el Name ya fue modificado
fi

#FTP
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" $rutaftp
sed -i 's/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Bienvenidos al ftp de mundo servicios./' $rutaftp
sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/" $rutaftp
sed -i 's|#chroot_list_file=/etc/vsftpd/chroot_list|chroot_list_file=/etc/vsftpd/chroot_list|' $rutaftp

buscar=$(grep root@localhost $rutaapache)
if [ "buscar" = root@localhost ]; then
sed -i 's/root@localhost/yonieer13@gmail.com/' $rutaapache
else
echo ya fue agregado
fi

grep -i userftp /etc/passwd
verificar=$(echo $?)
if [ "$verificar" = "1" ] ; then
useradd -s /sbin/nologin userftp ; echo "Neytor1313" | passwd --stdin userftp
echo userftp > /etc/vsftpd/chroot_list
else
echo el usuario ya fue agregado
fi

echo allow_writeable_chroot=YES >> $rutaftp
echo local_root=/var/www/html/wp-content >> $rutaftp
echo pasv_enable=YES >> $rutaftp
echo pasv_max_port=40000 >> $rutaftp
echo pasv_min_port=40000 >> $rutaftp
echo port_enable=YES >> $rutaftp

#MOODLE
sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf

#ARRANCHA FTP
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
#ARRANCA APACHE
/sbin/apachectl -DFOREGROUND

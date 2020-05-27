# Install apache.
yum install --quiet -y httpd httpd-devel
# Copy config files.
cp httpd.conf /etc/httpd/conf/httpd.conf
cp httpd-vhosts /etc/httpd/conf/httpd-vhosts.conf
# Restart and configure apache.
service httpd start
chkconfig httpd on

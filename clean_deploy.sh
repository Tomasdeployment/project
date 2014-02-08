#!/usr/bin/bash
#a sandbox is created where files are manipulated
SANDBOX=sandbox_$RANDOM
echo Using sandbox $SANDBOX
#
# Stop services
/etc/init.d/apache2 stop
/etc/init.d/mysql stop
#
apt-get update
#target environment is cleaned
apt-get -q -y remove apache2
apt-get -q -y install apache2
#packages are installed
apt-get -q -y remove mysql-server mysql-client
echo mysql-server mysql-server/root_password password password | debconf-set-selections
echo mysql-server mysql-server/root_password_again password password | debconf-set-selections
apt-get -q -y install mysql-server mysql-client
#
cd /tmp
mkdir $SANDBOX
cd $SANDBOX/
#web app is installed
git clone https://github.com/Tomasdeployment/form
cd form/
#
cp Apache/www/* /var/www/
cp Apache/cgi-bin/* /usr/lib/cgi-bin/
chmod a+x /usr/lib/cgi-bin/*
#
# Start services
/etc/init.d/apache2 start
/etc/init.d/mysql start
#database is configured
cat <<FINISH | mysql -uroot -ppassword
drop database if exists dbtest;
CREATE DATABASE dbtest;
GRANT ALL PRIVILEGES ON dbtest.* TO dbtestuser@localhost IDENTIFIED BY 'dbpassword';
use dbtest;
drop table if exists custdetails;
create table if not exists custdetails (
name         VARCHAR(30)   NOT NULL DEFAULT '',
address         VARCHAR(30)   NOT NULL DEFAULT ''
);
insert into custdetails (name,address) values ('John Smith','Street Address'); select * from custdetails;
FINISH
#
cd /tmp
rm -rf $SANDBOX



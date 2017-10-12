#!/bin/bash
rm -rf ssr.sh
hmd=c4ca4238a0b923820dcc509a6f75849b;
web="http://"; 
webs="https://"; 
error="Authorization failure."; 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH 
clear; 
cd /
# Logo	******************************************************************
CopyrightLogo='
==========================================================================
			        欢迎使用
							  
		        ShadowSocks多用户管理系统

		        采用SSR+ss-panel V2+LAMP
		
		     ©2016-2017 ssr All rights received                          
	              	
==========================================================================';
echo "$CopyrightLogo";
# FILES  ******************************************************************
ServerLocation='ssr';
# VAR	******************************************************************
Model=$1;
Froms=$2;
MirrorHost='svn-10038864.cossh.myqcloud.com';
IPAddress=`wget http://members.3322.org/dyndns/getip -O - -q ; echo`;
pass='xxoo';
#==========================================================================
echo 
echo "本脚本支持【Centos6.x】系统(如遇到卡住，请耐心等待5-7分钟)"
echo 
echo -n "请输入授权码： "
read PASSWD
key2=$PASSWD
if [[ $key2 == $pass ]]
    then
	echo 
	echo 授权成功！[本机IP：$IPAddress]
    else
	echo
	echo "授权失败！"
OPW='
==========================================================================
			  服务授权失败，安装被终止
			
			  可能原因是您的ip未被授权
		
          ShadowSocks多用户管理系统安装失败 
			
		  ©2016-2017 ssr All rights received                          
		   
					
==========================================================================';
echo "$OPW";
exit 0;
fi
echo
function InputIPAddress()
{
	if [ "$IPAddress" == '' ]; then
		echo '无法检测您的IP';
		read -p '请输入您的公网IP:' IPAddress;
		[ "$IPAddress" == '' ] && InputIPAddress;
	fi;
	[ "$IPAddress" != '' ] && echo -n '[  OK  ] 您的IP是:' && echo $IPAddress;
	sleep 2
}
# mysql
echo -n "请输入数据库密码(默认xxoo)： "
read mysqlpass
if [ -z $mysqlpass ]
then
echo  "数据库密码：password"
mysqlpass=xxoo
else
        echo "数据库密码：$mysqlpass"
        fi
        echo -n "请输入后台登陆账号，请使用邮箱方式(默认admin@xxoo.com)： "
read gly
if [ -z $gly ]
then
echo  "后台账号：admin@xxoo.com"
gly=admin@xxoo.com
else
        echo "后台账号：$gly"
        fi
        echo -n "请输入SS连接端口，(默认1010)： "
read proxy
if [ -z $proxy ]
then
echo  "SS连接端口：1010"
proxy=1010
else
        echo "SS连接端口：$proxy"
        fi
        echo -n "请输入SS连接密码密码，(默认Admin)： "
read sspass
if [ -z $sspass ]
then
echo  "SS连接密码：Admin"
sspass=Admin
else
        echo "SS连接密码：$sspass"
        fi
        pptp=`echo -n $sspass|md5sum`
        sleep 2
echo "正在部署环境..."
yum install -y git redhat-lsb curl gawk tar httpd-devel unzip expect
yum install wget tar gcc gcc-c++ openssl openssl-devel pcre-devel python-devel libevent automake autoconf libtool make -y
# 
CO='
==========================================================================
			 安装被终止,请在Centos 6.x 系统上执行操作
 
			     ShadowSocks多用户管理系统安装失败 			       		       
			   ©2016-2017 Adc.bid.All rights received                          
					
==========================================================================';
version=`lsb_release -a | grep -e Release|awk -F ":" '{ print $2 }'|awk -F "." '{ print $1 }'`
if [ $version == "6" ];then
rpm -ivh ${webs}${MirrorHost}/${ServerLocation}/epel-release-6-8.noarch.rpm  >/dev/null 2>&1
rpm -ivh ${webs}${MirrorHost}/${ServerLocation}/remi-release-6.rpm  >/dev/null 2>&1
fi
if [ $version == "7" ];then
echo 
    echo "安装被终止，请在Centos6.x系统上执行操作..."
	echo "$CO";
exit
fi
if [ ! $version ];then
    echo 
    echo "安装被终止，请在Centos6.x系统上执行操作..."
	echo "$CO";
echo "检查并更新软件..."
fi
sleep 3
yum update -y
# SSR Installing ****************************************************************************
echo "配置网络环境..."
sleep 3
iptables -F >/dev/null 2>&1
service iptables save >/dev/null 2>&1
service iptables restart >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 1010 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 137 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 9999 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 1194 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 60880 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 80 -j ACCEPT >/dev/null 2>&1
iptables -A INPUT -p TCP --dport 22 -j ACCEPT >/dev/null 2>&1
service iptables save
service iptables stop
chkconfig iptables off
# SSR Installing ****************************************************************************
echo "开始安装LAMP环境" 
yum -y install httpd 
chkconfig httpd on
/etc/init.d/httpd start
yum remove -y mysql*
yum --enablerepo=remi install -y mysql mysql-server mysql-devel
chkconfig mysqld on 
service mysqld start
yum remove -y php*
yum install -y --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof php-bcmath php-cli php-common  php-devel php-fpm    php-gd php-imap  php-ldap php-mysql  php-odbc  php-pdo  php-pear  php-pecl-igbinary  php-xml php-xmlrpc php-opcache php-intl php-pecl-memcache
service php-fpm start
service httpd restart
cd /var/www/html
wget ${webs}${MirrorHost}/${ServerLocation}/phpmyadmin.zip >/dev/null 2>&1
unzip phpmyadmin.zip >/dev/null 2>&1 
rm -f phpmyadmin.zip
service php-fpm restart
service httpd restart
service mysqld restart
rm -rf /bin/lamp
echo "#!/bin/sh
echo 正在重启lamp服务...
service mysqld restart 
service php-fpm restart 
service httpd restart
echo 服务已启动
exit 0;
" >/bin/lamp
		chmod 0777 /bin/lamp
# SSR Installing ****************************************************************************
cd /root
yum -y install m2crypto python-setuptools
easy_install pip
pip install cymysql
wget ${web}${MirrorHost}/${ServerLocation}/ssr.zip >/dev/null 2>&1
unzip ssr.zip >/dev/null 2>&1
cd shadowsocks
cp apiconfig.py userapiconfig.py
cp mysql.json usermysql.json
cp config.json user-config.json
sed -i "5s/123456/$mysqlpass/" /root/shadowsocks/usermysql.json >/dev/null 2>&1
cd /root
mysqladmin -u root password $mysqlpass 
mysql -uroot -p$mysqlpass -e"CREATE DATABASE shadowsocks;" 
cd /var/www/html
wget ${web}${MirrorHost}/${ServerLocation}/ss.zip >/dev/null 2>&1
unzip ss.zip >/dev/null 2>&1
rm -rf ss.zip
mv ss/* /var/www/html/
cd lib/
sed -i "16s/password/$mysqlpass/" /var/www/html/lib/config.php >/dev/null 2>&1
sed -i "33s/admin@xxoo.com/$gly/" /var/www/html/sql/user.sql
sed -i "33s/Admin/$sspass/" /var/www/html/sql/user.sql
sed -i "33s/1010/$proxy/" /var/www/html/sql/user.sql
cd /var/www/html/sql
mysql -uroot -p$mysqlpass shadowsocks < invite_code.sql
mysql -uroot -p$mysqlpass shadowsocks < ss_node.sql
mysql -uroot -p$mysqlpass shadowsocks < ss_reset_pwd.sql
mysql -uroot -p$mysqlpass shadowsocks < ss_user_admin.sql
mysql -uroot -p$mysqlpass shadowsocks < user.sql
echo "正在启动SSR服务" 
sleep 1
cd /root/shadowsocks
chmod +x *.sh
./logrun.sh
chmod +x /etc/rc.d/rc.local
echo "/root/shadowsocks/run.sh" >/etc/rc.d/rc.local
rm -rf /bin/SSR
echo "#!/bin/sh
echo 正在重启SSR服务...
/root/shadowsocks/stop.sh
/root/shadowsocks/run.sh
echo 服务已启动
exit 0;
" >/bin/SSR
		chmod 0777 /bin/SSR
# SSR Installing ****************************************************************************
echo 
echo '=========================================================================='
echo
echo 恭喜！您的SSR多用户管理系统安装完毕
echo
echo 恭喜您搭建成功！
echo
echo 数据库地址：http://$IPAddress/phpmyadmin
echo
echo 用户地址：http://$IPAddress/
echo
echo 管理后台：http://$IPAddress/admin
echo 
echo 你的数据库账号：root
echo
echo 你的数据库密码：$mysqlpass
echo 
echo 你的后台账号：$gly
echo
echo 你的后台密码：1993
echo
echo 连接端口：$proxy
echo
echo 连接密码：$sspass
echo
echo 本地端口：1080
echo
echo 加密方式：aes-256-cfb
echo
echo 协议：auth_sha1
echo
echo 混淆方式：http_simple
echo
echo lamp快捷重启命令：lamp
echo 
echo SSR快捷重启命令：SSR
echo 
echo 您的IP是：$IPAddress 
Client='
==========================================================================
			   ShadowSocks多用户管理系统安装完毕
			   
               ©2016-2017 Adc.bid.All rights received                          
	              							    
==========================================================================';
echo "$Client";
exit 0;
# SSR Installation Complete ****************************************************************************

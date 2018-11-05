if [ -e wordpress_main.sql ]
then
	sudo -u vagrant -H sh -c 'cd /var/www/vagrant/database; wp db import'
fi
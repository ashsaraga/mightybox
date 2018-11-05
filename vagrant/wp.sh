cd /var/www/html
sudo -u vagrant -H sh -c 'cd /var/www/vagrant; wp core download'
sudo -u vagrant -H sh -c 'cd /var/www/vagrant; wp config create --dbprefix=wp_'
sudo -u vagrant -H sh -c 'cd /var/www/html; touch .htaccess'
sudo -u vagrant -H sh -c 'cd /var/www/vagrant; wp core install --skip-email'
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins
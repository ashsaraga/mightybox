# Repo SSH clone link (retrieved by droplet.rb)
cloneLink=$1
echo 'GITHUB_REPO="'${cloneLink}'"' >> /etc/environment

# Server IP Address (set by droplet.rb)
ipAddress=$2
echo 'IP_ADDRESS="'${ipAddress}'"' >> /etc/environment

# Clone into master branch
cd /var/www/wordpress
sudo -Hu www-data git clone $1 .

# Run WP setup with /var/www/setup/master wp-cli.yml
cd /var/www/setup/master
sudo -Hu www-data wp config create --dbprefix=wp_ --url=$2 --dbpass=$3
sudo -Hu www-data wp core install --skip-email --url=$2 --dbpass=$3
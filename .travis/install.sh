#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    for version in 53 54 55 56 70 71;
    do
        brew install php$version --with-httpd
        brew unlink php$version;
    done
    echo 'Installed all PHP versions.'

    cat > ~/Sites/phpinfo/index.php << EOF
<?php
phpinfo();
EOF

    echo '<VirtualHost *:80>
        ServerName phpinfo.dev
        DocumentRoot /Users/phil/Sites/phpinfo/

	<Directory /Users/phil/Sites/phpinfo/>
		Options FollowSymLinks
		Require all granted
	</Directory>
</VirtualHost>' >> /usr/local/etc/httpd/extra/httpd-vhosts.conf

    echo '<VirtualHost *:80>
        ServerName phpinfo.dev
        DocumentRoot /Users/phil/Sites/phpinfo/

	<Directory /Users/phil/Sites/phpinfo/>
		Options FollowSymLinks
		Require all granted
	</Directory>
</VirtualHost>' >> /etc/apache2/extra/httpd-vhosts.conf

fi
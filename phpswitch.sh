#!/bin/bash
# Creator: Phil Cook
# Email: phil@phil-cook.com
# Twitter: @p_cook
php_array=("php53" "php54" "php55")
php_installed_array=()
php_version="php$1"
apache_conf_path="/etc/apache2/httpd.conf"
brew_prefix=$(brew --prefix | sed 's#/#\\\/#g')
php_opt_path="$brew_prefix\/opt\/"
php_lib_path="\/libexec\/apache2\/libphp5.so"
php_mod_path="$php_opt_path$php_version$php_lib_path"

# Has the user submitted a version required
if [[ -z "$1" ]]
then
	echo "Please set which version you want to switch to. E.g. brew-php-switcher 53"
	exit
fi

# What versions of php are installed via brew
for i in ${php_array[@]}
	do
		if [[ -n $(brew ls --versions $i) ]]
		then
			php_installed_array+=("$i")
		fi
done

# Check that the requested version is supported
if [[ " ${php_array[*]} " == *"$php_version"* ]]
then
	# Check that the requested version is installed
	if [[ " ${php_installed_array[*]} " == *"$php_version"* ]]
	then
		echo "Switching to $php_version"
		echo "Switching your shell"
		for i in ${php_installed_array[@]}
		do
			if [[ -n $(brew ls --versions $i) ]]
			then
				brew unlink $i
			fi
		done
		brew link "$php_version"
		echo "You will need sudo power from now on"
		echo "Switching your apache conf"
		for j in ${php_installed_array[@]}
		do
			sudo sed -i.bak "s/^LoadModule[ \t]php5_module[ \t]$php_opt_path$j$php_lib_path/\#LoadModule php5_module $php_opt_path$j$php_lib_path/g" $apache_conf_path
		done
		sudo sed -i.bak "s/^\#LoadModule[ \t]php5_module[ \t]$php_mod_path/LoadModule php5_module $php_mod_path/g" $apache_conf_path
		echo "Restarting apache"
		sudo apachectl restart
		echo "All done!"
	else
		echo "Sorry, but $php_version is not installed via brew. Install by running brew install $php_version"
	fi
else
	echo "Unknown version of PHP. PHP Switcher can only handle arguements of 53,54,55"
fi

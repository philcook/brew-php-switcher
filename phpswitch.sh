#!/bin/bash
# Creator: Phil Cook
# Email: phil@phil-cook.com
# Twitter: @p_cook
brew_prefix=$(brew --prefix | sed 's#/#\\\/#g')

php_array=("php53" "php54" "php55" "php56")
php_installed_array=()
php_version="php$1"
php_opt_path="$brew_prefix\/opt\/"

apache_change=1
apache_conf_path="/etc/apache2/httpd.conf"
apache_php_lib_path="\/libexec\/apache2\/libphp5.so"
apache_php_mod_path="$php_opt_path$php_version$apache_php_lib_path"

# Has the user submitted a version required
if [[ -z "$1" ]]
then
	echo "usage: brew-php-switcher version [-s]"; echo;
	echo "    version    one of:" ${php_array[@]};
	echo "    -s         skip change of mod_php on apache"; echo;
	exit
fi

while [[ ${2:0:1} = '-' ]] ; do
	N=1
	L=${#1}
	while [[ $N -lt $L ]] ; do
		case ${2:$N:1} in
			's') apache_change=0 ;;
			*) echo $USAGE
			exit 1 ;;
		esac
		N=$(($N+1))
	done
	shift
done

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
		if [[ $apache_change -eq 1 ]]; then
			echo "You will need sudo power from now on"
			echo "Switching your apache conf"
			for j in ${php_installed_array[@]}
			do
				sudo sed -i.bak "s/^LoadModule[ \t]php5_module[ \t]$php_opt_path$j$apache_php_lib_path/\#LoadModule php5_module $php_opt_path$j$apache_php_lib_path/g" $apache_conf_path
			done
			sudo sed -i.bak "s/^\#LoadModule[ \t]php5_module[ \t]$apache_php_mod_path/LoadModule php5_module $apache_php_mod_path/g" $apache_conf_path
			echo "Restarting apache"
			sudo apachectl restart
		fi
		echo "All done!"
	else
		echo "Sorry, but $php_version is not installed via brew. Install by running: brew install $php_version"
	fi
else
	echo "Unknown version of PHP. PHP Switcher can only handle arguments of:" ${php_array[@]}
fi

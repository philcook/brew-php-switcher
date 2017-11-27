#!/bin/bash

# Creator: Phil Cook
# Email: phil@phil-cook.com
# Twitter: @p_cook
brew_prefix=$(brew --prefix | sed 's#/#\\\/#g')

brew_array=("53","54","55","56","70","71")
php_array=("php53" "php54" "php55" "php56" "php70" "php71")
php_installed_array=()
php_version="php$1"
php_opt_path="$brew_prefix\/opt\/"

php5_module="php5_module"
apache_php5_lib_path="\/libexec\/apache2\/libphp5.so"
php7_module="php7_module"
apache_php7_lib_path="\/libexec\/apache2\/libphp7.so"
native_osx_php_apache_module="LoadModule php5_module libexec\/apache2\/libphp5.so"

php_module="$php5_module"
apache_php_lib_path="$apache_php5_lib_path"
if [ $(echo "$php_version" | sed 's/^php//') -ge 70 ]; then
    php_module="$php7_module"
    apache_php_lib_path="$apache_php7_lib_path"
fi

apache_change=1
apache_conf_path=$(apachectl -V | grep SERVER_CONFIG_FILE | cut -d '"' -f 2)
apache_php_mod_path="$php_opt_path$php_version$apache_php_lib_path"
apache_location=$(which apachectl)
apache_sudo=1

if [[ "$EUID" -eq 0 ]]
then
    printf "$(tput setaf 1)Don't run as root!! Please run as your own user"
    exit
fi

# Has the user submitted a version required
if [[ -z "$1" ]]
then
    echo "usage: brew-php-switcher version [-s]"; echo;
    echo "    version    one of:" ${brew_array[@]};
    echo "    -s         skip change of mod_php on apache"; echo;
    exit
fi

# Check for skip apache
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
for i in ${php_array[*]}
    do
        if [[ -n "$(brew ls --versions "$i")" ]]
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
        # Switch Shell
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

        # Switch apache
        if [[ $apache_change -eq 1 ]]; then
            if [[ $apache_location == "/usr/sbin/apachectl" ]]; then
                apache_sudo=1
                printf "We have detected you are using OSX's native apache, as such you will require sudo power from now on\n"
            elif [[ $apache_location == "/usr/local/bin/apachectl" ]]; then
                printf "We have detected you are using Homebrew apache, checking if sudo power is required\n"
                if [[ $(ps -u $(whoami) | grep "httpd" | grep -v "grep") ]]; then
                    apache_sudo=0
                    printf "User $(tput setaf 4)$(whoami)$(tput sgr0) is running apache therefore no sudo required\n"
                else
                    apache_sudo=1
                    printf "User $(tput setaf 4)$(whoami)$(tput sgr0) not running apache therefore sudo power is required\n"
                fi
            fi
            printf "Switching your apache conf\n"

            for j in ${php_installed_array[@]}
            do
                loop_php_module="$php5_module"
                loop_apache_php_lib_path="$apache_php5_lib_path"
                if [ $(echo "$j" | sed 's/^php//') -ge 70 ]; then
                    loop_php_module="$php7_module"
                    loop_apache_php_lib_path="$apache_php7_lib_path"
                fi
                loop_load_module="LoadModule $loop_php_module"
                loop_php_module_path="$php_opt_path$j$loop_apache_php_lib_path"
                apache_module_string="LoadModule $loop_php_module $php_opt_path$j$loop_apache_php_lib_path"
                comment_apache_module_string="#$apache_module_string"

                # Check if there is a brew standard link to the Cellar php file and if so remove it
                if [[ $apache_sudo -eq 1 ]]; then
                    sudo sed -i.bak -E "/^\#?$loop_load_module +\/usr\/local\/Cellar\/$j\/.+$/d" $apache_conf_path
                else
                    sed -i.bak -E "/^\#?$loop_load_module +\/usr\/local\/Cellar\/$j\/.+$/d" $apache_conf_path
                fi

                # If apache module string within apache conf
                if grep -q "$apache_module_string" "$apache_conf_path"; then
                    # If apache module string not commented out already
                    if ! grep -q "$comment_apache_module_string" "$apache_conf_path"; then
                        if [[ $apache_sudo -eq 1 ]]; then
                            sudo sed -i.bak "s/$apache_module_string/$comment_apache_module_string/g" $apache_conf_path
                        else
                            sed -i.bak "s/$apache_module_string/$comment_apache_module_string/g" $apache_conf_path
                        fi
                    fi
                # Else the string for the php module is not in the apache config then add it
                 else
                    if [[ $apache_sudo -eq 1 ]]; then
                        sudo sed -i.bak "/\#?LoadModule.*$ /
                        $comment_apache_module_string \
                        " $apache_conf_path
                    else
                        sed -i.bak "/\#?LoadModule.*$ /
                        $comment_apache_module_string \
                        " $apache_conf_path
                    fi
                fi
            done
            if [[ $apache_sudo -eq 1 ]]; then
                sudo sed -i.bak "s/\#LoadModule $php_module $apache_php_mod_path/LoadModule $php_module $apache_php_mod_path/g" $apache_conf_path
            else
                sed -i.bak "s/\#LoadModule $php_module $apache_php_mod_path/LoadModule $php_module $apache_php_mod_path/g" $apache_conf_path
            fi
            echo "Restarting apache"
            if [[ $apache_sudo -eq 1 ]]; then
                sudo apachectl restart
            else
                apachectl restart
            fi
        fi
        echo "All done!"
    else
        echo "Sorry, but $php_version is not installed via brew. Install by running: brew install $php_version"
    fi
else
    echo "Unknown version of PHP. PHP Switcher can only handle arguments of:" ${brew_array[@]}
fi

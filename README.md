PHP Switcher
=========

PHP switcher is a simple script to switch your Apache and CLI configs quickly between versions major versions of PHP.

If you support multiple products/projects that are built using either brand new or old legacy PHP functionality and you find it a pain to change config files continually this will make the whole process last seconds not minutes.

Caveats
-------

For users of OSX only who have installed PHP via [Homebrew] and for PHP version 5.3, 5.4 and 5.5 only.

Your Apache config must be setup using the same paths as below.
```sh
LoadModule php5_module /usr/local/opt/php53/libexec/apache2/libphp5.so
#LoadModule php5_module /usr/local/opt/php54/libexec/apache2/libphp5.so
#LoadModule php5_module /usr/local/opt/php55/libexec/apache2/libphp5.so
```

Version
----

1.0

Installation
--------------
Where **[version]** exists, please replace with syntax of **53**,**54** or **55** depending on which version is required.

```sh
git clone git@github.com:philcook/php-switcher.git php-switcher
cd php-switcher
sh phpswitch.sh [version]
```

You can also add aliases in your shell as well for even quicker switching, add this to your **.bash_profile** or favourite shell config.

```sh
alias php53="sh /path/to/phpswitch.sh 53"
alias php54="sh /path/to/phpswitch.sh 54"
alias php55="sh /path/to/phpswitch.sh 55"
```

License
----

MIT

[Homebrew]:http://http://brew.sh/
[@p_cook]:http://twitter.com/p_cook
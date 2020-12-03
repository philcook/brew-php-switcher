Brew PHP Switcher [![Build Status](https://travis-ci.org/philcook/brew-php-switcher.svg?branch=master)](https://travis-ci.org/philcook/brew-php-switcher)
=========

Brew PHP switcher is a simple script to switch your Apache and CLI configs quickly between major versions of PHP.

If you support multiple products/projects that are built using either brand new or old legacy PHP functionality and you find it a pain to change config files continually this will make the whole process just one command.

Caveats
-------

For users of OSX only who have installed PHP via [Homebrew] and for PHP version 5.6, 7.0, 7.1, 7.2, 7.3, 7.4 and 8.0 only.

Your Apache config must have native osx PHP module commented out.
```sh
#LoadModule php5_module libexec/apache2/libphp5.so
```

Brew PHP Switcher will automatically add the [Homebrew]'s PHP module location in the Apache config in the following format.
```sh
#LoadModule php5_module /usr/local/opt/php@5.6/lib/httpd/modules/libphp5.so
#LoadModule php7_module /usr/local/opt/php@7.0/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.1/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.2/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.3/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@7.4/lib/httpd/modules/libphp7.so
#LoadModule php7_module /usr/local/opt/php@8.0/lib/httpd/modules/libphp8.so
```

Version
----

2.2

Installation
--------------
```sh
brew install brew-php-switcher
```

Where **5.6** exists, please replace with syntax of **5.6**, **7.0**, **7.1**, **7.2**, **7.3**, **7.4** or **8.0** depending on which version is required.
```sh
brew-php-switcher 5.6
```

> by default will switch apache config

Options
--------------

- `-s|-s=*` Skips apache & valet config switch for i.e

```sh
# skip apache only
brew-php-switcher 5.6 -s

# skip valet only
brew-php-switcher 5.6 -s=valet

# skip valet & apache
brew-php-switcher 5.6 -s=valet,apache
```
- `-c=*` switch a specific config for i.e

```sh
# switch valet config only
brew-php-switcher 5.6 -c=valet

# switch valet & apache config only
brew-php-switcher 5.6 -c=valet,apache

# switch apache config only
brew-php-switcher 5.6 -c=apache
```

License
----

MIT

[Homebrew]:http://brew.sh/
[@p_cook]:http://twitter.com/p_cook

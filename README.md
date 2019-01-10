Brew PHP Switcher [![Build Status](https://travis-ci.org/philcook/brew-php-switcher.svg?branch=master)](https://travis-ci.org/philcook/brew-php-switcher)
=========

Brew PHP switcher is a simple script to switch your Apache and CLI configs quickly between major versions of PHP.

If you support multiple products/projects that are built using either brand new or old legacy PHP functionality and you find it a pain to change config files continually this will make the whole process just one command.

Version
----

2.1

Installation
--------------

```sh
brew install brew-php-switcher
```

Where **7.3** exists, please replace with syntax of **5.6**\*, **7.0**\*, **7.1**, **7.2**, or **7.3** depending on which version is required.

```sh
brew-php-switcher 7.3
```

> by default will switch apache config

**\*Note: PHP 5.6 and 7.0 have been removed from [homebrew/core](https://github.com/homebrew/homebrew-core) due to EOL reasons. Support should be considered deprecated and will be removed in a future version.**

Options
--------------

- `-s|-s=*` Skips apache & valet config switch for i.e

```sh
# skip apache only
brew-php-switcher 7.3 -s

# skip valet only
brew-php-switcher 7.3 -s=valet

# skip valet & apache
brew-php-switcher 7.3 -s=valet,apache
```
- `-c=*` switch a specific config for i.e

```sh
# switch valet config only
brew-php-switcher 7.3 -c=valet

# switch valet & apache config only
brew-php-switcher 7.3 -c=valet,apache

# switch apache config only
brew-php-switcher 7.3 -c=apache
```

Caveats
-------

For users of OSX only who have installed PHP via [Homebrew] and for PHP version 5.6, 7.0, 7.1, 7.2 and 7.3 only.

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
```

License
----

MIT

[Homebrew]:http://brew.sh/
[@p_cook]:http://twitter.com/p_cook

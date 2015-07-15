Brew PHP Switcher
=========

Brew PHP switcher is a simple script to switch your Apache and CLI configs quickly between major versions of PHP.

If you support multiple products/projects that are built using either brand new or old legacy PHP functionality and you find it a pain to change config files continually this will make the whole process last seconds not minutes.

Caveats
-------

For users of OSX only who have installed PHP via [Homebrew] and for PHP version 5.3, 5.4, 5.5, 5.6 and 7.0 only.

Your Apache config must be setup using the same paths as below. Replace homebrew's default /usr/local with the output from your `brew --prefix` if needed.
```sh
#LoadModule php5_module /usr/local/opt/php53/libexec/apache2/libphp5.so
#LoadModule php5_module /usr/local/opt/php54/libexec/apache2/libphp5.so
#LoadModule php5_module /usr/local/opt/php55/libexec/apache2/libphp5.so
#LoadModule php5_module /usr/local/opt/php56/libexec/apache2/libphp5.so
```

Version
----

1.5

Installation
--------------
```sh
brew install brew-php-switcher
```

Where **56** exists, please replace with syntax of **53**, **54**, **55**, **56** or **70** depending on which version is required.
```sh
brew-php-switcher 56
```

Options
--------------

-s Skips apache config switch

License
----

MIT

[Homebrew]: http://brew.sh/
[@p_cook]: http://twitter.com/p_cook

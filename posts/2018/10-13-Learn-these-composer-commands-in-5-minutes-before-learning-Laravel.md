==title==
Learn these composer commands in 5 minutes before learning Laravel

==author==
Sky Chin

==description==

==featureimage==
1_eT-lyHD7N8wm7Uq6PRnQ9A.jpeg

==tags==

==body==
My goal of writing this post is you can save this guide and read again later when you need a `composer` command for daily usage.

If this post doesn't help you, email me at [sky4just@gmail.com](mailto:sky4just@gmail.com). I'll fix it.

You will need different `composer` commands when you are performing different tasks. I category the commands in different usages as below. 

* When you are installing a new Laravel project
* When you are developing
* When you are deploying

Before you start to learn `composer` commands, you need to install `composer`. If you have done this already, skip to the next one.

# Installation

If you are a Mac user, I recommend you to install `composer` via Homebrew.

 If you are using Windows or Linux machine,  you can install the `composer` manually.

## Homebrew

[Homebrew](https://brew.sh/) is an open-source software package management on Mac. It helps you to manage your software.

If you don't have [Homebrew](https://brew.sh/) yet, you can install with this command.

~~~ powershell
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
~~~

For more information, you can refer to [installation guide](https://docs.brew.sh/Installation).

Once you have Homebrew installed, you can install `composer` with this command.

~~~ powershell
$ brew install composer

$ composer —version
Composer version 1.7.1 2018-08-07 09:39:23
~~~

## Manual install

If install via Homebrew is not working for you, you can install `composer` manually.

~~~ powershell
$ php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
$ php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
$ php composer-setup.php
$ php -r "unlink('composer-setup.php');”
~~~

For more detail information, you can refer to https://getcomposer.org/download/.

Alright, let's get started with `composer` commands.

# Composer

Composer is a dependency management tool for PHP. 

You declare your project dependencies (system requirements and required packages) in a single file named `composer.json`. Your peers can setup your project in their machines with just one single command.

What command would you need when you are starting a new project?

# When you are starting a new project

Firstly, you can use `composer create-project` command to clone project from existing package.

~~~ powershell
$ composer create-project <package name> <destination folder> <version>
~~~

<package name\> - e.g. laravel/laravel, doctrine/orm

<destination folder\> - e.g. blog, any folder name

<version\> - Optional, e.g. 2.2.*

For example, you want to install a fresh new Laravel project in a folder named app.

~~~ powershell
$ composer create-project laravel/laravel app
~~~

## Install the whole project

In most of the cases, you clone the project from Github or other source code version control system. 

You can install the defined dependencies with this command.

~~~ powershell
$ composer install
~~~

Next, what command would you need during the development?

# During the development

During the development, you install, update, and remove the installed packages.

You can install a new package with this command.

~~~ powershell
$ composer require <package name>:<version>
~~~

<package name\> - e.g. phpunit/phpunit

<version\> - Optional, e.g. 2.2.*

If you want to update all the packages to the latest version, you can run this command.

~~~ powershell
$ composer update
~~~

Alternatively, if you want to update one package only, run this command instead.

~~~ powershell
$ composer update <package name>
~~~

Otherwise, you can remove the installed package by running this command.

~~~ powershell
$ composer remove <package name>
~~~

Your application is ready to release now. What command would you need during the deployment?

# During the deployment

After you run any of commands above, you should have a file named `composer.lock` in your project folder.

`composer.lock` file contains all the information of installed packages and the exact dowloaded version.

I strongly recommend you commit this file to your version control system. Check [this](https://getcomposer.org/doc/01-basic-usage.md#commit-your-composer-lock-file-to-version-control) out. 

Once you've updated source code in your production machine, you can run this command to install all the dependencies.

~~~ powershell
$ composer install
~~~

This command will install the dependencies with the version listed in the composer.lock.

This can prevent a new release from any of the packages that will break your application to be deployed together.

# Last

Again, if this post doesn't help you, email me at [sky4just@gmail.com](mailto:sky4just@gmail.com). I'll fix it.

# dotfiles
bootstrap and single source of development environment configuration

## TODOs
* write a bootstrap scripts for powershell core installation on various platforms
* core script - cli entry
* oh-my-posh installation and $profile creation
* finish help
* add utility Test-Command
* add dotfiles to PATH during bootstrap?

# Repository structure

* _bootstrap/_ - scripts to bootstrap powershell on various environments

* _packages/_ - list of tools to install and how to configre them
    * _packages.txt_ - list of packages to install
    * _packageName/_ - configuration files for a packages with name _packageName_


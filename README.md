# dotfiles

This repository contains configuration files and setup scripts for configuring my development environment.

## Why powershell?

I've experimented with a few methods in the past to maintain a consistent setup, including shell/batch scripts
and Python. However, keeping two sets of scripts—one for Windows and one for Linux—proved challenging to stay up to date.
Bootstrapping Python of correct versions wasn't an straightforward task as well.

After trying various scripting languages like Python, shell, and batch scripts, I found a decent solution
in powershell. Using powershell, I can now easily set up configurations and install
tools on both Windows and Linux with a unified approach. This not only simplifies the whole process but also saves me
from the headache of managing different sets of scripts, making development more efficient and straightforward.

## TODOs
* set correct term value? (test setting if not from docker command)
* neovim: dotnet project select doesn't work on linux as expected

## Repository structure

* _bootstrap/_ - scripts to bootstrap powershell on various environments

* _packages/_ - list of tools to install and how to configure them
    * _packages.json_ - list of packages to install
    * _packageName/_ - configuration files for a packages with name _packageName_

* _docker/_ - script for testing\working with this setup in a container

* _test/_ - configuration tests, ensure that everything is installed correctly.

## Notes

Those are created by configuration scripts:
* _$HOME/.environment.json_ contains environment variables loaded by _$PROFILE_ on a new session
* _$HOME/.path.json_ contains path additions loaded by _$PROFILE_ on a new session


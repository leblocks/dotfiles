# dotfiles
bootstrap and single source of development environment configuration

## TODOs
* test using alpine, write correct alpine bootstrap
* set correct term value? (test setting if not from docker command)
* replace all curls with Invoke-WebRequest
* neovim: project select doesn't work on linux

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


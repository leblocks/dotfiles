# dotfiles
bootstrap and single source of development environment configuration

## TODOs
* test neovim install on windows and linux
* some day think of using scoop instead of choco
* sort env variables on write
* how to use test command in profile ? (considering links)
* how to log commands from scripts?
* write tests for util
* set default shell in tmux
* set correct term value
* write correct top10 command
* powershell editor service isnt unattended
* replace all curls with Invoke-WebRequest
* languages:
    * dap c#

## Repository structure

* _bootstrap/_ - scripts to bootstrap powershell on various environments

* _packages/_ - list of tools to install and how to configre them
    * _packages.json_ - list of packages to install
    * _packageName/_ - configuration files for a packages with name _packageName_

## Notes

Those are created by configuration scripts:
    * _$HOME/.environment.json_ contains environment variables loaded by _$PROFILE_ on a new session
    * _$HOME/.path.json_ contains path additions loaded by _$PROFILE_ on a new session


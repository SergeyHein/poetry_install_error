# poetry_install_error
official bug report available at https://github.com/python-poetry/poetry/issues/8488


- **Poetry version**: 1.6.1
- **Python version**:   3.8.10
- **OS version and name**: Windows 10


- [x] I am on the [latest](https://github.com/python-poetry/poetry/releases/latest) stable Poetry version, installed using a recommended method.
- [ ] similiar issues  : https://github.com/python-poetry/poetry/issues/7611 for a different ( outdated) poetry version (1.4.0) and superior python version ( 3.10.9). W/o debug output
- [x] I have consulted the [FAQ](https://python-poetry.org/docs/faq/) and [blog](https://python-poetry.org/blog/) for any relevant entries or release notes.
- [x] If an exception occurs when executing a command, I executed it again in debug mode (`-vvv` option) and have included the output below.

## Issue
See repository. Repository contains 3 different pyproject files. Poetry consistently failes on 2 of them under Windows yet, successeds on 3rd one provided as a reference. 1st and 2nd pyprojects have python dependecies versions frozen, 3rd one has pykeepass dependecy defined with ~

Re-running poertry install aftrer  failure on first two projects results in successfull creation of virstual environments.


An exhaustive script to reproduce behavior is available in reproduce_github_poetry_issue.ps1


## How to reproduce


Run reproduce_github_poetry_issue.ps1


## Project 1

[tool.poetry.dependencies]
python = ">=3.7,<3.9"
pykeepass = "4.0.1"

First install fails, second succeeds
## Project 2

[tool.poetry.dependencies]
python = ">=3.7,<3.9"
future="0.18.3"
construct="2.10.54"

First install fails, second succeeds

## Project 3

[tool.poetry.dependencies]
python = ">=3.7,<3.9"
pykeepass = "~4.0.1"

First install succeeds, second succeeds

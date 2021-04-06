# RedMica UI extension

This plugin adds useful UI improvements that are difficult to implement in Redmine itself.

## Features

* 1. Makes the Redmine select box searchable
* 2. Add Burndown chart on version detail

## Installation

Place the plugin source at Redmine plugins directory.

`git clone` or copy an unarchived plugin to plugins/redmica_ui_extension on your Redmine installation path.

```
$ git clone https://github.com/redmica/redmica_ui_extension.git /path/to/redmine/plugins/redmica_ui_extension
```
## Test

Chrome Driver required to run system tests. You can also use [selenium/standalone-chrome-debug](https://hub.docker.com/r/selenium/standalone-chrome-debug).
```
$ RAILS_ENV=test bundle exec rake test TEST=plugins/redmica_ui_extension/test
```

## LICENSE

GNU General Public License v2.0 (GPLv2)

## Maintainer

[Far End Technologies Corporation](https://www.farend.co.jp/)

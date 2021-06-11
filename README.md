# RedMica UI extension

This plugin adds useful UI improvements that are difficult to implement in Redmine itself.

## Features

### 1. Make the selection box searchable

Change the Redmine selection box to searchable.  
Replace Redmine selectbox with [Select2 4.0.12](https://select2.org/).

Demo:  
| Issues filter | New issue |
| ------------- | --------- |
| <kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_filters.gif" /></kbd> | <kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_new_issue.gif" /></kbd> |

### 2. Display Burndown Chart on version detail

### 3. You can disable each feature on the plugin settings page

Administration > Plugins > RedMica UI extension configure

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/plugin-settings.png" /></kbd>

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

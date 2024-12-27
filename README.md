# RedMica UI extension

This plugin adds useful UI improvements that are difficult to implement in Redmine itself.

## Features

### 1. Make the selection box searchable

Change the Redmine selection box to searchable.  
Replace Redmine selectbox with [Select2 4.0.12](https://select2.org/).  
This feature is based on the redmine_searchable_selectbox plugin(https://github.com/farend/redmine_searchable_selectbox).

Demo:  
| Issues filter | New issue |
| ------------- | --------- |
| <kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_filters.gif" /></kbd> | <kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_new_issue.gif" /></kbd> |

### 2. Display Burndown Chart on version detail

Display a burndown chart on the version detail page based on the information in the version issues.

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo-burndown-chart.png" /></kbd>

[Explanation of Burndown Chart - Data represented in the chart (./data-represented-in-the-chart.md)](/data-represented-in-the-chart.md)

### 3. You can disable each feature on the plugin settings page

Administration > Plugins > RedMica UI extension configure

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/plugin-settings.png" /></kbd>

### 4. Add a mermaid macro to use the mermaid syntax in the wiki

Add a mermaid macro to convert text written in [Mermaid syntax](https://mermaid-js.github.io/mermaid/#/./n00b-syntaxReference) into a diagram.  
You can use the mermaid macro by writing the following in issues, wiki pages, etc.

```
{{mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses
}}
```

**Warning: Mermaid macro does not support Internet Explorer.**

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_mermaid_macro.png" /></kbd>

### 5. Preview Attachment

Preview attachments without screen transitions.  
The following attachments can be previewed.  
Image, Audio, Video, PDF

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_preview_attachment.gif" /></kbd>

## Installation

Place the plugin source at Redmine plugins directory.

`git clone` or copy an unarchived plugin to plugins/redmica_ui_extension on your Redmine installation path.

```
$ git clone https://github.com/redmica/redmica_ui_extension.git /path/to/redmine/plugins/redmica_ui_extension
```
## Test

```
$ # for system test
$ npm install playwright
$ npx playwright install chromium
$ npx playwright install-deps
$ RAILS_ENV=test bundle exec rake test TEST=plugins/redmica_ui_extension/test
```

## Libraries included

- Select2 4.0.13
  - LICENSE: https://github.com/select2/select2/blob/master/LICENSE.md
- mermaid.js 11.4.1
  - LICENSE: https://github.com/mermaid-js/mermaid/blob/master/LICENSE
  - mermaid.js includes code from DOMPurify, which is licensed under the Mozilla Public License Version 2.0 (MPL 2.0). See `LICENSE.MPL-2.0` for details.
- BigPicture.js 2.6.1
  - LICENSE: https://github.com/henrygd/bigpicture/blob/master/LICENSE

## LICENSE

GNU General Public License v2.0 (GPLv2)

## Maintainer

[Far End Technologies Corporation](https://www.farend.co.jp/)

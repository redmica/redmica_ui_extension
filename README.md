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

> [!IMPORTANT]
> Redmine core now supports rendering Mermaid code blocks as diagrams ([Feature #44425](https://www.redmine.org/issues/44425)).
> As a result, this plugin keeps only the Mermaid macro, for backward compatibility.
>
> **To render Mermaid diagrams with this version of the plugin, use a version of Redmine/RedMica that includes [Feature #44425](https://www.redmine.org/issues/44425), and install Mermaid.js with the following command:**
>
> ```
> bin/rails redmine:mermaid:install RAILS_ENV=production
> ```
>
> If Mermaid.js is not installed, or if your Redmine/RedMica version does not include Feature #44425, the Mermaid macro is displayed as a plain code block.
>
> **To use Mermaid diagrams with a Redmine/RedMica version that does not include Feature #44425, use the [v0.6.0](https://github.com/redmica/redmica_ui_extension/tree/v0.6.0) tag of this plugin.**

**Warning: Mermaid macro does not support Internet Explorer.**

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_mermaid_macro.png" /></kbd>

### 5. Preview Attachment

Preview attachments without screen transitions.  
The following attachments can be previewed.  
Image, Audio, Video, PDF

<kbd><img src="https://github.com/redmica/redmica_ui_extension/blob/images/demo_preview_attachment.gif" /></kbd>

## Installation

> [!NOTE]
> The `master` branch is a development branch and may include incompatible changes. Use a version tag for installation and updates.

Download a release from [Releases](https://github.com/redmica/redmica_ui_extension/releases), extract it, and place it in `plugins/redmica_ui_extension` on your Redmine installation path.

If you use Git, you can clone the repository directly by specifying the version tag.

```bash
$ git clone -b <version-tag (e.g. v0.6.0)> https://github.com/redmica/redmica_ui_extension.git /path/to/redmine/plugins/redmica_ui_extension
```

## Test

Run the following commands from your Redmine root:

```
$ # for system test
$ bundle install
$ npm --prefix plugins/redmica_ui_extension install
$ npx --prefix plugins/redmica_ui_extension playwright install chromium
$ npx --prefix plugins/redmica_ui_extension playwright install-deps
$ RAILS_ENV=test bundle exec rake test TEST=plugins/redmica_ui_extension/test
```

## Libraries included

- Select2 4.0.13
  - LICENSE: https://github.com/select2/select2/blob/master/LICENSE.md
- BigPicture.js 2.6.1
  - LICENSE: https://github.com/henrygd/bigpicture/blob/master/LICENSE

## LICENSE

GNU General Public License v2.0 (GPLv2)

## Maintainer

[Far End Technologies Corporation](https://www.farend.co.jp/)

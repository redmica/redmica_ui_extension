# frozen_string_literal: true

# Common methods for redmica_ui_extension
require_relative 'lib/redmica_ui_extension/setting_patch'
Setting.include RedmicaUiExtension::SettingPatch

# searchable_selectbox
require_relative 'lib/searchable_selectbox/hook_listener'
require_relative 'lib/searchable_selectbox/my_helper_patch'
MyHelper.include SearchableSelectbox::MyHelperPatch

# burndown_chart
require_relative 'lib/burndown_chart/hook_listener'
require_relative 'lib/burndown_chart/versions_helper_patch'
VersionsHelper.include BurndownChart::VersionsHelperPatch

# mermaid macro
Redmine::WikiFormatting::Macros.register do
  desc "Convert the text in the block to a diagram using mermaid.js. Mermaid's Syntax: https://mermaid-js.github.io/mermaid/#/n00b-syntaxReference\n" +
        "Example:\n\n" +
        "{{mermaid\n" +
        "erDiagram\n" +
        "    CUSTOMER ||--o{ ORDER : places\n" +
        "    ORDER ||--|{ LINE-ITEM : contains\n" +
        "    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses\n" +
        "}}"

  # Rendering is delegated to Redmine core, which renders ```mermaid code
  # blocks as diagrams. This macro only emits the same markup as such a code
  # block, so that core's mermaid Stimulus controller picks it up.
  macro :mermaid do |_obj, _args, text|
    content_tag(:pre, content_tag(:code, text, data: {language: 'mermaid', controller: 'mermaid'}))
  end
end

# preview_attachment
require_relative 'lib/preview_attachment/application_helper_patch'
require_relative 'lib/preview_attachment/hook_listener'
ApplicationHelper.include PreviewAttachment::ApplicationHelperPatch

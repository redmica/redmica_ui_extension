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
require_relative 'lib/mermaid_macro/hook_listener'
Redmine::WikiFormatting::Macros.register do
  desc "Convert the text in the block to a diagram using mermaid.js. Mermaid's Syntax: https://mermaid-js.github.io/mermaid/#/n00b-syntaxReference\n" +
        "Example:\n\n" +
        "{{mermaid\n" +
        "erDiagram\n" +
        "    CUSTOMER ||--o{ ORDER : places\n" +
        "    ORDER ||--|{ LINE-ITEM : contains\n" +
        "    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses\n" +
        "}}"

  macro :mermaid do |_obj, _args, text|
    tmp_id = "mermaid-#{SecureRandom.hex(10)}"

    content_tag(:div, text, class: 'mermaid', id: tmp_id) +
      javascript_tag("renderMermaidMacro('##{tmp_id}');")
  end
end

# preview_attachment
require_relative 'lib/preview_attachment/application_helper_patch'
require_relative 'lib/preview_attachment/hook_listener'
ApplicationHelper.include PreviewAttachment::ApplicationHelperPatch

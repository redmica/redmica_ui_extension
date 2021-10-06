# frozen_string_literal: true

# searchable_selectbox
require_dependency 'searchable_selectbox/hook_listener'
require_dependency 'searchable_selectbox/my_helper_patch'
Rails.configuration.to_prepare do
  MyHelper.include SearchableSelectbox::MyHelperPatch
end

# burndown_chart
require_dependency 'burndown_chart/hook_listener'
require_dependency 'burndown_chart/versions_helper_patch'
Rails.configuration.to_prepare do
  VersionsHelper.include BurndownChart::VersionsHelperPatch
end

# Common methods for redmica_ui_extension
require_dependency 'redmica_ui_extension/setting_patch'
Rails.configuration.to_prepare do
  Setting.include RedmicaUiExtension::SettingPatch
end

# mermaid macro
require 'mermaid_macro/hook_listener'
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
      javascript_tag("initMermaidMacro('#{tmp_id}');")
  end
end

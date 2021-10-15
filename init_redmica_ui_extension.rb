# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  # Common methods for redmica_ui_extension
  require 'redmica_ui_extension/setting_patch'
  Setting.include RedmicaUiExtension::SettingPatch

  # searchable_selectbox
  require 'searchable_selectbox/hook_listener'
  require 'searchable_selectbox/my_helper_patch'
  MyHelper.include SearchableSelectbox::MyHelperPatch

  # burndown_chart
  require 'burndown_chart/hook_listener'
  require 'burndown_chart/versions_helper_patch'
  VersionsHelper.include BurndownChart::VersionsHelperPatch

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

      content_tag(:div, text, class: 'mermaid before-init-mermaid', id: tmp_id) +
        javascript_tag("initMermaidMacro('#{tmp_id}');")
    end
  end
end

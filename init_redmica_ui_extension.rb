# frozen_string_literal: true

require 'setting'
Rails.configuration.to_prepare do
  # Common methods for redmica_ui_extension
  require_dependency 'redmica_ui_extension/setting_patch'
  Setting.include RedmicaUiExtension::SettingPatch

  # searchable_selectbox
  require_dependency 'searchable_selectbox/hook_listener'
  require_dependency 'searchable_selectbox/my_helper_patch'
  MyHelper.include SearchableSelectbox::MyHelperPatch

  # burndown_chart
  require_dependency 'burndown_chart/hook_listener'
  require_dependency 'burndown_chart/versions_helper_patch'
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
      error_message = t(:error_can_not_execute_macro_html, name: 'mermaid', error: I18n.t('redmica_ui_extension.mermaid_macro.error_mermaid_macro_not_available_in_ie'))

      content_tag(:div, text, class: 'mermaid', id: tmp_id) +
        content_tag(:div, error_message, class: 'flash error mermaid-error-message') +
        javascript_tag("initMermaidMacro('#{tmp_id}');")
    end
  end
end

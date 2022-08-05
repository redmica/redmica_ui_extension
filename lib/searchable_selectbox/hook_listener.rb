# frozen_string_literal: true

module SearchableSelectbox
  class HookListener < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      return '' unless Setting.enabled_redmica_ui_extension_feature?('searchable_selectbox')

      stylesheet_link_tag('../searchable_selectbox/stylesheets/select2.min', plugin: 'redmica_ui_extension') +
      stylesheet_link_tag('../searchable_selectbox/stylesheets/searchable_selectbox', plugin: 'redmica_ui_extension') +
      javascript_include_tag('../searchable_selectbox/javascripts/select2.full.min.js', plugin: 'redmica_ui_extension') +
      javascript_include_tag('../searchable_selectbox/javascripts/searchable_selectbox.js', plugin: 'redmica_ui_extension') +
      javascript_tag('var enabledMultipleSelectboxSearchable = true;') if Setting.plugin_redmica_ui_extension['searchable_selectbox'].to_h['enabled_multiple_selectbox'] == '1'
    end
  end
end

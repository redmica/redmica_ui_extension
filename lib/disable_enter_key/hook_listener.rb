# frozen_string_literal: true

module DisableEnterKey
  class HookListener < Redmine::Hook::ViewListener
    def view_issues_form_details_bottom(context)
      return '' unless Setting.plugin_redmica_ui_extension['disable_enter_key'].to_h['enabled']

      javascript_include_tag('../disable_enter_key/javascripts/disable_enter_key.js', plugin: 'redmica_ui_extension')
    end
  end
end

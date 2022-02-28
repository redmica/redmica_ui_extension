# frozen_string_literal: true

module PreviewAttachment
  class HookListener < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      return '' unless Setting.enabled_redmica_ui_extension_feature?('preview_attachment')

      javascript_include_tag('../preview_attachment/javascripts/BigPicture.min.js', plugin: 'redmica_ui_extension') +
      javascript_include_tag('../preview_attachment/javascripts/preview_attachment.js', plugin: 'redmica_ui_extension')
    end
  end
end

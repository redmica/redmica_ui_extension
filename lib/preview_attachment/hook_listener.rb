# frozen_string_literal: true

module PreviewAttachment
  class HookListener < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      return '' unless Setting.enabled_redmica_ui_extension_feature?('preview_attachment')

      javascript_include_tag('preview_attachment/BigPicture.min.js', plugin: 'redmica_ui_extension') +
      javascript_include_tag('preview_attachment/preview_attachment.js', plugin: 'redmica_ui_extension') +
      stylesheet_link_tag('preview_attachment/preview_attachment.css', plugin: 'redmica_ui_extension')
    end
  end
end

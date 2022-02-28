# frozen_string_literal: true

require_dependency 'application_helper'

module PreviewAttachment
  module ApplicationHelperPatch
    def self.included(base)
      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods
      def link_to_attachment(attachment, options={})
        original_link = super(attachment, options.dup)
        return original_link unless Setting.enabled_redmica_ui_extension_feature?('preview_attachment')
        return original_link unless options[:class].to_s.include?('icon-download')

        bp_src = if attachment.is_image?
                   'imgSrc'
                 elsif attachment.is_video?
                   'vidSrc'
                 elsif attachment.is_audio?
                   'audio'
                 elsif attachment.is_pdf?
                   'iframeSrc'
                 else
                   nil
                 end
        return original_link unless bp_src

        filename = attachment.filename
        url = download_named_attachment_url(attachment, { filename: filename })
        link_to('', '#', :class => 'icon-only icon-zoom-in',
                :data => { :bp => filename, :bp_src => bp_src, :url => url },
                :onclick => 'previewAttachment(this)') + original_link
      end
    end
  end
end

# frozen_string_literal: true

require File.expand_path('../../../../../test/test_helper', __FILE__)

class ApplicationHelperPatchTest < Redmine::HelperTest
  include ApplicationHelper
  fixtures :attachments

  def setup
    @attachment = Attachment.find(3)
  end

  def assert_original_link_to_attachment(attachment)
    assert_equal(
      '<a href="/attachments/3">logo.gif</a>',
      link_to_attachment(attachment))
    assert_equal(
      '<a href="/attachments/3">Text</a>',
      link_to_attachment(attachment, :text => 'Text'))
    assert_equal(
      link_to("logo.gif", "/attachments/3", :class => "foo"),
      link_to_attachment(attachment, :class => 'foo'))
    assert_equal(
      '<a href="/attachments/download/3/logo.gif">logo.gif</a>',
      link_to_attachment(attachment, :download => true))
    assert_equal(
      '<a href="http://test.host/attachments/3">logo.gif</a>',
      link_to_attachment(attachment, :only_path => false))
  end

  def test_link_to_attachment_should_return_original_link_when_setting_is_disabled
    with_settings :plugin_redmica_ui_extension => {'preview_attachment' => {'enabled' => 0}} do
      assert_original_link_to_attachment(@attachment)
      assert_equal(
        '<a class="icon-download" href="/attachments/download/3/logo.gif">logo.gif</a>',
        link_to_attachment(@attachment, {:download => true, :class => 'icon-download'}))
    end
  end

  def test_link_to_attachment_should_return_original_link_when_class_option_does_not_include_icon_download
    with_settings :plugin_redmica_ui_extension => {'preview_attachment' => {'enabled' => 1}} do
      assert_original_link_to_attachment(@attachment)
      assert_equal(
        '<a class="" href="/attachments/download/3/logo.gif">logo.gif</a>',
        link_to_attachment(@attachment, {:download => true, :class => ''}))
    end
  end

  def test_link_to_attachment_should_return_preview_link_when_setting_is_enabled_and_class_option_includes_icon_download
    with_settings :plugin_redmica_ui_extension => {'preview_attachment' => {'enabled' => 1}} do
      original_link = '<a class="icon-download" href="/attachments/download/3/logo.gif">logo.gif</a>'.html_safe
      preview_link = link_to('', '#', :class => 'icon-only icon-zoom-in',
                             :data => { :bp => 'logo.gif',
                                        :bp_src => 'imgSrc',
                                        :url => 'http://test.host/attachments/download/3/logo.gif' },
                             :onclick => 'previewAttachment(this)').html_safe
      assert_equal(
        preview_link + original_link,
        link_to_attachment(@attachment, {:download => true, :class => 'icon-download'}))
    end
  end
end

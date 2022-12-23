# frozen_string_literal: true

require_relative '../../../../test/test_helper'

class SettingPatchTest < Redmine::HelperTest
  fixtures :users

  def test_enabled_redmica_ui_extension_feature?
    # setting is blank => true
    with_settings :plugin_redmica_ui_extension => {} do
      assert Setting.enabled_redmica_ui_extension_feature?('burndown_chart')
    end
    # enabled: '1' => true
    with_settings :plugin_redmica_ui_extension => {'burndown_chart' => {'enabled' => '1'}} do
      assert Setting.enabled_redmica_ui_extension_feature?('burndown_chart')
    end
    # enabled: '0' => false
    with_settings :plugin_redmica_ui_extension => {'burndown_chart' => {'enabled' => '0'}} do
      assert_not Setting.enabled_redmica_ui_extension_feature?('burndown_chart')
    end
  end
end

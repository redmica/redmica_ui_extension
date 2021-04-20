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

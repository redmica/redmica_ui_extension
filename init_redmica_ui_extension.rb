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
end

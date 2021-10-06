# frozen_string_literal: true

require File.expand_path('../init_redmica_ui_extension', __FILE__)

Redmine::Plugin.register :redmica_ui_extension do
  requires_redmine version_or_higher: '4.1'
  name 'RedMica UI extension'
  author 'Far End Technologies Corporation'
  description 'This plugin adds useful UI improvements.'
  version '0.0.1'
  url 'https://github.com/redmica/redmica_ui_extension'
  author_url 'https://github.com/redmica'

  settings default: {'searchable_selectbox' => {'enabled' => 1}, 'burndown_chart' => {'enabled' => 1}}, partial: 'settings/redmica_ui_extension'
end

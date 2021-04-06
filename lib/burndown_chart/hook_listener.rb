# frozen_string_literal: true

module BurndownChart
  class HookListener < Redmine::Hook::ViewListener
    render_on :view_versions_show_bottom, partial: 'ui_extension/burndown_chart'
  end
end

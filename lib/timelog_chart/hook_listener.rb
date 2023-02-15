# frozen_string_literal: true

module TimelogChart
  class HookListener < Redmine::Hook::ViewListener
    render_on :view_layouts_base_content, partial: 'ui_extension/timelog_chart'
  end
end

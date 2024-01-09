# frozen_string_literal: true

require File.expand_path('../../../../../test/application_system_test_case', __FILE__)

class TimelogChartTest < ApplicationSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :time_entries

  def test_render_chart_on_timelog_report
    with_settings :plugin_redmica_ui_extension => {'timelog_chart' => {'enabled' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/projects/ecookbook/time_entries/report?columns=month&criteria[]=user'

      within '#content' do
        assert page.find('#timelog_chart')
      end
    end
  end

  def test_does_not_render_chart_if_report_empty
    with_settings :plugin_redmica_ui_extension => {'timelog_chart' => {'enabled' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/projects/ecookbook/time_entries/report?columns=month'

      assert page.has_no_css?('#timelog_chart')
    end
  end

  def test_does_not_render_chart_if_enabled_setting_value_is_zero
    with_settings :plugin_redmica_ui_extension => {'timelog_chart' => {'enabled' => 0}} do
      log_user('jsmith', 'jsmith')
      visit '/projects/ecookbook/time_entries/report?columns=month&criteria[]=user'

      assert page.has_no_css?('#timelog_chart')
    end
  end
end

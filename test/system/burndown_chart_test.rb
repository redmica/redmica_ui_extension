# frozen_string_literal: true

require_relative '../playwright_system_test_case'

class BurndownChartTest < PlaywrightSystemTestCase
  fixtures :projects, :enabled_modules, :versions,
           :users, :members, :roles, :member_roles,
           :trackers, :projects_trackers, :enumerations, :issue_statuses, :issues

  def test_render_chart_on_version_detail
    with_settings :plugin_redmica_ui_extension => {'burndown_chart' => {'enabled' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/versions/2'

      assert page.has_css?('#version-detail-chart')
      within '#version-detail-chart' do
        assert page.find('#burndown-chart')
      end
    end
  end

  def test_does_not_render_chart_if_issues_empty
    with_settings :plugin_redmica_ui_extension => {'burndown_chart' => {'enabled' => 1}} do
      version = Version.find(2)
      version.fixed_issues.delete_all

      log_user('jsmith', 'jsmith')
      visit '/versions/2'

      assert page.has_no_css?('#version-detail-chart')
      assert page.all(:css, '#version-detail-chart').empty?
    end
  end

  def test_does_not_render_chart_if_enabled_setting_value_is_zero
    with_settings :plugin_redmica_ui_extension => {'burndown_chart' => {'enabled' => 0}} do
      log_user('jsmith', 'jsmith')
      visit '/versions/2'

      assert page.has_no_css?('#version-detail-chart')
      assert page.all(:css, '#version-detail-chart').empty?
    end
  end
end

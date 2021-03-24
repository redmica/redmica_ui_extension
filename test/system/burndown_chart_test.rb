# frozen_string_literal: true

require File.expand_path('../../../../../test/application_system_test_case', __FILE__)

class BurndownChartTest < ApplicationSystemTestCase
  fixtures :projects, :enabled_modules, :versions,
           :users, :members, :roles, :member_roles,
           :trackers, :projects_trackers, :enumerations, :issue_statuses, :issues

  def test_render_chart_on_version_detail
    log_user('jsmith', 'jsmith')
    visit '/versions/2'

    assert page.has_css?('#version-detail-chart')
    within '#version-detail-chart' do
      assert page.find('#burndown-chart')
    end
  end

  def test_does_not_render_chart_if_issues_empty
    version = Version.find(2)
    version.fixed_issues.delete_all

    log_user('jsmith', 'jsmith')
    visit '/versions/2'

    assert page.has_no_css?('#version-detail-chart')
    assert page.all(:css, '#version-detail-chart').empty?
  end
end

# frozen_string_literal: true

require File.expand_path('../../../../../test/test_helper', __FILE__)

class TimelogHelperPatchTest < Redmine::HelperTest
  include TimelogHelper
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :time_entries

  def test_timelog_chart_datas
    project = Project.generate!
    user_1, user_2  = User.find(1), User.find(2)
    travel_to 1.month.ago do
      TimeEntry.create!(:project => project, :author => user_1, :user => user_1, :hours => 1.25, :spent_on => Date.today)
      TimeEntry.create!(:project => project, :author => user_2, :user => user_2, :hours => 2.5, :spent_on => Date.today)
    end
    TimeEntry.create!(:project => project, :author => user_1, :user => user_1, :hours => 5.0, :spent_on => Date.today)
    TimeEntry.create!(:project => project, :author => user_2, :user => user_2, :hours => 2.25, :spent_on => Date.today)

    query = TimeEntryQuery.generate!(:project => project)
    report = Redmine::Helpers::TimeReport.new(project, ['user'], 'month', query.results_scope)
    chart_data = timelog_chart_datas(report)

    assert chart_data['month']
    assert_equal report.periods, chart_data['month'][:labels]
    assert_equal 'bar', chart_data['month'][:type]
    assert_equal [{:data => [3.75, 7.25]}], chart_data['month'][:datasets]

    assert chart_data['user']
    assert_equal [user_1, user_2].map(&:name), chart_data['user'][:labels]
    assert_equal 'horizontalBar', chart_data['user'][:type]
    assert_equal [{:label => report.periods[0], :data => [1.25, 2.5]},
                  {:label => report.periods[1], :data => [5.0, 2.25]}], chart_data['user'][:datasets]
  end

  def test_timelog_chart_datas_should_return_empty_data_when_report_is_nil
    assert_empty timelog_chart_datas(nil)
  end

  def test_timelog_chart_datas_should_return_empty_data_when_report_periods_is_nil
    project = Project.generate!
    query = TimeEntryQuery.generate!(:project => project)
    report = Redmine::Helpers::TimeReport.new(project, [], 'month', query.results_scope)
    assert_nil report.periods

    assert_empty timelog_chart_datas(report)
  end
end

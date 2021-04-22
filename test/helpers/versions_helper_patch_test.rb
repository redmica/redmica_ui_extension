# frozen_string_literal: true

require File.expand_path('../../../../../test/test_helper', __FILE__)

class VersionsHelperPatchTest < Redmine::HelperTest
  include VersionsHelper
  fixtures :projects, :enabled_modules, :versions, :issues,
           :users, :members, :roles, :member_roles,
           :trackers, :projects_trackers, :enumerations, :issue_statuses

  def test_issues_burndown_chart_data_should_return_chart_data
    # 3 days ago
    travel_to 3.days.before
    version = Version.create!(:project => Project.find(1), :name => 'test', :due_date => 4.days.after.to_date)
    2.times.each do |i|
      Issue.create!(:project => version.project, :fixed_version => version,
                    :priority => IssuePriority.find_by_name('Normal'), :tracker => version.project.trackers.first,
                    :subject => "test issue #{i}", :author => User.current)
    end
    travel_back

    # 2 days ago
    travel_to 2.days.before
    issue = version.fixed_issues.last
    issue.status = IssueStatus.where(:is_closed => true).first
    issue.save
    travel_back

    # yesterday
    travel_to 1.day.before
    issue = Issue.create!(:project => version.project, :fixed_version => version,
                          :priority => IssuePriority.find_by_name('Normal'), :tracker => version.project.trackers.first,
                          :subject => "test issue 2", :author => User.current)
    travel_back

    # today
    issue.reload
    issue.status = IssueStatus.where(:is_closed => true).first
    issue.save

    # generate chart data
    chart_data = issues_burndown_chart_data(version)
    labels = chart_data[:labels]
    datasets = chart_data[:datasets]

    # assert labels for xaxis
    assert_equal [3.days.before.to_date.to_s,
                  2.days.before.to_date.to_s,
                  1.day.before.to_date.to_s,
                  User.current.today.to_s,
                  1.day.after.to_date.to_s], labels

    # assert label in datasets
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_open_line'), datasets.first[:label]
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_total_substract_closed_line'), datasets.second[:label]
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_ideal_line'), datasets.last[:label]

    # assert data for 'open' line
    assert_equal [{:t => 3.days.before.to_date.to_s, :y => 2},
                  {:t => 2.days.before.to_date.to_s, :y => 1},
                  {:t => 1.day.before.to_date.to_s, :y => 2},
                  {:t => User.current.today.to_s, :y => 1}],
                 datasets.first[:data]
    # assert data for 'total - closed' line
    assert_equal [{:t => 3.days.before.to_date.to_s, :y => 3},
                  {:t => 2.days.before.to_date.to_s, :y => 2},
                  {:t => 1.day.before.to_date.to_s, :y => 2},
                  {:t => User.current.today.to_s, :y => 1}],
                 datasets.second[:data]
    # assert data for 'ideal' line
    assert_equal [{:t => 3.days.before.to_date.to_s, :y => 3},
                  {:t => 1.day.after.to_date.to_s, :y => 0}],
                 datasets.last[:data]
  end

  def test_issues_burndown_chart_data_should_return_chart_data_end_with_latest_issue_closed_on
    # 3 days ago (create version and issue)
    travel_to 3.days.before
    version = Version.create!(:project => Project.find(1), :name => 'test', :due_date => nil)
    issue = Issue.create!(:project => version.project, :fixed_version => version,
                          :priority => IssuePriority.find_by_name('Normal'), :tracker => version.project.trackers.first,
                          :subject => "test issue", :author => User.current)
    travel_back

    # today (close issue and close version)
    issue.reload
    issue.status = IssueStatus.where(:is_closed => true).first
    issue.save
    version.status = 'closed'
    version.save

    # generate chart data
    chart_data = issues_burndown_chart_data(version)
    labels = chart_data[:labels]
    datasets = chart_data[:datasets]

    # assert labels for xaxis (end with latest issue closed_on)
    assert_equal [3.days.before.to_date.to_s,
                  2.days.before.to_date.to_s,
                  1.day.before.to_date.to_s,
                  issue.closed_on.to_date.to_s], labels
  end

  def test_issues_burndown_chart_data_should_return_chart_data_end_with_today
    # 5 days ago (create version and issue)
    travel_to 5.days.before
    version = Version.create!(:project => Project.find(1), :name => 'test', :due_date => nil)
    issue = Issue.create!(:project => version.project, :fixed_version => version,
                          :priority => IssuePriority.find_by_name('Normal'), :tracker => version.project.trackers.first,
                          :subject => "test issue", :author => User.current)
    travel_back

    # generate chart data
    chart_data = issues_burndown_chart_data(version)
    labels = chart_data[:labels]
    datasets = chart_data[:datasets]

    assert_equal 5.days.before.to_date.to_s, labels.first
    assert_equal User.current.today.to_s, labels.last
  end

  def test_issues_burndown_chart_data_should_return_chart_data_without_ideal
    version = Version.find(2)
    version.update(:due_date => nil)
    version.stubs(:start_date).returns(3.days.before.to_date)

    chart_data = issues_burndown_chart_data(version)
    labels = chart_data[:labels]
    datasets = chart_data[:datasets]

    # assert labels for xaxis
    assert_equal [3.days.before.to_date.to_s,
                  2.days.before.to_date.to_s,
                  1.day.before.to_date.to_s,
                  User.current.today.to_s], labels

    # assert label in datasets
    assert_equal 2, datasets.size
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_open_line'), datasets.first[:label]
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_total_substract_closed_line'), datasets.last[:label]
  end

  def test_issues_burndown_chart_data_should_return_chart_data_without_ideal_when_due_date_earlier_than_start_date
    version = Version.find(2)
    version.update(:due_date => 2.days.before.to_date)
    version.stubs(:start_date).returns(1.days.before.to_date)

    issue = version.fixed_issues.last
    issue.status = IssueStatus.where(:is_closed => true).first
    issue.save

    chart_data = issues_burndown_chart_data(version)
    datasets = chart_data[:datasets]

    # assert label in datasets
    assert_equal 2, datasets.size
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_open_line'), datasets.first[:label]
    assert_equal I18n.t('redmica_ui_extension.burndown_chart.label_total_substract_closed_line'), datasets.last[:label]
  end

  def test_issues_burndown_chart_data_should_return_nil_when_visible_fixed_issues_empty
    version = Version.create!(:project => Project.find(1), :name => 'test')
    version.visible_fixed_issues.destroy_all
    assert_empty version.visible_fixed_issues
    assert_nil issues_burndown_chart_data(version)
  end

  def test_issues_burndown_chart_data_should_return_nil_when_order_of_start_date_and_due_date_is_reversed
    version = Version.create!(:project => Project.find(1), :name => 'test', :due_date => 10.days.after)
    issue = Issue.create!(:project => version.project, :fixed_version => version,
                          :priority => IssuePriority.find_by_name('Normal'),
                          :tracker => version.project.trackers.first, :subject => 'text', :author => User.current,
                          :start_date => 11.days.after)
    assert_nil issues_burndown_chart_data(version)
  end
end

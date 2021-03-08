# frozen_string_literal: true

require File.expand_path('../../../../../test/test_helper', __FILE__)

class VersionsHelperPatchTest < Redmine::HelperTest
  include VersionsHelper
  fixtures :projects, :enabled_modules,
           :users, :members, :roles, :member_roles,
           :trackers, :projects_trackers, :enumerations, :issue_statuses

  def test_issues_burndown_chart_data_should_return_chart_data
    User.any_instance.stubs(:today).returns(3.days.after.to_date)
    version = Version.create!(:project => Project.find(1), :name => 'test', :due_date => 5.days.after.to_date)
    issue = Issue.create!(:project => version.project, :fixed_version => version,
                          :priority => IssuePriority.find_by_name('Normal'),
                          :tracker => version.project.trackers.first, :subject => 'text', :author => User.current,
                          :start_date => 1.days.after.to_date)
    chart_data = {
      :labels => (1.days.after.to_date..5.days.after.to_date).map { |d| d.to_s },
      :datasets => [
        {:label => I18n.t('redmica_ui_extension.burndown_chart.label_ideal_line'), :data => [{:t => 1.days.after.to_date.to_s, :y => 1}, {:t => 5.days.after.to_date.to_s, :y => 0}],
         :backgroundColor => "rgba(0, 0, 0, 0)",
         :lineTension => 0, :borderWidth => 2, :borderDash => [5, 2], :spanGaps => true},
        {:label => I18n.t('redmica_ui_extension.burndown_chart.label_total_substract_closed_line'), :data => [{:t => 1.days.after.to_date.to_s, :y => 1}, {:t => 2.days.after.to_date.to_s, :y => 1}, {:t => 3.days.after.to_date.to_s, :y => 1}],
         :borderColor => "rgba(186, 224, 186, 1)", :backgroundColor => "rgba(0, 0, 0, 0)", :pointBackgroundColor => "rgba(186, 224, 186, 1)",
         :lineTension => 0, :borderWidth => 2, :borderDash => [5, 2]},
        {:label => I18n.t('redmica_ui_extension.burndown_chart.label_open_line'), :data => [{:t => 1.days.after.to_date.to_s, :y => 1}, {:t => 2.days.after.to_date.to_s, :y => 1}, {:t => 3.days.after.to_date.to_s, :y => 1}],
         :borderColor => "rgba(186, 224, 186, 1)", :backgroundColor => "rgba(186, 224, 186, 0.1)", :pointBackgroundColor => "rgba(186, 224, 186, 1)",
         :lineTension => 0, :borderWidth => 2}
      ]
    }
    assert_equal chart_data, issues_burndown_chart_data(version)
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

# frozen_string_literal: true

require_dependency 'versions_helper'

module BurndownChart
  module VersionsHelperPatch
    def self.included(base)
      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods
      def issues_burndown_chart_data(version)
        return nil if version.visible_fixed_issues.empty?
        chart_start_date = (version.start_date || version.created_on).to_date
        chart_end_date = [version.due_date, version.visible_fixed_issues.maximum(:due_date), version.visible_fixed_issues.maximum(:updated_on)].compact.max.to_date
        line_end_date = [User.current.today, chart_end_date].min
        step_size = ((chart_start_date..chart_end_date).count.to_f / 90).ceil
        issues = version.visible_fixed_issues
        return nil if step_size < 1
        total_closed = chart_start_date.step(line_end_date, step_size).collect{|d| {:t => d.to_s, :y => issues.where("#{Issue.table_name}.closed_on IS NULL OR #{Issue.table_name}.closed_on>=?", d.end_of_day).count}}
        open = chart_start_date.step(line_end_date, step_size).collect{|d| {:t => d.to_s, :y => issues.where("#{Issue.table_name}.created_on<=?", d.end_of_day).count - issues.open(false).where("#{Issue.table_name}.closed_on<=?", d.end_of_day).count}}
        chart_data = {
          :labels => chart_start_date.step(chart_end_date, step_size).collect{|d|d.to_s},
          :datasets => [
            {:label => I18n.t('redmica_ui_extension.burndown_chart.label_ideal_line'), :data => [{:t => chart_start_date.to_s, :y => total_closed.first[:y]}, {:t => chart_end_date.to_s, :y => 0}],
             :backgroundColor => "rgba(0, 0, 0, 0)",
             :lineTension => 0, :borderWidth => 2, :borderDash => [5, 2], :spanGaps => true},
            {:label => I18n.t('redmica_ui_extension.burndown_chart.label_total_substract_closed_line'), :data => total_closed,
             :borderColor => "rgba(186, 224, 186, 1)", :backgroundColor => "rgba(0, 0, 0, 0)", :pointBackgroundColor => "rgba(186, 224, 186, 1)",
             :lineTension => 0, :borderWidth => 2, :borderDash => [5, 2]},
            {:label => I18n.t('redmica_ui_extension.burndown_chart.label_open_line'), :data => open,
             :borderColor => "rgba(186, 224, 186, 1)", :backgroundColor => "rgba(186, 224, 186, 0.1)", :pointBackgroundColor => "rgba(186, 224, 186, 1)",
             :lineTension => 0, :borderWidth => 2}
          ]
        }
        return chart_data
      end
    end
  end
end

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
        if version.open_issues_count == 0
          chart_end_date = [version.due_date,
                            version.visible_fixed_issues.open(false).maximum(:closed_on).to_date].compact.max
        elsif version.open_issues_count > 0
          if version.visible_fixed_issues.open(false).empty?
            chart_end_date = [(version.due_date || User.current.today),
                              version.visible_fixed_issues.maximum(:created_on).to_date].max
          else
            chart_end_date = [(version.due_date|| User.current.today),
                              version.visible_fixed_issues.maximum(:created_on).to_date,
                              version.visible_fixed_issues.open(false).maximum(:closed_on).to_date].max
          end
        end
        line_end_date = [User.current.today, chart_end_date].min
        step_size = ((chart_start_date..chart_end_date).count.to_f / 90).ceil
        issues = version.visible_fixed_issues
        return nil if step_size < 1

        ideal = [{ :t => chart_start_date.to_s, :y => issues.count }, { :t => version.due_date.to_s, :y => 0 }]
        plot_dates = (chart_start_date.step(line_end_date, step_size).to_a + [line_end_date]).uniq
        total_closed = plot_dates.collect{ |d| { :t => d.to_s, :y => issues.count - issues.open(false).where("#{Issue.table_name}.closed_on<=?", d.end_of_day).count } }
        open = plot_dates.collect do |d|
          { :t => d.to_s, :y => issues.where("#{Issue.table_name}.created_on<=?", d.end_of_day).count - issues.open(false).where("#{Issue.table_name}.closed_on<=?", d.end_of_day).count }
        end

        labels = chart_start_date.step(chart_end_date, step_size).collect{ |d| d.to_s }
        datasets = []
        datasets << {:label => I18n.t('redmica_ui_extension.burndown_chart.label_open_line'), :data => open,
                     :borderColor => "rgba(90, 195, 154, 1)", :backgroundColor => "rgba(90, 195, 54, 0.1)", :pointBackgroundColor => "rgba(90, 195, 54, 1)",
                     :lineTension => 0, :borderWidth => 2, pointRadius: 2, fill: true}
        datasets << {:label => I18n.t('redmica_ui_extension.burndown_chart.label_total_substract_closed_line'), :data => total_closed,
                     :borderColor => "rgba(186, 224, 186, 1)", :backgroundColor => "rgba(0, 0, 0, 0)", :pointBackgroundColor => "rgba(186, 224, 186, 1)",
                     :lineTension => 0, :borderWidth => 2, :borderDash => [5, 2], pointRadius: 2}
        if version.due_date && version.due_date > chart_start_date
          datasets << {:label => I18n.t('redmica_ui_extension.burndown_chart.label_ideal_line'), :data => ideal,
                       :backgroundColor => "rgba(0, 0, 0, 0)",
                       :lineTension => 0, :borderWidth => 2, :borderDash => [5, 2], :spanGaps => true}
        end

        return {:labels => labels, :datasets => datasets}
      end
    end
  end
end

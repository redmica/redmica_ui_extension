# frozen_string_literal: true

require_dependency 'timelog_helper'

module TimelogChart
  module TimelogHelperPatch
    def self.included(base)
      base.send(:prepend, InstanceMethods)
    end

    module InstanceMethods
      def timelog_chart_datas(report, period_name='month')
        return {} if report.nil?
        return {} if report.periods.nil?
        chart_datas = {}
        chart_datas[period_name] = { :labels => [], :type => 'bar', :datasets => [{:data => []}] }
        report.periods.each do |period|
          chart_datas[period_name][:labels] << period
          chart_datas[period_name][:datasets].first[:data] << sum_hours(select_hours(report.hours, report.columns, period.to_s))
        end
        report.criteria.each_with_index do |criteria, level|
          chart_datas[criteria] = { :labels => [], :type => 'horizontalBar', :datasets => [{:data => []}]}
          report.hours.collect {|h| h[criteria]}.uniq.each do |value|
            hours_for_value = select_hours(report.hours, criteria, value)
            next if hours_for_value.empty?
            chart_datas[criteria][:labels] << truncate(format_criteria_value(report.available_criteria[report.criteria[level]], value, false).to_s)
            chart_datas[criteria][:datasets].first[:data] << report.periods.collect {|period| sum_hours(select_hours(hours_for_value, report.columns, period.to_s)) }.sum
          end
        end
        chart_datas
      end
    end
  end
end

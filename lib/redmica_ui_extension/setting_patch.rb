# frozen_string_literal: true

module RedmicaUiExtension
  module SettingPatch
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def enabled_redmica_ui_extension_feature?(feature_name)
        is_enabled = Setting.plugin_redmica_ui_extension[feature_name].to_h['enabled']
        is_enabled.nil? ? true : is_enabled.to_i == 1
      end
    end
  end
end

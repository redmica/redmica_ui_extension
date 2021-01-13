# frozen_string_literal: true

# searchable_selectbox
require_dependency 'searchable_selectbox/hook_listener'
require_dependency 'searchable_selectbox/my_helper_patch'
Rails.configuration.to_prepare do
  MyHelper.__send__(:include, SearchableSelectbox::MyHelperPatch)
end

# frozen_string_literal: true

require File.expand_path('../../../../../test/application_system_test_case', __FILE__)

class DisableEnterKeyTest < ApplicationSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details

  def test_press_enter_key_should_submit_in_issue_subject_field
    with_settings :plugin_redmica_ui_extension => {'disable_enter_key' => {'enabled' => nil}} do
      log_user('jsmith', 'jsmith')
      visit '/issues/1'

      click_on 'Edit', match: :first
      find('#issue_subject').send_keys('2')
      find('#issue_subject').native.send_keys(:enter)

    assert page.find('h3', text: 'Cannot print recipes2').present?
    end
  end

  def test_press_enter_key_should_not_submit_in_issue_subject_field
    with_settings :plugin_redmica_ui_extension => {'disable_enter_key' => {'enabled' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/issues/1'

      click_on 'Edit', match: :first
      find('#issue_subject').send_keys('2')
      find('#issue_subject').native.send_keys(:enter)

      # The value does not change because it has not been submitted
      assert page.find('h3', text: 'Cannot print recipes').present?
    end
  end

  def test_press_enter_and_control_key_should_submit_in_issue_subject_field
    with_settings :plugin_redmica_ui_extension => {'disable_enter_key' => {'enabled' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/issues/1'

      click_on 'Edit', match: :first
      find('#issue_subject').send_keys('2')
      find('#issue_subject').native.send_keys(:control, :enter)

      assert page.find('h3', text: 'Cannot print recipes2').present?
    end
  end
end

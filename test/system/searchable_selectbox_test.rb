# frozen_string_literal: true

require File.expand_path('../../../../../test/application_system_test_case', __FILE__)

class SearchableSelectboxTest < ApplicationSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details

  def test_select2_does_not_apply_if_searchable_selectbox_enabled_is_nil
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => nil}} do
      log_user('jsmith', 'jsmith')
      visit '/my/page'

      assert page.has_css?('#block-select')
      assert page.has_no_css?('span[aria-labelledby="select2-block-select-container"]')
    end
  end

  def test_add_block_in_my_page
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 1}} do
      preferences = User.find(2).pref
      preferences.my_page_layout = {'top' => ['issuesassignedtome']}
      preferences.save!

      log_user('jsmith', 'jsmith')
      visit '/my/page'
      # Click select2 selectbox
      find('span[aria-labelledby="select2-block-select-container"]').click
      within '.select2-dropdown' do
        # Input text
        find('.select2-search__field').send_keys('w')

        # Make sure you have the options you expect
        loop until has_content?('Watched issues', wait: 10)
        loop until has_content?('Latest news', wait: 10)

        # Choose first one
        find('.select2-search__field').send_keys(:enter)
      end

      # Confirm that the number of blocks is increased by selecting the selectbox
      assert page.has_css?('#block-issueswatched')
      assert_equal({'top' => ['issueswatched', 'issuesassignedtome']}, preferences.reload.my_page_layout)
    end
  end

  def test_remove_block_in_my_page
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 1}} do
      preferences = User.find(2).pref
      preferences.my_page_layout = {'top' => ['issuesassignedtome']}
      preferences.save!

      log_user('jsmith', 'jsmith')
      visit '/my/page'
      within '#block-issuesassignedtome' do
        click_on 'Delete'
      end
      assert page.has_no_css?('#block-issuesassignedtome')
      assert_equal({'top' => []}, preferences.reload.my_page_layout)

      # Select2 is applied to select#block-select by MyHelperPatch
      assert page.has_css?('select#block-select.select2-hidden-accessible')
      assert page.has_css?('span[aria-labelledby="select2-block-select-container"]')
    end
  end

  def test_add_issues_filter
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/issues'

      within('table.issues.list') do
        assert_equal 12, page.all(:css, 'table.issues.list tr').size
      end

      # Click Add filter selectbox
      find('span[aria-labelledby="select2-add_filter_select-container"]').click
      within '.select2-dropdown' do
        # Input text
        find('.select2-search__field').send_keys('Assignee')

        # Make sure you have the options you expect
        loop until has_content?('Assignee', wait: 10)
        loop until has_content?("Assignee's group", wait: 10)
        loop until has_content?("Assignee's role", wait: 10)

        # Choose first one
        find('.select2-search__field').send_keys(:enter)
      end

      # Click Add filter selectbox
      find('span[aria-labelledby="select2-values_assigned_to_id_1-container"]').click
      within '.select2-dropdown' do
        # Input text
        find('.select2-search__field').send_keys('j')

        # Make sure you have the options you expect
        loop until has_content?('John Smith', wait: 10)

        # Choose first one
        find('.select2-search__field').send_keys(:enter)
      end
      click_on 'Apply'

      within('table.issues.list') do
        assert_equal 2, page.all(:css, 'table.issues.list tr').size
      end
    end
  end
end

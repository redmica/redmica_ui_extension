# frozen_string_literal: true

require File.expand_path('../../../../../test/application_system_test_case', __FILE__)

class SearchableSelectboxTest < ApplicationSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details

  def test_select2_does_not_apply_if_searchable_selectbox_enabled_setting_value_is_zero
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 0}} do
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

  def test_searchable_selectbox_should_replace_multiple_selectbox_to_select2_if_enabled_multiple_selectbox_is_1
    CustomField.find(1).update(multiple: true)

    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 1, 'enabled_multiple_selectbox' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/issues/1/edit'

      assert page.has_css?('select#issue_custom_field_values_1.select2-hidden-accessible[multiple]')
      assert page.has_css?('select#issue_custom_field_values_1 + .select2-container span.select2-selection--multiple')
    end
  end

  def test_add_issues_filter_if_enabled_multiple_selectbox_is_1
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 1, 'enabled_multiple_selectbox' => 1}} do
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
        # Choose first one
        find('.select2-search__field').send_keys(:enter)
      end

      # Switch singleselect to multiselect
      find('tr#tr_assigned_to_id .toggle-multiselect').click
      assert page.has_css?('tr#tr_assigned_to_id select#values_assigned_to_id_1.select2-hidden-accessible[multiple]')
      assert page.has_css?('tr#tr_assigned_to_id select#values_assigned_to_id_1 + .select2-container span.select2-selection--multiple')

      find('select#values_assigned_to_id_1 + span.select2-container').click
      find('select#values_assigned_to_id_1 + span.select2-container .select2-search__field').send_keys('Dave')
      find('.select2-search__field').send_keys(:enter)
      find('select#values_assigned_to_id_1 + span.select2-container .select2-search__field').send_keys('john')
      find('.select2-search__field').send_keys(:enter)
      click_on 'Apply'

      within('table.issues.list') do
        assert_equal 4, page.all(:css, 'table.issues.list tr').size
      end
    end
  end

  def test_searchable_selectbox_should_not_apply_select2_to_columns_selectbox_in_query
    with_settings :plugin_redmica_ui_extension => {'searchable_selectbox' => {'enabled' => 1, 'enabled_multiple_selectbox' => 1}} do
      log_user('jsmith', 'jsmith')
      visit '/issues'

      find('fieldset#options legend').click

      assert page.has_css?('select#available_c[multiple]')
      assert page.has_css?('select#selected_c[multiple]')
    end
  end
end

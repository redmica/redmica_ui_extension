# frozen_string_literal: true

require File.expand_path('../../../../../test/application_system_test_case', __FILE__)

class MermaidMacroTest < ApplicationSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details

  def test_mermaid_macro_in_issue_page
    log_user('jsmith', 'jsmith')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}"

    assert_selector 'div#journal-1-notes' do
      assert_selector '.mermaid svg'
      assert_selector '.mermaid.before_init_mermaid', count: 0
    end
  end

  def test_mermaid_macro_when_preview_notes
    log_user('jsmith', 'jsmith')
    issue = Issue.find(1)
    visit "/issues/#{issue.id}"

    # input mermaid macro text to textarea and switch preview tab
    first('.icon-edit').click
    fill_in 'issue_notes', with: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}"
    find('a.tab-preview').click

    assert_selector 'div.wiki.wiki-preview' do
      assert_selector '.mermaid svg'
      assert_selector '.mermaid.before_init_mermaid', count: 0
    end
  end

  def test_mermaid_macro_when_edit_notes_by_ajax
    log_user('admin', 'admin')
    issue = Issue.find(1)
    visit "/issues/#{issue.id}"

    within 'div#note-1' do
      page.find('.icon-edit').click
      fill_in 'journal_1_notes', with: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}"
      page.find('input[name="commit"]').click
    end

    assert_selector 'div#journal-1-notes' do
      assert_selector '.mermaid svg'
      assert_selector '.mermaid.before_init_mermaid', count: 0
    end
  end
end

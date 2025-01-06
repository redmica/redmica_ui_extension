# frozen_string_literal: true

require_relative '../playwright_system_test_case'

class MermaidMacroTest < PlaywrightSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details

  def test_mermaid_macro_in_issue_page
    log_user('jsmith', 'jsmith')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}"

    assert_selector "div#journal-#{issue.journals.first.id}-notes" do
      assert_selector '.mermaid[data-processed="true"] svg'
      assert_selector '.mermaid:not([data-processed])', count: 0

      # Test that the diagram is not in an incorrectly drawn state.
      assert_selector '.mermaid svg path.error-icon', count: 0
      assert_not_equal '0', first('.mermaid svg .node foreignObject')['width']
    end
  end

  def test_mermaid_macro_error
    log_user('jsmith', 'jsmith')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\nError\n}}")
    visit "/issues/#{issue.id}"

    assert_selector "div#journal-#{issue.journals.first.id}-notes" do
      assert_selector '.mermaid[data-processed="true"] svg path.error-icon'
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
    sleep 1

    assert_selector 'div.wiki.wiki-preview' do
      assert_selector '.mermaid[data-processed="true"] svg'
      assert_selector '.mermaid:not([data-processed])', count: 0

      # Test that the diagram is not in an incorrectly drawn state.
      assert_selector '.mermaid svg path.error-icon', count: 0
      assert_not_equal '0', first('.mermaid svg .node foreignObject')['width']
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

    assert_selector "div#journal-#{issue.journals.first.id}-notes" do
      assert_selector '.mermaid[data-processed="true"] svg'
      assert_selector '.mermaid:not([data-processed])', count: 0

      # Test that the diagram is not in an incorrectly drawn state.
      assert_selector '.mermaid svg path.error-icon', count: 0
      assert_not_equal '0', first('.mermaid svg .node foreignObject')['width']
    end
  end

  def test_mermaid_macro_in_notes_tab
    log_user('admin', 'admin')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}?tab=notes"

    assert_selector "div#journal-#{issue.journals.first.id}-notes" do
      assert_selector '.mermaid[data-processed="true"] svg'
      assert_selector '.mermaid:not([data-processed])', count: 0

      # Test that the diagram is not in an incorrectly drawn state.
      assert_selector '.mermaid svg path.error-icon', count: 0
      assert_not_equal '0', first('.mermaid svg .node foreignObject')['width']
    end
  end

  def test_mermaid_macro_has_non_zero_size
    log_user('admin', 'admin')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}?tab=notes"

    width, height = page.driver.evaluate_script <<-JS
      (function() {
        var svg = document.querySelector('div.mermaid svg');
        if (!svg) return [0, 0];
        var rect = svg.getBoundingClientRect();
        return [rect.width, rect.height];
      })();
    JS
    assert width > 0, "SVG width should be greater than 0, but it's #{width}."
    assert height > 0, "SVG height should be greater than 0, but it's #{height}."

    svg = find("div.mermaid svg")
    assert svg.visible?, "SVG should be visible but it's not."
  end

  def test_mermaid_macro_when_resize_window
    log_user('admin', 'admin')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\nsequenceDiagram\nA->>B: next\nB->>C: next\nC->>D: next\nD->>E: next\nE->>F: next;\n}}")
    visit "/issues/#{issue.id}?tab=notes"

    Capybara.current_session.current_window.resize_to(2000, 1080) # non responsive mode
    assert_selector('a.mobile-toggle-button', count: 0)
    width_in_wide_screen, height_in_wide_screen = page.driver.evaluate_script <<-JS
      (function() {
        var svg = document.querySelector('div.mermaid svg');
        if (!svg) return [0, 0];
        var rect = svg.getBoundingClientRect();
        return [rect.width, rect.height];
      })();
    JS

    Capybara.current_session.current_window.resize_to(899, 1080) # responsive mode
    assert_selector('a.mobile-toggle-button', count: 1)
    width_in_responsive_mode_screen, height_in_responsive_mode_screen = page.driver.evaluate_script <<-JS
      (function() {
        var svg = document.querySelector('div.mermaid svg');
        if (!svg) return [0, 0];
        var rect = svg.getBoundingClientRect();
        return [rect.width, rect.height];
      })();
    JS

    # Check height and width of the svg is smaller than before when the screen width is changed.
    assert height_in_wide_screen > height_in_responsive_mode_screen
    assert height_in_responsive_mode_screen > 0
    assert width_in_wide_screen > width_in_responsive_mode_screen
    assert width_in_responsive_mode_screen > 0
  end
end

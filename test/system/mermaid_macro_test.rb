# frozen_string_literal: true

require_relative '../playwright_system_test_case'

# The mermaid macro only emits the markup of a ```mermaid code block, and
# Redmine core renders it with Mermaid.js. These tests require Mermaid.js to be
# installed with `bin/rails redmine:mermaid:install RAILS_ENV=test`, and are
# skipped otherwise.
class MermaidMacroTest < PlaywrightSystemTestCase
  fixtures :projects, :users, :email_addresses, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :enabled_modules, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers,
           :watchers, :journals, :journal_details

  def setup
    # Redmine::Mermaid is not defined in Redmine/RedMica versions without
    # Mermaid rendering in core.
    skip 'Mermaid.js is not installed' unless defined?(Redmine::Mermaid) && Redmine::Mermaid.available?
  end

  def test_mermaid_macro_in_issue_page
    log_user('jsmith', 'jsmith')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}"

    within "div#journal-#{issue.journals.first.id}-notes" do
      assert_rendered_diagram
    end
  end

  def test_mermaid_macro_error
    log_user('jsmith', 'jsmith')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\nthis is not a valid mermaid diagram(((\n}}")
    visit "/issues/#{issue.id}"

    within "div#journal-#{issue.journals.first.id}-notes" do
      assert_selector '.flash.error', text: 'Failed to render mermaid diagram'
      assert_selector 'pre code[data-controller="mermaid"]', text: 'this is not a valid mermaid diagram'
      assert_no_selector 'div.mermaid svg'
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

    within 'div.wiki.wiki-preview' do
      assert_rendered_diagram
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

    within "div#journal-#{issue.journals.first.id}-notes" do
      assert_rendered_diagram
    end
  end

  def test_mermaid_macro_in_notes_tab
    log_user('admin', 'admin')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}?tab=notes"

    within "div#journal-#{issue.journals.first.id}-notes" do
      assert_rendered_diagram
    end
  end

  def test_mermaid_macro_has_non_zero_size
    log_user('admin', 'admin')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\ngraph TD;\nA-->B;\nA-->C;\nB-->D;\nC-->D;\n}}")
    visit "/issues/#{issue.id}?tab=notes"

    svg = find('div.mermaid svg')
    width, height = svg_size
    assert width > 0, "SVG width should be greater than 0, but it's #{width}."
    assert height > 0, "SVG height should be greater than 0, but it's #{height}."
    assert svg.visible?, "SVG should be visible but it's not."
  end

  def test_mermaid_macro_when_resize_window
    log_user('admin', 'admin')
    issue = Issue.find(1)
    issue.journals.first.update(notes: "{{mermaid\nsequenceDiagram\nA->>B: next\nB->>C: next\nC->>D: next\nD->>E: next\nE->>F: next;\n}}")
    visit "/issues/#{issue.id}?tab=notes"
    assert_selector 'div.mermaid svg'

    Capybara.current_session.current_window.resize_to(2000, 1080) # non responsive mode
    assert_selector('a.mobile-toggle-button', count: 0)
    width_in_wide_screen, height_in_wide_screen = svg_size

    Capybara.current_session.current_window.resize_to(899, 1080) # responsive mode
    assert_selector('a.mobile-toggle-button', count: 1)
    width_in_responsive_mode_screen, height_in_responsive_mode_screen = svg_size

    # Check height and width of the svg is smaller than before when the screen width is changed.
    assert height_in_wide_screen > height_in_responsive_mode_screen
    assert height_in_responsive_mode_screen > 0
    assert width_in_wide_screen > width_in_responsive_mode_screen
    assert width_in_responsive_mode_screen > 0
  end

  private

  def assert_rendered_diagram
    # The source code block is kept but hidden once the diagram is rendered.
    assert_selector 'pre code[data-controller="mermaid"]', visible: :hidden
    assert_selector 'div.mermaid[data-processed="true"] svg'
    assert_no_selector '.flash.error'

    # Test that the diagram is not in an incorrectly drawn state.
    assert_no_selector 'div.mermaid svg .error-icon'
    assert_not_equal '0', first('div.mermaid svg .node foreignObject')['width']
  end

  def svg_size
    page.driver.evaluate_script <<-JS
      (function() {
        var svg = document.querySelector('div.mermaid svg');
        if (!svg) return [0, 0];
        var rect = svg.getBoundingClientRect();
        return [rect.width, rect.height];
      })();
    JS
  end
end

# frozen_string_literal: true

require_relative '../../../../test/test_helper'

class MermaidMacroHelperTest < Redmine::HelperTest
  include ApplicationHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include ERB::Util
  extend ActionView::Helpers::SanitizeHelper::ClassMethods

  fixtures :projects, :users

  def test_macro_mermaid_renders_markup_for_core_mermaid_controller
    with_settings text_formatting: 'textile' do
      result = textilizable("{{mermaid\ngraph TD;\nA-->B;\n}}")
      assert_include '<code data-language="mermaid" data-controller="mermaid">', result
      assert_include 'graph TD;', result
    end
  end

  def test_macro_mermaid_with_common_mark
    with_settings text_formatting: 'common_mark' do
      result = textilizable("{{mermaid\ngraph TD;\nA-->B;\n}}")
      assert_include '<code data-language="mermaid" data-controller="mermaid">', result
    end
  end

  def test_macro_mermaid_escapes_html
    with_settings text_formatting: 'textile' do
      result = textilizable("{{mermaid\ngraph TD;\nA[\"<img src=x onerror=alert(1)>\"]-->B;\n}}")
      assert_not_include '<img src=x', result
    end
  end
end

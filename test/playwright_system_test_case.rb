# frozen_string_literal: true

require_relative '../../../test/test_helper'

class PlaywrightSystemTestCase < ActionDispatch::SystemTestCase
  Capybara.register_driver(:playwright) do |app|
    driver_opts = {
      browser_type: :chromium,
      headless: true
    }
    Capybara::Playwright::Driver.new(app, **driver_opts)
  end

  Capybara.default_driver = :playwright
  Capybara.javascript_driver = :playwright

  driven_by(:playwright)

  # Should not depend on locale since Redmine displays login page
  # using default browser locale which depend on system locale for "real" browsers drivers
  def log_user(login, password)
    visit '/my/page'
    assert_equal '/login', current_path
    within('#login-form form') do
      fill_in 'username', :with => login
      fill_in 'password', :with => password
      find('input[name=login]').click
    end
    assert_equal '/my/page', current_path
  end
end
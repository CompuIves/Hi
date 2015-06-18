module FeatureHelpers
  def visit(path, options = {})
    # Ye gods man, please don't silently fail when server gives an HTTP 500
    result = page.visit(path)
    if result == "fail"
      raise result
    end
    result
  end

  # Capybara waits for HTTP requests, HTTP redirects and AJAX requests
  # Capybara does not wait for javascript redirects like `window.location = 'some_location'`
  # This method forces Capybara to wait for these redirects as well
  def wait_for_js_redirect(wait_max: 30, to: nil, &trigger_js_redirect)
    old_path = current_path
    trigger_js_redirect.call
    wait_for(wait_max: wait_max, to: to) { current_path != old_path }
  end

  # Make capybara wait for page load
  def wait_for_page_load(wait_max: 30, &trigger_page_load)
    test_page_loaded_flag = "a#{SecureRandom.hex(11)}"
    allow(Rails).to receive(:test_page_loaded_flag).and_return test_page_loaded_flag
    trigger_page_load.call
    wait_for(wait_max: wait_max) do
      page.evaluate_script('$("#test_page_loaded_flag").attr("class")') == test_page_loaded_flag
    end
  end

  # Make Capybara wait for some condition to evaluate to true
  # - Provide a block evaluating a condition returning true when Capybara should proceed
  # - Optionally override the default max wait time
  def wait_for(wait_max: 30, to: nil, &block)
    waited = 0
    while !block.call && waited < wait_max
      sleep 1
      waited += 1
    end
    unless waited < wait_max
      message = "Timeout of #{wait_max} seconds exceeded"
      message += " while waiting for redirect to #{to}" if to
      message += '!'
      fail message
    end
  end

  # Only use this method when click_on does not work
  # This can happen on VM/docker containers
  # see this issue: https://github.com/teampoltergeist/poltergeist/issues/520
  def click_element(css_selector, options = {})
    if Capybara.current_driver == :poltergeist
      find(css_selector, options).trigger('click')
    else
      find(css_selector, options).click
    end
  end

  def set_locale(locale)
    I18n.default_locale = I18n.locale = locale
  end

  def browser_cookies
    Hash[page.driver.cookies.map {|key, value| [key, value.instance_variable_get(:@attributes)]}]
  end

  def inspect_browser_cookies
    puts YAML.dump browser_cookies
  end

  def inspect_response_headers
    puts YAML.dump Capybara.current_session.response_headers
  end
end

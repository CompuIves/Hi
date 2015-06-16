class ScreenshotHelper
  attr_accessor :page
  attr_accessor :driver
  attr_accessor :settings

  def initialize(page, options = {})
    @page = page
    @driver = page.driver
    @settings = options
  end

  def screenshot(name, options = {})
    resize_page(options) do
      save_screenshot(name)
    end
    remove_highlights
  end

  def highlight(selector, options = {})
    page.first selector
    script = <<-END
  (function() {

    $(function() {
      var selector = #{selector.inspect};
      var height = #{options[:height] || 0};
      var width = #{options[:width] || 0};
      var top = #{options[:top] || 0};
      var left = #{options[:left] || 0};
      var elements, height_diff, width_diff, highlight;
      if (selector !== "") {
        elements = $(selector);
        $("body").prepend('<div id="highlight_for_test"></div>');
        highlight = $("#highlight_for_test");
        highlight.css("position", "absolute");
        highlight.css("z-index", "9999");
        highlight.css("border", "4px solid red");
        highlight.css("-webkit-border-radius", "9999px");
        highlight.css("-webkit-box-shadow", "0 0 10em 1em rgba(0,0,0,0.5)");
        element_height = elements[0].offsetHeight;
        height = height || element_height + 30;
        height_diff = height - element_height;
        element_width = elements[0].offsetWidth;
        width = width || element_width + 30;
        width_diff = width - element_width;
        top = top || elements.offset().top - (0.5 * height_diff) - 4;
        left = left || elements.offset().left - (0.5 * width_diff) - 4;
        highlight.width(width);
        highlight.height(height);
        highlight.offset({
          top: top,
          left: left
        });
      }
    });

  }).call(this);
  END

    driver.execute_script(script)
  end

  def set_size(width, height)
    return if ENV.key?('BROWSER_STACK') || ENV.key?('VM')
    if driver.respond_to? :resize
      driver.resize(width, height)
    else
      driver.browser.manage.window.resize_to(width, height)
    end
  end

  private

  def save_screenshot(name)
    file_name = File.join(screenshot_dir, "#{name}.png")
    if driver.respond_to? :render
      driver.render file_name
    else
      driver.browser.save_screenshot file_name
    end
  end

  def screenshot_dir
    dir = settings[:dir]
    if driver.browser.respond_to? :capabilities
      capabilities = driver.browser.capabilities
      if capabilities.browser_name == 'internet explorer'
        dir = File.join(dir, "ie#{capabilities.version}")
      end
    end
    FileUtils.mkdir_p dir unless File.directory? dir
    dir
  end

  def remove_highlights
    driver.execute_script("$('#highlight_for_test').remove()")
  end

  def resize_page(options = {})
    options[:width] ||= settings[:screen_width]
    options[:height] ||= settings[:screen_height]
    set_size(options[:width], options[:height])
    yield
    set_size(settings[:screen_width], settings[:screen_height])
  end
end

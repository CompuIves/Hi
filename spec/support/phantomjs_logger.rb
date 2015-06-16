class PhantomjsLogger < IO
  def write(content_to_log)
    $stdout.write filter_content content_to_log
  end

  private

  FILTER = []

  def filter_content(content)
    content unless FILTER.match content
  end
end

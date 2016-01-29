class BaseCodeRunner
  def accepts_filename?(filename)
    false
  end

  def accepts_zipfile?(path)
    false
  end

  def run(path)
    raise NotImplementedError, '#run needs to be overriden. '
  end
end
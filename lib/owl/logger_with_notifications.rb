class LoggerWithNotifications < Logger
  def initialize(*args, notifier:)
    super(*args)
    @notifier = notifier
  end

  def warn(progname = nil, &block)
    notify(progname, title: 'Warning', &block)
    super(progname, &block)
  end

  def error(progname = nil, &block)
    notify(progname, title: 'Error', &block)
    super(progname, &block)
  end

  def fatal(progname = nil, &block)
    notify(progname, title: 'Warning', &block)
    super(progname, &block)
  end

  def info(progname = nil, silent = true, &block)
    notify(progname, title: 'Info', &block) unless silent
    super(progname, &block)
  end

  private

  def notify(message, title: '')
    message =
      if block_given?
        yield
      elsif message.kind_of?(Exception)
        "*#{message.inspect}* ```#{message.backtrace.join("\n").gsub("`", "'")}```"
      else
        message.to_s
      end

    @notifier.ping(
      "*#{title}*",
      attachments: [{ text: message, mrkdwn_in: %w[text] }]
    )
  end
end

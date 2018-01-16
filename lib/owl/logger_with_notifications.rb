class LoggerWithNotifications < Logger
  def initialize(*args, notifier:)
    super(*args)
    @notifier = notifier
  end

  def warn(progname = nil, &block)
    notify(progname, title: 'Warning')
    super(progname, &block)
  end

  def error(progname = nil, &block)
    notify(progname, title: 'Error')
    super(progname, &block)
  end

  def fatal(progname = nil, &block)
    notify(progname, title: 'Warning')
    super(progname, &block)
  end

  private
    def notify(message, title: '')
      @notifier.ping("*#{title}*", attachments: [{ text: message.kind_of?(Exception) ? "*#{message.inspect}* ```#{message.backtrace.join("\n").gsub("`", "'")}```" : message.to_s, mrkdwn_in: %w(text) }])
    end
end

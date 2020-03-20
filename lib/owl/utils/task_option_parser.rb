class TaskOptionParser

  def initialize
    @options = {}

    @parser = OptionParser.new do |opts|
      opts.on('--dump=ARG', String) { |dump| @options['dump'] = dump }
      opts.on('--host=ARG', String) { |host| @options['host'] = host }
      opts.on('--local_db=ARG', String) { |database| @options['local_db'] = database }
      opts.on('--out=ARG', String) { |out| @options['out'] = out }
      opts.on('--remote_db=ARG', String) { |database| @options['remote_db'] = database }
      opts.on('--user=ARG', String) { |user| @options['user'] = user }
    end
  end

  def parse!
    args = @parser.order!(ARGV) {}
    @parser.parse!(args)

    defaults.merge(@options).transform_keys(&:to_sym)
  end

  private

    def defaults
      @defaults ||= config
    end

    def config
      config_file_path = Rails.root.join('config', 'dump.yml')
      config_file = ERB.new(File.read(config_file_path).to_s).result
      YAML.load(config_file)['default']
    end
end

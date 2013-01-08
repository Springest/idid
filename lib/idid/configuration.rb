module Idid
  class Configuration

    SMTP_DEFAULTS = {
      :address => 'smtp.gmail.com',
      :port => '587',
      :user_name => ENV['GMAIL_SMTP_USER'],
      :password => ENV['GMAIL_SMTP_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }

    EXIM_DEFAULTS = {
      :location => '/usr/bin/exim'
    }

    # Public: Name of the project to post to (e.g. project.idonethis.com)
    attr_accessor :project
    # Public: Email address String to use when sending mail.
    attr_accessor :email
    # Public: Email delivery configuration
    attr_accessor :delivery

    # Public: configuration to use with iDoneThis
    #
    # options - Hash with configuration options
    #           project    - Name of the project to post to (e.g.
    #                        project.idonethis.com)
    #           email      - Email address to use when sending mail.
    #           delivery   - Email delivery configuration Hash:
    #                        method  - Symbol (:smtp|:sendmail|:exim)
    #                        options - Configuration Hash for the
    #                        delivery method (see:
    #                        https://github.com/mikel/mail).
    #
    # Returns a new Idid::Configuration instance
    def initialize(options = {})
      options = read_config.merge options if read_config
      raise ArgumentError.new "Provide a project to use." unless options['project']
      raise ArgumentError.new "Provide an email address." unless options['email']
      raise ArgumentError.new "Provide a delivery method." unless options['delivery']

      @project = options['project']
      @email = options['email']
      @delivery = options['delivery']
    end

    def write
      config = {
        'project' => project,
        'email'   => email,
        'delivery' => delivery
      }

      File.open(self.class.config_file, 'w') do |f|
        f.write config.to_yaml
      end
    end

    def read_config
      @config ||= self.class.read_config
    end

    def self.read_config
      if File.exist? config_file
        config = YAML.load_file config_file
      end
    end

    def self.config_file
      File.join ENV['HOME'], '.idid.yml'
    end
  end
end

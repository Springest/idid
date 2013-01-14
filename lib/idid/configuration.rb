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

    # Public: Account type for this user
    attr_accessor :account_type
    # Public: Name of the team to post to
    attr_accessor :team
    # Public: Email address String to use when sending mail.
    attr_accessor :email
    # Public: Email delivery configuration
    attr_accessor :delivery

    # Public: configuration to use with iDoneThis
    #
    # options - Hash with configuration options
    #           email      - Email address to use when sending mail.
    #           delivery   - Email delivery configuration Hash:
    #                        method  - Symbol (:smtp|:sendmail|:exim)
    #                        options - Configuration Hash for the
    #                        delivery method (see:
    #                        https://github.com/mikel/mail).
    #           team       - Name of the team to post to (optional)
    #
    # Returns a new Idid::Configuration instance
    def initialize(options = {})
      options = read_config.merge options if read_config
      raise ArgumentError.new "Provide an account type." unless options['account_type']
      raise ArgumentError.new "Provide a team to use." if options['account_type'] == 'team' && options['team'].nil?
      raise ArgumentError.new "Provide an email address." unless options['email']
      raise ArgumentError.new "Provide a delivery method." unless options['delivery']

      @account_type = options['account_type']
      @team = options['team']
      @email = options['email']
      @delivery = options['delivery']
    end

    # Public: The email address of IDoneThis to send your updates to. This
    # depends on whether you have a personal or a team account.
    #
    # Returns the String with the right email address to use
    def idonethis_email
      personal_account? ? "today@idonethis.com" : "#{team}@team.idonethis.com"
    end

    # Public: Determines if current configuration belongs to a personal account
    #
    # Returns boolean
    def personal_account?
      account_type == 'personal'
    end

    # Public: Determines if current configuration belongs to a team account
    #
    # Returns boolean
    def team_account?
      account_type == 'team'
    end

    def write
      config = {
        'account_type' => account_type,
        'team' => team,
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

module Idid
  module Interactive
    class << self

      def create_config
        status "Please take a moment to create a new configuration.."
        config = user_config
        config['delivery'] ||= {}

        user_config_from_key 'account_type', "What kind of iDoneThis account do you have? (personal|team)", 'personal', config

        if config["account_type"] == 'team'
          user_config_from_key 'team', "What is the name of your iDoneThis team? (check the URL <team>.idonethis.com).", nil, config
        else
          config["team"] = nil
        end

        user_config_from_key 'email', "What is your associated email address for this iDoneThis account?", nil, config
        user_config_from_key 'method', "How do you want to send emails to iDoneThis? (smtp|sendmail|exim)", 'smtp', config['delivery']

        case config['delivery']['method']
        when 'smtp'
          delivery_options = Idid::Configuration::SMTP_DEFAULTS
        when 'exim'
          delivery_options = Idid::Configuration::EXIM_DEFAULTS
        else
          delivery_options = {}
        end

        config['delivery']['options'] ||= {}
        delivery_options.each do |key, default|
          user_config_from_key key, key.to_s, default, config['delivery']['options']
        end

        Idid::Configuration.new config
      end

      def user_config_from_key(key, text, default, config = nil)
        config ||= user_config

        config[key.to_s] ||=
          begin
            ask "#{text} [#{default}]:"
            input_or_default default
          end
      end

      def user_config
        Idid::Configuration.read_config || {}
      end

      def status(text)
        puts "\e[36m#{text}\e[0m"
      end

      def fail(text = 'Failed!')
        puts "\e[31m#{text}\e[0m"
      end

      def ask(question)
        puts "\e[32m#{question}\e[0m"
      end

      def input_or_default(default)
        val = STDIN.gets.chomp
        val.size == 0 ? default : val
      end
    end
  end
end

require 'mail'
require 'yaml'

Dir[File.expand_path("../idid/**/*.rb", __FILE__)].each {|f| require f}

module Idid
  class << self
    attr_accessor :configuration

    def send *words
      setup_delivery
      Mail.deliver do
        from    Idid.configuration.email
        to      "#{Idid.configuration.project}@team.idonethis.com"
        subject "I did this"
        body    words.flatten.join(" ")
      end
    end

    def setup_delivery
      method = Idid.configuration.delivery['method']
      options = Idid.configuration.delivery['options'] || {}

      options.keys.each do |key|
        options[(key.to_sym rescue key) || key] = options.delete(key)
      end

      case method
      when 'smtp'
        setup_smtp options
      when 'sendmail'
        setup_sendmail
      when 'exim'
        setup_exim options
      end
    end

    def setup_smtp options = {}
      Mail.defaults do
        delivery_method :smtp, Idid::Configuration::SMTP_DEFAULTS.merge(options)
      end
    end

    def setup_sendmail
      Mail.defaults do
        delivery_method :sendmail
      end
    end

    def setup_exim options={}
      Mail.defaults do
        delivery_method :exim, Idid::Configuration::EXIM_DEFAULTS.merge(options)
      end
    end
  end
end

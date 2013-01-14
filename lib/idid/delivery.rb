module Idid
  class Delivery

    attr_accessor :config

    # Public: Initialize a new Delivery. It will automatically set the correct
    # delivery options
    #
    # config - The Hash options to use when sending the email to iDoneThis
    #
    # Returns a new instance of Delivery
    def initialize(config)
      @config = config
      setup_delivery
    end

    # Public: Send email to iDoneThis for logging
    #
    # message - The String with the actual activity you want to log
    #
    # Returns Mail::Message object
    def email(message)
      config = @config # Needed because @config is not in the block scope below

      Mail.deliver do
        from    config.email
        to      config.idonethis_email
        subject "I did this"
        body    message
      end
    end

    private
    # Private: Set the right delivery options for Mail to use, based on the
    # settings in the configuration file. Defaults to sending mail via SMTP, if
    # no or unknown delivery method is specified.
    #
    # Returns nothing
    def setup_delivery
      method = @config.delivery['method'] || :smtp
      options = @config.delivery['options'] || {}

      options.keys.each do |key|
        options[(key.to_sym rescue key) || key] = options.delete(key)
      end

      options = Idid::Configuration::SMTP_DEFAULTS.merge options if method == :smtp
      options = Idid::Configuration::EXIM_DEFAULTS.merge options if method == :exim

      mail_defaults_for method, options
    end

    def mail_defaults_for(method, options = {})
      Mail.defaults do
        delivery_method method, options
      end
    end

  end
end
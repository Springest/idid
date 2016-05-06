require 'json'

module Idid
  class Logfile

    attr_accessor :logs

    def initialize
      @logs = []
      read_log
    end

    # Public: A Hash representation of the logfile
    #
    # Returns a Hash of all log files and tasks
    def to_hash
      log_hash = {}
      logs.each do |log|
        log_hash.merge! log.to_hash
      end
      log_hash
    end

    # Public: A JSON representation of the logfile
    #
    # Returns a String in JSON encoding
    def to_json
      to_hash.to_json
    end

    # Public: Writes the log file to disk in JSON format
    #
    # Returns boolean
    def save
      File.open(logfile, 'w') { |f| f.write to_json }
    end

    # Public: finds any given List by name.
    #
    # name - String name of the list to search for
    #
    # Returns the first instance of List that it finds.
    def find(date)
      logs.any?{|log| log.formatted_date == date.strftime('%Y-%m-%d') }
    end


    private
    # Private: Location of the log file (~/.idid)
    #
    # Returns the String with the location of the log file
    def json_file
      File.join ENV['HOME'], '.idid'
    end

    # Private: Reads the log file into memory.
    #
    # Returns nothing
    def read_log
      logfile = JSON.load open(json_file) rescue {}

      logfile.each do |log_date, tasks|
        @logs << log = Idid::Log.new(Date.parse(log_date))

        tasks.each do |task|
          log.add_task Idid::Task.new(task)
        end
      end
    end

  end
end
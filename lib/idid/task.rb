require 'date'
require 'json'

module Idid
  class Task
    attr_accessor :contents, :log, :logdate

    # Public: Initialize a new Task
    #
    # contents - The String containing the task that has been done
    #
    # Returns an instance of Task
    def initialize(contents, logdate = nil)
      @contents = contents
      @logdate = logdate || Date.today
    end

    # Public: Save a task to the log file. If there were tasks for this day
    # already, it's appended to that days log. Otherwise, a new day is added to
    # the log.
    #
    # Returns boolean
    def save
      logdate = @logdate.strftime '%Y-%m-%d'

      if log.has_key? logdate
        log[logdate].push @contents
      else
        log[logdate] = [@contents]
      end

      Task.write_log log
    end

    # Public: Transform Task into a String
    #
    # Returns the String with the contents of the task
    def to_s
      @contents
    end

    def log
      @log ||= Task.read_log
    end

    # Public: Lists all activities for a given date.
    #
    # date - The String date you wish to show the entries of, in the format
    #        YYYY-MM-DD
    #
    # Returns the String showing the logged activities
    def self.list(date)
      formatted_date = Date.parse(date).strftime '%e %B %Y'
      list = read_log[date]

      if list.nil?
        "Could not find any activity for#{formatted_date}"
      else
        formatted_log = list.map{|l| '* ' + l }.join "\n"
        "Log for#{formatted_date}:\n#{formatted_log}"
      end
    end

    private
    # Private: Location of the log file (~/.idid)
    #
    # Returns the String with the location of the log file
    def self.logfile
      File.join ENV['HOME'], '.idid'
    end

    # Private: Reads the log file into memory.
    #
    # Returns the Hash containing all log entries, or an empty hash if no
    # entries were found
    def self.read_log
      if File.exists? logfile
          JSON.load open(logfile) rescue {}
      else
        {}
      end
    end

    # Private: Writes the log file to disk in JSON format
    #
    # log - The Hash containing the done log
    #
    # Returns boolean
    def self.write_log(log)
      File.open(logfile, 'w') { |f| f.write log.to_json }
    end
  end
end

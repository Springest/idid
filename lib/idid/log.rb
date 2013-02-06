module Idid
  class Log

    attr_accessor :log_date, :tasks

    def initialize(log_date)
      @log_date = log_date || Date.today
      @tasks = []
    end

    # Public: Add a task to the Log
    #
    # task - An instance of Idid::Task
    #
    # Returns nothing
    def add_task(task)
      tasks << task
    end

    # Public: Lists all activities for a given date.
    #
    # date - The String date you wish to show the entries of, in the format
    #        YYYY-MM-DD
    #
    # Returns the String showing the logged activities
    def list
      if tasks.empty?
        "Could not find any activity for #{human_date}"
      else
        "Log for #{human_date}:\n#{formatted_tasks}"
      end
    end

    # Public: A Hash representation of a Log
    #
    # Returns a Hash with all tasks for this log date
    def to_hash
      { self.formatted_date => tasks.map(&:to_s) }
    end

    # Public: Formats the log_date so it's human readable
    #
    # Returns the String formatted date
    def human_date
      log_date.strftime('%e %B %Y').strip
    end

    # Public: Formats the log_date for usage in a Hash key (YYYY-MM-DD)
    #
    # Returns a String formatted date
    def formatted_date
      log_date.strftime '%Y-%m-%d'
    end

    # Public: Formats all tasks associated with the current log for human
    # readability
    #
    # Returns the String formatted tasks
    def formatted_tasks
      tasks.map{|task| task.to_item }.join "\n"
    end

  end
end
module Idid
  class Task

    attr_accessor :contents

    # Public: Initialize a new Task
    #
    # contents - The String containing the task that has been done
    #
    # Returns an instance of Task
    def initialize(contents)
      @contents = contents
    end

    # Public: Transform Task into a String
    #
    # Returns the String with the contents of the task
    def to_s
      @contents
    end

    # Public: Transform Task into a logged item
    # Returns the String formatted for use in a logged list
    def to_item
      "* #{contents}"
    end

  end
end

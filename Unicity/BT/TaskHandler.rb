#!/usr/bin/env ruby

module Unicity
  
  module BT

    class TaskHandler
      
      def self.process(task, exchange)
        return task.process(exchange)
      end
      
    end
    
  end
  
end

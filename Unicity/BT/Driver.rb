#!/usr/bin/env ruby

require "./Exchange.rb"
require "./Message.rb"
require "./Task.rb"
require "./TaskHandler.rb"
require "./TaskStatus.rb"
require "./TaskStub.rb"

module Unicity
  
  module BT
    
    class Driver
      
      def initialize(file)
        @file = file
      end
      
      def run(exchange, id = "BEHAVE")
        task = Unicity::BT::TaskStub.new()

        if task.is_a? Unicity::BT::Task
          status = Unicity::BT::TaskHandler.process(task, exchange)
          return status
        end
        
        return Unicity::BT::TaskStatus::ERROR
      end
      
    end
    
  end
  
end

driver = Unicity::BT::Driver.new("file")
status = driver.run(Unicity::BT::Exchange.new())
puts status

#!/usr/bin/env ruby

require "./TaskBranch.rb"

module Unicity
  
  module BT
    
    class TaskSelector < Unicity::BT::TaskBranch
    
      def initialize(blackboard = nil, settings = nil)
        super(blackboard, settings)
      end

      def process(exchange)
        shuffle = false
        if shuffle
          @tasks = @tasks.shuffle
        end
        inactives = 0;
        @tasks.each do |task|
          status = Unicity::BT::TaskHandler.process(task, exchange)
          if status == Unicity::BT::TaskStatus::INACTIVE
            inactive += 1
          elsif status != Unicity::BT::TaskStatus::FAILED
            return status
          end
        end
        if inactives < @tasks.count
          return Unicity::BT::TaskStatus::FAILED
        else
          return Unicity::BT::TaskStatus::INACTIVE
        end
        return
      end
      
    end

  end
  
end

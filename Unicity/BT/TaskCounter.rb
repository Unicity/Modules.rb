#!/usr/bin/env ruby

require "./TaskDecorator.rb"

module Unicity
  
  module BT
    
    class TaskCounter < Unicity::BT::TaskDecorator
      
      def initialize(blackboard = nil, settings = nil)
        super(blackboard, settings)
        @counter = 0
      end
      
      def process(exchange)
        if @counter < settings.max_count
          @counter += 1;
          return Unicity::BT::TaskStatus::ACTIVE         
        end
        @counter = 0
        status = Unicity::BT::TaskHandler.process(@task, exchange)
        return status
      end
      
      def reset()
        @counter = 0
      end
      
    end

  end
  
end

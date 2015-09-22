#!/usr/bin/env ruby

require "./TaskStatus.rb"

module Unicity
  
  module BT
    
    class Task
      
      attr_accessor :blackboard
      attr_accessor :settings
      
      def initialize(blackboard = nil, settings = nil)
        @blackboard = blackboard
        @settings = settings
      end
      
      def process(exchange)
        return Unicity::BT::TaskStatus::INACTIVE
      end
      
      def reset()
        # do nothing
      end
      
    end

  end
  
end

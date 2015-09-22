#!/usr/bin/env ruby

require "./TaskLeaf.rb"
require "./TaskStatus.rb"

module Unicity
  
  module BT
    
    class TaskStub < Unicity::BT::TaskLeaf
      
      def initialize(blackboard = nil, settings = nil)
        super(blackboard, settings)
      end
      
      def process(exchange)
        return Unicity::BT::TaskStatus::SUCCESS
      end
      
    end

  end
  
end

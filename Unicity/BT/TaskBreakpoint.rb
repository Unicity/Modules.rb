#!/usr/bin/env ruby

require "./TaskAction.rb"
require "./TaskStatus.rb"

module Unicity
  
  module BT
    
    class TaskBreakpoint < Unicity::BT::TaskAction
      
      def process(exchange)
        return Unicity::BT::TaskStatus::QUIT
      end
      
    end

  end
  
end

#!/usr/bin/env ruby

require "./Message.rb"

module Unicity

  module BT

    class Exchange

      attr_accessor :in
      attr_accessor :out

      def initialize()
        @in = Unicity::BT::Message.new()
        @out = Unicity::BT::Message.new()
      end
    
    end

  end
  
end
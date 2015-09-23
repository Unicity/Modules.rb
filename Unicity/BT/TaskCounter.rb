#!/usr/bin/env ruby

##
# Copyright © 2015 Unicity International.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

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

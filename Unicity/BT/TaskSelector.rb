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

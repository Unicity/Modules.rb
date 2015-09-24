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

require "./task_selector.rb"
require "./task_handler.rb"
require "./task_status.rb"

module Unicity

	module BT

		class TaskPicker < Unicity::BT::TaskSelector

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("index")
					@settings["index"] = 0
				end
			end

			def process(exchange)
				shuffle = @settings["shuffle"]
				if shuffle
					@tasks = @tasks.shuffle
				end
				index = @settings["index"]
				if @tasks[index].nil?
					return Unicity::BT::TaskStatus::ERROR
				end
				return Unicity::BT::TaskHandler.process(task, exchange)
			end

		end

	end

end

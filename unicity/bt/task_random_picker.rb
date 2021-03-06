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

require "./task_picker.rb"
require "./task_handler.rb"
require "./task_status.rb"

module Unicity

	module BT

		class TaskRandomPicker < Unicity::BT::TaskPicker

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				#if !@settings.has_key?("callable")
				#	@settings["callable"] = "rand"
				#end
			end

			def process(exchange)
				count = @tasks.count()
				if count > 0
					callable = Random.new(1234)
					index = callable.rand()
					return Unicity::BT::TaskHandler.process(@task[index], exchange)
				end
				return Unicity::BT::TaskStatus::ERROR
			end

		end

	end

end

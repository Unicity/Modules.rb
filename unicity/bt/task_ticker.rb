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

require "./task_decorator.rb"
require "./task_handler.rb"
require "./task_status.rb"

module Unicity

	module BT

		class TaskTicker < Unicity::BT::TaskDecorator

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("interval")
					@settings["interval"] = 1000 # 1 millisecond = 1/1000 of a second
				end
				@next_time = Time.now + (@settings["interval"] / 1000)
			end

			def process(exchange)
				interval = @settings["interval"] / 1000 # milliseconds => seconds
				if Time.now >= @next_time
					status = Unicity::BT::TaskHandler.process(task, exchange)
					@next_time += interval
					return status
				end
				return Unicity::BT::TaskStatus::ACTIVE
			end

			def reset()
				@next_time = Time.now + (@settings["interval"] / 1000)
			end

		end

	end

end

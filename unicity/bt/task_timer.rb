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

		class TaskTimer < Unicity::BT::TaskDecorator

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("delay")
					@settings["delay"] = 0 # 1 millisecond = 1/1000 of a second
				end
				if !@settings.has_key?("duration")
					@settings["duration"] = 1000 # 1 millisecond = 1/1000 of a second
				end
				@start_time = Time.now
			end

			def process(exchange)
				delay = @settings["delay"] / 1000 # milliseconds => seconds
				deltaT = Time.now - @start_time
				if deltaT >= delay
					duration = @settings["duration"] / 1000 # milliseconds => seconds
					if deltaT < (delay + duration)
						return Unicity::BT::TaskHandler.process(task, exchange)
					end
				end
				return Unicity::BT::TaskStatus::INACTIVE
			end

			def reset()
				@start_time = Time.now
			end

		end

	end

end

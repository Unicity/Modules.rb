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

		class TaskIterator < Unicity::BT::TaskDecorator

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("reverse")
					@settings["reverse"] = false
				end
				if !@settings.has_key?("steps")
					@settings["steps"] = 1
				end
			end

			def process(exchange)
				steps = @settings["steps"]
				inactives = 0;
				if @settings["reverse"]
					i = @tasks.count
					while i >= steps do
						status = Unicity::BT::TaskHandler.process(task, exchange)
						if status == Unicity::BT::TaskStatus::INACTIVE
							inactives += 1
						elsif status != Unicity::BT::TaskStatus::FAILED
							return status
						end
						i = i - 1
					end
				else
					inactives = 0;
					i = 0
					while i < steps do
						status = Unicity::BT::TaskHandler.process(task, exchange)
						if status == Unicity::BT::TaskStatus::INACTIVE
							inactives += 1
						elsif status != Unicity::BT::TaskStatus::FAILED
							return status
						end
						i = i + 1
					end
				end
				if inactives < @tasks.count
					return Unicity::BT::TaskStatus::FAILED
				else
					return Unicity::BT::TaskStatus::INACTIVE
				end
			end

		end

	end

end

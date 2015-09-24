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

		class TaskRepeater < Unicity::BT::TaskDecorator

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if @settings.has_key?("until")
					status = Unicity::BT::TaskStatus.valueOf(@settings["until"])
					if status != Unicity::BT::TaskStatus::SUCCESS
						status = Unicity::BT::TaskStatus::FAILED
					end
					@settings["until"] = status
				else
					@settings["until"] = Unicity::BT::TaskStatus::SUCCESS
				end
			end

			def process(exchange)
				until_status = @settings["until"]
				loop do
					status = Unicity::BT::TaskHandler.process(task, exchange)
					if status != Unicity::BT::TaskStatus::SUCCESS && status != Unicity::BT::TaskStatus::FAILED
						return status
					end
					break if status == until_status
				end
				return until_status
			end

		end

	end

end

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

		class TaskSucceeder < Unicity::BT::TaskDecorator

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("failed")
					@settings["failed"] = true
				end
				if !@settings.has_key?("error")
					@settings["error"] = false
				end
				if !@settings.has_key?("inactive")
					@settings["inactive"] = false
				end
				if !@settings.has_key?("active")
					@settings["active"] = false
				end
			end

			def process(exchange)
				status = Unicity::BT::TaskHandler.process(task, exchange)
				case status
					when Unicity::BT::TaskStatus::FAILED
						if @settings["failed"]
							status = Unicity::BT::TaskStatus::SUCCESS
						end
					when Unicity::BT::TaskStatus::ERROR
						if @settings["error"]
							status = Unicity::BT::TaskStatus::SUCCESS
						end
					when Unicity::BT::TaskStatus::INACTIVE
						if @settings["inactive"]
							status = Unicity::BT::TaskStatus::SUCCESS
						end
					when Unicity::BT::TaskStatus::ACTIVE
						if @settings["active"]
							status = Unicity::BT::TaskStatus::SUCCESS
						end
					else
						return status
				end
			end

		end

	end

end

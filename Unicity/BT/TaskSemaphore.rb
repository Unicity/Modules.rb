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
require "./TaskHandler.rb"
require "./TaskStatus.rb"

module Unicity

	module BT

		class TaskSemaphore < Unicity::BT::TaskDecorator

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("id")
					@settings["id"] = self.class.name
				end
			end

			def process(exchange)
				id = @settings["id"]
				if @blackboard.has_key?(id)
					hashCode = @blackboard[id]
					if hashCode == task.hash
						status = Unicity::BT::TaskHandler.process(task, exchange)
						if status != Unicity::BT::TaskStatus::ACTIVE
							@blackboard.delete(id)
						end
						return status
					end
					return Unicity::BT::TaskStatus::ACTIVE
				else
					status = Unicity::BT::TaskHandler.process(task, exchange)
					if status == Unicity::BT::TaskStatus::ACTIVE
						@blackboard[id] = task.hash
					end
					return status
				end
			end

			def reset()
				id = @settings["id"]
				if @blackboard.has_key?(id)
					@blackboard.delete(id)
				end
			end

		end

	end

end

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

require "./task_sequence.rb"
require "./task_handler.rb"
require "./task_status.rb"

module Unicity

	module BT

		class TaskStatefulSequence < Unicity::BT::TaskSequence

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				@state = 0
			end

			def process(exchange)
				inactives = 0;
				while @state < @tasks.count
					status = Unicity::BT::TaskHandler.process(@tasks[@state], exchange)
					if status == Unicity::BT::Task::Status::INACTIVE
						inactives += 1
					elsif status == Unicity::BT::Task::Status::ACTIVE
						return status
					elsif status != Unicity::BT::Task::Status::SUCCESS
						@state = 0
						return status
					end
					@state += 1
				end
				@state = 0
				if inactives < @tasks.count
					return Unicity::BT::Task::Status::SUCCESS
				else
					return Unicity::BT::Task::Status::INACTIVE;
				end
			end

			def reset()
				@state = 0
			end

		end

	end

end

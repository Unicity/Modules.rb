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

require "./task_branch.rb"
require "./task_handler.rb"
require "./task_status.rb"

module Unicity

	module BT

		class TaskParallel < Unicity::BT::TaskBranch

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				if !@settings.has_key?("shuffle")
					@settings["shuffle"] = false
				end
				if !@settings.has_key?("successes")
					@settings["successes"] = 1
				end
				if !@settings.has_key?("failures")
					@settings["failures"] = 1
				end
			end

			def process(exchange)
				count = @tasks.count
				if count > 0
					shuffle = @settings["shuffle"]
					if shuffle
						@tasks = @tasks.shuffle
					end
					inactives = 0;
					successes = 0
					failures = 0
					@tasks.each do |task|
						status = Unicity::BT::TaskHandler.process(task, exchange)
						case status
							when Unicity::BT::TaskStatus::QUIT
								return status
							when Unicity::BT::TaskStatus::FAILED
								failures += 1
								if failures >= [failures, count].min
									return Unicity::BT::TaskStatus::FAILED
								end
							when Unicity::BT::TaskStatus::ERROR
								return status
							when Unicity::BT::TaskStatus::INACTIVE
								inactives += 1
							when Unicity::BT::TaskStatus::SUCCESS
								successes += 1
								if successes >= [successes, count].min
									return Unicity::BT::TaskStatus::SUCCESS
								end
							else
								# do nothing
						end
					end
					if inactives != count
						return Unicity::BT::TaskStatus::ACTIVE
					end
				end
				return Unicity::BT::TaskStatus::INACTIVE
			end

		end

	end

end

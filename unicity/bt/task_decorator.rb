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

require "./task_composite.rb"

module Unicity

	module BT

		class TaskDecorator < Unicity::BT::TaskComposite

			def initialize(blackboard = {}, settings = {})
				super(blackboard, settings)
				@tasks = [nil]
			end

			def addTask(task)
				@tasks[0] = task
			end

			def getTask()
				return @tasks[0]
			end

			def task()
				return @tasks[0]
			end

			def setTask(task = nil)
				@tasks[0] = task
			end

		end

	end

end

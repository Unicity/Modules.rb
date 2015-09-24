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

		class TaskInverter < Unicity::BT::TaskDecorator

			def process(exchange)
				status = Unicity::BT::TaskHandler.process(task, exchange)
				case status
					when Unicity::BT::TaskStatus::FAILED
						return Unicity::BT::TaskStatus::SUCCESS
					when Unicity::BT::TaskStatus::SUCCESS
						return Unicity::BT::TaskStatus::FAILED
					else
						return status
				end
			end

		end

	end

end

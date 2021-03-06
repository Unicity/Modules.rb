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

require "./exchange.rb"
require "./message.rb"
require "./task.rb"
require "./task_handler.rb"
require "./task_status.rb"
require "./task_stub.rb"
require "./task_failer.rb"

module Unicity

	module BT

		class Driver

			def initialize(file)
				@file = file
			end

			def run(exchange, id = "BEHAVE")
				stub = Unicity::BT::TaskStub.new({}, {"status" => "inactive"})

				task = Unicity::BT::TaskFailer.new({}, {"inactive" => false})
				task.addTask(stub)

				if task.is_a? Unicity::BT::Task
					status = Unicity::BT::TaskHandler.process(task, exchange)
					return status
				end

				return Unicity::BT::TaskStatus::ERROR
			end

		end

	end

end

driver = Unicity::BT::Driver.new("file")
status = driver.run(Unicity::BT::Exchange.new())
puts status

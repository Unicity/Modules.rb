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

require "./task_condition.rb"

module Unicity

	module BT

		class TaskConditionFactory

			def getObject(parser, element)
				if element["type"].nil?
					name = parser.getElementPrefixedName(element)
					raise Exception.new("Unable to process Spring XML. Tag \"#{name}\" is missing \"type\" attribute.")
				end
				type = element["type"]

				xpath = "./spring-bt:blackboard"
				children = element.find(xpath, "spring-bt:http://static.unicity.com/modules/xsd/spring-bt.xsd")
				blackboard = !children.empty? ? parser.getObjectFromElement(children.first) : nil

				xpath = "./spring-bt:settings"
				children = element.find(xpath, "spring-bt:http://static.unicity.com/modules/xsd/spring-bt.xsd")
				settings = !children.empty? ? parser.getObjectFromElement(children.first) : nil

				object = eval(type).new(blackboard, settings)

				if !object.is_a?(Unicity::BT::TaskCondition)
					raise Exception.new("Invalid type defined. Expected a task condition, but got an element of type \"#{type}\" instead.")
				end

				return object
			end

		end

	end

end

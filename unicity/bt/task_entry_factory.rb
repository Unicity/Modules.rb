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

module Unicity

	module BT

		class TaskEntryFactory

			def getObject(parser, element)
				object = {}

				if element["key"].nil?
					name = parser.getElementPrefixedName(element)
					raise Exception.new("Unable to process Spring XML. Tag \"#{name}\" is missing \"key\" attribute.")
				end
				key = element["key"]
				if !parser.isKey?(key)
					raise Exception.new("Unable to process Spring XML. Expected a valid entry key, but got \"key\".")
				end

				children = parser.getElementChildren(element, nil)
				if !children.empty?
					children.each do |child|
						object[key] = parser.getObjectFromElement(child)
					end
				elsif !element["value-ref"].nil?
					object[key] = parser.getObjectFromIdRef(element["value-ref"])
				elsif !element["value"].nil?
					value = element["value"]
					if !element["value-type"].nil?
						type = element["value-type"]
						if !parser.isPrimitiveType(type)
							raise Exception.new("Unable to process Spring XML. Expected a valid primitive type, but got \"#{type}\".")
						end
						value = Unicity::Core::Convert.changeType(value, type)
					end
					object[key] = value
				else
					raise Exception.new("Unable to process Spring XML. Tag \"entry\" is missing \"value\" attribute.")
				end

				return object
			end

		end

	end

end

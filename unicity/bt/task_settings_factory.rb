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

		class TaskSettingsFactory

			def getObject(parser, element)
				object = {}

				children = parser.getElementChildren("spring-bt")
				if !children.empty?
					children.each do |child|
						name = parser.getElementName(child)
						if name == "entry"
							pairs = parser.getObjectFromElement(child)
							pairs.each do |key, value|
								object[key] = value
							end
						else
							name = parser.getElementPrefixedName(child)
							raise Exception.new("Unable to process Spring XML. Expected an \"entry\" element, but got an element of type \"#{name}\" instead.")
						end
					end
				end

				return object
			end

		end

	end

end

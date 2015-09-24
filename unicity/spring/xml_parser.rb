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

require 'xml'

module Unicity

	module Spring

		class XMLParser

			def initialize(context)
				@context = context
				@idrefs = {}
				@singletons = {}
			end

			def getObjectIds(type = nil)
				document = @context.parse
				xpath = !type.nil? ? "/spring:objects/*[@type='#{type}']/@id" : "/spring:objects/*/@id"
				elements = document.find(xpath, "spring:http://static.unicity.com/modules/xsd/spring.xsd")
				ids = []
				elements.each do |element|
					ids << element.value
				end
				return ids
			end

			def getResource()
				resources = @context.getResources()
				return resources[0]
			end

		end

	end

end

#parser = XML::Parser.file("input.spring.xml")
#xml = Unicity::Spring::XMLParser.new(parser)
#puts xml.getObjectIds().inspect

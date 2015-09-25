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
				@context = context # XMLObjectFactory
				@idrefs = {}
				@singletons = {}
			end

			def find(idref)
				if !self.isId(idref)
					raise ArgumentError.new("Invalid argument detected #{idref}")
				end
				resource = self.getResource()
				xpath = "/spring:objects/*[@id='#{idref}' or contains(@name,'#{idref}')]"
				elements = resource.find(xpath, "spring:http://static.unicity.com/modules/xsd/spring.xsd")
				elements = elements.select do |element|
					(!element["id"].nil? && element["id"] == idref) || (!element["name"].nil? && element["name"].split(/(,|;|\s)+/).include?(idref))
				end
				return elements
			end

			def getObjectIds(type = nil)
				resource = self.getResource()
				xpath = !type.nil? ? "/spring:objects/*[@type='#{type}']/@id" : "/spring:objects/*/@id"
				attributes = resource.find(xpath, "spring:http://static.unicity.com/modules/xsd/spring.xsd")
				ids = []
				attributes.each do |attribute|
					ids << attribute.value
				end
				return ids
			end

			def getObjectScope(id)
				elements = self.find(id)
				if !elements.empty?
					element = elements.first
					if !element["scope"].nil?
						scope = element["scope"]
						if !self.isScopeType(scope)
							raise Exception.new("Unable to process Spring XML. Expected a valid \"scope\" token, but got \"#{scope}\".")
						end
						return scope
					end
					return "singleton"
				end
				return nil
			end


			def getResource()
				resources = @context.getResources()
				return resources[0]
			end

			def isId(token)
				return token.is_a?(String) && token.match(/^[a-z0-9_]+$/i)
			end

			def isKey(token)
				return token.is_a?(String) && token.length > 0
			end

			def isMethodName(token)
				return token.is_a?(String) && token.match(/^[a-z_][a-z0-9_]*$/i)
			end

			def isPropertyName(token)
				return token.is_a?(String) && token.match(/^[a-z_][a-z0-9_]*$/i)
			end

			def isScopeType(token)
				return token.is_a?(String) && token.match(/^(singleton|prototype|session)$/)
			end

			def isSpacePreserved(token)
				return token.is_a?(String) && token.match(/^preserve$/)
			end

		end

	end

end

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

	module Spring

		class XMLObjectDefinition

			def initialize(element)
				@element = element
			end

			def getFactoryMethod()
				return !@element["factory-method"].nil? ? @element["factory-method"] : ""
			end

			def getFactoryObject()
				return !@element['factory-object'].nil? ? @element['factory-object'].gsub(".", "::") : ""
			end

			def getId()
				return !@element["id"].nil? ? @element["id"] : ""
			end

			def getNames()
				return !@element["name"].nil? ? @element["name"].split(/(,|;|\s)+/) : []
			end

			def getScope()
				return !@element["scope"].nil? ? @element["scope"] : "singleton";
			end

			def getType()
				return !@element['type'].nil? ? @element['type'].gsub(".", "::") : ""
			end

			def isPrototype?()
				return self.getScope == "prototype"
			end

			def isSingleton?()
				return self.getScope == "singleton"
			end

		end

	end

end

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

	class XMLObjectFactory

		def initialize(resource = nil)
			@resources = []
			if !resource.nil?()
				@resources << resource
			end
			@parser = Unicity::Spring::XMLParser.new(self)
		end

		def addResource(resource)
			@resources << resource
		end

		def getObject(id)
			return @parser.getObjectFromIdRef(id, {})
		end

		def getObjectIds(type = nil)
			return @parser.getObjectIds(type)
		end

		def getObjectScope(id)
			return @parser.getObjectScope(id)
		end

		def getObjectType(id)
			return @parser.getObjectType(id)
		end

		def getParser()
			return @parser
		end

		def getResources()
			return @resources
		end

		def hasObject(id)
			return @parser.hasObject(id)
		end

	end

end
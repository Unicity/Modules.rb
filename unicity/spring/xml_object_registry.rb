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

		class XMLObjectRegistry

			def initialize()
				@register = {}
			end

			def getValue(key)
				return @register[self.getKey(key)]
			end

			def has_key?(key)
				return @register.has_key?(self.getKey(key))
			end

			def putEntry(key, factory)
				return @register[self.getKey(key)] = factory
			end

			def getKey(key)
				return key.reverse.join("/")
			end

		end

	end

end

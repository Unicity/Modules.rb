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

require("xml")

module Unicity

	module Spring

		class XMLParser

			@@encodings = [
				"NONE", "UTF_8", "UTF_16LE", "UTF_16BE", "UCS_4LE",
				"UCS_4BE", "EBCDIC", "UCS_4_2143", "UCS_4_3412", "UCS_2",
				"ISO_8859_1", "ISO_8859_2", "ISO_8859_3", "ISO_8859_4", "ISO_8859_5",
				"ISO_8859_6", "ISO_8859_7", "ISO_8859_8", "ISO_8859_9", "ISO_2022_JP",
				"SHIFT_JIS", "EUC_JP", "ASCII"
			]

			@@primitives = [
				"bool", "boolean",
				"char",
				"date", "datetime", "time", "timestamp",
				"decimal", "double", "float", "money", "number", "real", "single",
				"bit", "byte", "int", "int8", "int16", "int32", "int64", "long", "short", "uint", "uint8", "uint16", "uint32", "uint64", "integer", "word",
				"ord", "ordinal",
				"nil", "null",
				"nvarchar", "string", "varchar", "undefined"
			]

			def initialize(context)
				@context = context # XMLObjectFactory
				@idrefs = {}
				@registry = nil
				@singletons = {}
			end

			def find(idref)
				if !self.isId?(idref)
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

			def getElementChildren(element, namespace = "")
				children = element.children
				if namespace.is_a?(String) && namespace.length > 0
					children = children.select do |child|
						child.element? && self.getElementNamespace(child) == namespace
					end
				else
					children = children.select do |child|
						child.element?
					end
				end
				return children
			end

			def getElementName(element)
				return element.name
			end

			def getElementNamespace(element)
				return !element.namespace? ? element.namespaces.first.prefix : ""
			end

			def getElementPrefixedName(element)
				return !element.namespace? ? element.namespaces.first.prefix + ":" + element.name : element.name
			end

			def getEncoding()
				encoding = self.getResource().encoding
				if encoding > 0
					return @@encodings[encoding] # http://xml4r.github.io/libxml-ruby/rdoc/index.html
				end
				return "UTF-8"
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
						if !self.isScopeType?(scope)
							raise Exception.new("Unable to process Spring XML. Expected a valid \"scope\" token, but got \"#{scope}\".")
						end
						return scope
					end
					return "singleton"
				end
				return nil
			end

			def getObjectType(id)
				elements = self.find(id)
				if !elements.empty?
					element = elements.first
					if !element["type"].nil?
						type = element["type"]
						if self.isClassName?(type)
							return type.gsub(".", "::")
						end
					end
				end
				return nil
			end

			def getRegistry()
				return @registry
			end

			def getResource()
				resources = @context.getResources()
				return resources[0]
			end

			def hasObject?(id)
				elements = self.find(id)
				return !elements.empty?
			end

			def isClassName?(token)
				return token.is_a?(String) && token.match(/^((\\\|_|\\.)?[a-z][a-z0-9]*)+$/i)
			end

			def isId?(token)
				return token.is_a?(String) && token.match(/^[a-z0-9_]+$/i)
			end

			def isIdref?(token, resource = nil)
				if !resource.nil?
					if !self.isId?(token)
						raise ArgumentError.new("Invalid argument detected (id: #{token}).")
					end
					xpath = "/spring:objects/*[@id='#{token}' or contains(@name,'#{token}')]"
					elements = resource.find(xpath, "spring:http://static.unicity.com/modules/xsd/spring.xsd")
					elements = elements.select do |element|
						(!element["id"].nil? && element["id"] == idref) || (!element["name"].nil? && element["name"].split(/(,|;|\s)+/).include?(idref))
					end
					return !elements.empty?
				end
				return self.isId?(token)
			end

			def isKey?(token)
				return token.is_a?(String) && token.length > 0
			end

			def isMethodName?(token)
				return token.is_a?(String) && token.match(/^[a-z_][a-z0-9_]*$/i)
			end

			def isPrimitiveType?(token)
				return token.is_a?(String) && @@primitives.include?(token.downcase)
			end

			def isPropertyName?(token)
				return token.is_a?(String) && token.match(/^[a-z_][a-z0-9_]*$/i)
			end

			def isScopeType?(token)
				return token.is_a?(String) && token.match(/^(singleton|prototype|session)$/)
			end

			def isSpacePreserved?(token)
				return token.is_a?(String) && token.match(/^preserve$/)
			end

		end

	end

end

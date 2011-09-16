/**
 * Copyright (c) 2011 Tuomas Artman, http://artman.fi
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.flow.managers {
	
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Acts as a cache for introspection calls.
	 */	
	public class IntrospectionManager {
		
		private static var describeLookup:Dictionary = new Dictionary();
		
		/**
		 * Gets the name of a class or instance. The name is always returned in instance format (packet.class), not class format (packet::class). 
		 * @param The instance or class who's name to retreive
		 * @return The name of the object or class.
		 */		
		public static function getClassName(object:Object):String {
			if(object is String) {
				return (object as String).replace("::", ".");
			}
			return getQualifiedClassName(object).replace("::", ".");
		}
		
		/**
		 * Returns the descriptor of the object. The descriptor is only fetched once and thereafter cached. 
		 * @param The instance or class who's descriptor to fetch
		 * @return The descriptor of the instance or class.
		 */		
		public static function getDescriptor(object:Object):XML {
			var name:String = getClassName(object);
			if(!describeLookup[name]) {
				describeLookup[name] = describeType(object);
			}
			return describeLookup[name];
		}
	}
}
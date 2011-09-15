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
	import flash.utils.getDefinitionByName;
	
	/**
	 * A collection of statuc methods to register default skins for components. 
	 */	
	public class SkinManager {
		
		private static var defaultSkins:Object;
		
		/**
		 * Initializes the manager and registers all default skins for Flow's components. This is called automatically by Flow.
		 */		
		public static function init():void {
			var components:Array = ["Button", "Checkbox", "HScrollBar", "VScrollBar", "TextInput", "TextArea", "Alert"]
			defaultSkins = {};
			for each(var component:String in components) {
				defaultSkins["com.flow.components." + component] = "com.flow.skins." + component + "Skin";
			}
		}
		init();
		
		/**
		 * Registeres a skin class for a component. Components and skins can be passed in via class references or strings.
		 * All default components and skins are registered using strings so that they are not included in the compiled SWF unless used.
		 * If you want to use the default skins you need to reference their skins in your code.
		 * @param The component class or package name of the component.
		 * @param The skin class or package name to register as a default skin for the component.
		 */		
		public static function registerDefaultSkin(component:*, skinClass:*):void {
			if(!(component is String)) {
				component = IntrospectionManager.getClassName(component);
			}
			if (skinClass is String) {
				skinClass = getDefinitionByName(defaultSkins[component]) as Class;	
			}
			defaultSkins[component] = skinClass;
		}
		
		/**
		 * Retreives the default skin for a component.
		 * @param The component class, instance of the class or package name.
		 * @return The default skin class or null, if no default skin could be found.
		 */		
		public static function getDefaultSkin(component:*):Class {
			component = IntrospectionManager.getClassName(component);
			if(defaultSkins[component]) {
				var cmp:* = defaultSkins[component];
				if(cmp is String) {
					cmp = getDefinitionByName(cmp);
				}
				return cmp;
			}
			return null;
		}
	}
}
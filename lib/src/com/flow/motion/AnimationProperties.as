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

package com.flow.motion {
	
	import com.flow.managers.IntrospectionManager;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	[RemoteClass(alias="AnimationProps")]
	public class AnimationProperties {
		
		public var properties:Vector.<AnimationProperty>;
		
		private static var animateablePropsLookup:Dictionary  = new Dictionary();
		
		public function AnimationProperties() {
			properties = new Vector.<AnimationProperty>();
		}
		
		public function parseChanges(newProps:AnimationProperties):Vector.<AnimationProperty> {
			var ret:Vector.<AnimationProperty> = new Vector.<AnimationProperty>();
			if(newProps) {
				for(var i:int = 0; i<properties.length; i++) {
					if(properties[i].value != newProps.properties[i].value && newProps.properties[i].value !== null) {
						ret.push(newProps.properties[i]);
					}
				}
			}
			if(ret.length) {
				return ret;
			}
			return null;
		}
		
		public function applyToObject(object:Object):void {
			for(var i:int = 0; i<properties.length; i++) {
				var prop:AnimationProperty = properties[i];
				if(prop.value != object[prop.name] && prop.value !== null) {
					object[prop.name] = prop.value;
				}
			}
		}
		
		public function gatherProps(object:Object):void {
			var name:String = IntrospectionManager.getClassName(object);
			if(!animateablePropsLookup[name]) {
				var props:Vector.<AnimationProperty> = new Vector.<AnimationProperty>();
				if(object is IAnimateable) {
					var desc:XML = IntrospectionManager.getDescriptor(object);
					var lst:XMLList = desc..metadata.(@name == "Animateable");
					for(var i:int = 0; i<lst.length(); i++) {
						props.push(new AnimationProperty(
							lst[i].parent().@name, 
							null,
							lst[i].arg.(@key == "type").@value ? lst[i].arg.(@key == "type").@value + "" : null)
						)
					}
					animateablePropsLookup[name] = props;
				}
				if(object is DisplayObject) {
					var displayProps:Array = ["x", "y", "z", "rotation", "rotationX", "rotationY", "rotationZ", "scaleX", "scaleY", "width", "height"];
					for(i = 0; i<displayProps.length; i++) {
						props.push(new AnimationProperty(displayProps[i]));
					}
				}
			}
			properties = animateablePropsLookup[name].concat();
			
			for(i = 0; i<properties.length; i++) {
				var prop:AnimationProperty = properties[i];
				properties[i] = new AnimationProperty(prop.name, object[prop.name], prop.type);
			}
		}		
	}
}
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

package com.flow.effects {
	
	import com.flow.components.Component;
	
	import flash.display.DisplayObject;

	public class AnimationProps {
		
		public var x:int;
		public var y:int;
		public var z:int;
		public var rotation:Number;
		public var rotationX:Number;
		public var rotationY:Number;
		public var rotationZ:Number
		public var scaleX:Number;
		public var scaleY:Number;
		public var width:int;
		public var height:int;
		public var percentWidth:Number;
		public var percentHeight:Number
		public var horizontalCenter:*;
		public var verticalCenter:*;
		public var top:*;
		public var right:*;
		public var bottom:*;
		public var left:*;
		
		public static const propsDisplayObject:Vector.<String> = Vector.<String>(["x", "y", "z", "rotation", "rotationX", "rotationY", "rotationZ", "scaleX", "scaleY", "width", "height"]);
		
		public static const propsComponent:Vector.<String> = Vector.<String>(["x", "y", "z", "rotation", "rotationX", "rotationY", "rotationZ", "scaleX", "scaleY", "width", "height", 
			"percentWidth", "percentHeight", "horizontalCenter", "verticalCenter", "top", "right", "bottom", "left"]);
		
		public function AnimationProps() {
		}
		
		public function parseChanges(newProps:AnimationProps):Object {
			var found:Boolean = false;
			var ret:Object = {};
			if(newProps) {
				for(var i:int = 0; i<propsComponent.length; i++) {
					var prop:String = propsComponent[i];
					if(this[prop] != newProps[prop] && !isNaN(newProps[prop])) {
						ret[prop] = newProps[prop];
						found = true;
					}
				}
			}
			if(found) {
				return ret;
			}
			return null;
		}
		
		public function applyToDisplayObject(displayObject:DisplayObject):void {
			var props:Vector.<String> = displayObject is Component ? propsComponent : propsDisplayObject;
			for(var i:int = 0; i<props.length; i++) {
				var prop:String = props[i];
				if(this[prop] != displayObject[prop] && !isNaN(this[prop])) {
					displayObject[prop] = this[prop];
				}
			}
		}
		
		public function gatherProps(displayObject:DisplayObject):void {
			var props:Vector.<String> = displayObject is Component ? propsComponent : propsDisplayObject;
			for(var i:int = 0; i<props.length; i++) {
				var prop:String = props[i];
				this[prop] = displayObject[prop];
			}
		}
	}
}
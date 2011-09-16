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
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.flow.components.Component;
	import com.flow.components.supportClasses.DefaultTooltip;
	import com.flow.components.supportClasses.ITooltip;

	public class TooltipManager {
		
		public static var instance:TooltipManager = new TooltipManager();
		
		public var defaultTooltip:Class;
		private var activeTip:DisplayObject;
		private var root:DisplayObjectContainer;
		
		public function TooltipManager() {
			defaultTooltip = DefaultTooltip;
		}
		
		public function setRoot(container:DisplayObjectContainer):void {
			root = container;
			root.mouseEnabled = false;
			root.mouseChildren = false;
		}
		
		public function showTooltip(from:Component):void {
			showTooltipWithText(from.tooltip);
		}
		
		public function showTooltipWithText(text:String):void {
			if(activeTip) {
				hideTooltip();
			}
			activeTip = new defaultTooltip();
			(activeTip as ITooltip).text = text;
			root.addChild(activeTip as DisplayObject);
			root.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			mouseMove()
		}

		public function hideTooltip(from:Component = null):void {
			if(activeTip) {
				while(root.numChildren) {
					root.removeChildAt(0);
				}
				root.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				activeTip = null;
			}
		}
		
		private function mouseMove(e:MouseEvent = null):void {
			(activeTip as ITooltip).setLocation(root.mouseX, root.mouseY, root.stage.stageWidth, root.stage.stageHeight);
		}
	}
}
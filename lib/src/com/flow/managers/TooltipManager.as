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
	
	import com.flow.components.Component;
	import com.flow.components.supportClasses.DefaultTooltip;
	import com.flow.components.supportClasses.ITooltip;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * A singleton class to manage the display of tooltips. You usually don't call any methods of the TooltipManager directly. Instead,
	 * you set the tooltip-propert of a Component to the text you whish to display, and the Component will take care of creating and
	 * destroying the tooltip.
	 */	
	public class TooltipManager {
		
		/**
		 * The singleton instance. 
		 */		
		public static var instance:TooltipManager = new TooltipManager();
		
		/**
		 * The class to use for all tooltips. 
		 */		
		public var defaultTooltip:Class;
		private var activeTip:DisplayObject;
		private var root:DisplayObjectContainer;
		
		/**
		 * Constructor. As this is a singleton instance, you don't instantiate it directly. 
		 */		
		public function TooltipManager() {
			defaultTooltip = DefaultTooltip;
		}
		
		/** @private */ 
		public function setRoot(container:DisplayObjectContainer):void {
			root = container;
			root.mouseEnabled = false;
			root.mouseChildren = false;
		}
		
		/**
		 * Creates a tooltip for a component. This method is called automatically by any component that has the tooltip-property set. 
		 * @param The component whose tooltip to display.
		 */		
		public function showTooltip(from:Component):void {
			showTooltipWithText(from.tooltip);
		}
		
		/** @private */  
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

		/**
		 * Hides a tooltip. This method is called automatically by all components when the mouse leaves it's bounding box. 
		 */		
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
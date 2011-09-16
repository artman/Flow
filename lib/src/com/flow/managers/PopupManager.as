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
	import com.flow.containers.Application;
	import com.flow.containers.Container;
	import com.flow.effects.Effect;
	import com.flow.motion.Tween;
	
	import flash.display.DisplayObject;

	/**
	 * Collection of static methods for managing pop-ups. Pop-ups appear on top of everything else.
	 */	
	public class PopupManager {
		
		public static var ALIGN_CENTER:String = "center";
		public static var ALIGN_NONE:String = "none";
		
		private static var popups:Vector.<Component>;
		
		/**
		 * The default fade speed of new popups. 
		 */		
		public static var defaultSpeed:Number = 0.1;
		
		/**
		 * The default fade speed of popups that are beeing removed. 
		 */		
		public static var defaultSpeedOut:Number = 0.2;
		
		private static var popupRoot:Container;
		
		private static function init():void {
			popups = new Vector.<Component>();
			popupRoot = new Container();
			popupRoot.percentWidth = 100;
			popupRoot.percentHeight = 100;
		}
		init();
		
		
		/**
		 * Adds a new popup to the stage. 
		 * @param The popup component to add
		 * @param Alignment of the popup. If this parameter is PopupManager.ALIGN_CENTER, the popup's verticalCenter and horizontalCenter are set to 0, so that the popup appears
		 * in the center of the screen. Otherwise the caller is responsible for setting the popups alignment.
		 * @param Not in use yet
		 * @param The speed at which to fade the popup in. If not defined, the #defaultSpeed will be used.
		 * @see #defaultSpeed
		 */		
		public static function addPopup(popup:Component, align:String = "center", effect:Effect = null, speed:Number = -1):void {
			if(!Application.application.contains(popupRoot)) {
				Application.application.addChild(popupRoot);
			}
			if(align == ALIGN_CENTER) {
				popup.horizontalCenter = 0;
				popup.verticalCenter = 0;
			}
			popupRoot.addChild(popup);
			popup.alpha = 0;
			popups.push(popup);
			new Tween(popup, speed != -1 ? speed: defaultSpeed, {alpha:1});
		}
		
		/**
		 * Removed a previously added popup. 
		 * @param The popup to remove.
		 * @param Not used yet.
		 * @param The speed at which to remove the popup. If not defined, the #defaultSpeedOut will be used.
		 * @see #defaultSpeedOut
		 */		
		public static function removePopup(popup:Component, effect:Effect = null, speed:Number = 0):void {
			var outSpeed:Number = speed ? speed: defaultSpeedOut ? defaultSpeedOut : defaultSpeed;
			popups.splice(popups.indexOf(popup), 1);
			if(!outSpeed) {
				if(popup.parent) {
					popup.parent.removeChild(popup);
				}
			} else {
				new Tween(popup, outSpeed, {alpha:0}).completeHandler = function(t:Tween):void {
					popup.parent.removeChild(popup);
				}
			}
		}	
		
		public static function removeAllPopups():void {
			for(var i:int = popups.length-1; i>=0; i--) {
				removePopup(popups[i]);
			}
		}
	}
}

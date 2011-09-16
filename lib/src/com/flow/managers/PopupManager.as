package com.flow.managers {
	import com.flow.components.Component;
	import com.flow.containers.Application;
	import com.flow.containers.Container;
	import com.flow.effects.Effect;
	import com.flow.motion.Tween;
	
	import flash.display.DisplayObject;

	public class PopupManager {
		
		public static var ALIGN_CENTER:String = "center";
		public static var ALIGN_NONE:String = "none";
		
		private static var popups:Vector.<Component>;
		
		public static var defaultSpeed:Number = 0.1;
		public static var defaultSpeedOut:Number = 0.2;
		
		public static function init():void {
			popups = new Vector.<Component>();
			popupRoot = new Container();
			popupRoot.percentWidth = 100;
			popupRoot.percentHeight = 100;
		}
		init();
		
		public function PopupManager() {
		}
		
		public static var popupRoot:Container;
		
		public static function addPopup(popup:Component, align:String = "center", effect:Effect = null, speed:Number = 0):void {
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
			new Tween(popup, speed ? speed: defaultSpeed, {alpha:1});
		}
		
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

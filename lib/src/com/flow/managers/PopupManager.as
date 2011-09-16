package com.flow.managers {
	import com.flow.components.Component;
	import com.flow.containers.Application;
	import com.flow.containers.Container;
	import com.flow.effects.Effect;
	import com.flow.motion.Tween;

	public class PopupManager {
		
		public static var ALIGN_CENTER:String = "center";
		public static var ALIGN_NONE:String = "none";
		
		public static var defaultSpeed:Number = 0.1;
		public static var defaultSpeedOut:Number = 0.2;
		
		public function PopupManager() {
		}
		
		public static var popupRoot:Container;
		
		public static function addPopup(popup:Component, align:String = "center", effect:Effect = null, speed:Number = 0):void {
			if(!popupRoot) {
				popupRoot = new Container();
				popupRoot.percentWidth = 100;
				popupRoot.percentHeight = 100;
			}
			if(!Application.application.contains(popupRoot)) {
				Application.application.addChild(popupRoot);
			}
			if(align == ALIGN_CENTER) {
				popup.horizontalCenter = 0;
				popup.verticalCenter = 0;
			}
			popupRoot.addChild(popup);
			popup.alpha = 0;
			new Tween(popup, speed ? speed: defaultSpeed, {alpha:1});
		}
		
		public static function removePopup(popup:Component, effect:Effect = null, speed:Number = 0):void {
			var outSpeed:Number = speed ? speed: defaultSpeedOut ? defaultSpeedOut : defaultSpeed;
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
	}
}

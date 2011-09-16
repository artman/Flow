package com.flow.managers {
	import flash.utils.getDefinitionByName;

	public class SkinManager {
		
		private static var defaultSkins:Object;
		public static function init():void {
			var components:Array = ["Button", "CheckBox", "HScrollBar", "VScrollBar", "TextInput"]
			defaultSkins = {};
			for each(var component:String in components) {
				defaultSkins["com.flow.components." + component] = "com.flow.skins." + component + "Skin";
			}
		}
		init();
		
		public static function registerDefaultSkin(component:String, skinClass:String):void {
			defaultSkins[component] = skinClass;
		}
		
		public static function getDefaultSkin(component:String):Class {
			component = component.replace("::", ".");
			if(defaultSkins[component]) {
				try {
					var skin:String = defaultSkins[component];
					return getDefinitionByName(defaultSkins[component]) as Class;
				} catch(e:Error) {
					return null;
				}
			}
			return null;
		}
	}
}
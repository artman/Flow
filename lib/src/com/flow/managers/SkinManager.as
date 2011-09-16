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
		
		public static function registerDefaultSkin(component:*, skinClass:*):void {
			if(!(component is String)) {
				component = IntrospectionManager.getClassName(component);
			}
			if (skinClass is String) {
				skinClass = getDefinitionByName(defaultSkins[component]) as Class;	
			}
			defaultSkins[component] = skinClass;
		}
		
		public static function getDefaultSkin(component:String):Class {
			component = component.replace("::", ".");
			if(defaultSkins[component]) {
				return defaultSkins[component];
			}
			return null;
		}
	}
}
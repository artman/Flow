package com.flow.managers {
	import flash.utils.getDefinitionByName;

	public class SkinManager {
		
		private static var defaultSkins:Object;
		public static function init():void {
			var components:Array = ["Button", "Checkbox", "HScrollBar", "VScrollBar", "TextInput", "TextArea"]
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
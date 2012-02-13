package com.flow.managers {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * The Resource Manager lets you easily localize textual content within your application. Flow's resource manager works like the Resource Manager
	 * in Flex. You create resource files in a special folder (usually locale) that contains sub-folders with all the locales supported by your application
	 * (e.g. en_US). The files are named according the resource bundle name you want to choose and have a prefix of .properties. Each line in a 
	 * resource file contains the variable name, an equal sign and the actual value for that variable. (e.g. "main_welcom = Welcome to Flow"). You trigger
	 * Flex to include you resource file in the build via the <code>[ResourceBundle("NameOfResourceBundle")]</code>-metadata somewhere in your app.
	 * 
	 * From anywhere in you'll be able to use <code>ResourceManager.instance.getString("name")</code> to retreive a string from a resource bundle
	 * Components also include a shortcut - the static property <code>resources</code> - to the resource manager.
	 */	
	public class ResourceManager {
		
		[Bindable]
		public static var instance:ResourceManager = new ResourceManager();
		private var bundles:Dictionary;
		private var localeChain:Array;
		private var activeBundles:Dictionary;
		private var _locale:String;
		
		public function ResourceManager() {
			bundles = new Dictionary();
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;			
			if (!applicationDomain.hasDefinition("_CompiledResourceBundleInfo")) {
				return;
			}
			var resourceInfo:Object = applicationDomain.getDefinition("_CompiledResourceBundleInfo");
			var c:Class = Class(applicationDomain.getDefinition("_CompiledResourceBundleInfo"));
			var locales:Array = c.compiledLocales;
			var bundleNames:Array = c.compiledResourceBundleNames;
			
			parseResourceBundles(locales, bundleNames);
			
			localeChain = locales;
		}
	
		private function parseResourceBundles(locales:Array, bundleNames:Array):void {
			var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			
			var n:int = locales ? locales.length : 0;
			var m:int = bundleNames ? bundleNames.length:0;
			
			for (var i:int = 0; i < n; i++) {
				var locale:String = locales[i];
				bundles[locale] = new Dictionary();
				for (var j:int = 0; j < m; j++) {
					var bundleName:String = bundleNames[j];
					var packageName:String = null;		
					var resourceBundleClassName:String = locale + "$" + bundleName + "_properties";
					
					var bundleClass:Class = null;
					if (applicationDomain.hasDefinition(resourceBundleClassName)) {
						bundleClass = Class(applicationDomain.getDefinition(resourceBundleClassName));
					}
					
					if (!bundleClass) {
						resourceBundleClassName = bundleName;
						if (applicationDomain.hasDefinition(resourceBundleClassName)) {
							bundleClass = Class(applicationDomain.getDefinition(resourceBundleClassName));
						}
					}
					
					if (!bundleClass) {
						//throw new Error("Could not find compiled resource bundle '" + bundleName + "' for locale '" + locale + "'.");
					}
					var bndl:Object = new bundleClass();	
					bundles[locale][bundleName.toLowerCase()] = bndl.content;
				}
			}
			if(locales.length) {
				this.locale = locales[0];
			}
		}
		
		/**
		 * The current locale.
		 */		
		public function get locale():String {
			return _locale;
		}
		public function set locale(value:String):void {
			if(_locale != value) {
				_locale = value;
				activeBundles = bundles[value];
			}
		}
		
		/**
		 * Retreives a string from a resource bundle with the current locale. 
		 * @param The name of the resource to retreive
		 * @param The name of the resource bundle. If left unspecified or set to null, the "general" resource bundle will be used.
		 * @param Any variables you want to replace in the fetched resource. You may define one or more variables in the resource string using the syntax
		 * <code>{1}, {2}, {n}</code>. These are replaced by the optional parameters given.
		 * @return The string resource.
		 */		
		public function getString(name:String, resourceBundle:String = "general", ...rest):String {
			if(activeBundles) {
				var bundle:Object = activeBundles[resourceBundle ? resourceBundle.toLowerCase() : "general"];
				if(bundle) {
					var str:String = bundle[name];
					for(var i:int = 0; i<rest.length; i++) {
						str = str.replace("{"+(i+1)+"}", rest[i]);
					}
					return str;
				}
			}
			return null;
		}
	}
}
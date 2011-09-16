package com.flow.commands {
	import com.flow.managers.TextFormatManager;
	
	import flash.text.TextFormat;

	public class InitApplicationCommand extends Command {
		
		[Embed(source="/assets/fonts/FreeUniversal-Regular.ttf", fontFamily="Universal", fontWeight="normal", advancedAntiAliasing="true", embedAsCFF="false")]
		private const Universal:Class;
		
		[Embed(source="/assets/fonts/FreeUniversal-Bold.ttf", fontFamily="Universal", fontWeight="bold", advancedAntiAliasing="true", embedAsCFF="false")]
		private const UniversalBold:Class;
		
		public function InitApplicationCommand() {
			super();
			TextFormatManager.registerTextFormat("normal", new TextFormat("Universal", 10, 0, false, false, false, null, null, null, 0, 0, null, 4));
			TextFormatManager.registerTextFormat("heading", new TextFormat("Universal", 18, 0, true, false, false, null, null, null, 0, 0, null, 4));
			TextFormatManager.registerTextFormat("bold", new TextFormat("Universal", 10, 0, true, false, false, null, null, null, 0, 0, null, 4));
		}
	}
}
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
			TextFormatManager.registerTextFormat("normal", new TextFormat("Universal", 11, 0, false, false, false, null, null, null, 0, 0, null, 2));
			TextFormatManager.registerTextFormat("heading", new TextFormat("Universal", 18, 0, true, false, false, null, null, null, 0, 0, null, 2));
			TextFormatManager.registerTextFormat("bold", new TextFormat("Universal", 11, 0, true, false, false, null, null, null, 0, 0, null, 2));
		}
	}
}
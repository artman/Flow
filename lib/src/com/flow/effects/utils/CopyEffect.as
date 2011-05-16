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

package com.flow.effects.utils {
	
	import com.flow.effects.BlurEffect;
	import com.flow.effects.ColorTransformEffect;
	import com.flow.effects.DropShadowEffect;
	import com.flow.effects.Effect;
	import com.flow.effects.GlowEffect;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class CopyEffect {
		public function CopyEffect() {
		}
		
		public static function copyFromTargetFilters(target:DisplayObject, assignTo:DisplayObject):Effect {
			var effect:Effect = null;
			var nextChain:Effect = null;
			for(var i:int = 0; i<target.filters.length; i++) {
				var filter:BitmapFilter = target.filters[i];
				var currentEffect:Effect;
				if(filter is BlurFilter) {
					currentEffect = new BlurEffect(assignTo, (filter as BlurFilter).blurX,  (filter as BlurFilter).blurY, (filter as BlurFilter).quality);
				}
				if(filter is GlowFilter) {
					currentEffect = new GlowEffect(assignTo, (filter as GlowFilter).color, (filter as GlowFilter).alpha, (filter as GlowFilter).blurX,  (filter as GlowFilter).blurY, (filter as GlowFilter).strength, (filter as GlowFilter).quality);
				}
				if(filter is DropShadowFilter) {
					currentEffect = new DropShadowEffect(assignTo, (filter as DropShadowFilter).distance, (filter as DropShadowFilter).angle, (filter as DropShadowFilter).color, (filter as DropShadowFilter).alpha, (filter as DropShadowFilter).blurX,  (filter as DropShadowFilter).blurY, (filter as DropShadowFilter).strength,  (filter as DropShadowFilter).quality,  (filter as DropShadowFilter).inner,  (filter as DropShadowFilter).knockout,  (filter as DropShadowFilter).hideObject);
				}
				if(currentEffect) {
					if(!effect) {
						effect = currentEffect;
						nextChain = currentEffect;
					} else {
						nextChain.addChild(currentEffect);
					}
				}
			}
			
			if(target.transform.colorTransform) {
				currentEffect = new ColorTransformEffect(assignTo, target.transform.colorTransform);
				if(!effect) {
					effect = currentEffect;
				} else {
					nextChain.addChild(currentEffect);
				}
			}
			
			return effect;
		}
	}
}
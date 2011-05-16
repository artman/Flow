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

package com.flow.effects {
	
	import com.flow.components.Component;
	import com.flow.motion.Tween;

	[DefaultProperty("effect")]
	public class EffectTransition extends Transition {
		
		public var fade:Boolean;
		public var effect:Effect;
		
		public function EffectTransition(speed:Number = 0.3, effect:Effect = null, fade:Boolean = true) {
			super(speed);
			this.effect = effect;
			this.fade = fade;
		}

		override protected function initTarget(target:Component):void {
			effect.target = target;
			if(fade) {
				effect.targetAlpha = 0;
			} else {
				effect.value = 1;
			}
		}
		
		override public function animateShow(speed:Number):void {
			if(fade) {
				effect.fadeTargetIn(speed);
			} else {
				effect.animateOut(speed);
			}
		}
		
		override public function animateHide(speed:Number):void {
			var tween:Tween;
			if(fade) {
				tween = effect.fadeTargetOut(speed);
			} else {
				tween = effect.animateIn(speed);
			}
			tween.completeHandler = hideDone;
		}
		
		private function hideDone(tween:Tween):void {
			complete();
		}
	}
}
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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class MaskFilterEffect extends Effect {

		private var _bounds:int;
		protected var maskSprite:Sprite;
		private var cached:Boolean;

		public function MaskFilterEffect(target:DisplayObject = null, bounds:int = 5):void {
			super(target);
			this.bounds = bounds;
		}
		
		public function get bounds():int {
			return _bounds;
		}
		public function set bounds(value:int):void {
			if(value != _bounds) {
				_bounds = value;
				invalidate();
			}
		}

		private function createMask():void {
			if(!maskSprite){
				maskSprite = new Sprite();
				cached = _target.cacheAsBitmap;
				_target.cacheAsBitmap = true;
				maskSprite.cacheAsBitmap = true;
				_target.mask = maskSprite;
				_target.stage.addChild(maskSprite);
			}
		}
		
		
		final override protected function render(val:Number):Array{
			if(val && _target && _target.stage) {
				createMask();
				var bnds:Object = _target.getBounds(_target.stage);
				bnds.x -= bounds;
				bnds.y -= bounds;
				bnds.width += bounds*2;
				bnds.height += bounds*2;
				
				renderMask(val, bnds);
				
				maskSprite.x = bnds.x;
				maskSprite.y = bnds.y;
				maskSprite.width = bnds.width
				maskSprite.height = bnds.height
				
			} else {
				removeMask()
			}
			return [];
		}
		
		private function removeMask():void {
			if(maskSprite) {
				_target.cacheAsBitmap = cached;
				_target.mask = null;
				maskSprite.stage.removeChild(maskSprite);
				maskSprite = null
			}
		}
		
		override public function dispose():void {
			removeMask()
			super.dispose();
		}
		
		protected function renderMask(val:Number, bnds:Object):void {
			throw new Error("MaskFilter cannot be used directly.");
		}
	}
}
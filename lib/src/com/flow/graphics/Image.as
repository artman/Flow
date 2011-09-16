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

package com.flow.graphics {
	
	import com.flow.components.Component;
	import com.flow.effects.Effect;
	import com.flow.net.loaders.DisplayObjectLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class Image extends Component {
		private var _source:*;
		private var _image:DisplayObject;
		private var orgWidth:Number;
		private var orgHeight:Number;
		private var _flipHorizontal:Boolean = false;
		private var _flipVertical:Boolean = false;
		
		private var _fadeInSpeed:Number;
		private var _fadeInEffect:Effect;
		
		private var _loader:DisplayObjectLoader;
		
		public function Image() {
			super();
		}
		
		public function set image(value:DisplayObject):void {
			if(value != _image) {
				_image = value;
				if(_image) {
					orgWidth = _image.width;
					orgHeight = _image.height;
					invalidateProperties();
				}
			}
		}
		public function get image():DisplayObject  {
			return _image;
		}
		
		public function get source():* {
			return _source;
		}
		public function set source(value:*):void  {
			if(value != _source) {
				_source = value;
				if(_source) {
					if(_source is Class) {
						var img:* = new value();
						if(img is BitmapData) {
							img = new Bitmap(img);
						}
						image = img;
					} else if(_source is String || _source is URLRequest) {
						var context:LoaderContext = new LoaderContext(true);
						_loader = new DisplayObjectLoader(_source, null, false, context);
						_loader.addHandlers(loadingComplete);
						_loader.fadeInSpeed = _fadeInSpeed;
						_loader.fadeInEffect = _fadeInEffect;
					}
				} else {
					image = null;
				}
			}
		}
		
		private function loadingComplete(result:DisplayObject):void {
			image = result;
			if(image is Bitmap) {
				(image as Bitmap).smoothing = true;
				(image as Bitmap).pixelSnapping = PixelSnapping.NEVER;
			}
		}

		public function get flipVertical():Boolean {
			return _flipVertical;
		}
		public function set flipVertical(value:Boolean):void {
			if(value != _flipVertical) {
				_flipVertical = value;
				invalidate();
			}
		}
		
		public function get flipHorizontal():Boolean {
			return _flipHorizontal;
		}
		public function set flipHorizontal(value:Boolean):void {
			if(value != _flipHorizontal) {
				_flipHorizontal = value;
				invalidate();
			}
		}
		
		public function get fadeInSpeed():Number {
			return _fadeInSpeed;
		}
		public function set fadeInSpeed(value:Number):void {
			if(value != _fadeInSpeed) {
				_fadeInSpeed = value;
				if(_loader) {
					_loader.fadeInSpeed = _fadeInSpeed;
				}
			}
		}
		
		public function get fadeInEffect():Effect {
			return _fadeInEffect;
		}
		public function set fadeInEffect(value:Effect):void {
			if(value != _fadeInEffect) {
				_fadeInEffect = value;
				if(_loader) {
					_loader.fadeInEffect = _fadeInEffect;
				}
			}
		}
		
		override public function validateProperties():void {
			while(numChildren > 0) {
				removeChildAt(0);
			}
			if(_image) {
				addChild(_image);
			}
		}

		override public function draw(w:Number, h:Number):void {
			super.draw(w, h);
			if (_image) {
				_image.scaleX = _image.scaleY = 1;
				_image.x = _image.y = 0;
		
				if(!(_image is Sprite)) {
					_image.width = w;
					_image.height = h;
				} else {
					_image.scaleX = w/orgWidth;
					_image.scaleY = h/orgHeight;
				}
				if(flipHorizontal) {
					_image.x = _image.width;
					_image.scaleX = -_image.scaleX;
				}
				if(flipVertical) {
					_image.y = _image.height;
					_image.scaleY = -_image.scaleY;
				}
			}
		}
		
		override public function measure():void {
			if(_image) {
				measuredWidth = orgWidth;
				measuredHeight = orgHeight;
			}
		}
	}
}
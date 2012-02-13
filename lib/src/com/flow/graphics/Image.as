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
	
	/**
	 * Displays an external or embedded image. 
	 */	
	public class Image extends Component {
		private var _source:*;
		private var _image:DisplayObject;
		private var orgWidth:Number;
		private var orgHeight:Number;
		private var _flipHorizontal:Boolean = false;
		private var _flipVertical:Boolean = false;
		private var _fadeInSpeed:Number;
		private var _fadeInEffect:Effect;
		private var _smoothing:Boolean = true;
		
		private var _loader:DisplayObjectLoader;
		
		/**
		 * Constructor 
		 */		
		public function Image() {
			super();
		}
		
		/**
		 * A DisplayObject to be displayed. Setting the source property will automatically populate the image-property
		 * accordingly. 
		 */		
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
		
		/**
		 * A source from which to display the image. The source can be a Bitmap-instance, a BitmapData-instance or a URL string from which to load
		 * a Bitmap.
		 */		
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
							img = new Bitmap(img, "auto", _smoothing);
						}
						image = img;
					} else if(_source is String || _source is URLRequest) {
						var context:LoaderContext = new LoaderContext(true);
						_loader = new DisplayObjectLoader(_source, null, false, context);
						_loader.addHandlers(loadingComplete);
						_loader.fadeInSpeed = _fadeInSpeed;
						_loader.fadeInEffect = _fadeInEffect;
					} else if(_source is BitmapData) {
						image = new Bitmap(_source, "auto", _smoothing);
					} else if(_source is Bitmap) {
						image = new Bitmap((_source as Bitmap).bitmapData, "auto", _smoothing)
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
		
		/**
		 * Whether to turn on smoothing if the source has been set to a a Bitmap image.
		 */		
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void {
			if(value != _smoothing) {
				_smoothing = value;
				if(image && image is Bitmap) {
					(image as Bitmap).smoothing = _smoothing;
				}
			}
		}
		
		/**
		 * Whether to flip the image vertically (default false) 
		 */		
		public function get flipVertical():Boolean {
			return _flipVertical;
		}
		public function set flipVertical(value:Boolean):void {
			if(value != _flipVertical) {
				_flipVertical = value;
				invalidate();
			}
		}
		
		/**
		 * Whether to flip the image horizontally (default false) 
		 */	
		public function get flipHorizontal():Boolean {
			return _flipHorizontal;
		}
		public function set flipHorizontal(value:Boolean):void {
			if(value != _flipHorizontal) {
				_flipHorizontal = value;
				invalidate();
			}
		}
		
		/**
		 * When you set the source to a remote URL, the fadeInSpeed property can be used to define the speed of
		 * fading the image in (in seconds) after it has been loaded.
		 */		
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
		
		/**
		 * When you set the source to a remote URL, the fadeInEffect property can be used to define the effect to
		 * use when fading the image in after it has been loaded. The speed of the fade in is defined by fadeInSpeed.
		 */	
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
		
		/** @private */
		override public function validateProperties():void {
			super.validateProperties();
			while(numChildren > 0) {
				removeChildAt(0);
			}
			if(_image) {
				addChild(_image);
			}
		}
		
		/** @privagte */
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
		
		/** @private */
		override public function measure():void {
			if(_image) {
				measuredWidth = orgWidth;
				measuredHeight = orgHeight;
			}
		}
	}
}
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

package com.flow.components {
	
	import flash.events.TextEvent;
	
	/**
	 * A text area component that displays multiple lines of text and can be used by the user to input text. 
	 */	
	public class TextArea extends TextInput {
		
		/** Whether to allow the entry of a carriage return  */		
		public var allowEnter:Boolean = true;
		
		public function TextArea() {
			super();
		}
		
		/** @inheritDoc */
		[SkinPart(required="true")]
		override public function set labelDisplay(value:Label):void {
			super.labelDisplay = value;
			if(_labelDisplay) {
				_labelDisplay.multiline = true;
				_labelDisplay.textField.addEventListener(TextEvent.TEXT_INPUT, textInput);
			}
		}
		override public function get labelDisplay():Label {
			return _labelDisplay;
		}
		
		/** @private */
		protected function textInput(e:TextEvent):void {
			if(!allowEnter && e.text.charCodeAt() == 10) {
				e.preventDefault();
			}
		}
	}
}
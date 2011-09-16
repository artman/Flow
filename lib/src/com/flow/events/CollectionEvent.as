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

package com.flow.events {
	
	import flash.events.Event;
	
	public class CollectionEvent extends Event {

		public static const COLLECTION_CHANGE:String = "collectionChange";
		
		public function CollectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, location:int = -1, oldLocation:int = -1, items:Array = null) {
			super(type, bubbles, cancelable);
			this.kind = kind;
			this.location = location;
			this.oldLocation = oldLocation;
			this.items = items ? items : [];
		}

		public var kind:String;
		public var items:Array;
		public var location:int;
		public var oldLocation:int;
	}
}

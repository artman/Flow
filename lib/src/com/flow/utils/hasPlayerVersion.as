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

package com.flow.utils {
	
	import flash.system.Capabilities;
	
	/**
	 * Checks if the client is running a compatible Flash Player version. 
	 */	
	public function hasPlayerVersion(major:int, minor:int = 0, build:int = 0):Boolean {
		var ver:Array = Capabilities.version.split(" ")[1].split(",");
		var playerMajor:int = parseInt(ver[0]);
		var playerMinor:int = parseInt(ver[1]);
		var playerBuild:int = parseInt(ver[2]);
		if(playerMajor < major) {
			return false;
		} else if(playerMajor == major) {
			if(playerMinor < minor) {
				return false;
			} else if(playerMinor == minor) {
				return playerBuild >= build;
			}
		}
		return true;
	}
}
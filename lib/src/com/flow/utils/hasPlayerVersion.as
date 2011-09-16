package com.flow.utils {
	import flash.system.Capabilities;
		
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
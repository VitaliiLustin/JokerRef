/**
 * Created by Vadim on 17.06.2015.
 */
package com.jokerbros.joker.models {

import flash.events.EventDispatcher;

public class DataModel extends EventDispatcher {

	private var data:Object;

	public function DataModel() {
		data = {};
	}

	public function getData(key:String):Object
	{
		if(data.hasOwnProperty(key)){
			return data[key];
		} else {
			trace(key+": not found");
			return null;
		}
	}

	public function setData(key:String, params:Object):void
	{
		data[key] = params;
	}
}
}

package com.collections 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Set 
	{
		private var _data:Object;
		
		public function Set() 
		{
			this._data = new Object();
		}
		public function flag(name:String)
		{
			this._data[name] = true;
		}
		public function deflag(name:String)
		{
			delete this._data[name];
		}
		
		public function flagged(name:String)
		{
			return this._data.hasOwnProperty(name);
		}
		
		public function get items():Vector.<String>
		{
			var ret:Vector.<String> = new Vector.<String>();
			for (var item:String in this._data)
			{
				ret.push(item);
			}
			return ret;
		}
		public function toString():String
		{
			var ret:String = "";
			for (var item:String in this._data)
			{
				ret += item + " ";
			}
			return ret;
		}
	}

}
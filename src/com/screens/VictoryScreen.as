package com.screens 
{
	import com.Document;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class VictoryScreen extends Screen 
	{
		
		public function VictoryScreen(_parent:Document)
		{
			super(_parent);
			this.title_btn.addEventListener(MouseEvent.CLICK, this.toTitle);
		}
	}
}
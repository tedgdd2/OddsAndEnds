﻿package com.objects 
{
	import flash.display.MovieClip;
	import com.layers.Layer;
	
	public class GameObject extends MovieClip
	{
		// layer its sitting in
		protected var _parent:Layer;
		// velocities
		public var dx:Number;
		public var dy:Number;
		// accelerations
		public var ax:Number;
		public var ay:Number;

		public function GameObject(_parent:Layer) 
		{
			this._parent = _parent;
			this._parent.addChild(this);
			this.dx = 0;
			this.dy = 0;
			this.ax = 0;
			this.ay = 0;
		}
		
		public function get halfWidth():Number
		{
			return Math.floor(this.width / 2);
		}
		public function get halfHeight():Number
		{
			return Math.floor(this.height / 2);
		}
		
		public function get fx():Number
		{
			return this.x + this.fdx;
		}
		public function get fy():Number
		{
			return this.y + this.fdy;
		}
		public function get fdx():Number
		{
			return this.dx + this.ax;
		}
		public function get fdy():Number
		{
			return this.dy + this.ay;
		}
		
		public function get airborne():Boolean
		{
			return this.dy != 0 || this.ay != 0;
		}
		// update velocities and position
		public function onFrame()
		{
			this.dx += this.ax;
			this.dy += this.ay;
			this.x += this.dx;
			this.y += this.dy;
		}
		public function sweepTestCollision(target:GameObject):Object
		{
			var ret:Object = new Object();
			ret["collision"] = false;
			var rdx:Number = this.fdx - target.fdx;
			var rdy:Number = this.fdy - target.fdy;
			
			var xDist:Number = this.fx - target.x;
			var yDist:Number = this.fy - target.y;
			var xRadius:Number = (this.halfWidth + target.halfWidth);
			var yRadius:Number = (this.halfHeight + target.halfHeight);
			
			if (rdx == 0)
			{
				var yTime:Number = (target.y - this.y) / rdy;
				var yTimeMin:Number = Math.min(yTime + yRadius / rdy, yTime - yRadius / rdy);
				if (yTimeMin >= 0 && yTimeMin < 1 && Math.abs(xDist) < xRadius)
				{
					ret["collision"] = true;
					ret["direction"] = "y";
					ret["time"] = yTimeMin;
				}
				
			} else if (rdy == 0)
			{
				var xTime:Number = (target.x - this.x) / rdx;
				var xTimeMin:Number = Math.min(xTime + xRadius / rdx, xTime - xRadius / rdx);
				if (xTimeMin >= 0 && xTimeMin < 1 && Math.abs(yDist) < yRadius)
				{
					ret["direction"] = "x";
					ret["time"] = xTimeMin;
					ret["collision"] = true;
				}
			} else
			{
				var xTime:Number = (target.x - this.x) / rdx;
				var yTime:Number = (target.y - this.y) / rdy;
				
				var xTimeMin:Number = Math.min(xTime + xRadius / rdx, xTime - xRadius / rdx);
				var yTimeMin:Number = Math.min(yTime + yRadius / rdy, yTime - yRadius / rdy);
				if (xTimeMin < 1 && yTimeMin < 1)
				{
					var xTimeMax:Number = Math.max(xTime + xRadius / rdx, xTime - xRadius / rdx); 
					var yTimeMax:Number = Math.max(yTime + yRadius / rdy, yTime - yRadius / rdy);
					
					if (xTimeMin < yTimeMax && yTimeMin < xTimeMax)
					{
						if ((xTimeMin <= yTimeMin || yTimeMin < 0) && xTimeMin >= 0 )
						{
							ret["direction"] = "x";
							ret["time"] = xTimeMin;
							ret["collision"] = true;
						} else if(yTimeMin >= 0)
						{
							ret["direction"] = "y";
							ret["time"] = yTimeMin;
							ret["collision"] = true;
						}
					}
				}
			}
			return ret;
		}
	}
	
}

﻿package com.objects
{
	
	import com.collections.Set;
	import com.layers.Layer;

	// Reprents the player clip
	// does its own velocity and position calculations
	public class Player extends GameObject 
	{
		private var _dir:String;
		private var _pose:String;
		private var _ownedPowerups:Set;
		private var _activePowerups:Set;
		public function Player(layer:Layer) 
		{
			super(layer);
			this._dir = "left";
			this._pose = "standing";
			this._ownedPowerups = new Set();
			this._activePowerups = new Set();
			super._moves = true;
		}
		public override function get halfHeight():Number
		{
			return 40;
		}
		public override function get halfWidth():Number
		{
			return 8;
		}
		
		public function activatePowerup(powerupName:String)
		{
			if (this._ownedPowerups.flagged(powerupName))
				this._activePowerups.flag(powerupName);
		}
		public function deactivatePowerup(powerupName:String)
		{
			if (this._ownedPowerups.flagged(powerupName))
				this._activePowerups.deflag(powerupName);
		}
		
		public function get dir():String 
		{
			return this._dir;
		}
		
		public function set dir(value:String):void 
		{
			this._dir = value;
		}
		
		public function get pose():String 
		{
			return this._pose;
		}
		
		public function set pose(value:String):void 
		{
			this._pose = value;
		}
		
		public function get ownedPowerups():Vector.<String> 
		{
			return this._ownedPowerups.items;
		}
		public function get activePowerups():Vector.<String> 
		{
			return this._activePowerups.items;
		}
		// reset accelerations
		public function resetAcceleration()
		{
			this.ax = 0;
			this.ay = 0;
		}
		public function powerup(name:String)
		{
			this._ownedPowerups.flag(name);
		}
		public override function onFrame()
		{
			super.onFrame();
			if (this.dx == 0)
				this.pose = "standing";
			
			if (this._activePowerups.flagged("spike_shield"))
			{
				this.gotoAndStop((this.pose == "" ? "" : (this.pose + " ")) + "spike " + this._dir);
			} else
			{
				if (this.airborne)
					this.gotoAndStop("jump " + this._dir);
				else
					this.gotoAndStop((this.pose == "" ? "" : (this.pose + " ")) + this._dir);
			}
			if (this.robot_mc.right_arm != null)
				this.robot_mc.right_arm.visible = this._activePowerups.flagged("strong_arm");
			if (this.robot_mc.left_arm != null)
				this.robot_mc.left_arm.visible = this._activePowerups.flagged("strong_arm");
			if (this.robot_mc.lightning_rod != null)
				this.robot_mc.lightning_rod.visible = this._activePowerups.flagged("lightning_rod");
			
		}
	}
}

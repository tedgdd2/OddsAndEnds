﻿package com.layers
{
	import flash.display.MovieClip;
	import com.layers.XMLManager;
	import com.objects.Platform;
	import com.objects.Spikes;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class LevelLayer extends Layer
	{
		//XML_PATH to our level.xml
		
		private var _platforms:Vector.<Platform>;
		private var _spikes:Vector.<Spikes>;
		private var _levelHeight:Number;
		private var _levelWidth:Number;
		private var _loaded:Boolean;
		private var _spawnPoint:Point;
		private var _started:Boolean;
		public function LevelLayer(_parent:MovieClip) 
		{
			super(_parent);
			this._platforms = new Vector.<Platform>();
			this._spikes = new Vector.<Spikes>();
			this._loaded = false;
			this._started = false;
			this._spawnPoint = new Point();
		}
		
		public function get platforms():Vector.<Platform>
		{
			return this._platforms;
		}
		
		public function get levelHeight():Number 
		{
			return this._levelHeight;
		}
		
		public function get levelWidth():Number 
		{
			return this._levelWidth;
		}
		
		public function get spikes():Vector.<Spikes> 
		{
			return _spikes;
		}
		
		public function get spawnPoint():Point 
		{
			return _spawnPoint;
		}
		
		// setups the level
		public override function setup(mediator:LayerMediator):Boolean
		{

			super.setupMediator(mediator, "level");
			
			//The current level
			var currentLevel:Number = 0;
			
			//trace(levelID);
			//Set up the level width and height
			this._levelWidth  = XMLManager.xmlInstance.xml.level[currentLevel].width[0].text();
			this._levelHeight = XMLManager.xmlInstance.xml.level[currentLevel].height[0].text();
			trace("Width: " + _levelWidth + ", Height: " + _levelHeight);
			
			//Set up the spawn point of the level
			this._spawnPoint.x = XMLManager.xmlInstance.xml.level[currentLevel].spawn[0].@x;
			this._spawnPoint.y = XMLManager.xmlInstance.xml.level[currentLevel].spawn[0].@y;
			trace("Spawn X: " + _spawnPoint.x +", Spawn Y:" + _spawnPoint.y);
			
			//Set up the goal, currently not implemented
			/*this._goalPoint.x = XMLManager.xmlInstance.xml.level[currentLevel].goal[0].@x;
			this._goalPoint.y = XMLManager.xmlInstance.xml.level[currentLevel].goal[0].@y;
			trace("goal X: " + _goalPoint.x +", goal Y:" + _goalPoint.y);*/
			
			//Add the platforms
			//For all the remaining elements in the platform section
			for (var i:int = 0; i < XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].*.length(); i++)
			{
				//The platform type to be used in the switch statement
				var platType:String = XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].@type;
				trace(platType);
				
				switch(platType)
				{
					case "platform":
						// platform data is entered as "x,y,width,height"
						//var info:Array = line.split(",");
						var platform:Platform = new Platform(this);
						
						platform.x = XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].@x;
						platform.y = XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].@y;
						platform.width = XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].width[0].text();
						platform.height = XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].height[0].text();
						
						this._platforms.push(platform);
						break;
					case "spike":
						// spike data is entered as "x,y,numspikes,rotation"
						var spikes:Spikes = new Spikes(this);
						
						spikes._length =  XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].width[0];
						spikes._rotation = XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].rotation[0];
						spikes.x =  XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].@x;
						spikes.y =  XMLManager.xmlInstance.xml.level[currentLevel].platforms[0].platform[i].@y;
						
						spikes.setup();
						
						this._spikes.push(spikes);
						break;
					default:
						throw new Error("You have entered an invalid platformtype");
				}
			}
			
			//Create the barriers of the world
			var rightWall:Platform = new Platform(this);
			rightWall.x = -10;
			rightWall.width = 20;
			rightWall.y = this._levelHeight / 2;
			rightWall.height = this._levelHeight + 40;
			
			var leftWall:Platform = new Platform(this);
			leftWall.x = this._levelWidth + 10;
			leftWall.width = 20;
			leftWall.y = this._levelHeight / 2;
			leftWall.height = this._levelHeight + 40;
			
			
			var topWall:Platform = new Platform(this);
			topWall.x = this._levelWidth / 2;
			topWall.width = this._levelWidth + 40;
			topWall.y = -10;
			topWall.height = 20;
			
			var bottomWall:Platform = new Platform(this);
			bottomWall.x = this._levelWidth / 2;
			bottomWall.width = this._levelWidth + 40;
			bottomWall.y = this._levelHeight + 10;
			bottomWall.height = 20;
			
			this._platforms.push(rightWall);
			this._platforms.push(leftWall);
			this._platforms.push(topWall);
			this._platforms.push(bottomWall);
			
			/*
			this._platforms.push(new Platform(this));
			
			this._platforms[0].x = 0;
			this._platforms[0].y = 340;
			
			
			this._platforms.push(new Platform(this));
			
			this._platforms[1].x = 450;
			this._platforms[1].y = 300;
			this._platforms[1].height = 200;
			
			
			this._platforms.push(new Platform(this));
			
			this._platforms[2].x = 200;
			this._platforms[2].y = 150;
			
			this._platforms.push(new Platform(this));
			
			this._platforms[3].x = 320;
			this._platforms[3].y = 481;
			this._platforms[3].width = 880;
			
			this._platforms.push(new Platform(this));
			
			this._platforms[4].x = -5;
			this._platforms[4].y = 240;
			this._platforms[4].width = 10;
			this._platforms[4].height = 500;
			
			
			
			this._spikes.push(new Spikes(this, 4, 0));
			
			this._spikes[0].x = 200;
			this._spikes[0].y = 440;
			
			this._spikes[0].setup();
			*/
		
				//var myTextLoader:URLLoader = new URLLoader();
				//var tempThis:LevelLayer = this;
				//myTextLoader.addEventListener(Event.COMPLETE, function load(e:Event)
				//{
					//tempThis.onLoaded(e, mediator);
				//}
				//);
				//myTextLoader.addEventListener(Event.OPEN, function test(e:Event)
				//{
					//trace("temp");
				//});/

				
				//this._started = true;
			//}
			return true;
		}
		function onLoaded(e:Event, mediator:LayerMediator):void 
		{
			//This is alllllll useless now
			
			//Get the world id

			/*var myArrayOfLines:Array = e.target.data.split("\r\n");
			var state:String = "";
			var states:Array = new Array("platform:", "level:", "spike:", "spawn:", "goal:");
			for each(var line:String in myArrayOfLines)
			{
				if (line.substr(0, 2) == "//")
				{
					// comment line
				} else if (states.indexOf(line) != -1)
				{
					state = line;
				} else
				{
					switch(state)
					{
					platform
					spike
						case "platform:":
							// platform data is entered as "x,y,width,height"
							var info:Array = line.split(",");
							var platform:Platform = new Platform(this);
							
							platform.x = parseInt(info[0]);
							platform.y = parseInt(info[1]);
							platform.width = parseInt(info[2]);
							platform.height = parseInt(info[3]);
							
							this._platforms.push(platform);
							break;
						case "spike:":
							// spike data is entered as "x,y,length,rotation"
							info = line.split(",");
							var spikes:Spikes = new Spikes(this, info[2], info[3]);
							
							spikes.x = parseInt(info[0]);
							spikes.y = parseInt(info[1]);
							
							spikes.setup();
							
							this._spikes.push(spikes);
							break;
						case "spawn:":
							// spawn data is entered in "property:value"
							info = line.split(":");
							if (info[0] == "x")
							{
								this._spawnPoint.x = parseInt(info[1]);
							} else if (info[0] == "y")
							{
								this._spawnPoint.y = parseInt(info[1]);
							}
							break;
						case "level:":
							// level data is entered in "property:value"
							info = line.split(":");
							if (info[0] == "width")
							{
								this._levelWidth = parseInt(info[1]);
							} else if (info[0] == "height")
							{
								this._levelHeight = parseInt(info[1]);
							}
							break;
						case "goal:":
							// goal data is entered in "property:value"
							info = line.split(":");
							if (info[0] == "x")
							{
								this._spawnPoint.x = parseInt(info[1]);
							} else if (info[0] == "y")
							{
								this._spawnPoint.y = parseInt(info[1]);
							}
							break;
							
					}
				}
			}
			
			var rightWall:Platform = new Platform(this);
			rightWall.x = -10;
			rightWall.width = 20;
			rightWall.y = this._levelHeight / 2;
			rightWall.height = this._levelHeight + 40;
			
			var leftWall:Platform = new Platform(this);
			leftWall.x = this._levelWidth + 10;
			leftWall.width = 20;
			leftWall.y = this._levelHeight / 2;
			leftWall.height = this._levelHeight + 40;
			
			
			var topWall:Platform = new Platform(this);
			topWall.x = this._levelWidth / 2;
			topWall.width = this._levelWidth + 40;
			topWall.y = -10;
			topWall.height = 20;
			
			var bottomWall:Platform = new Platform(this);
			bottomWall.x = this._levelWidth / 2;
			bottomWall.width = this._levelWidth + 40;
			bottomWall.y = this._levelHeight + 10;
			bottomWall.height = 20;
			
			this._platforms.push(rightWall);
			this._platforms.push(leftWall);
			this._platforms.push(topWall);
			this._platforms.push(bottomWall);
			
			
							
				
			this._loaded = true;*/
		}
		// calls all the functions
		// that need to be called once a frame
		public override function onFrame():void
		{
		}
		// kills the player clip
		public override function kill():void
		{
			for each(var platform:Platform in this._platforms)
			{
				this.removeChild(platform);
			}
		}
		// fulfills all requests we make
		public override function fulfill(key:String, target:Layer):void
		{
		}
	}
	
}

package {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	
	public class Dungeon extends MovieClip{
		

		public var dungeon:Array;
		
		private var textLoader:URLLoader;
		
		public var refStage:Stage;
		private var soundManager:SoundManager;
		private var trailEffect:TrailEffect;	
		private var gameStateManager:GameStateManager;	
		
		private var inputHandler:InputHandler;
		
		private var playerPosX:uint, playerPosY:uint, playerLastPosX:uint, playerLastPosY:uint;
		private var playerOrientation:String, currentPosition:String;
		//private var prevGraphicsLayout:String;
		private var graphicsLayout:String;
		public var battle:Boolean, treasure:Boolean, escaped:Boolean, allowedToMove:Boolean, end:Boolean;
		
		private var dungeonBackground:DungeonBackground;
		
		public var mintaka:Mintaka;
		public var rigel:Mintaka;
		public var bellatrix:Bellatrix;
		
		public var dungeonTreasure:Treasure;
		public var youWin:YouWin;
		public var gameOver:GameOver;
		
		public var leftPassageway1:LeftPassageway1, leftPassageway2:LeftPassageway2, leftPassageway3:LeftPassageway3, rightPassageway1:RightPassageway1, rightPassageway2:RightPassageway2, rightPassageway3:RightPassageway3;
		public var wall1:Wall1, wall2:Wall2, wall3:Wall3, wall4:Wall4, fog:Fog;
		public var door1:Door1, door2:Door2, door3:Door3, door4:Door4, exit1:Exit1, exit2:Exit2, exit3:Exit3, exit4:Exit4;
		
		public var player:Player;
		
		
		public function Dungeon(path:String, tStage:Stage, tSoundManager:SoundManager, tTrailEffect:TrailEffect, tGameStateManager:GameStateManager) {
			//Loads text file that includes the level layout
			textLoader = new URLLoader();
			textLoader.addEventListener(Event.COMPLETE, FileLoaded);
			//TO DO: change name of file: relative path
			textLoader.load(new URLRequest(path));
			
			battle = false;
			treasure = false;
			escaped = false;
			end = false;
			
			refStage = tStage;
			soundManager = tSoundManager;
			trailEffect = tTrailEffect;
			gameStateManager = tGameStateManager;
			
			leftPassageway1 = new LeftPassageway1();
			leftPassageway2 = new LeftPassageway2();
			leftPassageway3 = new LeftPassageway3();
			rightPassageway1 = new RightPassageway1();
			rightPassageway2 = new RightPassageway2();
			rightPassageway3 = new RightPassageway3();
			
			wall1 = new Wall1();
			wall2 = new Wall2();
			wall3 = new Wall3();
			wall4 = new Wall4();
			
			door1 = new Door1();
			door2 = new Door2();
			door3 = new Door3();
			door4 = new Door4();
			
			exit1 = new Exit1();
			exit2 = new Exit2();
			exit3 = new Exit3();
			exit4 = new Exit4();
			
			fog = new Fog();
	
			dungeonBackground = new DungeonBackground();
			youWin = new YouWin();

			addChild(dungeonBackground);
			
			
			player = new Player(100, 1, soundManager);
			addChild(player);
			player.y = refStage.stageHeight - 100;
			player.x = player.health + 50;
			
			player.DisplayHealthPotions();
			
			allowedToMove = true;
		}
		

		
		private function FileLoaded(e:Event):void {
			dungeon = e.target.data.split("\n");
			
			for(var t:Object in dungeon)
				trace(t + " : " + dungeon[t]);
			trace(dungeon.length);
			trace(dungeon[1].length);
			SpawnPlayer();
		}
		
		
		
		//Update is called every frame
		public function Update():void {
			
			if(player.isDead && end == false){
				end = true;
				soundManager.battle.Stop();
				soundManager.dead.Play();
				gameOver = new GameOver();
				addChild(gameOver);
				allowedToMove=false;
				soundManager.dead.addEventListener("FinishedPlaying", function (event:Event){ gameStateManager.onEscaped() });
			}
			if(!end){
				if(mintaka!=null){
					if(contains(mintaka)){
						if(!mintaka.isDead){
							mintaka.Update(player);
						}else{
							soundManager.battle.Stop();
							soundManager.defeated.Play();
							removeChild(mintaka);
							trailEffect.Disable();
							battle = false;
							player.HideLifeBar();
							soundManager.defeated.addEventListener("FinishedPlaying", BattleOver);
						}
					}
				}
				if(rigel!=null){
					if(contains(rigel)){
						if(!rigel.isDead){
							rigel.Update(player);
						}else{
							soundManager.battle.Stop();
							soundManager.defeated.Play();
							removeChild(rigel);
							trailEffect.Disable();
							battle = false;
							player.HideLifeBar();
							soundManager.defeated.addEventListener("FinishedPlaying", BattleOver);
						}
					}
				}
				if(bellatrix!=null){
					if(contains(bellatrix)){
						if(!bellatrix.isDead){
							bellatrix.Update(player);
						}else{
							soundManager.battle.Stop();
							soundManager.defeated.Play();
							removeChild(bellatrix);
							trailEffect.Disable();
							battle = false;
							player.HideLifeBar();
							soundManager.defeated.addEventListener("FinishedPlaying", BattleOver);
						}
					}
				}
			}
			
			
			
			/*
			if(dungeonBackground.currentLabel != null){
				if(dungeonBackground.currentLabel.slice(-1) == "S"){
					dungeonBackground.stop();
				}
			}
			*/
			//mintaka.Update();
			//DrawGraphics();
		}
		
		public function BattleOver(event:Event):void{
			if(dungeonTreasure!=null)
				if(contains(dungeonTreasure))
					removeChild(dungeonTreasure);
			soundManager.dungeon.Play();
			allowedToMove = true;
		}
		
		private function DrawGraphics():void {

			if(contains(leftPassageway1)) removeChild(leftPassageway1);
			if(contains(leftPassageway2)) removeChild(leftPassageway2);
			if(contains(leftPassageway3)) removeChild(leftPassageway3);
			if(contains(rightPassageway1)) removeChild(rightPassageway1);
			if(contains(rightPassageway2)) removeChild(rightPassageway2);
			if(contains(rightPassageway3)) removeChild(rightPassageway3);
			if(contains(wall1)) removeChild(wall1);
			if(contains(wall2)) removeChild(wall2);
			if(contains(wall3)) removeChild(wall3);
			if(contains(wall4)) removeChild(wall4);
			if(contains(door1)) removeChild(door1);
			if(contains(door2)) removeChild(door2);
			if(contains(door3)) removeChild(door3);
			if(contains(door4)) removeChild(door4);
			if(contains(exit1)) removeChild(exit1);
			if(contains(exit2)) removeChild(exit2);
			if(contains(exit3)) removeChild(exit3);
			if(contains(exit4)) removeChild(exit4);
			if(contains(fog)) removeChild(fog);
			
			var current:String = null;
			
			for (var i:uint = 0; i < graphicsLayout.length ; i++){
				
				current = graphicsLayout.slice(i,i+1);
				
				if(current == "L"){
					if(i == 0){
						addChild(leftPassageway1);
					}else if(i==1){
						addChild(leftPassageway2);
					}else if(i==2){
						addChild(leftPassageway3);
					}else if(i==3){
						addChild(fog);
					}
				}else if(current == "R"){
					if(i == 0){
						addChild(rightPassageway1);
					}else if(i==1){
						addChild(rightPassageway2);
					}else if(i==2){
						addChild(rightPassageway3);
					}else if(i==3){
						addChild(fog);
					}
				}else if(current == "B"){
					if(i == 0){
						addChild(leftPassageway1);
						addChild(rightPassageway1);
					}else if(i==1){
						addChild(leftPassageway2);
						addChild(rightPassageway2);
					}else if(i==2){
						addChild(leftPassageway3);
						addChild(rightPassageway3);
					}else if(i==3){
						addChild(fog);
					}
				}else if(current == "X"){
					if(i == 0){
						addChild(wall1);	
						break;
					}else if(i==1){
						addChild(wall2);
						break;
					}else if(i==2){
						addChild(wall3);
						break;
					}else{
						addChild(wall4);
						addChild(fog);
						break;
					}
				}else if(current == "D"){
					if(i == 0){
						addChild(door1);
						break;
					}else if(i==1){
						addChild(door2);
						break;
					}else if(i==2){
						addChild(door3);
						break;
					}else{
						addChild(door4);
						break;
					}
	
				}else if(current == "J"){
					if(i == 0){
						addChild(exit1);
						break;
					}else if(i==1){
						addChild(exit2);
						break;
					}else if(i==2){
						addChild(exit3);
						break;
					}else{
						addChild(exit4);
						break;
					}
				}
				
			}
			
			setChildIndex(player,numChildren-1);

		}
		
		
		
		private function SpawnPlayer():void{
			
			var i:uint = 0, j:uint = 0;
			
			var entranceFound:Boolean = false;
		
			while(i < dungeon.length && entranceFound != true) {
				while(j<dungeon[i].length-1 && entranceFound!=true){
					if(dungeon[i].charAt(j)=='E'){
						playerPosX=j;
						playerPosY=i;
						entranceFound=true;
					}
					j++;
				}
				i++;
				j=0;
			}
			
			//Determines player's initial orientation E1
			if(playerPosY!=0){
				if(dungeon[playerPosY-1].charAt(playerPosX)=='1'){
					playerPosY--;
					playerOrientation='N';
				}
			}
			if(playerPosY!=dungeon.length-2){
				if(dungeon[playerPosY+1].charAt(playerPosX)=='1'){
					playerPosY++;
					playerOrientation='S';
				}
			}
			if(playerPosX!=0){
				if(dungeon[playerPosY].charAt(playerPosX-1)=='1'){
					playerPosX--;
					playerOrientation='W';
				}
			}
			if(playerPosX!=dungeon[playerPosY].length-2){
				if(dungeon[playerPosY].charAt(playerPosX+1)=='1'){
					playerPosX++;
					playerOrientation='E';
				}
			}
			
			playerLastPosX = playerPosX;
			playerLastPosY = playerPosY;
			
			trace("Player Position: X="+playerPosX+" Y="+playerPosY);
			trace("Player Orientation: "+playerOrientation);
			trace("Current Position: "+dungeon[playerPosY].charAt(playerPosX));
			
			UpdateGraphics();
			
			
		}
		
		private function UpdateGraphics():void{
			
			var i:uint = playerPosY, j:uint = playerPosX;
			var nextChar:String;
			var end:Boolean = false;
			
			//prevGraphicsLayout = graphicsLayout;
			graphicsLayout="";

			do{
				nextChar="0";
				if((i==0 && playerOrientation=="N") || (i==dungeon.length-1 && playerOrientation=="S") || (j==0 && playerOrientation=="W") || (j==dungeon[i].length-2 && playerOrientation=="E")){
					nextChar="X";
				}else if(playerOrientation=="N"){
					if(dungeon[i-1].charAt(j)=="X"){ //If the next cell is a wall
						nextChar="X";
					}else if(dungeon[i-1].charAt(j)=="D"){ //If the next cell is a door
						nextChar="D";
					}else if(dungeon[i-1].charAt(j)=="E"){ //If the next cell is the main entrance (door)
						nextChar="J";  
					}else{
						if(j>0){
							if(dungeon[i-1].charAt(j-1)!="X"){
								nextChar="L";
							}
						}
						if(j<dungeon[i].length-2){
							if(dungeon[i-1].charAt(j+1)!="X"){
								if(nextChar=="L"){
									nextChar="B";
								}else{
									nextChar="R";
								}
							}
						}
						i--;
					}
				}else if(playerOrientation=="W"){
					if(dungeon[i].charAt(j-1)=="X"){
						nextChar="X";
					}else if(dungeon[i].charAt(j-1)=="D"){
						nextChar="D";
					}else if(dungeon[i].charAt(j-1)=="E"){
						nextChar="J"; 
					}else{
						if(i>0){
							if(dungeon[i-1].charAt(j-1)!="X"){
								nextChar="R";
							}
						}
						if(i<dungeon.length-1){
							if(dungeon[i+1].charAt(j-1)!="X"){
								if(nextChar=="R")  nextChar="B";
								else nextChar="L";
							}
						}
						j--;
					}
				}else if(playerOrientation=="S"){
					if(dungeon[i+1].charAt(j)=="X"){
						nextChar="X";
					}else if(dungeon[i+1].charAt(j)=="D"){
						nextChar='D';
					}else if(dungeon[i+1].charAt(j)=="E"){
						nextChar="J"; 
					}else{
						if(j>0){
							if(dungeon[i+1].charAt(j-1)!="X"){
								nextChar="R";
							}
						}
						if(j<dungeon[i].length-2){
							if(dungeon[i+1].charAt(j+1)!="X"){
								if(nextChar=="R")  nextChar="B";
								else nextChar="L";
							}
						}
						i++;
					}
				}else if(playerOrientation=="E"){
					if(dungeon[i].charAt(j+1)=="X"){
						nextChar="X";
					}else if(dungeon[i].charAt(j+1)=="D"){
						nextChar="D";
					}else if(dungeon[i].charAt(j+1)=="E"){
						nextChar="J"; 
					}else{
						if(i>0){
							if(dungeon[i-1].charAt(j+1)!="X"){
								nextChar="L";
							}
						}
						if(i<dungeon.length-1){
							if(dungeon[i+1].charAt(j+1)!="X"){
								if(nextChar=="L")  nextChar="B";
								else nextChar="R";
							}
						}
						j++;
					}
				}
				graphicsLayout += nextChar;
			}while(graphicsLayout.length < 4);
			
			DrawGraphics();
			
			trace("Graphics Layout: "+graphicsLayout);
		}
		

		public function MovePlayer(direction:String):void{
			
			playerLastPosX = playerPosX;
			playerLastPosY = playerPosY;
			
			if(direction=="left"){//Turn Left
				if(playerOrientation=="N") playerOrientation="W";
				else if(playerOrientation=="W") playerOrientation="S";
				else if(playerOrientation=="S") playerOrientation="E";
				else if(playerOrientation=="E") playerOrientation="N";
			}else if(direction=="right"){//Turn Right
				if(playerOrientation=="N") playerOrientation="E";
				else if(playerOrientation=="W") playerOrientation="N";
				else if(playerOrientation=="S") playerOrientation="W";
				else if(playerOrientation=="E") playerOrientation="S";
			}else if(direction=="forward"){//Step Forward
				if(playerOrientation=="N" && playerPosY!=0){
					if(CanMove(playerPosX,playerPosY-1)){
						playerPosY--;
						if(dungeon[playerPosY].charAt(playerPosX)=="D") playerPosY--;
					}
				}else if(playerOrientation=="W" && playerPosX!=0){
					if(CanMove(playerPosX-1,playerPosY)){
						playerPosX--;
						if(dungeon[playerPosY].charAt(playerPosX)=="D") playerPosX--;
					}
				}else if(playerOrientation=="S" && playerPosY!=dungeon.length-1){
					if(CanMove(playerPosX,playerPosY+1)){
						playerPosY++;
						if(dungeon[playerPosY].charAt(playerPosX)=="D") playerPosY++;
					}
				}else if(playerOrientation=="E" && playerPosX!=dungeon[playerPosY].length-2){
					if(CanMove(playerPosX+1,playerPosY)){
						playerPosX++;
						if(dungeon[playerPosY].charAt(playerPosX)=="D") playerPosX++;
					}
				}
			}
			
			currentPosition = dungeon[playerPosY].charAt(playerPosX);
			

			trace("Player Position: X="+playerPosX+" Y="+playerPosY);
			trace("Player Orientation: "+playerOrientation);
			trace("Current Position: "+currentPosition);
			
			UpdateGraphics();
			Escaped();
			Battle();
		}
		
		private function Battle():void{
			
			switch(currentPosition){
				case "M"://Mintaka
					trace("Battles Mintaka!");
					soundManager.dungeon.Stop();
					soundManager.battle.Play(0);
					trailEffect.Enable();
					player.DisplayLifeBar();
					RemoveMonster();
					mintaka = new Mintaka(20, soundManager, trailEffect);
					addChild(mintaka);
					allowedToMove=false;
					battle=true;
					break;
				case "B"://Bellatrix
					trace("Battles Bellatrix!");
					soundManager.dungeon.Stop();
					soundManager.battle.Play(0);
					trailEffect.Enable();
					player.DisplayLifeBar();
					RemoveMonster();
					bellatrix = new Bellatrix(15, soundManager, trailEffect);
					bellatrix.width -= bellatrix.width/4;
					bellatrix.height -= bellatrix.height/4;
					addChild(bellatrix);
					allowedToMove=false;
					battle=true;
					break;
				case "R"://Rigel
					trace("Battles Rigel!");
					soundManager.dungeon.Stop();
					soundManager.battle.Play(0);
					trailEffect.Enable();
					player.DisplayLifeBar();
					RemoveMonster();
					rigel = new Mintaka(15, soundManager, trailEffect);
					rigel.width -= rigel.width/4;
					rigel.height -= rigel.height/4;
					addChild(rigel);
					allowedToMove=false;
					battle=true;
					break;
				case "T"://Treasure
					if(!treasure){
						soundManager.dungeon.Stop();
						soundManager.treasure.Play();
						dungeonTreasure = new Treasure();
						addChild(dungeonTreasure);
						allowedToMove=false;
						soundManager.treasure.addEventListener("FinishedPlaying", BattleOver);
						treasure=true;
					}
					break;
				case "P"://Potion
					RemoveMonster();
					player.PickUpPotion();
					break;
			}
		}
		private function RemoveMonster():void{
			if(playerPosY==0){
				dungeon[playerPosY] = "0"+dungeon[playerPosY].substr(1,dungeon[playerPosY].length-1);
			}else if(playerPosY==dungeon[playerPosY].length){
				dungeon[playerPosY] = dungeon[playerPosY].substr(0,dungeon[playerPosY].length-2)+"0";
			}else{
				dungeon[playerPosY] = dungeon[playerPosY].substr(0,playerPosX)+"0"+dungeon[playerPosY].substr(playerPosX+1,dungeon[playerPosY].length-1);
			}
		}
		
		private function Escaped():void{
			if(currentPosition=="E" && treasure){
				trace("Escaped!");
				soundManager.dungeon.Stop();
				soundManager.stairs.Play();
				soundManager.ending.Play();
				soundManager.ending.addEventListener("FinishedPlaying", function (event:Event){ gameStateManager.onEscaped() });
				addChild(youWin);
				end=true;
				allowedToMove=false;
				escaped=true;
			}
		}
		
		private function CanMove(posX:uint, posY:uint):Boolean{
			if(treasure && dungeon[posY].charAt(posX)=="E" && currentPosition=="1"){
				return true;
			}else{
				return dungeon[posY].charAt(posX)!="X" && dungeon[posY].charAt(posX)!="E";
			}
		}

		

	}
}
package  {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	
	public class Mintaka extends Enemy {
		
		
		public var inPoint:Point;
		public var topEntryPoint:Point, bottomEntryPoint:Point, topExitPoint:Point, bottomExitPoint:Point;
		
		public var weakArea:MovieClip;
		
		var soundManager:SoundManager;	
		var trailEffect:TrailEffect;
		
		var lastMousePosition:Point, currentMousePosition:Point;
		
		var currentState:String;
		var idleCycle:uint;
	
		var fireball:Fireball;
		
		var red:RedPoint;

		public function Mintaka(tHealth:Number, tSoundManager:SoundManager, tTrailEffect:TrailEffect){
			
			health = tHealth;
			
			soundManager = tSoundManager;
			trailEffect = tTrailEffect;
			
			x=650;
			y=350;
			
			
			weakArea = new MovieClip;
			var weakRect:Shape = new Shape;
			weakRect.graphics.beginFill(0x00FF00, 0.0); 
			weakRect.graphics.drawRect(-40, -20, 80, 120); 
			weakRect.graphics.endFill();
			weakArea.addChild(weakRect);
			
			
			weakArea.addEventListener(MouseEvent.ROLL_OVER, printInPoint);
			weakArea.addEventListener(MouseEvent.ROLL_OUT, printOutPoint);
			
			
			
			inPoint = new Point;
			
			lastMousePosition = new Point;
			currentMousePosition = new Point;
			
			idleCycle = randomNumberInRange(2,4);
			ChangeState("Idle");
		}
		

		//Update is called every frame
		public function Update(player:Player):void {
			lastMousePosition = currentMousePosition;
			currentMousePosition = globalToLocal(new Point(stage.mouseX, stage.mouseY));
			if(!isDead){
				if(currentLabel == "BackToIdleE"){
					if(contains(weakArea))
						removeChild(weakArea);
					
				}
				
				if(currentLabel.slice(-1) == "E"){
					if(idleCycle>0){
						currentState = "Idle";
						idleCycle--;
					}else{// Enemy charges and exposes weak area
						currentState = "Charge";
						addChild(weakArea);
						idleCycle = randomNumberInRange(2,4);
					}
	
					gotoAndPlay(currentState);
				}
				if(currentLabel == "Attack"){
					fireball = new Fireball();
					addChild(fireball);
				}
				if(fireball!=null){
					if(contains(fireball) && fireball.finishedPlaying){
						if(player.shieldUp){ //Detects if player is using shield
							soundManager.shield.Play(); //Player avoids fireball
						}else{
							soundManager.playerhit.Play();//Player Gets Hit By Fireball
							player.DamagePlayer(10);
							player.DisplayLifeBar();
						}
						removeChild(fireball);
					}
				}
			}else{
				stop();
			}
			
		}
		
		public function randomNumberInRange(min:uint, max:uint):uint{
			return (Math.floor(Math.random() * (max - min + 1)) + min);
		}
		
		public function ChangeState(state:String):void{
			switch(state){
				case "Idle":
					currentState = "Idle";
					gotoAndPlay("Idle");
					break;
				case "Charge":
					currentState = "Charge";
					gotoAndPlay("Charge");
					break;
				case "Attack":
					currentState = "Attack";
					gotoAndPlay("Attack");
					break;
			}
		}
	
		//trace(weakArea.getRect(weakArea).topLeft);
		
		public function printInPoint(event:MouseEvent):void{
			
			
			topEntryPoint = GetLineIntersectionPoint(lastMousePosition, new Point(event.localX, event.localY), new Point(-40.0, -20.0), new Point(40.0, -20.0));
			bottomEntryPoint = GetLineIntersectionPoint(lastMousePosition, new Point(event.localX, event.localY), new Point(-40.0, 100.0), new Point(40.0, 100.0));
			
			/*if(topEntryPoint){
				red = new RedPoint(topEntryPoint);
				weakArea.addChild(red);
			}else if(bottomEntryPoint){
				red = new RedPoint(bottomEntryPoint);
				weakArea.addChild(red);
			}*/

			
		}
		
		public function printOutPoint(event:MouseEvent):void{
			
			topExitPoint = GetLineIntersectionPoint(lastMousePosition, new Point(event.localX, event.localY), new Point(-40.0, -20.0), new Point(40.0, -20.0));
			bottomExitPoint = GetLineIntersectionPoint(lastMousePosition, new Point(event.localX, event.localY), new Point(-40.0, 100.0), new Point(40.0, 100.0));

			/*if(topExitPoint){
				red = new RedPoint(topExitPoint);
				weakArea.addChild(red);
			}else if(bottomExitPoint){
				red = new RedPoint(bottomExitPoint);
				weakArea.addChild(red);
			}*/

			if(trailEffect.active == true){
				if(topEntryPoint!=null){
					//Entered through the top
	
					if(bottomExitPoint!=null){ 
						//Left through the bottom
						GetsHit();
						soundManager.mintakaHurt.Play();
					}else{
						soundManager.miss.Play();
					}
				}else if(bottomEntryPoint!=null){
					//Entered through the bottom
	
					if(topExitPoint!=null){
						//Left through the top
						GetsHit();
						soundManager.mintakaHurt.Play();
					}else{
						soundManager.miss.Play();
					}
				}else{
					soundManager.miss.Play();
					//Entered through one side
				}
			}
			
			

		}

	}
	
}

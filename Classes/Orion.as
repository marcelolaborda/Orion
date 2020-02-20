package {
	
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.utils.Timer;	
	import flash.events.TimerEvent;
	
	public class Orion extends MovieClip {
		
		public var inputHandler:InputHandler;
		public var screenManager:ScreenManager;
		public var soundManager:SoundManager;
		
		public var trailEffect:TrailEffect;
		public var shield:Shield;
		
		var healthBarTimer:Timer;

		
		public function Orion(){
			
			
			trailEffect = new TrailEffect(stage);
			soundManager = new SoundManager();
			inputHandler = new InputHandler(stage);
			screenManager = new ScreenManager(stage, soundManager,trailEffect);
			
			shield = new Shield();

			addEventListener(Event.ENTER_FRAME,Update);
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			healthBarTimer = new Timer(2000,1);
			healthBarTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function (event:Event){ screenManager.level.player.HideLifeBar() });
		}
		
		//Game loop - Update is called every frame
		private function Update(event:Event):void {
			
			
			screenManager.Update();


			if(inputHandler.keyPressed.esc){//Press ESC to quit game
				inputHandler.keyPressed.esc = false;
				fscommand("quit");
			}

			if(screenManager.level!=null){
				if(!screenManager.level.end){
					if(inputHandler.keyPressed.one){
						inputHandler.keyPressed.one = false;
						if(screenManager.level.player.potions>0){
							screenManager.level.player.UsePotion();
							screenManager.level.player.DisplayLifeBar();
							if(!screenManager.level.battle){
								healthBarTimer.reset();
								healthBarTimer.start();
							}
						}else{
							soundManager.empty.Play();
						}
					}
					if(screenManager.level.battle){
						if(inputHandler.keyPressed.e){
							trailEffect.Disable();
							if(!stage.contains(shield)){
								stage.addChild(shield);
								screenManager.level.player.ShieldUp();
	
							}
						}else{
							trailEffect.Enable();
							if(stage.contains(shield)){
								stage.removeChild(shield);
								screenManager.level.player.ShieldDown();
							}
						}
					}else if(screenManager.currentScreen == "Dungeon" && screenManager.level.allowedToMove){
						if(inputHandler.keyPressed.left){
							screenManager.level.MovePlayer("left");
							inputHandler.keyPressed.left = false;
						}
	
						if(inputHandler.keyPressed.right){
							screenManager.level.MovePlayer("right");
							inputHandler.keyPressed.right = false;
						}
						
						if(inputHandler.keyPressed.up){
							screenManager.level.MovePlayer("forward");
							inputHandler.keyPressed.up = false;
						}
						
					}
				}
			}


			if(screenManager.currentScreen == "TitleScreen" && inputHandler.keyPressed.enter){
				screenManager.PressedStart();
			}
			
			if(screenManager.currentScreen == "IntroScreen" && inputHandler.keyPressed.enter){
				screenManager.SkippedIntro();
			}
			
		}
	}
	
}
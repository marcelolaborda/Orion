package {
	
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	
	
	public class ScreenManager {
		

		private var stage:Stage;
		//private var screens:Object = {openingCreditsScreen:OpeningCreditsScreen};
		private var openingCreditsScreen:OpeningCreditsScreen;
		private var titleScreen:TitleScreen;
		private var introScreen:IntroScreen;
		
		public var level:Dungeon;
		
		public var currentScreen:String;
		
		public var gameStateManager:GameStateManager;
		public var soundManager:SoundManager;
		public var trailEffect:TrailEffect;
		
		private var titleTimeoutListener:Function;
		
		public function ScreenManager (tStage:Stage, tSoundManager:SoundManager, tTrailEffect:TrailEffect){
			stage = tStage;
			soundManager = tSoundManager;
			trailEffect = tTrailEffect;
			
			openingCreditsScreen = new OpeningCreditsScreen;
			titleScreen = new TitleScreen;
			introScreen = new IntroScreen;
			
			currentScreen = "";
		
			gameStateManager = new GameStateManager;
			gameStateManager.addEventListener("GameLoaded", ScreenHandler);
			gameStateManager.addEventListener("CreditsOver", ScreenHandler);
			gameStateManager.addEventListener("TitleScreenTimeout", ScreenHandler);
			gameStateManager.addEventListener("PressedStart", ScreenHandler);
			gameStateManager.addEventListener("IntroOver", ScreenHandler);
			gameStateManager.addEventListener("FinishedGame", ScreenHandler);
			//gameState.addEventListener( Event.COMPLETE, DrawOpeningCreditsScreen );
			//gameState = new GameState(GameState.LOADED);
			//addEventListener( Event.COMPLETE, DrawOpeningCreditsScreen );
			//stage.addChild(openingCreditsScreen);
			
			DrawOpeningCreditsScreen();
			//DrawDungeonScreen();
		}
		
		
		//Update is called every frame
		public function Update():void {
			if(level!=null){
				level.Update();
			}
			
		}
		
		
		public function ScreenHandler(event:Event):void{
			
			switch (event.type) {	
				
				case "GameLoaded" :
					DrawOpeningCreditsScreen();
					break;
				case "CreditsOver" :
					RemoveOpeningCreditsScreen();
					DrawTitleScreen();
					break;
				case "TitleScreenTimeout" :
					RemoveTitleScreen();
					DrawOpeningCreditsScreen();
					break;
				case "PressedStart":
					RemoveTitleScreen();
					DrawIntroScreen();
					break;
				case "IntroOver" :
					RemoveIntroScreen();
					DrawDungeonScreen();
					break;
				case "FinishedGame" :
					RemoveDungeonScreen();
					DrawOpeningCreditsScreen();
					break;
		
			}
		}
		
		

		
		public function DrawOpeningCreditsScreen():void {
			trace("OpeningCredits Added");
			currentScreen = "OpeningCredits";
			if(!stage.contains(openingCreditsScreen)){
				stage.addChild(openingCreditsScreen);
				soundManager.opening.Play();
				if(!soundManager.opening.hasEventListener("FinishedPlaying"))
					soundManager.opening.addEventListener("FinishedPlaying", function (event:Event){ gameStateManager.onCreditsOver() });
			}
		}
		
		public function RemoveOpeningCreditsScreen():void {
			trace("OpeningCredits Removed");
			if(stage.contains(openingCreditsScreen)){
				stage.removeChild(openingCreditsScreen);
			}
		}
		
		public function DrawTitleScreen():void{
			trace("TitleScreen Added");
			currentScreen = "TitleScreen";
			if(!stage.contains(titleScreen)){
				stage.addChild(titleScreen);
				soundManager.theme.Play();
				if(!soundManager.theme.hasEventListener("FinishedPlaying")){
					titleTimeoutListener = function (event:Event){ gameStateManager.onTitleScreenTimeout() };
					soundManager.theme.addEventListener("FinishedPlaying", titleTimeoutListener);
				}
			}
		}
		
		public function PressedStart():void{
			currentScreen = "";
			if(soundManager.theme.hasEventListener("FinishedPlaying")){
				soundManager.theme.Stop();
				soundManager.theme.removeEventListener("FinishedPlaying", titleTimeoutListener);
				soundManager.start.Play();
				soundManager.start.addEventListener("FinishedPlaying", function (event:Event){ gameStateManager.onPressedStart() });
			}
		}
		
		public function SkippedIntro():void{
			soundManager.intro.Stop();
			gameStateManager.onIntroOver();
		}
				
		public function RemoveTitleScreen():void {
			trace("TitleScreen Removed");
			if(stage.contains(titleScreen)){
				stage.removeChild(titleScreen);
			}
		}
		
		public function DrawIntroScreen():void {
			trace("IntroScreen Added");
			currentScreen = "IntroScreen";
			if(!stage.contains(introScreen)){
				stage.addChild(introScreen);
				soundManager.intro.Play();
			}
			
		}
		
		public function RemoveIntroScreen():void {
			trace("IntroScreen Removed");
			if(stage.contains(introScreen)){
				stage.removeChild(introScreen);
			}
		}
		
		public function DrawDungeonScreen():void{
			trace("DungeonScreen Added");
			currentScreen = "Dungeon";
			level = new Dungeon("Dungeons/dungeon.txt", stage, soundManager, trailEffect, gameStateManager);
			if(!stage.contains(level)){
				stage.addChild(level);
				soundManager.dungeon.Play();
			}
		}
		
		public function RemoveDungeonScreen():void {
			trace("DungeonScreen Removed");
			if(stage.contains(introScreen)){
				stage.removeChild(introScreen);
			}
		}
	}
}
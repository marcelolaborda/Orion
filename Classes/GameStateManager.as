package {
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class GameStateManager extends EventDispatcher {
		
		public function GameStateManager() {
			trace("ScreenTransition Constructor");
		}
		
		public function onFinishedLoading():void {
			dispatchEvent(new Event("GameLoaded"));
		}
		
		public function onCreditsOver():void {
			dispatchEvent(new Event("CreditsOver"));
		}
		
		public function onTitleScreenTimeout():void {
			dispatchEvent(new Event("TitleScreenTimeout"));
		}
		
		public function onPressedStart():void {
			dispatchEvent(new Event("PressedStart"));
		}
		
		public function onIntroOver():void {
			dispatchEvent(new Event("IntroOver"));
		}
		
		public function onEscaped():void {
			dispatchEvent(new Event("FinishedGame"));
		}
		
	}
}
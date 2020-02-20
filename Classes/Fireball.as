package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Fireball  extends MovieClip {
		
		var finishedPlaying:Boolean;
		
		public function Fireball() {
			addEventListener(Event.ENTER_FRAME, Update);
			finishedPlaying = false;
		}
		
		function Update(event:Event):void{
			if(currentLabel == "Destroy"){
				finishedPlaying = true;
				stop();
			}
				
		}
	}
}
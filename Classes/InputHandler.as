package {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class InputHandler extends EventDispatcher {
	
		public var keyPressed:Object = {left:false,right:false,up:false,down:false,enter:false,e:false,one:false,esc:false};
		private var stage:Stage;
		private var listener:Function;
		
		public function InputHandler(tStage:Stage){
			stage = tStage;
			listener = function (event:KeyboardEvent){ KeyEvent(event,true) };
			stage.addEventListener(KeyboardEvent.KEY_DOWN, listener);
			stage.addEventListener(KeyboardEvent.KEY_UP, function (event:KeyboardEvent){ KeyEvent(event,false) });
		}
		
		//Listens for key events
		//sets "keyPressed" properties to true when a key is pressed down
		//sets "keyPressed" properties to false when a key is released
		private function KeyEvent(key:KeyboardEvent, keyState:Boolean):void{
			if(keyState == true){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, listener);
			}else{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, listener);
			}
			switch(key.keyCode){
				case Keyboard.LEFT:
					keyPressed.left = keyState;
					break;
				case Keyboard.A:
					keyPressed.left = keyState;
					break;
				case Keyboard.RIGHT:
					keyPressed.right = keyState;
					break;
				case Keyboard.D:
					keyPressed.right = keyState;
					break;
				case Keyboard.UP:
					keyPressed.up = keyState;
					break;
				case Keyboard.W:
					keyPressed.up = keyState;
					break;
				case Keyboard.DOWN:
					keyPressed.down = keyState;
					break;
				case Keyboard.S:
					keyPressed.down = keyState;
					break;
				case Keyboard.ENTER:
					keyPressed.enter = keyState;
					break;
				case Keyboard.E:
					keyPressed.e = keyState;
					break;
				case Keyboard.NUMBER_1:
					keyPressed.one = keyState;
					break;
				case Keyboard.ESCAPE:
					keyPressed.esc = keyState;
					break;
				default:
					keyPressed.enter = keyState;
					break;
			}
			
		}
	}
}
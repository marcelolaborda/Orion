package {
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TrailEffect {
		
		public var stage:Stage;
		
		public var lastMousePosition:Object = {x: 0.0, y: 0.0};
		
		public var fadeFunction:Function;
		
		public var eventFunctions:Object;
		public var eventNumber:uint;
		
		public var active:Boolean;
		
		public function TrailEffect(tStage:Stage) {
			stage = tStage;

			active = false;
			
			eventFunctions = new Object;
			eventNumber = 0;

		}
		
		public function Update() {

		}
		
		public function Enable():void{
			if(!stage.hasEventListener(MouseEvent.MOUSE_DOWN) && !stage.hasEventListener(MouseEvent.MOUSE_UP))
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		public function Disable():void{
			active = false;
			if(stage.hasEventListener(MouseEvent.MOUSE_DOWN) && stage.hasEventListener(MouseEvent.MOUSE_UP) && stage.hasEventListener(MouseEvent.MOUSE_MOVE))
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
	
		public function AddTrailSection(currentMousePositionX:Number, currentMousePositionY:Number):void {
			var trailSection:Shape = new Shape();
			trailSection.graphics.lineStyle(20, 0xFFFFFF, 1, false, "normal", "none");
			trailSection.graphics.moveTo(lastMousePosition.x, lastMousePosition.y);
			trailSection.graphics.lineTo (currentMousePositionX, currentMousePositionY);
			
			fadeFunction = FadeTrailSection(lastMousePosition.x, lastMousePosition.y, currentMousePositionX, currentMousePositionY, eventNumber);
			eventFunctions["event"+eventNumber] = fadeFunction;
			eventNumber++;
			trailSection.addEventListener (Event.ENTER_FRAME, fadeFunction);

			stage.addChild(trailSection);
			lastMousePosition.x = currentMousePositionX;
			lastMousePosition.y = currentMousePositionY;
		}
		
		public function FadeTrailSection(fromX:Number, fromY:Number, toX:Number, toY:Number, fadeFunctionId:uint):Function {
			return function(event:Event):void {
				if(event.target.alpha >= 0.0){
					event.target.graphics.clear();
					event.target.graphics.lineStyle(20 * event.target.alpha, 0xFFFFFF, 1, false, "normal", "none");
					event.target.graphics.moveTo(fromX, fromY);
					event.target.graphics.lineTo(toX, toY);
					event.target.alpha -= 0.05;
	
				}else{
					event.target.removeEventListener (Event.ENTER_FRAME, eventFunctions["event"+fadeFunctionId]);
					delete eventFunctions["event"+fadeFunctionId];
					stage.removeChild((Shape)(event.target));
				}
			};
		}
		
		
		public function mouseDownHandler(event:MouseEvent):void {
			active = true;
			lastMousePosition.x = event.stageX;
			lastMousePosition.y = event.stageY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void {
			AddTrailSection(event.stageX, event.stageY);

		}    
		
		private function mouseUpHandler(event:MouseEvent):void {
			active = false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
	}
}
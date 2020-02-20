package  {
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import flashx.textLayout.formats.Float;
	
	public class Enemy extends MovieClip  {
		
		var health:Number;
		var hitAnimation:Tween;
		public var isDead:Boolean;
		
		public function Enemy() {
			
			isDead = false;
			
			hitAnimation = new Tween(this, "alpha", None.easeNone, 0, 1, 0.2, true);
			alpha = 1.0;
			hitAnimation.stop();

			//hitAnimation.addEventListener(TweenEvent.MOTION_LOOP, ReverseHitAnimation);
			//hitAnimation = new Tween(this, "alpha", Elastic.easeOut, 1, 0, 3, true);
		}
		
		
		public function GetsHit():void{
			health--;
			if(health<=0){
				isDead = true;
				trace("Enemy is Dead");
			}
			hitAnimation.addEventListener(TweenEvent.MOTION_FINISH, ReverseHitAnimation);
			hitAnimation.start();
		}
		
		function ReverseHitAnimation(e:TweenEvent):void{
			hitAnimation.removeEventListener(TweenEvent.MOTION_FINISH, ReverseHitAnimation);
			hitAnimation.start();
		}
		/*
		public function GetLineIntersectionPoint(a:Point, b:Point, c:Point, d:Point):Point {
			
			var distAB:Number;
			var cos:Number;
			var sin:Number;
			var ABpos:Number;
		
			
			// Checks if the lines are determined by two different points
			if ((a.x == b.x && a.y == b.y) || (c.x == d.x && c.y == d.y)) 
				return null;
			
			if ( a == c || a == d || b == c || b == d ) 
				return null;
			
			b = b.clone();
			c = c.clone();
			d = d.clone();
			
			trace(a+" , "+b);
			trace(c+" , "+d);
			
			b.offset( -a.x, -a.y);
			c.offset( -a.x, -a.y);
			d.offset( -a.x, -a.y);
			
			distAB = b.length;
			cos = b.x / distAB;
			sin = b.y / distAB;
			
			c = new Point(c.x * cos + c.y * sin, c.y * cos - c.x * sin);
			d = new Point(d.x * cos + d.y * sin, d.y * cos - d.x * sin);
			
			if ((c.y < 0 && d.y < 0) || (c.y >= 0 && d.y >= 0)) 
				return null;
			
			ABpos = d.x + (c.x - d.x) * d.y / (d.y - c.y);
			
			if (ABpos < 0 || ABpos > distAB)
				return null;
			
			return new Point(a.x + ABpos * cos, a.y + ABpos * sin);
		}
		*/
		
		// Find the point of intersection between two lines
		public function GetLineIntersectionPoint(a:Point, b:Point, c:Point, d:Point):Point {
			var abSlopeX:Number, abSlopeY:Number, cdSlopeX:Number, cdSlopeY:Number;
			var intersectionPoint:Point = new Point();
			
			abSlopeX = b.x - a.x;
			abSlopeY = b.y - a.y;
			
			cdSlopeX = d.x - c.x;
			cdSlopeY = d.y - c.y;
			
			var s:Number, t:Number;
			
			//s = (-abSlopeY * (a.x - c.x) + abSlopeX * (a.y - c.y)) / (-cdSlopeX * abSlopeY + abSlopeX * cdSlopeY);
			t = (cdSlopeX * (a.y - c.y) - cdSlopeY * (a.x - c.x)) / (-cdSlopeX * abSlopeY + abSlopeX * cdSlopeY);
			
		
			intersectionPoint.x = a.x + (t * abSlopeX);
			intersectionPoint.y = a.y + (t * abSlopeY);
			
			//if (s >= 0 && s <= 1 && t >= 0 && t <= 1){ 

				
				//return intersectionPoint; //Intersection

			//}
			
			// The segments intersect if t is between 0 and 1.
			if (t >= 0 && t <= 1){
				return intersectionPoint; //Intersection
			}else{
				return null; //No intersection
			}
			//return null; //No intersection
		}
		
		
		
		/*
		// Find the point of intersection between two lines
		public function GetLineIntersectionPoint(a:Point, b:Point, c:Point, d:Point):Point {
			
			//The line segments (x1,y1) and (x2,y2) are defined by the following functions:
			//x1(t) = x11 + dx1 * t1
			//y1(t) = y11 + dy1 * t1
			//x2(t) = x21 + dx2 * t2
			//y2(t) = y21 + dy2 * t2

			var abSlopeX:Number, abSlopeY:Number, cdSlopeX:Number, cdSlopeY:Number;
			var intersectionPoint:Point = new Point();
			
			abSlopeX = b.x - a.x;
			abSlopeY = b.y - a.y;
			
			cdSlopeX = d.x - c.x;
			cdSlopeY = d.y - c.y;
			
			// Solve for t1 and t2
			var denominator:Number = (abSlopeY * cdSlopeX - abSlopeX * cdSlopeY);
			
			var t1:Number = ((a.x - c.x) * cdSlopeY + (c.y - a.y) * cdSlopeX) / denominator;
			
			if (t1 == Number.POSITIVE_INFINITY) {
				// The lines are parallel
				return null;
			}
			
			//Lines intersect
			
			var t2:Number = ((c.x - a.x) * abSlopeY + (a.y - c.y) * abSlopeX) / -denominator;
			
			// Find the point of intersection.
			intersectionPoint = new Point(a.x + abSlopeX * t1, a.y + abSlopeY * t1);
			
			// The segments intersect if t1 and t2 are between 0 and 1.
			if (t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1){
				
				return intersectionPoint; //Intersection
			}
			
			return intersectionPoint;
			//return null; //No intersection
			
			// Find the closest points on the segments.
			if (t1 < 0)
			{
				t1 = 0;
			}
			else if (t1 > 1)
			{
				t1 = 1;
			}
			
			if (t2 < 0)
			{
				t2 = 0;
			}
			else if (t2 > 1)
			{
				t2 = 1;
			}
			
			close_p1 = new PointF(p1.X + dx12 * t1, p1.Y + dy12 * t1);
			close_p2 = new PointF(p3.X + dx34 * t2, p3.Y + dy34 * t2);
			
		}
			*/

	}
	
}

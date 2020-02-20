package {
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class RedPoint extends MovieClip {
		
		public function RedPoint(p:Point) {
			x = p.x;
			y = p.y;
		}
	}
}
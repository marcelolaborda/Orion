package {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class HealthPotion  extends MovieClip {
		
		var potions:Number;
		
		public function HealthPotion(tPotions:Number){
			potions = tPotions;
			TextField(getChildByName("NumPotions")).text = potions.toString();
		}
		
		public function UsePotion():void{
			if(potions>0){
				potions--;
				TextField(getChildByName("NumPotions")).text = potions.toString();
			}
		}
		
		public function GetPotion():void{
			potions++;
			TextField(getChildByName("NumPotions")).text = potions.toString();
		}
	}
}
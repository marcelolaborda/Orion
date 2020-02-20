package {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	
	public class Player extends MovieClip {
		
		
		var health:Number;
		var maxHealth:uint;
		var strength:uint;
		var healthBar:Shape;
		var healthBarContainer:Shape;
		public var potions:Number;
		var potionBar:HealthPotion;
		public var isDead:Boolean;
		public var shieldUp:Boolean;
		public var soundManager:SoundManager;
		
		public function Player(tHealth:uint, tStrength:uint, tSoundManger:SoundManager) {
			health = tHealth;
			maxHealth = tHealth;
			strength = tStrength;
			potions = 1;
			
			soundManager = tSoundManger;
			
			potionBar = new HealthPotion(potions);
			potionBar.x += 1000;

			shieldUp = false;
			isDead = false;
		}
		
		public function DamagePlayer(damage:uint):void {
			if(health>0){
				health -= damage;
			}
			if(health<=0){
				health = 0;
				trace("Player Dies!");
				isDead = true;
			}
		}
		
		public function PickUpPotion():void{
			potionBar.GetPotion();
			soundManager.getpotion.Play();
			potions++;
		}
		
		public function UsePotion():void{
			if(health<maxHealth){
				soundManager.usepotion.Play();
				if(health + 20 > maxHealth){
					health = maxHealth;
					potionBar.UsePotion();
					potions--;
				}else{
					health += 20;
					potionBar.UsePotion();
					potions--;
				}
			}else{
				soundManager.empty.Play();
			}
		}
		
		public function ShieldUp():void{
			shieldUp = true;
		}
		
		public function ShieldDown():void{
			shieldUp = false;
		}
		
		public function DisplayLifeBar():void{
			if(healthBar!=null)
				if(contains(healthBar))
					removeChild(healthBar);
			
			healthBar = new Shape;
			healthBar.graphics.lineStyle(7, 0x00FFFF, 0.0);
			healthBar.graphics.beginFill(0xFF0000, 1.0); 
			healthBar.graphics.drawRoundRect(0, 0, (health*300)/maxHealth , 40, 20, 20); 
			healthBar.graphics.endFill();
			addChild(healthBar);
			
			if(healthBarContainer!=null)
				if(contains(healthBarContainer))
					removeChild(healthBarContainer);
			
			healthBarContainer = new Shape;
			healthBarContainer.graphics.lineStyle(7, 0xFFFF00, 1.0);
			healthBarContainer.graphics.drawRoundRect(0, 0, 300, 40, 20, 20);
			addChild(healthBarContainer);
			

		}
		
		public function HideLifeBar():void{
			if(healthBar!=null)
				if(contains(healthBar))
					removeChild(healthBar);
			if(healthBarContainer!=null)
				if(contains(healthBarContainer))
					removeChild(healthBarContainer);
		}
		
		public function DisplayHealthPotions():void{
			if(potionBar!=null){
				if(contains(potionBar)){
					removeChild(potionBar);
				}
			}
			addChild(potionBar);
		}
	}
}
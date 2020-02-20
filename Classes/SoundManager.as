package {
	
	
	public class SoundManager {
		
		public var mute:Boolean;
		public var masterVolume:int;
		public var opening:SoundStream;
		public var theme:SoundStream;
		public var intro:SoundStream;
		public var start:SoundStream;
		public var dungeon:SoundStream;
		public var battle:SoundStream;
		public var mintakaHurt:SoundStream;
		public var mintakaDies:SoundStream;
		public var miss:SoundStream;
		public var shield:SoundStream;
		public var playerhit:SoundStream;
		public var usepotion:SoundStream;
		public var getpotion:SoundStream;
		public var empty:SoundStream;
		public var defeated:SoundStream;
		public var treasure:SoundStream;
		public var stairs:SoundStream;
		public var ending:SoundStream;
		public var dead:SoundStream;

		
		public function SoundManager() {
			opening = new SoundStream("Sounds/opening.mp3", 0.5, false);
			theme = new SoundStream("Sounds/theme.mp3", 0.5, false);
			intro = new SoundStream("Sounds/intro.mp3", 0.5, false, 25, 21);
			start = new SoundStream("Sounds/start.mp3", 0.5, false);
			dungeon = new SoundStream("Sounds/dungeon.mp3", 0.5, false, 25, 21);
			battle = new SoundStream("Sounds/battle.mp3", 0.5, false, 5351, 21, 24);
			mintakaHurt = new SoundStream("Sounds/mintakaHurt.mp3", 0.3, true);
			mintakaDies = new SoundStream("Sounds/mintakaDies.mp3", 0.3, true);
			miss = new SoundStream("Sounds/miss.mp3", 0.4, true);
			shield = new SoundStream("Sounds/shield.mp3", 0.4, true);
			playerhit = new SoundStream("Sounds/playerhit.mp3", 0.5, true);
			usepotion = new SoundStream("Sounds/usepotion.mp3", 0.6, true);
			getpotion = new SoundStream("Sounds/getpotion.mp3", 0.6, true);
			empty = new SoundStream("Sounds/empty.mp3", 0.5, true);
			defeated = new SoundStream("Sounds/defeated.mp3", 0.5, true);
			treasure = new SoundStream("Sounds/treasure.mp3", 0.5, true);
			stairs = new SoundStream("Sounds/stairs.mp3", 0.8, true);
			ending = new SoundStream("Sounds/ending.mp3", 0.5, true);
			dead = new SoundStream("Sounds/dead.mp3", 0.5, true);

		}
		
	}
}
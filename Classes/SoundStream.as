package {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;	
	
	public class SoundStream extends EventDispatcher{
		
		private var mute:Boolean;
		private var sound:Sound;
		private var channel:SoundChannel;
		private var transform:SoundTransform;
		private var lastPlaybackPosition:Number; //Keeps playback position. Used to Pause() stream.
		private var allowOverlapping:Boolean;
		private var allowLooping:Boolean;
		private var loopStart:Number, loopEnd:Number, initialPlaybackPosition:Number, loopTimer:Timer;
		private var isPlaying:Boolean;
		private var loaded:Boolean;
		private var queued:Boolean;
		
		public function SoundStream(path:String, volume:Number, overlapping:Boolean, loopingStart:Number = 0.0, loopingEnd:Number = 0.0, startPlaybackPosition:Number = NaN) {
			sound = new Sound();
		 	channel = new SoundChannel();
			transform = new SoundTransform();
			loaded = false;
			queued = false;
			sound.addEventListener(Event.COMPLETE, SoundLoaded);
			sound.load(new URLRequest(path));
			transform.volume = volume;
			channel.soundTransform = transform;
			allowOverlapping = overlapping;
			if(loopingEnd!=0.0){
				loopStart = loopingStart;
				loopEnd = loopingEnd;
				initialPlaybackPosition = startPlaybackPosition;
				allowLooping = true;
			}else{
				allowLooping = false;
			}

		}
		
		public function SoundLoaded(event:Event):void{
			loaded = true;
			if(queued)
				Play();
		}
		
		public function Play(starts:Number = NaN):void {
			if(loaded){
				if(!isPlaying || allowOverlapping){ //Avoids sound overlapping if disabled
					isPlaying = true;
					lastPlaybackPosition = 0;
					if(allowLooping){
						if(isNaN(initialPlaybackPosition)){
							channel = sound.play((isNaN(starts) ? loopStart : starts));
							loopTimer = new Timer(sound.length-(loopEnd+(isNaN(starts) ? loopStart : starts)), 1);
						}else{
							channel = sound.play(initialPlaybackPosition);
							loopTimer = new Timer(sound.length-(loopEnd+initialPlaybackPosition), 1);
							initialPlaybackPosition = NaN;
						}
						loopTimer.start();
						loopTimer.addEventListener(TimerEvent.TIMER_COMPLETE, Restart);
					}else{
						channel = sound.play();
						channel.addEventListener(Event.SOUND_COMPLETE, FinishedPlaying);
					}
					channel.soundTransform = transform;
				}
			}else{
				queued = true;
			}
		}
		
		public function Restart(event:Event):void {
			isPlaying = false;
			if(loopTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
				loopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, Restart);
			Play();
		}
		
		public function Stop():void {
			lastPlaybackPosition = 0;
			isPlaying = false;
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, FinishedPlaying);
			if(loopTimer!=null)
				loopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, Restart);
		}
		
		public function Pause():void {
			isPlaying = false;
			lastPlaybackPosition = channel.position;
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, FinishedPlaying);
		}
		
		public function Resume():void {
			if(!isPlaying){//Avoids sound overlapping
				isPlaying = true;
				channel = sound.play(lastPlaybackPosition);
				channel.addEventListener(Event.SOUND_COMPLETE, FinishedPlaying);
				channel.soundTransform = transform;
			}
		}
		
		public function SetVolume(volume:Number):void {
			transform.volume = volume;
			channel.soundTransform = transform;
		}
		
		public function FinishedPlaying(event:Event):void {
			dispatchEvent(new Event("FinishedPlaying"));
			isPlaying = false;
		}

	}
}
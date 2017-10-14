package com.utils
{
   import flash.media.SoundTransform;
   import flash.media.SoundChannel;
   import flash.media.Sound;
   import flash.media.SoundMixer;
   import flash.events.Event;
   
   public final class Mixer
   {
      
      private static var instance:com.utils.Mixer;
       
      
      private var soundTransform:SoundTransform;
      
      private var volume:Number;
      
      private var pauseVolume:Number;
      
      private var sfx:Boolean;
      
      private var music:Boolean;
      
      private var musicChannel:SoundChannel;
      
      private var sfxChannel;
      
      private var bgMusic:Array;
      
      private var clickSnd:Sound;
      
      private var currentMusic:uint;
      
      private const sfxChannelAmount:uint = 10;
      
      private var sfxChannels:Array;
      
      private var latestSfxChannel:uint;
      
      private var musicChannelPosition:Number = 0;
      
      public function Mixer(pKey:SingletonBlocker)
      {
         sfxChannels = [];
         super();
         if(pKey == null)
         {
            throw new Error("Error: Instantiation failed: Use Mixer.getInstance() instead of new.");
         }
         initSound();
      }
      
      public static function getInstance() : com.utils.Mixer
      {
         if(instance == null)
         {
            instance = new com.utils.Mixer(new SingletonBlocker());
         }
         return instance;
      }
      
      public function muteAll() : *
      {
         try
         {
            SoundMixer.stopAll();
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::muteAll error");
         }
      }
      
      public function toggleSfx() : *
      {
         sfx = !sfx;
      }
      
      public function toggleMusic() : *
      {
         try
         {
            music = !music;
            if(!music)
            {
               if(musicChannel != null)
               {
                  musicChannel.stop();
               }
            }
            else
            {
               playMusic(bgMusic);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::toggleMusic error");
         }
      }
      
      public function musicPlayerToggleMusic() : *
      {
         try
         {
            music = !music;
            if(!music)
            {
               if(musicChannel != null)
               {
                  pauseSound();
               }
            }
            else
            {
               resumeSound();
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::music player toggleMusic error");
         }
      }
      
      public function checkMusicByVolume() : Boolean
      {
         if(music && soundTransform.volume > 0)
         {
            return true;
         }
         return false;
      }
      
      public function pauseSound() : *
      {
         this.musicChannelPosition = musicChannel.position;
         musicChannel.stop();
      }
      
      public function resumeSound() : *
      {
         if(bgMusic && bgMusic[0] != null)
         {
            soundTransform.volume = volume;
            if(bgMusic.length > 0)
            {
               musicChannel = bgMusic[0].play(this.musicChannelPosition,999999999,soundTransform);
            }
            else
            {
               playMusic(bgMusic);
            }
         }
      }
      
      public function getSfx() : Boolean
      {
         return sfx;
      }
      
      public function getMusic() : Boolean
      {
         return music;
      }
      
      public function setMusic(bln:Boolean) : void
      {
         music = bln;
      }
      
      public function playSoundOnLeft(sound:Sound) : *
      {
         try
         {
            soundTransform.leftToLeft = 1;
            soundTransform.rightToRight = 0.5;
            soundTransform.volume = volume;
            if(sfx)
            {
               sound.play(0,0,soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function playSoundOnRight(sound:Sound) : *
      {
         try
         {
            soundTransform.leftToLeft = 0.5;
            soundTransform.rightToRight = 1;
            soundTransform.volume = volume;
            if(sfx)
            {
               sound.play(0,0,soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function playSound(sound:Sound) : *
      {
         try
         {
            soundTransform.volume = volume;
            if(sfx)
            {
               sound.play(0,0,soundTransform);
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playSound error");
         }
      }
      
      public function playSfx(sound:Sound, channelId:String) : *
      {
         try
         {
            if(this.latestSfxChannel >= this.sfxChannelAmount)
            {
               this.latestSfxChannel = 0;
            }
            if(this.sfxChannels[this.latestSfxChannel].sfxChannel != null)
            {
               this.sfxChannels[this.latestSfxChannel].sfxChannel.stop();
            }
            this.sfxChannels[this.latestSfxChannel].channelId = channelId;
            this.sfxChannels[this.latestSfxChannel].sfxChannel = sound.play(0,1,this.soundTransform);
            this.latestSfxChannel++;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playSound error");
         }
      }
      
      public function stopSfx(channelId:String) : *
      {
         var channelIndex:int = -1;
         for(var i:int = 0; i < this.sfxChannelAmount - 1; i++)
         {
            if(this.sfxChannels[i].channelId == channelId)
            {
               channelIndex = i;
               break;
            }
         }
         if(channelIndex < 0)
         {
            throw new Error("Mixer::sfx channel ID not found");
         }
         this.sfxChannels[channelIndex].channelId = "";
         this.sfxChannels[channelIndex].sfxChannel.stop();
      }
      
      public function playMusic(_music:Array = null) : *
      {
         try
         {
            stopMusic();
            bgMusic = _music;
            soundTransform.volume = volume;
            if(music)
            {
               currentMusic = 0;
               if(bgMusic.length > 1)
               {
                  musicChannel = bgMusic[0].play(0,1,soundTransform);
                  musicChannel.addEventListener(Event.SOUND_COMPLETE,playNextMusic);
               }
               else
               {
                  musicChannel = bgMusic[0].play(0,999999999,soundTransform);
               }
            }
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playMusic error");
         }
      }
      
      public function getMusicChannel() : SoundChannel
      {
         return musicChannel;
      }
      
      public function getCurrentMusic() : Sound
      {
         return bgMusic[this.currentMusic];
      }
      
      public function getCurrentMusicLinkageString() : String
      {
         return bgMusic[0];
      }
      
      public function isPlayingMusic() : Boolean
      {
         try
         {
            if(music)
            {
               if(bgMusic.length > 0)
               {
                  return true;
               }
               return false;
            }
            return false;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playMusic error");
         }
         return false;
      }
      
      public function playNextMusic(evt:Event) : *
      {
         try
         {
            currentMusic++;
            if(music)
            {
               musicChannel.removeEventListener(Event.SOUND_COMPLETE,playNextMusic);
               if(currentMusic < bgMusic.length)
               {
                  musicChannel = bgMusic[currentMusic].play(0,1,soundTransform);
                  musicChannel.addEventListener(Event.SOUND_COMPLETE,playNextMusic);
               }
               else
               {
                  musicChannel = bgMusic[currentMusic - 1].play(0,999999999,soundTransform);
               }
            }
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::playNextMusic error");
         }
      }
      
      public function stopMusic() : *
      {
         try
         {
            if(music)
            {
               if(musicChannel != null)
               {
                  musicChannel.stop();
               }
            }
            bgMusic = new Array();
            this.musicChannelPosition = 0;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::stopMusic error");
         }
      }
      
      public function setVolume(vol:Number) : void
      {
         try
         {
            volume = vol;
            soundTransform.volume = volume;
            musicChannel.soundTransform = soundTransform;
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
         }
      }
      
      public function getVolume() : Number
      {
         return soundTransform.volume;
      }
      
      public function initSound() : *
      {
         var i:int = 0;
         var newSfxChannel:SoundChannel = null;
         try
         {
            soundTransform = new SoundTransform();
            volume = 1;
            sfx = true;
            music = true;
            bgMusic = new Array();
            musicChannel = new SoundChannel();
            this.setVolume(volume);
            this.musicChannelPosition = 0;
            this.latestSfxChannel = 0;
            for(i = 0; i < this.sfxChannelAmount; i++)
            {
               newSfxChannel = new SoundChannel();
               newSfxChannel.soundTransform = soundTransform;
               this.sfxChannels.push({
                  "id":"",
                  "sfxChannel":""
               });
            }
         }
         catch(e:Error)
         {
            Out.error(this,e.getStackTrace());
            throw new Error("Mixer::initSound error");
         }
      }
   }
}

class SingletonBlocker
{
    
   
   function SingletonBlocker()
   {
      super();
   }
}

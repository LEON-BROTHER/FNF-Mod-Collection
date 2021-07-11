package;

import flixel.FlxG;
import Song.SwagSong;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	public static var SONG:SwagSong;
	var camFollow:FlxObject;
	var tankdead:FlxSound = new FlxSound().loadEmbedded(Paths.soundRandom('jeffGameover/jeffGameover-', 1, 25));

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		FlxG.sound.list.add(tankdead);
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'school':
				if (PlayState.curSong == 'Your Reality')
				{
					stageSuffix = '-senpai';
					daBf = 'playablesenpai';
				}
				else	
				{
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
				}
			case 'school-neon':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'school-neon-2':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'school-b':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'schoolEvil-b':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			case 'stage-neo' | 'limo-neo' | 'spooky-neo' | 'philly-neo':
				daBf = 'bf-neo';
			case 'stage-b' | 'limo-b' | 'spooky-b' | 'philly-b' | 'mall-b' | 'mallEvil-b':
				daBf = 'bf-b';
				stageSuffix = '-b';
			case 'stage-star' | 'spooky-star' | 'philly-star' | 'limo-star':
				daBf = 'bf-star';
				stageSuffix = '-star';
			case 'hellstage':
				if (FlxG.save.data.bobCrash == 'Yes')
				{
					daBf = 'fdkapojiokfsdj';
				}
				else
				{
					daBf = 'bf';
				}
			case 'nevada' | 'auditorHell' | 'nevadaSpook':
				daBf = 'bf-signDeath';
				stageSuffix = '-tricky';
			case 'genocide':
				daBf = 'bf-knife';
			case 'tankman1':
				if (PlayState.curSong == 'Stress' || PlayState.curSong == 'Stress-Duet'){
					daBf = 'bf-holding-gf-dead';
				}
				else{daBf = 'bf';}
			default:
				daBf = 'bf';
		}

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		
		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			if (PlayState.curStage == 'tankman1')
			{
					FlxG.sound.music.volume = 0.1;
					tankdead.play(true);
					trace(tankdead.length);
					var realtime:Float = tankdead.length / 1000;
					new FlxTimer().start(realtime, function(tmr:FlxTimer)
						{
							FlxG.sound.music.volume = 0.9;
						});
			}

			
			
			
			
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
		

			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}

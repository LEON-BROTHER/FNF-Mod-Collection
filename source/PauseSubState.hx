package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import Controls.KeyboardScheme;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public static var babymode:String = "No";
	public static var sickmode:String = "No";
	public static var controlmode:String = "WASD";
	public static var keys:FlxText;

	var stopspamming:Int = 0;

	var menuItems:Array<String> = [
		'Resume', 'Restart Song', 'Kade Input', 'Only SICK MODE', 'Change Song', 'Change Character', 'Controls', 'Debug Menu', 'Animation Debug',
		'Animation player', 'Exit to menu'
	];

	var curSelected:Int = 0;
	var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
	var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
	var pauseMusic:FlxSound;

	var startedCountdown:Bool = false;

	public function new(x:Float, y:Float)
	{
		super();
		if (PauseMenuMusic.starcatcher == 1)
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast-star'), true, true);
		if (PauseMenuMusic.normal == 1)
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

	
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		keys = new FlxText(20, 15 + 32 + 32, 0, "", 32);
		if (FlxG.save.data.controlstype == 'wasd')
			controlmode = "WASD";
		else if (FlxG.save.data.controlstype == 'asdf')
			controlmode = "ASDF";
		else if (FlxG.save.data.controlstype == 'qwop')
			controlmode = "QWOP";
		else if (FlxG.save.data.controlstype == 'dfjk')
			controlmode = "DFJK";
		else
			trace('none');

		keys.text = controlmode;
		keys.scrollFactor.set();
		keys.setFormat(Paths.font('vcr.ttf'), 32);
		keys.updateHitbox();
		add(keys);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		keys.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		keys.x = FlxG.width - (keys.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(keys, {alpha: 1, y: keys.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var controlsStrings:Array<String> = [];

		if (upP && !startedCountdown)
		{
			changeSelection(-1);
		}
		if (downP && !startedCountdown)
		{
			changeSelection(1);
		}

		if (accepted && !startedCountdown)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
								keys.visible = false;
								bg.visible = false;
								levelDifficulty.visible = false;
								levelInfo.visible = false;
								remove(grpMenuShit);
								startedCountdown = true;
								startCountdown();
							

				case "Restart Song":
					FlxG.resetState();
					PlayState.songMiss = 0;
				case "Exit to menu":
					FlxG.switchState(new MainMenuState());
				case "Debug Menu":
					FlxG.switchState(new ChartingState());
				case "Kade Input":
					if (babymode == "No")
					{
						babymode = "Yes";
						FlxG.resetState();
						sickmode = "No";
						PlayState.songMiss = 0;
					}
					else
					{
						babymode = "No";
						FlxG.resetState();
						sickmode = "No";
						PlayState.songMiss = 0;
					}
				case "Only SICK MODE":
					if (sickmode == "No")
					{
						sickmode = "Yes";
						FlxG.resetState();
						babymode = "No";
						PlayState.songMiss = 0;
					}
					else
					{
						sickmode = "No";
						FlxG.resetState();
						babymode = "No";
						PlayState.songMiss = 0;
					}
				case "Change Song":
					FlxG.switchState(new CategoryState());
				case "Change Character":
					FlxG.switchState(new ChangePlayerState());
				case "Controls":
					if (controlmode == "WASD")
					{
						controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
						FlxG.save.data.controlstype = 'dfjk';
						FlxG.save.flush();
						controlmode = "DFJK";
						FlxTween.tween(keys, {alpha: 1, y: keys.y}, 0.4, {ease: FlxEase.quartInOut});
						keys.text = controlmode;
						keys.scrollFactor.set();
						keys.setFormat(Paths.font('vcr.ttf'), 32);
						keys.updateHitbox();
						add(keys);
					}
					else if (controlmode == "DFJK")
					{
						controls.setKeyboardScheme(KeyboardScheme.Custom, true);
						FlxG.save.data.controlstype = 'qwop';
						FlxG.save.flush();
						controlmode = "QWOP";
						FlxTween.tween(keys, {alpha: 1, y: keys.y}, 0.4, {ease: FlxEase.quartInOut});
						keys.text = controlmode;
						keys.scrollFactor.set();
						keys.setFormat(Paths.font('vcr.ttf'), 32);
						keys.updateHitbox();
						add(keys);
					}
					else if (controlmode == "QWOP")
					{
						controls.setKeyboardScheme(KeyboardScheme.Guldi, true);
						controlmode = "ASDF";
						FlxG.save.data.controlstype = 'asdf';
						FlxG.save.flush();
						FlxTween.tween(keys, {alpha: 1, y: keys.y}, 0.4, {ease: FlxEase.quartInOut});
						keys.text = controlmode;
						keys.scrollFactor.set();
						keys.setFormat(Paths.font('vcr.ttf'), 32);
						keys.updateHitbox();
						add(keys);
					}
					else
					{
						controls.setKeyboardScheme(KeyboardScheme.Solo, true);
						controlmode = "WASD";
						FlxG.save.data.controlstype = 'wasd';
						FlxG.save.flush();
						FlxTween.tween(keys, {alpha: 1, y: keys.y}, 0.4, {ease: FlxEase.quartInOut});
						keys.text = controlmode;
						keys.scrollFactor.set();
						keys.setFormat(Paths.font('vcr.ttf'), 32);
						keys.updateHitbox();
						add(keys);
					}
				case "Animation Debug":
					FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
				case "Animation player":
					FlxG.switchState(new AnimationDebug(PlayState.SONG.player1));
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
	var swagCounter:Int = 0;

	function startCountdown():Void
	{
		var startTimer:FlxTimer;

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', "set", "go"]);
		introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
		introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);


		var introAlts:Array<String> = introAssets.get('default');
		var altSuffix:String = "";

		for (value in introAssets.keys())
		{
			if (value == PlayState.curStage)
			{
				introAlts = introAssets.get(value);
				altSuffix = '-pixel';
			}
		}

		FlxG.sound.play(Paths.sound('intro3' + altSuffix, 'shared'), 0.6);

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{

			switch (swagCounter)
			{
				case 0:
					var ready:FlxSprite = new FlxSprite();

					if (introAlts[0] == 'ready')
						ready.loadGraphic(Paths.image(introAlts[0], 'shared'));
					else
						ready.loadGraphic(Paths.image(introAlts[0], 'week6'));
					ready.scrollFactor.set();
					ready.updateHitbox();

					

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix, 'shared'), 0.6);
				case 1:
					var set:FlxSprite = new FlxSprite();

					if (introAlts[1] == 'set')
						set.loadGraphic(Paths.image(introAlts[1], 'shared'));
					else
						set.loadGraphic(Paths.image(introAlts[1], 'week6'));

					set.scrollFactor.set();

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix, 'shared'), 0.6);
				case 2:
					var go:FlxSprite = new FlxSprite();

					if (introAlts[2] == 'go')
						go.loadGraphic(Paths.image(introAlts[2], 'shared'));
					else
						go.loadGraphic(Paths.image(introAlts[2], 'week6'));

				

					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix, 'shared'), 0.6);
				case 3:
					close();
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 4);
	}
}

package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class ModOptionsState extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public var menuItems:Array<String> = ['Toggle Week 7 Cutscenes', 'Toggle Bob Crashing'];

	public var curSelected:Int = 0;

	public var pauseMusic:FlxSound;

	public static var up:Int = 1;
	public static var down:Int = 0;
	public static var keys:FlxText;
	public static var keysWeek7:FlxText;
	public static var keysBob:FlxText;
	public static var keysenemy:FlxText;
	var eneyme:String;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		if (CategoryState.chara != 1)
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		else
			bg = new FlxSprite().loadGraphic(Paths.image('chara-menu'));
		bg.scrollFactor.set();
		add(bg);
		keysWeek7 = new FlxText(70, 0, 0, "", 32);
		keysBob = new FlxText(70, 30, 0, "", 32);
		keysenemy = new FlxText(70, 60, 0, "", 32);

		FlxTween.tween(keysWeek7, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
		keysWeek7.text = "Week 7 Cutscenes: " + FlxG.save.data.week7Cut.toUpperCase();
		keysWeek7.scrollFactor.set();
		keysWeek7.setFormat(Paths.font('vcr.ttf'), 32);
		keysWeek7.updateHitbox();
		add(keysWeek7);

		FlxTween.tween(keysBob, {alpha: 1, y: 30}, 0.4, {ease: FlxEase.quartInOut});
		keysBob.text = "Bob Crashing: " + FlxG.save.data.bobCrash.toUpperCase();
		keysBob.scrollFactor.set();
		keysBob.setFormat(Paths.font('vcr.ttf'), 32);
		keysBob.updateHitbox();
		add(keysBob);
		if (FlxG.save.data.playenemy)
			eneyme = 'Yes';
		else
			eneyme = 'No';

		FlxTween.tween(keysenemy, {alpha: 1, y: 60}, 0.4, {ease: FlxEase.quartInOut});
		keysenemy.text = "Play as Enemy: " + eneyme;
		keysenemy.scrollFactor.set();
		keysenemy.setFormat(Paths.font('vcr.ttf'), 32);
		keysenemy.updateHitbox();



		pauseMusic = new FlxSound().loadEmbedded(Paths.music('category'), true, true);

		FlxG.sound.list.add(pauseMusic);

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
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var back = controls.BACK;
		var controlsStrings:Array<String> = [];

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Toggle Week 7 Cutscenes":
					if (FlxG.save.data.week7Cut == 'Yes')
					{
						FlxG.save.data.week7Cut = 'No';
						FlxG.save.flush();
					}
					else
					{
						FlxG.save.data.week7Cut = 'Yes';
						FlxG.save.flush();
					}

					FlxTween.tween(keysWeek7, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keysWeek7.text = "Week 7 Cutscenes: " + FlxG.save.data.week7Cut.toUpperCase();
					keysWeek7.scrollFactor.set();
					keysWeek7.setFormat(Paths.font('vcr.ttf'), 32);
					keysWeek7.updateHitbox();
					add(keysWeek7);

				case "Toggle Bob Crashing":
					if (FlxG.save.data.bobCrash == 'Yes')
					{
						FlxG.save.data.bobCrash = 'No';
						FlxG.save.flush();
					}
					else
					{
						FlxG.save.data.bobCrash = 'Yes';
						FlxG.save.flush();
					}

					FlxTween.tween(keysBob, {alpha: 1, y: 30}, 0.4, {ease: FlxEase.quartInOut});
					keysBob.text = "Bob Crashing: " + FlxG.save.data.bobCrash.toUpperCase();
					keysBob.scrollFactor.set();
					keysBob.setFormat(Paths.font('vcr.ttf'), 32);
					keysBob.updateHitbox();
					add(keysBob);
		
					
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
}

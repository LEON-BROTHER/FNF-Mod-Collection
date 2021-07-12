package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class StoryCateState extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public var menuItems:Array<String> = [
		'Base Game', 'B-Sides', 'Garcello', 'Monika', 'Neo', 'Whitty'
	];

	public var curSelected:Int = 0;

	public var pauseMusic:FlxSound;

	public static var playlist:Int;
	public static var chara:Int;
	public static var monika:Bool = false;
	

	override function create()
	{
		monika = false;
		PlayState.isStoryMode = false;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		if (CategoryState.chara != 1)
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		else
			bg = new FlxSprite().loadGraphic(Paths.image('chara-menu'));
		bg.scrollFactor.set();
		add(bg);
		playlist = 0;

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
			monika = false;
		}
		if (accepted)
		{
			
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Base Game":
					

					playlist = 1;
					FlxG.switchState(new StoryMenuState());
				case "Neo":
					

					playlist = 2;
					FlxG.switchState(new StoryMenuState());
				case "B-Sides":
					

					playlist = 3;
					FlxG.switchState(new StoryMenuState());
				case "Garcello":
					
					playlist = 4;
					FlxG.switchState(new StoryMenuState());
				case "Monika":
					monika = true;
					playlist = 5;
					FlxG.switchState(new StoryMenuState());
				case "Whitty":
					
					playlist = 6;
					FlxG.switchState(new StoryMenuState());
				
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

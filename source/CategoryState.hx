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

class CategoryState extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public var menuItems:Array<String> = [
		'Normal','Agoti' ,'Annie', 'Anders', 'B3 Remixes', 'B-Sides', 'Beatstreets', 'Bob', 'Carol', 'Chara', 'Detra', 'Duet Mod', 'Duet B-Sides', 'Garcello', 'Hex',
		'Impostor', 'Kapi', 'Matt', 'Miku', 'Mid-Fight-Masses','Monika', 'Neko Freak', 'Neo', 'Neon', 'Retrospecter', 'Salty Sunday', 'Sans', 'Sky', 'Shaggy',
		'Starcatcher', 'Tabi', 'Tord', 'Tree', 'Tricky', 'Touhou', 'Whitty', 'X-Event', 'Zardy', 'Singles'
	];

	public var curSelected:Int = 0;

	public var pauseMusic:FlxSound;

	public static var playlist:Int;
	public static var chara:Int;
	public static var inCategory:Int;

	override function create()
	{
		PlayState.isStoryMode = false;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		if (CategoryState.chara != 1)
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		else
			bg = new FlxSprite().loadGraphic(Paths.image('chara-menu'));
		bg.scrollFactor.set();
		add(bg);
		inCategory = 1;

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
			inCategory = 0;
			FlxG.switchState(new MainMenuState());
			
		}
		if (accepted)
		{
			
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Normal":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 1;
					FlxG.switchState(new FreeplayState());
				case "Agoti":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
	
					playlist = 43;
					FlxG.switchState(new FreeplayState());
				case "Neo":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 2;
					FlxG.switchState(new FreeplayState());
				case "B-Sides":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 3;
					FlxG.switchState(new FreeplayState());
				case "Singles":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 6;
					FlxG.switchState(new FreeplayState());
				case "Hex":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 7;
					FlxG.switchState(new FreeplayState());
				case "Carol":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 9;
					FlxG.switchState(new FreeplayState());
				case "Sky":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 10;
					FlxG.switchState(new FreeplayState());
				case "Duet Mod":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 5;
					FlxG.switchState(new FreeplayState());
				case "Duet B-Sides":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 8;
					FlxG.switchState(new FreeplayState());
				case "Miku":
					playlist = 11;
					FlxG.switchState(new FreeplayState());
				case "Touhou":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 12;
					FlxG.switchState(new FreeplayState());
				case "Starcatcher":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 13;
					FlxG.switchState(new FreeplayState());
				case "Matt":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 14;
					FlxG.switchState(new FreeplayState());
				case "X-Event":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 15;
					FlxG.switchState(new DisclaimerState());
				case "Mid-Fight-Masses":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 16;
					FlxG.switchState(new FreeplayState());
				case "Beatstreets":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 17;
					FlxG.switchState(new FreeplayState());
				case "Garcello":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 18;
					FlxG.switchState(new FreeplayState());
				case "Sans":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					playlist = 19;
					FlxG.switchState(new FreeplayState());
				case "Neon":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 20;
					FlxG.switchState(new FreeplayState());
				case "Kapi":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 22;
					FlxG.switchState(new FreeplayState());
				case "Chara":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 21;
				
					FlxG.switchState(new FreeplayState());
				case "Annie":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 23;
					FlxG.switchState(new FreeplayState());
				case "Tord":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 24;
					FlxG.switchState(new FreeplayState());
				case "Shaggy":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 25;
					FlxG.switchState(new FreeplayState());
				case "Anders":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 26;
					FlxG.switchState(new FreeplayState());
				case "Bob":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 42;
					FlxG.switchState(new FreeplayState());
				case "Tricky":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 28;
					FlxG.switchState(new FreeplayState());
				case "Whitty":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 29;
					FlxG.switchState(new FreeplayState());
				case "Zardy":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 30;
					FlxG.switchState(new FreeplayState());
				case "Tree":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 31;
					FlxG.switchState(new FreeplayState());
				case "Tabi":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 32;
					FlxG.switchState(new FreeplayState());
				case "Retrospecter":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 33;
					FlxG.switchState(new FreeplayState());
				case "Impostor":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 34;
					FlxG.switchState(new FreeplayState());
				case "B3 Remixes":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 35;
					FlxG.switchState(new FreeplayState());
				case "Detra":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 36;
					FlxG.switchState(new FreeplayState());
				case "Neko Freak":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 37;
					FlxG.switchState(new FreeplayState());
				case "Salty Sunday":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 38;
					FlxG.switchState(new FreeplayState());
				case "More Singles":
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					playlist = 40;
					FlxG.switchState(new FreeplayState());
				case 'Monika':
					playlist = 41;
					FlxG.switchState(new FreeplayState());

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

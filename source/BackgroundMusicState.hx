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


class BackgroundMusicState extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	public var menuItems:Array<String> = ['Normal','Neo','B-Sides','Hex', 'Agoti', 'Beatstreets'];

	public var curSelected:Int = 0;

	public var pauseMusic:FlxSound;
	public static var hex:Int = 0;
	public static var normal:Int = 1;
	public static var neo:Int = 0;
	public static var beat:Int = 0;
	public static var bsides:Int = 0;
	public static var agoti:Int = 0;

	


	
	override function create()
	{
		
	
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		if (CategoryState.chara != 1)
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
	 	else
		    bg = new FlxSprite().loadGraphic(Paths.image('chara-menu'));
		bg.scrollFactor.set();
		add(bg);

	


	
	
		
	

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
			FlxG.switchState(new OptionsMenuState());
		}
		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Normal":
					normal = 1;
					neo = 0;
					bsides = 0;
					hex = 0;
					beat = 0;
					agoti = 0;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				case "Neo":
					normal = 0;
					neo = 1;
					bsides = 0;
					hex = 0;
					beat = 0;
					agoti = 0;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu-n'));
				case "B-Sides":
					normal = 0;
					neo = 0;
					bsides = 1;
					hex = 0;
					beat = 0;
					agoti = 0;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu-b'));
				case "Hex":
					normal = 0;
					neo = 0;
					bsides = 0;
					beat = 0;
					hex = 1;
					agoti = 0;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu-h'));
				case "Agoti":
					normal = 0;
					neo = 0;
					bsides = 0;
					beat = 0;
					hex = 0;
					agoti = 1;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu-agoti'));
				case "Beatstreets":
					normal = 0;
					neo = 0;
					bsides = 0;
					hex = 0;
					beat = 1;
					agoti = 0;
					FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu-beat'));
					
					
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
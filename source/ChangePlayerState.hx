package;

import flixel.input.keyboard.FlxKeyboard;
import openfl.ui.Keyboard;
import openfl.display.Preloader.DefaultPreloader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.ui.FlxVirtualPad;
import flixel.effects.FlxFlicker;

using StringTools;

class ChangePlayerState extends MusicBeatState
{
	var bflist:Array<String> = [
		'bf', 'bf-christmas', 'bf-pixel', 'bf-b', 'bf-christmas-b', 'bf-pixel-b'
	];

	var curSelected:Int = 0;

	var _keyboard:FlxKeyboard;

	var BG:FlxSprite;

	var arrowsz:FlxSprite;

	var character:FlxSprite;

	var curselected_text:FlxText;

	var selected:Bool = false;

	override function create()
	{
		// bg
		BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG1.png');

		// characterselect_text
		var characterselect_text:Alphabet = new Alphabet(0, 0, "character select", true, false);
		characterselect_text.screenCenter();
		characterselect_text.y = 50;

		// curselected_text
		curselected_text = new FlxText(0, 10, bflist[0], 24);
		curselected_text.alpha = 0.5;
		curselected_text.x = (FlxG.width) - (curselected_text.width) - 25;

		// arrowsz
		arrowsz = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/arrowsz.png');

		// characters
		character = new FlxSprite(0, 0);

		character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/BOYFRIEND.png',
			'assets/images/charSelect/characters/vanilla/BOYFRIEND.xml');

		character.antialiasing = true;

		character.animation.addByPrefix('bf_idle', 'BF idle dance', 24);
		character.animation.addByPrefix('bf_select', 'BF HEY!!', 24);

		character.updateHitbox();

		character.setGraphicSize(Std.int(275));

		character.x = (FlxG.width / 2) - (character.width / 2);
		character.y = (FlxG.height / 2) - (character.height / 2);

		add(BG);

		add(arrowsz);

		add(characterselect_text);
		add(character);

		changeSelection(0);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.pressed.ESCAPE)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			switch curSelected
			{
				case 0:
					character.animation.play('bf_select');
				case 1:
					character.animation.play('bfChristmas_select');
				case 2:
					character.animation.play('bfPixel_select');
				case 3:
					character.animation.play('bf_select');
				case 4:
					character.animation.play('bfChristmas_select');
				case 5:
					character.animation.play('bfPixel_select');
				default:
					character.animation.play('bf_select');
			}

			selected = true;
			PlayState.bfsel = curSelected;

			FlxG.sound.play(Paths.sound('confirmMenu'));

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			changeSelection(1);
		}

		if (FlxG.keys.justPressed.LEFT)
		{
			changeSelection(-1);
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = bflist.length - 1;
		if (curSelected >= bflist.length)
			curSelected = 0;

		curselected_text.text = bflist[curSelected];

		switch curSelected
		{
			case 0:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/BOYFRIEND.png',
					'assets/images/charSelect/characters/vanilla/BOYFRIEND.xml');

				character.animation.addByPrefix('bf_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bf_select', 'BF HEY!!', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bf_idle');
			case 1:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/bfChristmas.png',
					'assets/images/charSelect/characters/vanilla/bfChristmas.xml');

				character.animation.addByPrefix('bfChristmas_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfChristmas_select', 'BF HEY!!', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfChristmas_idle');
			case 2:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/bfPixel.png',
					'assets/images/charSelect/characters/vanilla/bfPixel.xml');

				character.animation.addByPrefix('bfPixel_idle', 'BF IDLE instance', 24);
				character.animation.addByPrefix('bfPixel_select', 'BF UP NOTE instance', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfPixel_idle');
			case 3:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/BOYFRIEND-b.png',
					'assets/images/charSelect/characters/bsides/BOYFRIEND-b.xml');

				character.animation.addByPrefix('bf_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bf_select', 'BF HEY!!', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('bf_idle');
			case 4:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/bfChristmas-b.png',
					'assets/images/charSelect/characters/bsides/bfChristmas-b.xml');

				character.animation.addByPrefix('bfChristmas_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfChristmas_select', 'BF HEY!!', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('bfChristmas_idle');
			case 5:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/bfPixel-b.png',
					'assets/images/charSelect/characters/bsides/bfPixel-b.xml');

				character.animation.addByPrefix('bfPixel_idle', 'BF IDLE instance', 24);
				character.animation.addByPrefix('bfPixel_select', 'BF UP NOTE instance', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('bfPixel_idle');
			default:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/BOYFRIEND.png',
					'assets/images/charSelect/characters/vanilla/BOYFRIEND.xml');

				character.animation.addByPrefix('bf_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bf_select', 'BF HEY!!', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bf_idle');
		}
	}
}

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
		'bf', 'bf-christmas', 'bf-pixel', 'bf-holding-gf', 'bf-b', 'bf-christmas-b', 'bf-pixel-b', 'bf-neo', 'bf-minus', 'bf-minus-beta', 'bf-minus-blue',
		'ena', 'ena-christmas', 'ena-pixel', 'bf-rs', 'bf-christmas-rs', 'bf-pixel-rs', 'bf-star', 'bf-reanim', 'bf-christmas-reanim'
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
		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
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
					character.animation.play('bfGf_select');
				case 4:
					character.animation.play('bf_select');
				case 5:
					character.animation.play('bfChristmas_select');
				case 6:
					character.animation.play('bfPixel_select');
				case 7:
					character.animation.play('bfNeo_select');
				case 8:
					character.animation.play('bfMinus_select');
				case 9:
					character.animation.play('bfMinusBeta_select');
				case 10:
					character.animation.play('bfMinusBlue_select');
				case 11:
					character.animation.play('bfEna_select');
				case 12:
					character.animation.play('bfEnaChristmas_select');
				case 13:
					character.animation.play('bfEnaPixel_select');
				case 14:
					character.animation.play('bfRs_select');
				case 15:
					character.animation.play('bfRsChristmas_select');
				case 16:
					character.animation.play('bfRsPixel_select');
				case 17:
					character.animation.play('bfStar_select');
				case 18:
					character.animation.play('bfReanim_select');
				case 19:
					character.animation.play('bfReanimChristmas_select');
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
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/bfAndGF.png',
					'assets/images/charSelect/characters/vanilla/bfAndGF.xml');

				character.animation.addByPrefix('bfGf_idle', 'BF idle dance w gf', 24);
				character.animation.addByPrefix('bfGf_select', 'BF NOTE UP0', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG3.png');

				add(BG);
				add(character);

				character.animation.play('bfGf_idle');
			case 4:
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
			case 5:
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
			case 6:
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
			case 7:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/neo/bf-neo.png',
					'assets/images/charSelect/characters/neo/bf-neo.xml');

				character.animation.addByPrefix('bfNeo_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfNeo_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG7.png');

				add(BG);
				add(character);

				character.animation.play('bfNeo_idle');
			case 8:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/minus/BOYFRIEND_2.png',
					'assets/images/charSelect/characters/minus/BOYFRIEND_2.xml');

				character.animation.addByPrefix('bfMinus_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfMinus_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfMinus_idle');
			case 9:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/minus/BOYFRIEND_1.png',
					'assets/images/charSelect/characters/minus/BOYFRIEND_1.xml');

				character.animation.addByPrefix('bfMinusBeta_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfMinusBeta_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG2.png');

				add(BG);
				add(character);

				character.animation.play('bfMinusBeta_idle');
			case 10:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/minus/BOYFRIEND_3.png',
					'assets/images/charSelect/characters/minus/BOYFRIEND_3.xml');

				character.animation.addByPrefix('bfMinusBlue_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfMinusBlue_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG6.png');

				add(BG);
				add(character);

				character.animation.play('bfMinusBlue_idle');
			case 11:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/ena/BOYFRIEND-ena.png',
					'assets/images/charSelect/characters/ena/BOYFRIEND-ena.xml');

				character.animation.addByPrefix('bfEna_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfEna_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG4.png');

				add(BG);
				add(character);

				character.animation.play('bfEna_idle');
			case 12:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/ena/bfChristmas-ena.png',
					'assets/images/charSelect/characters/ena/bfChristmas-ena.xml');

				character.animation.addByPrefix('bfEnaChristmas_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfEnaChristmas_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG4.png');

				add(BG);
				add(character);

				character.animation.play('bfEnaChristmas_idle');
			case 13:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/ena/bfPixel-ena.png',
					'assets/images/charSelect/characters/ena/bfPixel-ena.xml');

				character.animation.addByPrefix('bfEnaPixel_idle', 'BF IDLE', 24);
				character.animation.addByPrefix('bfEnaPixel_select', 'BF UP NOTE', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG4.png');

				add(BG);
				add(character);

				character.animation.play('bfEnaPixel_idle');
			case 14:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/retrospecter/BOYFRIEND-rs.png',
					'assets/images/charSelect/characters/retrospecter/BOYFRIEND-rs.xml');

				character.animation.addByPrefix('bfRs_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfRs_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfRs_idle');
			case 15:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/retrospecter/bfChristmas-rs.png',
					'assets/images/charSelect/characters/retrospecter/bfChristmas-rs.xml');

				character.animation.addByPrefix('bfRsChristmas_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfRsChristmas_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfRsChristmas_idle');
			case 16:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/retrospecter/bfPixel-rs.png',
					'assets/images/charSelect/characters/retrospecter/bfPixel-rs.xml');

				character.animation.addByPrefix('bfRsPixel_idle', 'BF IDLE', 24);
				character.animation.addByPrefix('bfRsPixel_select', 'BF UP NOTE', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfRsPixel_idle');
			case 17:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/starcatcher/BOYFRIEND-star.png',
					'assets/images/charSelect/characters/starcatcher/BOYFRIEND-star.xml');

				character.animation.addByPrefix('bfStar_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfStar_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG0.png');

				add(BG);
				add(character);

				character.animation.play('bfStar_idle');
			case 18:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/reanimated/BOYFRIEND-reanim.png',
					'assets/images/charSelect/characters/reanimated/BOYFRIEND-reanim.xml');

				character.animation.addByPrefix('bfReanim_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfReanim_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG6.png');

				add(BG);
				add(character);

				character.animation.play('bfReanim_idle');
			case 19:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/reanimated/bfChristmas-reanim.png',
					'assets/images/charSelect/characters/reanimated/bfChristmas-reanim.xml');

				character.animation.addByPrefix('bfReanimChristmas_idle', 'BF idle dance', 24);
				character.animation.addByPrefix('bfReanimChristmas_select', 'BF HEY!!', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG6.png');

				add(BG);
				add(character);

				character.animation.play('bfReanimChristmas_idle');
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

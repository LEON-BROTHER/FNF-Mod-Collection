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
		'bf', 'bf-christmas', 'bf-pixel', 'dad', 'pico', 'spooky', 'monster', 'monster-christmas', 'mom', 'parents-christmas', 'senpai', 'senpai-angry',
		'spirit', 'annie', 'annie2', 'anders', 'anders-fearsome', 'bf-b', 'bf-christmas-b', 'bf-pixel-b', 'dad-b', 'pico-b', 'spooky-b',
		'monster-christmas-b', 'mom-b', 'parents-christmas-b', 'senpai-b', 'senpai-angry-b', 'spirit-b'
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
					character.animation.play('dad_select');
				case 4:
					character.animation.play('spooky_select');
				case 5:
					character.animation.play('monster_select');
				case 6:
					character.animation.play('pico_select');
				case 7:
					character.animation.play('mom_select');
				case 8:
					character.animation.play('parentsChristmas_select');
				case 9:
					character.animation.play('monsterChristmas_select');
				case 10:
					character.animation.play('senpai_select');
				case 11:
					character.animation.play('senpaiAngry_select');
				case 12:
					character.animation.play('spirit_select');
				case 13:
					character.animation.play('annie_select');
				case 14:
					character.animation.play('annie2_select');
				case 15:
					character.animation.play('anders_select');
				case 16:
					character.animation.play('andersFearsome_select');
				case 17:
					character.animation.play('bf_select');
				case 18:
					character.animation.play('bfChristmas_select');
				case 19:
					character.animation.play('bfPixel_select');
				case 20:
					character.animation.play('dad_select');
				case 21:
					character.animation.play('spooky_select');
				case 22:
					character.animation.play('pico_select');
				case 23:
					character.animation.play('mom_select');
				case 24:
					character.animation.play('parentsChristmas_select');
				case 25:
					character.animation.play('monsterChristmas_select');
				case 26:
					character.animation.play('senpai_select');
				case 27:
					character.animation.play('senpaiAngry_select');
				case 28:
					character.animation.play('spirit_select');
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
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/DADDY_DEAREST.png',
					'assets/images/charSelect/characters/vanilla/DADDY_DEAREST.xml');

				character.animation.addByPrefix('dad_idle', 'Dad idle dance', 24);
				character.animation.addByPrefix('dad_select', 'Dad Sing Note UP', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG1.png');

				add(BG);
				add(character);

				character.animation.play('dad_idle');
			case 4:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/spooky_kids_assets.png',
					'assets/images/charSelect/characters/vanilla/spooky_kids_assets.xml');

				character.animation.addByPrefix('spooky_idle', 'spooky dance idle', 24);
				character.animation.addByPrefix('spooky_select', 'spooky UP NOTE', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG3.png');

				add(BG);
				add(character);

				character.animation.play('spooky_idle');
			case 5:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/Monster_Assets.png',
					'assets/images/charSelect/characters/vanilla/Monster_Assets.xml');

				character.animation.addByPrefix('monster_idle', 'monster idle', 24);
				character.animation.addByPrefix('monster_select', 'monster up note', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG4.png');

				add(BG);
				add(character);

				character.animation.play('monster_idle');
			case 6:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/Pico_FNF_assetss.png',
					'assets/images/charSelect/characters/vanilla/Pico_FNF_assetss.xml');

				character.animation.addByPrefix('pico_idle', 'Pico Idle Dance', 24);
				character.animation.addByPrefix('pico_select', 'pico Up note0', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG2.png');

				add(BG);
				add(character);

				character.animation.play('pico_idle');
			case 7:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/Mom_Assets.png',
					'assets/images/charSelect/characters/vanilla/Mom_Assets.xml');

				character.animation.addByPrefix('mom_idle', 'Mom Idle', 24);
				character.animation.addByPrefix('mom_select', 'Mom Up Pose', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG1.png');

				add(BG);
				add(character);

				character.animation.play('mom_idle');
			case 8:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/mom_dad_christmas_assets.png',
					'assets/images/charSelect/characters/vanilla/mom_dad_christmas_assets.xml');

				character.animation.addByPrefix('parentsChristmas_idle', 'Parent Christmas Idle', 24);
				character.animation.addByPrefix('parentsChristmas_select', 'Parent Up Note Dad', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG1.png');

				add(BG);
				add(character);

				character.animation.play('parentsChristmas_idle');
			case 9:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/monsterChristmas.png',
					'assets/images/charSelect/characters/vanilla/monsterChristmas.xml');

				character.animation.addByPrefix('monsterChristmas_idle', 'monster idle', 24);
				character.animation.addByPrefix('monsterChristmas_select', 'monster up note', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG4.png');

				add(BG);
				add(character);

				character.animation.play('monsterChristmas_idle');
			case 10:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/senpai.png',
					'assets/images/charSelect/characters/vanilla/senpai.xml');

				character.animation.addByPrefix('senpai_idle', 'Senpai Idle instance', 24);
				character.animation.addByPrefix('senpai_select', 'SENPAI UP NOTE instance', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG6.png');

				add(BG);
				add(character);

				character.animation.play('senpai_idle');
			case 11:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/senpai.png',
					'assets/images/charSelect/characters/vanilla/senpai.xml');

				character.animation.addByPrefix('senpaiAngry_idle', 'Angry Senpai Idle instance', 24);
				character.animation.addByPrefix('senpaiAngry_select', 'Angry Senpai UP NOTE', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG6.png');

				add(BG);
				add(character);

				character.animation.play('senpaiAngry_idle');
			case 12:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/vanilla/spiritFaceForward.png',
					'assets/images/charSelect/characters/vanilla/spirit.xml');

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG5.png');

				add(BG);
				add(character);
			case 13:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/annie/Pico_FNF_assetss.png',
					'assets/images/charSelect/characters/annie/Pico_FNF_assetss.xml');

				character.animation.addByPrefix('annie_idle', 'Pico Idle Dance', 24);
				character.animation.addByPrefix('annie_select', 'pico Up note0', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG10.png');

				add(BG);
				add(character);

				character.animation.play('annie_idle');
			case 14:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/annie/monsterChristmas.png',
					'assets/images/charSelect/characters/annie/monsterChristmas.xml');

				character.animation.addByPrefix('annie2_idle', 'monster idle', 24);
				character.animation.addByPrefix('annie2_select', 'monster up note', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG10.png');

				add(BG);
				add(character);

				character.animation.play('annie2_idle');
			case 15:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/anders/anders.png',
					'assets/images/charSelect/characters/anders/anders.xml');

				character.animation.addByPrefix('anders_idle', 'Dad idle dance', 24);
				character.animation.addByPrefix('anders_select', 'Dad Sing Note UP', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG7.png');

				add(BG);
				add(character);

				character.animation.play('anders_idle');
			case 16:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/anders/anders_fearsome.png',
					'assets/images/charSelect/characters/anders/anders_fearsome.xml');

				character.animation.addByPrefix('andersFearsome_idle', 'anders_f_idle', 24);
				character.animation.addByPrefix('andersFearsome_select', 'anders_f_up_note', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG7.png');

				add(BG);
				add(character);

				character.animation.play('andersFearsome_idle');
			case 17:
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
			case 18:
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
			case 19:
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
			case 20:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/DADDY_DEAREST-b.png',
					'assets/images/charSelect/characters/bsides/DADDY_DEAREST-b.xml');

				character.animation.addByPrefix('dad_idle', 'Dad idle dance', 24);
				character.animation.addByPrefix('dad_select', 'Dad Sing Note UP', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('dad_idle');
			case 21:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/spooky-b.png',
					'assets/images/charSelect/characters/bsides/spooky-b.xml');

				character.animation.addByPrefix('spooky_idle', 'spooky dance idle', 24);
				character.animation.addByPrefix('spooky_select', 'spooky UP NOTE', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('spooky_idle');
			case 22:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/pico-b.png',
					'assets/images/charSelect/characters/bsides/pico-b.xml');

				character.animation.addByPrefix('pico_idle', 'Pico Idle Dance', 24);
				character.animation.addByPrefix('pico_select', 'pico Up note0', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('pico_idle');
			case 23:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/momCar-b.png',
					'assets/images/charSelect/characters/bsides/momCar-b.xml');

				character.animation.addByPrefix('mom_idle', 'Mom Idle', 24);
				character.animation.addByPrefix('mom_select', 'Mom Up Pose', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('mom_idle');
			case 24:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/mom_dad_christmas_assets-b.png',
					'assets/images/charSelect/characters/bsides/mom_dad_christmas_assets-b.xml');

				character.animation.addByPrefix('parentsChristmas_idle', 'Parent Christmas Idle', 24);
				character.animation.addByPrefix('parentsChristmas_select', 'Parent Up Note Dad', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('parentsChristmas_idle');
			case 25:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/monsterChristmas.png',
					'assets/images/charSelect/characters/bsides/monsterChristmas.xml');

				character.animation.addByPrefix('monsterChristmas_idle', 'monster idle', 24);
				character.animation.addByPrefix('monsterChristmas_select', 'monster up note', 24);

				character.antialiasing = true;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('monsterChristmas_idle');
			case 26:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/senpai-b.png',
					'assets/images/charSelect/characters/bsides/senpai-b.xml');

				character.animation.addByPrefix('senpai_idle', 'Senpai Idle instance', 24);
				character.animation.addByPrefix('senpai_select', 'SENPAI UP NOTE instance', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('senpai_idle');
			case 27:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/senpai-b.png',
					'assets/images/charSelect/characters/bsides/senpai-b.xml');

				character.animation.addByPrefix('senpaiAngry_idle', 'Angry Senpai Idle instance', 24);
				character.animation.addByPrefix('senpaiAngry_select', 'Angry Senpai UP NOTE', 24);

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);

				character.animation.play('senpaiAngry_idle');
			case 28:
				remove(character);
				remove(BG);

				character = new FlxSprite(0, 0);
				character.frames = FlxAtlasFrames.fromSparrow('assets/images/charSelect/characters/bsides/spiritFaceForward.png',
					'assets/images/charSelect/characters/bsides/spirit.xml');

				character.antialiasing = false;

				character.updateHitbox();

				character.setGraphicSize(Std.int(275));

				character.x = (FlxG.width / 2) - (character.width / 2);
				character.y = (FlxG.height / 2) - (character.height / 2);

				BG = new FlxSprite(0, 0).loadGraphic('assets/images/charSelect/bgs/BG9.png');

				add(BG);
				add(character);
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

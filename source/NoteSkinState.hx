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
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class NoteSkinState extends MusicBeatState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	public var menuItems:Array<String> = [
		'Normal',
		'Neo',
		'X-Event',
		'Starcatcher',
		'Sarv-Notes',
		'Beatstreets',
		'Tabi-Notes',
		'Starlight-Notes',
		"Kapi-Notes",
		"Agoti-Notes",
		"Sketchy-Notes"
	];

	public var curSelected:Int = 0;

	public var pauseMusic:FlxSound;

	public static var normal:Int = 1;
	public static var neo:Int = 0;
	public static var xe:Int = 0;
	public static var star:Int = 0;
	public static var sarv:Int = 0;
	public static var beats:Int = 0;
	public static var tabi:Int = 0;
	public static var starlight:Int = 0;
	public static var kapi:Int = 0;
	public static var agoti:Int = 0;
	public static var sketchy:Int = 0;
	public static var keys:FlxText;
	public static var sel:String = "Normal";

	public var strumLine:FlxSprite;
	public var strumLineNotes:FlxTypedGroup<FlxSprite>;
	public var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camHUD:FlxCamera;
	var babyArrow:FlxSprite;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		if (CategoryState.chara != 1)
			bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		else
			bg = new FlxSprite().loadGraphic(Paths.image('chara-menu'));
		bg.scrollFactor.set();
		add(bg);
		keys = new FlxText(70, 0, 0, "", 32);
		keys.text = "CurSelected: " + sel;
		keys.scrollFactor.set();
		keys.setFormat(Paths.font('vcr.ttf'), 32);
		keys.updateHitbox();
		add(keys);
		FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);

		strumLine = new FlxSprite(0, 25).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		strumLine.cameras = [camHUD];
		playerStrums.cameras = [camHUD];

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
					xe = 0;
					star = 0;
					beats = 0;
					sarv = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Normal";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Neo":
					normal = 0;
					neo = 1;
					xe = 0;
					star = 0;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Neo";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "X-Event":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 1;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "X-Event";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Starcatcher":
					normal = 0;
					neo = 0;
					star = 1;
					xe = 0;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Starcatcher";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Beatstreets":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 0;
					beats = 1;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Beatstreets";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Sarv-Notes":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 1;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Sarv-Notes";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Tabi-Notes":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 0;
					beats = 0;
					tabi = 1;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Tabi-Notes";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Starlight-Notes":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 1;
					kapi = 0;
					agoti = 0;
					sketchy = 0;
					sel = "Starlight-Notes";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Kapi-Notes":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 1;
					agoti = 0;
					sketchy = 0;
					sel = "Kapi-Notes";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Agoti-Notes":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 1;
					sketchy = 0;
					sel = "Agoti-Notes";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
				case "Sketchy-Notes":
					normal = 0;
					neo = 0;
					star = 0;
					xe = 0;
					sarv = 0;
					beats = 0;
					tabi = 0;
					starlight = 0;
					kapi = 0;
					agoti = 0;
					sketchy = 1;
					sel = "Sketchy-Notes";
					FlxTween.tween(keys, {alpha: 1, y: 0}, 0.4, {ease: FlxEase.quartInOut});
					keys.text = "CurSelected: " + sel;
					keys.scrollFactor.set();
					keys.setFormat(Paths.font('vcr.ttf'), 32);
					keys.updateHitbox();
					add(keys);
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

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			babyArrow = new FlxSprite(0, strumLine.y);
			if (curSelected == 1)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-neo');
			if (curSelected == 2)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-xe');
			if (curSelected == 0)
				babyArrow.frames = Paths.getSparrowAtlas('shaggy/NOTE_assets-shaggy');
			if (curSelected == 3)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-star');
			if (curSelected == 4)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets2');
			if (curSelected == 5)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-beats');
			if (curSelected == 6)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-tabi');
			if (curSelected == 7)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-starlight');
			if (curSelected == 8)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-kapi');
			if (curSelected == 9)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-agoti');
			if (curSelected == 10)
				babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-sketchy');
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
			babyArrow.antialiasing = true;
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			switch (Math.abs(i))
			{
				case 0:
					babyArrow.x += Note.swagWidth * 0;
					babyArrow.animation.addByPrefix('static', 'purple0', 24, false);
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
				case 1:
					babyArrow.x += Note.swagWidth * 1;
					babyArrow.animation.addByPrefix('static', 'blue0', 24, false);
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 2:
					babyArrow.x += Note.swagWidth * 2;
					babyArrow.animation.addByPrefix('static', 'green0', 24, false);
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.x += Note.swagWidth * 3;
					babyArrow.animation.addByPrefix('static', 'red0', 24, false);
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
			}
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		generateStaticArrows(1);
		// Chopper.exe is auf mordliste//

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

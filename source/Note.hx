package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public static var noteScale:Float;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;
	public var mania:Int = 0;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var EX1_NOTE:Int = 4;
	public static var EX2_NOTE:Int = 5;
	public static var tooMuch:Float = 30;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		
		swagWidth = 160 * 0.7; //factor not the same as noteScale
		noteScale = 0.7;
		mania = 0;
		if (PlayState.SONG.mania == 1)
		{
			swagWidth = 120 * 0.7;
			noteScale = 0.6;
			mania = 1;
		}
		else if (PlayState.SONG.mania == 2)
		{
			swagWidth = 90 * 0.7;
			noteScale = 0.46;
			mania = 2;
		}
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		if (PlayState.SONG.mania == 2)
		{
			x -= tooMuch;
		}
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		this.noteData = noteData;

		
		this.strumTime = strumTime;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil' | 'school-b' | 'schoolEvil-b' :
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);
			

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			case 'school-neon' | 'school-neon-2':
				loadGraphic(Paths.image('neon/pixelUI/arrows-pixels'), true, 17, 17);

				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);

				if (isSustainNote)
				{
					loadGraphic(Paths.image('neon/pixelUI/arrowEnds'), true, 7, 6);

					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);
			

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
			default:
				if (NoteSkinState.neo == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets-neo');
				if (NoteSkinState.xe == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets-xe');
				if (NoteSkinState.normal == 1)
					frames = Paths.getSparrowAtlas('shaggy/NOTE_assets-shaggy');
				if (NoteSkinState.star == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets-star');
				if (NoteSkinState.sarv == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets2');
				if (NoteSkinState.beats == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets-beats');
				
				if (mania == 1 || mania == 2)
					frames = Paths.getSparrowAtlas('shaggy/NOTE_assets-shaggy');
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				if (mania == 1 || mania == 2)
					animation.addByPrefix('whiteScroll', 'white0');
					animation.addByPrefix('yellowScroll', 'yellow0');
					animation.addByPrefix('violetScroll', 'violet0');
					animation.addByPrefix('blackScroll', 'black0');
					animation.addByPrefix('darkScroll', 'dark0');


				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');
				if (mania == 1 || mania == 2)
					animation.addByPrefix('whiteholdend', 'white hold end');
					animation.addByPrefix('yellowholdend', 'yellow hold end');
					animation.addByPrefix('violetholdend', 'violet hold end');
					animation.addByPrefix('blackholdend', 'black hold end');
					animation.addByPrefix('darkholdend', 'dark hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				if (mania == 1 || mania == 2)
					animation.addByPrefix('whitehold', 'white hold piece');
					animation.addByPrefix('yellowhold', 'yellow hold piece');
					animation.addByPrefix('violethold', 'violet hold piece');
					animation.addByPrefix('blackhold', 'black hold piece');
					animation.addByPrefix('darkhold', 'dark hold piece');

				setGraphicSize(Std.int(width * noteScale));
				updateHitbox();
				antialiasing = true;
		}

		switch (noteData)
		{
			case 0:
			//nada
		}
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1) frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2) frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];

		x += swagWidth * noteData;
		animation.play(frameN[noteData] + 'Scroll');
		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;
			if (FlxG.save.data.down == 'down')
			{
				scale.y *= -1;
			}

			x += width / 2;

			animation.play(frameN[noteData] + 'holdend');
			switch (noteData)
			{
				case 0:
				//nada
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
					//nada
				}
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');
				
				
				if (FlxG.save.data.down == 'down' && PlayState.SONG.speed < 2.0)
				{
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.0 * PlayState.SONG.speed;
					trace('0');
				}

			

				else if (FlxG.save.data.down == 'down' && PlayState.SONG.speed > 1.9 && PlayState.SONG.speed < 2.6)  
				{ 
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 0.9 * PlayState.SONG.speed;
					trace('1');
				}
				else if (FlxG.save.data.down == 'down' && PlayState.SONG.speed > 2.5 && PlayState.SONG.speed < 2.9) 
				{
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 0.8 * PlayState.SONG.speed;
					trace('2');
				}
				else if (FlxG.save.data.down == 'down' && PlayState.SONG.speed > 2.9) 
				{
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 0.7 * PlayState.SONG.speed;
					trace('3');
				}
				else
				{
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed * (0.7 / noteScale);
					trace('Upscroll');
				}
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		//getStrumTime();

		super.update(elapsed);

		if (mustPress)
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
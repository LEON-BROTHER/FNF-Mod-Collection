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
	public var burning:Bool = false;
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

	public function new(strumTime:Float, _noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		swagWidth = 160 * 0.7; // factor not the same as noteScale
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

		burning = _noteData > 7;
		// if(!isSustainNote) { burning = Std.random(3) == 1; } //Set random notes to burning

		// No held fire notes :[ (Part 1)
		if (isSustainNote && prevNote.burning)
		{
			burning = true;
		}

		this.noteData = _noteData % 4;

		this.strumTime = strumTime;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil' | 'school-b' | 'schoolEvil-b':
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

				if (burning)
				{
					if (daStage == 'auditorHell')
					{
						frames = Paths.getSparrowAtlas('fourth/mech/ALL_deathnotes');
						animation.addByPrefix('greenScroll', 'Green Arrow');
						animation.addByPrefix('redScroll', 'Red Arrow');
						animation.addByPrefix('blueScroll', 'Blue Arrow');
						animation.addByPrefix('purpleScroll', 'Purple Arrow');
						x -= 165;
					}
					else
					{
						trace("fire pog");

						frames = Paths.getSparrowAtlas('NOTE_fire');
						if (!FlxG.save.data.downscroll)
						{
							animation.addByPrefix('blueScroll', 'blue fire');
							animation.addByPrefix('greenScroll', 'green fire');
						}
						else
						{
							animation.addByPrefix('greenScroll', 'blue fire');
							animation.addByPrefix('blueScroll', 'green fire');
						}
						animation.addByPrefix('redScroll', 'red fire');
						animation.addByPrefix('purpleScroll', 'purple fire');

						if (FlxG.save.data.downscroll)
							flipY = true;

						x -= 50;
					}
				}
		}

		if (burning)
			setGraphicSize(Std.int(width * 0.86));

		switch (noteData)
		{
			case 0:
				// nada
		}
		var frameN:Array<String> = ['purple', 'blue', 'green', 'red'];
		if (mania == 1)
			frameN = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
		else if (mania == 2)
			frameN = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'black', 'dark'];

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
					// nada
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
						// nada
				}
				prevNote.animation.play(frameN[prevNote.noteData] + 'hold');

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed * (0.7 / noteScale);
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		// getStrumTime();

		super.update(elapsed);

				//No held fire notes :[ (Part 2)
				if(isSustainNote && prevNote.burning) { 
					this.kill(); 
				}

		if (mustPress)
		{
			if (!burning)
				{
					if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
						&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
						canBeHit = true;
					else
						canBeHit = false;
				}
				else
				{
					if (PlayState.curStage == 'auditorHell') // these though, REALLY hard to hit.
					{
						if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.3)
							&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2)) // also they're almost impossible to hit late!
							canBeHit = true;
						else
							canBeHit = false;
					}
					else
					{
					// make burning notes a lot harder to accidently hit because they're weirdchamp!
						if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.6)
							&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.4)) // also they're almost impossible to hit late!
							canBeHit = true;
						else
							canBeHit = false;
					}
				}
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

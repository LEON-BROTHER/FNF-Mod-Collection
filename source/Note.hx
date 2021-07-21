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

	public var noteType:Int = 0;
	public var fuck:Bool = false;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0)
	{
		this.noteType = noteType;
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

		// if(!isSustainNote) { burning = Std.random(3) == 1; } //Set random notes to burning

		// No held fire notes :[ (Part 1)
		var daStage:String = PlayState.curStage;
		this.noteData = noteData % 9;

		this.strumTime = strumTime;

		switch (daStage)
		{
			case 'school' | 'schoolEvil' | 'school-b' | 'schoolEvil-b' | 'school-b3' | 'schoolEvil-b3' | 'school-salty' | 'schoolEvil-salty':
				

				loadGraphic(Paths.image('monika/weeb/pixelUI/arrows-pixels'), true, 17, 17);

				if (noteType == 2)
					{
						animation.add('greenScroll', [22]);
						animation.add('redScroll', [23]);
						animation.add('blueScroll', [21]);
						animation.add('purpleScroll', [20]);
					}
				else
					{
						animation.add('greenScroll', [6]);
						animation.add('redScroll', [7]);
						animation.add('blueScroll', [5]);
						animation.add('purpleScroll', [4]);
					}

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
				if (NoteSkinState.tabi == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets-tabi');
				if (NoteSkinState.starlight == 1)
					frames = Paths.getSparrowAtlas('NOTE_assets-starlight');

				if (mania == 1 || mania == 2)
					frames = Paths.getSparrowAtlas('shaggy/NOTE_assets-shaggy');
				if (noteType == 2)
					{
						frames = Paths.getSparrowAtlas('ALL_deathnotes');
						x -= 165;
						animation.addByPrefix('greenScroll', 'Green Arrow');
						animation.addByPrefix('redScroll', 'Red Arrow');
						animation.addByPrefix('blueScroll', 'Blue Arrow');
						animation.addByPrefix('purpleScroll', 'Purple Arrow');
					}
					 else if (noteType == 3)
						{
							frames = Paths.getSparrowAtlas('NOTE_fire', "clown");
							if(!ClientPrefs.downScroll){
								animation.addByPrefix('blueScroll', 'blue fire');
								animation.addByPrefix('greenScroll', 'green fire');
							}
							else{
								animation.addByPrefix('greenScroll', 'blue fire');
								animation.addByPrefix('blueScroll', 'green fire');
							}
							animation.addByPrefix('redScroll', 'red fire');
							animation.addByPrefix('purpleScroll', 'purple fire');
	
							if(ClientPrefs.downScroll)
								flipY = true;
	
							x -= 50;
						}
				else if (noteType == 10)
					{
					frames = Paths.getSparrowAtlas('bob/CustomNotes');

				animation.addByPrefix('greenScroll', 'vertedUp');
				animation.addByPrefix('redScroll', 'vertedRight');
				animation.addByPrefix('blueScroll', 'vertedDown');
				animation.addByPrefix('purpleScroll', 'vertedLeft');

				
				updateHitbox();
				antialiasing = true;
					}
				else if (noteType == 11)
					{
					frames = Paths.getSparrowAtlas('bob/CustomNotes');

				animation.addByPrefix('greenScroll', 'hitUp');
				animation.addByPrefix('redScroll', 'hitRight');
				animation.addByPrefix('blueScroll', 'hitDown');
				animation.addByPrefix('purpleScroll', 'hitLeft');

				
				updateHitbox();
				antialiasing = true;
					}
				else {

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');
				animation.addByPrefix('whiteScroll', 'white0');
				animation.addByPrefix('yellowScroll', 'yellow0');
				animation.addByPrefix('violetScroll', 'violet0');
				animation.addByPrefix('blackScroll', 'black0');
				animation.addByPrefix('darkScroll', 'dark0');
				}

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
			if (ClientPrefs.downScroll)
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
		if (fuck)
			alpha = 0;

		// No held fire notes :[ (Part 2)

		if (mustPress)
		{
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

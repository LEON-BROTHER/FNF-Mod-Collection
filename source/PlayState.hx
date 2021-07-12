package;

import flixel.system.debug.Window;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import PauseSubState;
import openfl.media.Video;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

using StringTools;

class PlayState extends MusicBeatState
{
	public var screenDanced:Bool = false;
	public var chromDanced:Bool = false;

	public var vignette:FlxSprite;

	private var vignetteCamera:FlxCamera;

	public var noteShaked:Bool = false;
	public var crazyMode:Bool = false;
	public var isGenocide:Bool = false;
	public var minusHealth:Bool = false;
	public var justDoItMakeYourDreamsComeTrue:Bool = false;
	public var doIt:Bool = true;
	public var samShit:FlxSprite;

	var crowd:MogusBoppers;

	var genocideBG:FlxSprite;
	var genocideBoard:FlxSprite;
	var siniFireBehind:FlxTypedGroup<SiniFire>;
	var siniFireFront:FlxTypedGroup<SiniFire>;

	private var noteCam:FlxCamera;

	public var doIdle:Bool = false;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	var space:FlxBackdrop;
	var oldspace:FlxSprite;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var pissedsky:Int = 0;
	public static var tankmangood:Int = 0;
	public static var ughsky:Int = 0;
	public static var garlilman:Int = 0;
	public static var mania:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9];

	var gfVersion:String = 'gf';

	public static var bfsel:Int = 5000;

	var babymodep:String = PauseSubState.babymode;
	var sickmode:String = PauseSubState.sickmode;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	public var zeitwarten:Int = 1;
	public var timerwarten:Int = 0;

	private var cutTime:Float;
	private var shaggyT:FlxTrail;
	private var ctrTime:Float = 0;
	private var notice:FlxText;
	private var nShadow:FlxText;
	var bobmadshake:FlxSprite;
	var bobsound:FlxSound;

	public var TrickyLinesSing:Array<String> = [
		"SUFFER", "INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE",
		"MISJUDGED"
	];
	public var ExTrickyLinesSing:Array<String> = [
		"YOU AREN'T HANK",
		"WHERE IS HANK",
		"HANK???",
		"WHO ARE YOU",
		"WHERE AM I",
		"THIS ISN'T RIGHT",
		"MIDGET",
		"SYSTEM UNRESPONSIVE",
		"WHY CAN'T I KILL?????"
	];
	public var TrickyLinesMiss:Array<String> = [
		"TERRIBLE", "WASTE", "MISS CALCULTED", "PREDICTED", "FAILURE", "DISGUSTING", "ABHORRENT", "FORESEEN", "CONTEMPTIBLE", "PROGNOSTICATE", "DISPICABLE",
		"REPREHENSIBLE"
	];

	var MAINLIGHT:FlxSprite;

	public static var dad:Character;

	var s_ending:Bool = false;

	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	public static var gf:Character;

	private var boyfriend:Boyfriend;
	var tstatic:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('TrickyStatic', 'clown'), true, 320, 180);


	var tankmanreal:Int = 0;
	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	public static var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	var dreamOneBG:FlxSprite;
	var dreamOneIcons:FlxSprite;
	var dreamOneStage:FlxSprite;
	var dreamTwoBG:FlxSprite;
	var dreamTwoIcons:FlxSprite;
	var dreamTwoStage:FlxSprite;

	var tankSpeedJohn:Array<Float> = [];
	var goingRightJohn:Array<Bool> = [];
	var endingOffsetJohn:Array<Float> = [];
	var strumTimeJohn:Array<Dynamic> = [];

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	var johns:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;

	public static var staticVar:PlayState;

	public static var curSong:String = "";

	var steve:FlxSprite;
	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Float = 0;

	private var floatshit:Float = 0;

	public var curLight:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	public static var generatedMusic:Bool = false;

	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	var doof:DialogueBox;
	var doof2:DialogueBox;
	var doof3:DialogueBox;
	public static var showCutscene:Bool = true;
	var doof4:DialogueBox;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var burst:FlxSprite;
	var rock:FlxSprite;
	var gf_rock:FlxSprite;
	var doorFrame:FlxSprite;

	var dfS:Float = 1;

	var gf_launched:Bool = false;
	var sh_r:Float = 600;
	public var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	public var extra1:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra2:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];
	public var extra3:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	private var shakeEffect:Bool = false; 
	private var slightShakeEffect:Bool = false;
	var whiteflash:FlxSprite;
	var blackScreen:FlxSprite;

	var halloweenBG:FlxSprite;
	var halloweenBG3:FlxSprite;
	var halloweenBG4:FlxSprite;
	var halloweenBG5:FlxSprite;
	var halloweenBG6:FlxSprite;
	var halloweenBG7:FlxSprite;
	var curl1:FlxSprite;
	var curl2:FlxSprite;
	var curl3:FlxSprite;
	var isHalloween:Bool = false;
	var lightchara:Int = 0;
	var godCutEnd:Bool = false;
	var godMoveBf:Bool = true;
	var godMoveGf:Bool = false;
	var godMoveSh:Bool = false;
	var hank:FlxSprite;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var stageFront:FlxSprite;
	var gaster:FlxSprite;
	var deadpill:FlxSprite;

	var bellhillbg:FlxSprite;
	var superbellhill:FlxSprite;
	var SpgBg:FlxSprite;
	var furybg:FlxSprite;
	var furybackgroundthings:FlxSprite;
	var furybellshrine:FlxSprite;
	var catbell:FlxSprite;
	var bowserbodylol:FlxSprite;
	var redglow:FlxSprite;
	var redfilter:FlxSprite;
	var justwhite:FlxSprite;

	var squaredown:Int = 0;
	var squareoverwrite:FlxSprite;
	var squareoverwrite1:FlxSprite;

	var flashSprite:FlxSprite = new FlxSprite(-70, -70).makeGraphic(5000, 5000, 0xFFb30000);

	public var charactergaster:FlxSprite;

	var squareoverwrite2:FlxSprite;
	var squareoverwrite3:FlxSprite;
	var squareoverwrite4:FlxSprite;
	var littleGuys:FlxSprite;
	var squareoverwrite5:FlxSprite;

	var normalStage:FlxTypedGroup<FlxSprite>;
	var headlights:FlxSprite;
	var frontbop:FlxSprite;
	var cj:FlxSprite;
	private var dadRGB:Character;
	private var gfRGB:Character;
	private var bfRGB:Boyfriend;
	var rgbheadlights:FlxSprite;
	var rgbfrontbop:FlxSprite;
	var bopped:Bool = false;
	var rgbStage:FlxTypedGroup<FlxSprite>;
	var rgbString:String = '';

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;

	var _cb = 0;

	public static var songMiss:Int = 0;

	var songtrueScore:Int = 0;
	var scoreTxt:FlxText;
	var songtxt:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var songLength:Float = 0;
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	override public function create()
	{
		/*if (SONG.song.toLowerCase() == 'genocide')
			{
				trace('RIP RAM lol');
		}*/
		doIdle = false;
		isGenocide = (SONG.song.toLowerCase() == 'genocide');
		if ((SONG.song.toLowerCase() == 'genocide' && storyDifficulty >= 2) || (SONG.song.toLowerCase() == 'genocide-rs' && storyDifficulty >= 2))
		{
			crazyMode = true;
		}
		if (crazyMode)
		{
			health = 2;
		}
		minusHealth = false;
		justDoItMakeYourDreamsComeTrue = false;
		doIt = true;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		var cover:FlxSprite = new FlxSprite(-180, 755).loadGraphic(Paths.image('fourth/cover', 'clown'));
		var hole:FlxSprite = new FlxSprite(50, 530).loadGraphic(Paths.image('fourth/Spawnhole_Ground_BACK', 'clown'));
		var converHole:FlxSprite = new FlxSprite(7, 578).loadGraphic(Paths.image('fourth/Spawnhole_Ground_COVER', 'clown'));

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		staticVar = this;
		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');
		if (ClientPrefs.noteSplashes)
		{
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		var sploosh = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(sploosh);
		}
		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		mania = SONG.mania;
		whiteflash = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.WHITE);
		whiteflash.scrollFactor.set();
		blackScreen = new FlxSprite(-100, -100).makeGraphic(Std.int(FlxG.width * 100), Std.int(FlxG.height * 100), FlxColor.BLACK);
		blackScreen.scrollFactor.set();

		#if desktop
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'senpai-angry-b':
				iconRPC = 'senpai-b';
			case 'monster-christmas':
				iconRPC = 'lemon';
			case 'monster-christmas-b':
				iconRPC = 'lemon-b';
			case 'trickyMask':
				iconRPC = 'trickymask';
			case 'hex-noon':
				iconRPC = 'hex';
			case 'hex-night':
				iconRPC = 'hex';
			case 'sky-annoyed':
				iconRPC = 'sky';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'senpai-b-sides':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai-b-sides/senpaiDialogue'));
			case 'roses-b-sides':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses-b-sides/rosesDialogue'));
			case 'thorns-b-sides':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns-b-sides/thornsDialogue'));
				case 'high school conflict':
					dialogue = CoolUtil.coolTextFile(Paths.txt('high school conflict/high-school-conflictDialogue'));
					extra3 = CoolUtil.coolTextFile(Paths.txt('high school conflict/high-school-conflictEndDialogue')); 
				case 'bara no yume':
					extra1 = CoolUtil.coolTextFile(Paths.txt('bara no yume/bara no yume-Dialogue'));
					extra3 = CoolUtil.coolTextFile(Paths.txt('bara no yume/bara no yume-EndDialogue')); 
				case 'your demise':
					dialogue = CoolUtil.coolTextFile(Paths.txt('your demise/your-demiseDialogue'));
					extra2 = CoolUtil.coolTextFile(Paths.txt('your demise/your-demiseEndDialogue'));
					extra3 = CoolUtil.coolTextFile(Paths.txt('your demise/FinalCutsceneDialouge'));
		}

		vignetteCamera = new FlxCamera();
		vignetteCamera.bgColor.alpha = 0;

		FlxG.cameras.add(vignetteCamera);

		rgbStage = new FlxTypedGroup<FlxSprite>();
		add(rgbStage);
		
		switch (SONG.song.toLowerCase())
		{
		case 'artificial-lust':
		
			var bg:FlxSprite = new FlxSprite(0, 0);
			bg = new FlxSprite(-550, -160).loadGraphic(Paths.image('event/bg', 'CJ'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.5, 0.5);
			bg.active = false;
			rgbStage.add(bg);

			var stage:FlxSprite = new FlxSprite(-510, -260).loadGraphic(Paths.image('event/stage', 'CJ'));
			stage.antialiasing = ClientPrefs.globalAntialiasing;
			stage.active = false;
			rgbStage.add(stage);

			var light:FlxSprite = new FlxSprite(-510, -260).loadGraphic(Paths.image('event/light', 'CJ'));
			light.antialiasing = ClientPrefs.globalAntialiasing;
			rgbStage.add(light);

			rgbfrontbop = new FlxSprite(-510, 950);
			rgbfrontbop.frames = Paths.getSparrowAtlas('RGBfrontboppers', 'CJ');
			rgbfrontbop.antialiasing = ClientPrefs.globalAntialiasing;
			rgbfrontbop.animation.addByPrefix('idle', 'frontboppers', 24, false);
			rgbfrontbop.animation.play('idle');
			rgbStage.add(rgbfrontbop);

			rgbheadlights = new FlxSprite(-510, -80);
			rgbheadlights.frames = Paths.getSparrowAtlas('headlightsRGB', 'CJ');
			rgbheadlights.antialiasing = ClientPrefs.globalAntialiasing;
			rgbheadlights.animation.addByIndices('idle', 'lightsrepeated', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
			rgbheadlights.animation.addByIndices('idle2', 'lightsrepeated', [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25], "", 24, false);
			rgbheadlights.animation.play('idle');
			rgbStage.add(rgbheadlights);
		

		case 'spookeez' 
			| 'monster'
			| 'south'
			| 'spookeez-duet'
			| 'monster-duet'
			| 'south-duet':
		
			curStage = "spooky";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'megalo-strike-back':
		
			curStage = "charaut";
			defaultCamZoom = 0.90;

			halloweenBG = new FlxSprite(-250, -100).loadGraphic(Paths.image('utchara/chara-bg'));
			halloweenBG.scrollFactor.set(0.5, 0.5);
			halloweenBG.setGraphicSize(Std.int(halloweenBG.width * 1.15));
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);
		
		case 'pico'
		    | 'blammed'
			| 'philly'
			| 'pico-duet'
			| 'blammed-duet'
			| 'philly-duet'
			| 'philly-carol'
			| 'carol-roll'
			| 'blammed-carol'
		    | 'blammed-rs':
		
			curStage = 'philly';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
			add(street);
		
		case 'sunshine':
		
			curStage = 'sunstage';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/happysky'));
			bg.updateHitbox();
			bg.active = false;
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/happyground'));
			ground.updateHitbox();
			ground.active = false;
			ground.antialiasing = ClientPrefs.globalAntialiasing;
			add(ground);
		
		case 'withered':
		
			curStage = 'witheredstage';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/slightlyannyoed_sky'));
			bg.updateHitbox();
			bg.active = false;
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/slightlyannyoed_ground'));
			ground.updateHitbox();
			ground.active = false;
			ground.antialiasing = ClientPrefs.globalAntialiasing;
			add(ground);
		

		// phlox is a little baby
		case 'run':
		
			curStage = 'hellstage';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('bob/hell'));
			bg.updateHitbox();
			bg.active = false;
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var thingidk:FlxSprite = new FlxSprite(-271).loadGraphic(Paths.image('bob/middlething'));
			thingidk.updateHitbox();
			thingidk.active = false;
			thingidk.antialiasing = ClientPrefs.globalAntialiasing;
			thingidk.scrollFactor.set(0.3, 0.3);
			add(thingidk);

			var dead:FlxSprite = new FlxSprite(-60, 50).loadGraphic(Paths.image('bob/theydead'));
			dead.updateHitbox();
			dead.active = false;
			dead.antialiasing = ClientPrefs.globalAntialiasing;
			dead.scrollFactor.set(0.8, 0.8);
			add(dead);

			var ground:FlxSprite = new FlxSprite(-537, -158).loadGraphic(Paths.image('bob/ground'));
			ground.updateHitbox();
			ground.active = false;
			ground.antialiasing = ClientPrefs.globalAntialiasing;
			add(ground);

			bobmadshake = new FlxSprite(-198, -118);
			bobmadshake.frames = Paths.getSparrowAtlas('bob/bobscreen');
			bobmadshake.animation.addByPrefix('idle', 'BobScreen', 24);
			bobmadshake.scrollFactor.set(0, 0);
			bobmadshake.visible = false;

			bobsound = new FlxSound().loadEmbedded(Paths.sound('bobscreen'));
		
		case 'diminished' | 'pentafluoride':
		{
			curStage = 'anders_1';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('anders/entrance'));
			bg.scrollFactor.set(0.1, 0.1);
			bg.setGraphicSize(Std.int(bg.width * 0.85));
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('anders/pillars'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('anders/screen' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('anders/backrailing'));
			streetBehind.setGraphicSize(Std.int(streetBehind.width * 1.25));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('anders/cars'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('carPass0'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('anders/platform'));
			street.setGraphicSize(Std.int(street.width * 1.25));
			add(street);
		}
		case 'psychoneurotic':
		
			curStage = 'anders_2';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('anders/entrance_c'));
			bg.scrollFactor.set(0.1, 0.1);
			bg.setGraphicSize(Std.int(bg.width * 0.85));
			add(bg);

			var hallowTex = Paths.getSparrowAtlas('anders/rocks');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'rocks instance 1');
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('anders/pillars_c'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('anders/screen_c' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('anders/backrailing_c'));
			streetBehind.setGraphicSize(Std.int(streetBehind.width * 1.25));
			add(streetBehind);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('anders/platform_c'));
			street.setGraphicSize(Std.int(street.width * 1.25));
			add(street);
		
		case 'good-enough' | 'lover' | 'tug-of-war':
		
			curStage = 'annie';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('annie/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('annie/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('annie/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('annie/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('annie/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('car_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('annie/street'));
			add(street);
		
		case 'pico-starcatcher'
			| 'blammed-starcatcher'
			| 'philly-starcatcher':
		
			curStage = 'philly-star';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('starcatcher/philly/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('starcatcher/philly/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('starcatcher/philly/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('starcatcher/philly/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('starcatcher/philly/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('starcatcher/philly/street'));
			add(street);
		
		case 'pico-b-sides'
			| 'blammed-b-sides'
			| 'philly-b-sides'
			| 'pico-b-sides-duet'
			| 'blammed-b-sides-duet'
			| 'philly-b-sides-duet':
		
			curStage = 'philly-b';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
			add(street);
		
		case 'eferu-chan'
			| 'fruity-reeverb'
			| 'fl-slayer':
		
			curStage = 'limo-fl';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('flchan/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('flchan/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;
		
		case 'milf'
			| 'satin-panties'
			| 'high'
			| 'milf-duet'
			| 'satin-panties-duet'
			| 'high-duet'
			|'ex-girlfriend':
		
			curStage = 'limo';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		
		case 'milf-starcatcher'
			| 'satin-panties-starcatcher'
			| 'high-starcatcher':
		
			curStage = 'limo-star';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('starcatcher/limo/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-400, 520);
			bgLimo.frames = Paths.getSparrowAtlas('starcatcher/limo/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('starcatcher/limo/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('starcatcher/limo/limoDrive');

			limo = new FlxSprite(-340, 650);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('starcatcher/limo/fastCarLol'));
		
		case 'night-of-nights'
			| 'lunar-dial'
			| 'the-pocket-watch-of-blood':
		
			curStage = 'touhou';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('touhou/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = Paths.getSparrowAtlas('touhou/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('touhou/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('touhou/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;
		
		case 'milf-b-sides'
			| 'satin-panties-b-sides'
			| 'high-b-sides'
			| 'milf-b-sides-duet'
			| 'satin-panties-b-sides-duet'
			| 'high-b-sides-duet':
		
			curStage = 'limo-b';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('bside/limo/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = Paths.getSparrowAtlas('bside/limo/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('bside/limo/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('bside/limo/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('bside/limo/fastCarLol'));
		
		case 'milf-neo'
			| 'satin-panties-neo'
			| 'high-neo':
		
			curStage = 'limo-neo';
			defaultCamZoom = 0.70;

			var skyBG:FlxSprite = new FlxSprite(-300, -300).loadGraphic(Paths.image('neo/limoSunset-neo'));
			skyBG.scrollFactor.set(0.1, 0.1);
			skyBG.setGraphicSize(Std.int(skyBG.width * 1));
			add(skyBG);

			var limoTex = Paths.getSparrowAtlas('neo/limoDrive-neo');
			limo = new FlxSprite(-340, 760);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;
		
		case 'cocoa'
			| 'eggnog'
			| 'cocoa-duet'
			| 'eggnog-duet':
		
			curStage = 'mall';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
			bgEscalator.antialiasing = ClientPrefs.globalAntialiasing;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
			tree.antialiasing = ClientPrefs.globalAntialiasing;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = ClientPrefs.globalAntialiasing;
			add(santa);
		
		case 'cocoa-b-sides'
			| 'eggnog-b-sides'
			| 'cocoa-b-sides-duet'
			| 'eggnog-b-sides-duet':
		
			curStage = 'mall-b';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('bside/christmas/bgWalls'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('bside/christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('bside/christmas/bgEscalator'));
			bgEscalator.antialiasing = ClientPrefs.globalAntialiasing;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('bside/christmas/christmasTree'));
			tree.antialiasing = ClientPrefs.globalAntialiasing;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('bside/christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('bside/christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('bside/christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = ClientPrefs.globalAntialiasing;
			add(santa);
		
		case 'winter-horrorland' | 'winter-horrorland-duet':
		
			curStage = 'mallEvil';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
			evilTree.antialiasing = ClientPrefs.globalAntialiasing;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
			evilSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(evilSnow);
		
		case 'animal':
		
			curStage = 'annie2';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('annie/evilBG'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('annie/evilTree'));
			evilTree.antialiasing = ClientPrefs.globalAntialiasing;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 825).loadGraphic(Paths.image("annie/evilSnow"));
			evilSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(evilSnow);
		
		case 'w-hl-b-sides':
		
			curStage = 'mallEvil-b';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('bside/christmas/evilBG'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('bside/christmas/evilTree'));
			evilTree.antialiasing = ClientPrefs.globalAntialiasing;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("bside/christmas/evilSnow"));
			evilSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(evilSnow);
		
		case 'ronald-mcdonald':
		
			curStage = 'Ronald-Stage';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('ronald/ronald-BG'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('ronald/Tree'));
			evilTree.antialiasing = ClientPrefs.globalAntialiasing;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("ronald/ronald-floor"));
			evilSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(evilSnow);
		
		case 'senpai'
			| 'roses'
			| 'senpai-duet'
			| 'roses-duet'
			| 'roses-rs':
		
			curStage = 'school';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = Paths.getPackerAtlas('weeb/weebTrees');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'roses-duet' || SONG.song.toLowerCase() == 'roses-rs')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		
		case 'highrise' | 'ordinance':
		
			curStage = 'school-neon';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic(Paths.image('neon/weebSky'));
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('neon/weebStreet'));
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);

			bgStreet.setGraphicSize(widShit);

			bgSky.updateHitbox();

			bgStreet.updateHitbox();
		
		case 'thorns' | 'thorns-duet' | 'thorns-rs':
		
			curStage = 'schoolEvil';

			var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
			var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);

				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				add(waveSprite);
				add(waveSpriteFG);
			 */
		
		case 'transgression':
		
			curStage = 'school-neon-2';

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = Paths.getSparrowAtlas('neon/animatedEvilSchool');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);

				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				add(waveSprite);
				add(waveSpriteFG);
			 */
		
		case 'senpai-b-sides'
			| 'roses-b-sides'
			| 'senpai-b-sides-duet'
			| 'roses-b-sides-duet':
		
			curStage = 'school-b';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic(Paths.image('bside/weeb/weebSky'));
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('bside/weeb/weebSchool'));
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('bside/weeb/weebStreet'));
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('bside/weeb/weebTreesBack'));
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = Paths.getPackerAtlas('bside/weeb/weebTrees');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = Paths.getSparrowAtlas('bside/weeb/petals');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			if (SONG.song.toLowerCase() == 'roses-b-sides' || SONG.song.toLowerCase() == 'roses-b-sides')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		
		case 'thorns-b-sides' | 'thorns-b-sides-duet':
		
			curStage = 'schoolEvil-b';

			var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
			var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = Paths.getSparrowAtlas('bside/weeb/animatedEvilSchool');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);

				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				add(waveSprite);
				add(waveSpriteFG);
			 */
		
		case 'bopeebo-neo'
			| 'fresh-neo'
			| 'dadbattle-neo':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-neo';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('neo/stageback-neo'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('neo/stagefront-neo'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('neo/stagecurtains-neo'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'bopeebo-beatstreets'
			| 'fresh-beatstreets'
			| 'dadbattle-beatstreets':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-beats';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('beats/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('beats/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('beats/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'hairball':
		
			defaultCamZoom = 0.9;
			curStage = 'kapi';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/sunset'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapi/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...4)
			{
				var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/win' + i));
				light.scrollFactor.set(0.9, 0.9);
				light.visible = false;
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}
			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			upperBoppers = new FlxSprite(-600, -200);
			upperBoppers.frames = Paths.getSparrowAtlas('kapi/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(1.05, 1.05);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			littleGuys = new FlxSprite(25, 200);
			littleGuys.frames = Paths.getSparrowAtlas('kapi/littleguys');
			littleGuys.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			littleGuys.antialiasing = ClientPrefs.globalAntialiasing;
			littleGuys.scrollFactor.set(0.9, 0.9);
			littleGuys.setGraphicSize(Std.int(littleGuys.width * 1));
			littleGuys.updateHitbox();
			add(littleGuys);
		
		case 'wocky':
		
			defaultCamZoom = 0.9;
			curStage = 'kapi';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapi/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('kapi/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...4)
			{
				var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/win' + i));
				light.scrollFactor.set(0.9, 0.9);
				light.visible = false;
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}
			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
		
		case 'beathoven':
		
			defaultCamZoom = 0.9;
			curStage = 'kapi';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapi/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('kapi/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...4)
			{
				var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/win' + i));
				light.scrollFactor.set(0.9, 0.9);
				light.visible = false;
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}
			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			littleGuys = new FlxSprite(25, 200);
			littleGuys.frames = Paths.getSparrowAtlas('kapi/littleguys');
			littleGuys.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			littleGuys.antialiasing = ClientPrefs.globalAntialiasing;
			littleGuys.scrollFactor.set(0.9, 0.9);
			littleGuys.setGraphicSize(Std.int(littleGuys.width * 1));
			littleGuys.updateHitbox();
			add(littleGuys);
		
		case 'nyaw':
		
			curStage = 'stageclosed';

			defaultCamZoom = 0.9;
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/closed'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			bottomBoppers = new FlxSprite(-600, -200);
			bottomBoppers.frames = Paths.getSparrowAtlas('kapi/bgFreaks');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			bottomBoppers.scrollFactor.set(0.92, 0.92);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapi/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...4)
			{
				var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/win' + i));
				light.scrollFactor.set(0.9, 0.9);
				light.visible = false;
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}
			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			upperBoppers = new FlxSprite(-600, -200);
			upperBoppers.frames = Paths.getSparrowAtlas('kapi/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(1.05, 1.05);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1));
			upperBoppers.updateHitbox();
			add(upperBoppers);
		
		case 'flatzone':
		
			curStage = "gaw";

			var hallowTex = Paths.getSparrowAtlas('kapi/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);
		
		case 'spookeez-neo' | 'south-neo':
		
			curStage = "spooky-neo";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('neo/halloween_neo');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'spookeez-b-sides'
			| 'south-b-sides'
			| 'spookeez-b-sides-duet'
			| 'south-b-sides-duet':
		
			curStage = "spooky-b";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('bside/halloween_g');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'spookeez-starcatcher'
			| 'south-starcatcher'
			| 'sugar-rush':
		
			curStage = "spooky-star";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('starcatcher/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'spookeez-beatstreets' | 'south-beatstreets':
		
			curStage = "spooky-beat";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('starcatcher/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'pico-neo'
			| 'blammed-neo'
			| 'philly-neo':
		
			curStage = 'philly-neo';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('neo/sky-neo'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('neo/city-neo'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('neo/win-neo' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('neo/behindTrain-neo'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('neo/train-neo'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('police_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('neo/street-neo'));
			add(street);
		
		case 'pico-beatstreets'
			| 'blammed-beatstreets'
			| 'philly-beatstreets':
		
			curStage = 'philly-beat';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('beats/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('beats/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('beats/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('beats/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('beats/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('beats/street'));
			add(street);
		
		case 'bopeebo-b-sides'
			| 'fresh-b-sides'
			| 'dadbattle-b-sides'
			| 'bopeebo-b-sides-duet'
			| 'fresh-b-sides-duet'
			| 'dadbattle-b-sides-duet':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-b';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'dunk' | 'encore':
		
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-normal';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/stageback-hex'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('hex/stagefront-hex'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		
		case 'overwrite':
		
			defaultCamZoom = 0.7;
			curStage = 'chara';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('chara/overwrite_bg'));
			bg.setGraphicSize(Std.int(bg.width * 1.0));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			stageFront = new FlxSprite(-600, -200).loadGraphic(Paths.image('chara/overwrite_light'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.0));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.alpha = 0.7;
			stageFront.active = false;
			squareoverwrite = new FlxSprite(-500, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite.setGraphicSize(Std.int(squareoverwrite.width * 1.0));
			squareoverwrite.updateHitbox();
			squareoverwrite.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite.scrollFactor.set(0.9, 0.9);
			squareoverwrite.active = false;
			squareoverwrite.setGraphicSize(Std.int(squareoverwrite.height * 1.0));
			add(squareoverwrite);

			var squareoverwrite1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite1.setGraphicSize(Std.int(squareoverwrite1.width * 1.0));
			squareoverwrite1.updateHitbox();
			squareoverwrite1.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite1.scrollFactor.set(0.9, 0.9);
			squareoverwrite1.active = false;
			squareoverwrite1.setGraphicSize(Std.int(squareoverwrite1.height * 1.0));
			add(squareoverwrite1);
			var squareoverwrite2:FlxSprite = new FlxSprite(500, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite2.setGraphicSize(Std.int(squareoverwrite2.width * 1.0));
			squareoverwrite2.updateHitbox();
			squareoverwrite2.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite2.scrollFactor.set(0.9, 0.9);
			squareoverwrite2.active = false;
			squareoverwrite2.setGraphicSize(Std.int(squareoverwrite2.height * 1.0));
			add(squareoverwrite2);
			var squareoverwrite3:FlxSprite = new FlxSprite(1000, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite3.setGraphicSize(Std.int(squareoverwrite3.width * 1.0));
			squareoverwrite3.updateHitbox();
			squareoverwrite3.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite3.scrollFactor.set(0.9, 0.9);
			squareoverwrite3.active = false;
			squareoverwrite3.setGraphicSize(Std.int(squareoverwrite3.height * 1.0));
			add(squareoverwrite3);
			var squareoverwrite4:FlxSprite = new FlxSprite(1500, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite4.setGraphicSize(Std.int(squareoverwrite4.width * 1.0));
			squareoverwrite4.updateHitbox();
			squareoverwrite4.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite4.scrollFactor.set(0.9, 0.9);
			squareoverwrite4.active = false;
			squareoverwrite4.setGraphicSize(Std.int(squareoverwrite4.height * 1.0));
			add(squareoverwrite4);
			var squareoverwrite5:FlxSprite = new FlxSprite(2000, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite5.setGraphicSize(Std.int(squareoverwrite5.width * 1.0));
			squareoverwrite5.updateHitbox();
			squareoverwrite5.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite5.scrollFactor.set(0.9, 0.9);
			squareoverwrite5.active = false;
			squareoverwrite5.setGraphicSize(Std.int(squareoverwrite5.height * 1.0));
			add(squareoverwrite5);
			FlxTween.tween(squareoverwrite, {alpha: 1, y: squareoverwrite.y - 350}, 3, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite1, {alpha: 1, y: squareoverwrite1.y - 350}, 2.8, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite2, {alpha: 1, y: squareoverwrite2.y - 350}, 2.6, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite3, {alpha: 1, y: squareoverwrite3.y - 350}, 2.4, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite4, {alpha: 1, y: squareoverwrite4.y - 350}, 2.2, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite5, {alpha: 1, y: squareoverwrite5.y - 350}, 2.0, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(stageFront, {alpha: 1,}, 2.5, {type: FlxTween.PINGPONG, startDelay: 0.0});
		
		case 'relighted':
		
			defaultCamZoom = 0.7;
			curStage = 'xgaster';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('gaster/overwrite_bg'));
			bg.setGraphicSize(Std.int(bg.width * 1.0));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			stageFront = new FlxSprite(-600, -200).loadGraphic(Paths.image('gaster/overwrite_light'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.0));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.alpha = 0.7;
			stageFront.active = false;
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			gaster = new FlxSprite(-500, 500);
			gaster.frames = hallowTex;
			gaster.animation.addByPrefix('idle', 'fire_iddle');
			gaster.animation.play('idle');
			gaster.antialiasing = ClientPrefs.globalAntialiasing;
			add(gaster);
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster1:FlxSprite = new FlxSprite(-150, 300);
			gaster1.frames = hallowTex;
			gaster1.animation.addByPrefix('idle', 'fire_iddle');
			gaster1.animation.play('idle');
			gaster1.antialiasing = ClientPrefs.globalAntialiasing;
			add(gaster1);
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster2:FlxSprite = new FlxSprite(100, 50);
			gaster2.frames = hallowTex;
			gaster2.animation.addByPrefix('idle', 'fire_iddle');
			gaster2.animation.play('idle');
			gaster2.antialiasing = ClientPrefs.globalAntialiasing;
			add(gaster2);

			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster3:FlxSprite = new FlxSprite(900, 50);
			gaster3.frames = hallowTex;
			gaster3.animation.addByPrefix('idle', 'fire_iddle');
			gaster3.animation.play('idle');
			gaster3.antialiasing = ClientPrefs.globalAntialiasing;
			add(gaster3);

			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster4:FlxSprite = new FlxSprite(1250, 300);
			gaster4.frames = hallowTex;
			gaster4.animation.addByPrefix('idle', 'fire_iddle');
			gaster4.animation.play('idle');
			gaster4.antialiasing = ClientPrefs.globalAntialiasing;
			add(gaster4);
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster5:FlxSprite = new FlxSprite(1600, 500);
			gaster5.frames = hallowTex;
			gaster5.animation.addByPrefix('idle', 'fire_iddle');
			gaster5.animation.play('idle');
			gaster5.antialiasing = ClientPrefs.globalAntialiasing;

			add(gaster5);
			FlxTween.tween(stageFront, {alpha: 1,}, 2.5, {type: FlxTween.PINGPONG, startDelay: 0.0});
		
		case 'light-it-up'
			| 'ruckus'
			| 'target-practice':
		
			defaultCamZoom = 0.8;
			curStage = 'swordarena';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('matt/arena-bg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.setGraphicSize(Std.int(bg.width * 1));
			bg.active = false;
			add(bg);

			var bgBoppers:FlxSprite = new FlxSprite(-600, 140);
			bgBoppers.frames = Paths.getSparrowAtlas('matt/arena-characters');
			bgBoppers.animation.addByPrefix('bop', "bg-characters", 24);
			bgBoppers.animation.play('bop');
			bgBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			bgBoppers.scrollFactor.set(0.99, 0.9);
			bgBoppers.setGraphicSize(Std.int(bgBoppers.width * 1));
			bgBoppers.updateHitbox();
			add(bgBoppers);

			var bgRail:FlxSprite = new FlxSprite(-600, 320).loadGraphic(Paths.image('matt/railing'));
			bgRail.antialiasing = ClientPrefs.globalAntialiasing;
			bgRail.scrollFactor.set(0.9, 0.9);
			bgRail.active = false;
			bgRail.setGraphicSize(Std.int(bgRail.width * 1));
			bgRail.updateHitbox();
			add(bgRail);
		
		case 'sporting' | 'boxing-match':
		
			defaultCamZoom = 0.9;
			curStage = 'arenanight';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('matt/boxingnight1'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0, 0);
			bg.setGraphicSize(Std.int(bg.width * 1));
			bg.active = false;
			add(bg);

			var bg2:FlxSprite = new FlxSprite(-800, -200).loadGraphic(Paths.image('matt/boxingnight2'));
			bg2.antialiasing = ClientPrefs.globalAntialiasing;
			bg2.scrollFactor.set(1.2, 1.2);
			bg2.setGraphicSize(Std.int(bg.width * 1.3));
			bg2.active = false;
			add(bg2);

			var bg3:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('matt/boxingnight3'));
			bg3.antialiasing = ClientPrefs.globalAntialiasing;
			bg3.scrollFactor.set(0.9, 0.9);
			bg3.setGraphicSize(Std.int(bg.width * 0.9));
			bg3.active = false;
			add(bg3);
		
		case 'inkingmistake':
		
			defaultCamZoom = 0.7;
			curStage = 'inksans';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg0'));
			bg.setGraphicSize(Std.int(bg.width * 1.0));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			var squareoverwrite5:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg1'));
			squareoverwrite5.setGraphicSize(Std.int(squareoverwrite5.width * 1.0));
			squareoverwrite5.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite5.scrollFactor.set(0.9, 0.9);
			squareoverwrite5.active = false;
			add(squareoverwrite5);
			var squareoverwrite4:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg2'));
			squareoverwrite4.setGraphicSize(Std.int(squareoverwrite4.width * 1.0));
			squareoverwrite4.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite4.scrollFactor.set(0.9, 0.9);
			squareoverwrite4.active = false;
			add(squareoverwrite4);

			var squareoverwrite3:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg3'));
			squareoverwrite3.setGraphicSize(Std.int(squareoverwrite3.width * 1.0));
			squareoverwrite3.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite3.scrollFactor.set(0.9, 0.9);
			squareoverwrite3.active = false;
			add(squareoverwrite3);

			var squareoverwrite2:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg4'));
			squareoverwrite2.setGraphicSize(Std.int(squareoverwrite2.width * 1.0));
			squareoverwrite2.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite2.scrollFactor.set(0.9, 0.9);
			squareoverwrite2.active = false;
			add(squareoverwrite2);
			var squareoverwrite1:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg5'));
			squareoverwrite1.setGraphicSize(Std.int(squareoverwrite1.width * 1.0));
			squareoverwrite1.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite1.scrollFactor.set(0.9, 0.9);
			squareoverwrite1.active = false;
			add(squareoverwrite1);
			var squareoverwrite:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg6'));
			squareoverwrite.setGraphicSize(Std.int(squareoverwrite.width * 1.0));
			squareoverwrite.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite.scrollFactor.set(0.9, 0.9);
			squareoverwrite.active = false;
			add(squareoverwrite);

			var stageFront:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/ground'));
			stageFront.setGraphicSize(Std.int(bg.width * 1.0));
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
			gaster = new FlxSprite(-320, 70);
			var hallowTex = Paths.getSparrowAtlas('inksans/xgasterink');
			gaster.frames = hallowTex;
			gaster.animation.addByPrefix('idle', 'Xgasterink idle dance instance 1');
			gaster.animation.play('idle');
			gaster.antialiasing = ClientPrefs.globalAntialiasing;
			add(gaster);
			FlxTween.tween(gaster, {alpha: 0.2, y: gaster.y - 50}, 2.0, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite, {alpha: 1, y: squareoverwrite.y - 50}, 4, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite1, {alpha: 1, y: squareoverwrite1.y - 50}, 3, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite2, {alpha: 1, y: squareoverwrite2.y - 50}, 2.7, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite3, {alpha: 1, y: squareoverwrite3.y - 50}, 5.2, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite4, {alpha: 1, y: squareoverwrite4.y - 50}, 4.2, {type: FlxTween.PINGPONG, startDelay: 0.0});

			var squareoverwrite6:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/fg'));
			squareoverwrite6.setGraphicSize(Std.int(squareoverwrite6.width * 1.0));
			squareoverwrite6.antialiasing = ClientPrefs.globalAntialiasing;
			squareoverwrite6.scrollFactor.set(0.9, 0.9);
			squareoverwrite6.active = false;
			add(squareoverwrite6);
		
		case 'ram' | 'ram-rs':
		
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-noon';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/stageback-noon'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('hex/stagefront-noon'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		
		case 'popipo'
			| 'siu'
			| 'chug'
			| 'disappearance'
			| 'aishite':
		
			defaultCamZoom = 0.9;
			curStage = 'miku';
			var bg:FlxSprite = new FlxSprite(-325, -50).loadGraphic(Paths.image('miku/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			upperBoppers = new FlxSprite(20, 670);
			upperBoppers.frames = Paths.getSparrowAtlas('miku/bunch_of_simps');
			upperBoppers.animation.addByPrefix('bop', "Downer Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(0.9, 0.9);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.9));
			upperBoppers.updateHitbox();
		
		case 'hello-world':
		
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-night';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/stageback-night'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('hex/stagefront-night'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		
		case 'glitcher' | 'glitcher-rs':
		
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-hack';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('hex/stageback-hack'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('hex/stagefront-hack'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		
		case 'lo-fight'
			| 'overhead'
			| 'lo-fight-rs':
		
			defaultCamZoom = 0.8;
			curStage = 'whitty-normal';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('whitty/whittyBack'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('whitty/whittyFront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		
		case 'parish':
		
			defaultCamZoom = 0.8;
			curStage = 'church-normal';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/bg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/floor'));
			bg1.antialiasing = ClientPrefs.globalAntialiasing;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/pillars'));
			bg2.antialiasing = ClientPrefs.globalAntialiasing;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
		
		case 'casanova':
		
			defaultCamZoom = 0.8;
			curStage = 'church-selever';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church4/bg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church4/floor'));
			bg1.antialiasing = ClientPrefs.globalAntialiasing;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church4/pillars'));
			bg2.antialiasing = ClientPrefs.globalAntialiasing;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
		
		case 'worship':
		
			defaultCamZoom = 0.8;
			curStage = 'church-dark';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/bg-dark'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/floor-dark'));
			bg1.antialiasing = ClientPrefs.globalAntialiasing;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/pillars-dark'));
			bg2.antialiasing = ClientPrefs.globalAntialiasing;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
		
		case 'zavodila' | 'zavodila-rs':
		
			defaultCamZoom = 0.8;
			curStage = 'church-ruv';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church2/bg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church2/floor'));
			bg1.antialiasing = ClientPrefs.globalAntialiasing;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church2/pillars'));
			bg2.antialiasing = ClientPrefs.globalAntialiasing;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
			deadpill = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church2/pillarbroke'));
			deadpill.antialiasing = ClientPrefs.globalAntialiasing;
			deadpill.scrollFactor.set(0.9, 0.9);
			deadpill.active = false;
		
		case 'gospel' | 'gospel-rs':
		
			defaultCamZoom = 0.8;
			curStage = 'church-final';
			var bg:FlxSprite = new FlxSprite(-300, -550).loadGraphic(Paths.image('sarv/church3/bg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church3/floor'));
			bg1.antialiasing = ClientPrefs.globalAntialiasing;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church3/pillars'));
			bg2.antialiasing = ClientPrefs.globalAntialiasing;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
			curl1 = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church3/circ2'));
			curl1.antialiasing = ClientPrefs.globalAntialiasing;
			curl1.scrollFactor.set(0.9, 0.9);
			curl1.active = false;

			curl2 = new FlxSprite(360, -300).loadGraphic(Paths.image('sarv/church3/circ1'));
			curl2.antialiasing = ClientPrefs.globalAntialiasing;
			curl2.scrollFactor.set(0.9, 0.9);
			curl2.active = false;

			curl3 = new FlxSprite(-300, -600).loadGraphic(Paths.image('sarv/church3/circ0'));
			curl3.antialiasing = ClientPrefs.globalAntialiasing;
			curl3.scrollFactor.set(0.9, 0.9);
			curl3.active = false;
			add(curl1);
			add(curl2);
			add(curl3);
		
		case 'ballistic'
			| 'ballistic-old'
			| 'ballistic-rs':
		
			defaultCamZoom = 0.8;
			curStage = 'whitty-crazy';

			var hallowTex = Paths.getSparrowAtlas('whitty/BallisticBackground');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Background Whitty Moving', 24);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);
		
		case 'foolhardy'
			| 'foolhardy-duet'
			| 'foolhardy-rs':
		
			defaultCamZoom = 0.8;
			curStage = 'zardy';

			var hallowTex = Paths.getSparrowAtlas('zardy/Maze');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Stage', 24);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);
		
		case 'madness'
			|  'improbable-outset'
			| 'madness-duet'
			| 'improbable-outset-duet':
		
			// trace("line 538");
			defaultCamZoom = 0.75;
			curStage = 'nevada';

			tstatic.antialiasing = ClientPrefs.globalAntialiasing;
			tstatic.scrollFactor.set(0, 0);
			tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
			tstatic.animation.add('static', [0, 1, 2], 24, true);
			tstatic.animation.play('static');

			tstatic.alpha = 0;

			var bg:FlxSprite = new FlxSprite(-350, -300).loadGraphic(Paths.image('red', 'clown'));
			// bg.setGraphicSize(Std.int(bg.width * 2.5));
			// bg.updateHitbox();
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			var stageFront:FlxSprite;
			if (SONG.song.toLowerCase() != 'madness')
			{
				add(bg);
				stageFront = new FlxSprite(-1100, -460).loadGraphic(Paths.image('island_but_dumb', 'clown'));
			}
			else
				stageFront = new FlxSprite(-1100, -460).loadGraphic(Paths.image('island_but_rocks_float', 'clown'));

			stageFront.setGraphicSize(Std.int(stageFront.width * 1.4));
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			MAINLIGHT = new FlxSprite(-470, -150).loadGraphic(Paths.image('hue', 'clown'));
			MAINLIGHT.alpha - 0.3;
			MAINLIGHT.setGraphicSize(Std.int(MAINLIGHT.width * 0.9));
			MAINLIGHT.blend = "screen";
			MAINLIGHT.updateHitbox();
			MAINLIGHT.antialiasing = ClientPrefs.globalAntialiasing;
			MAINLIGHT.scrollFactor.set(1.2, 1.2);
		
		case 'madness-beatstreets' | 'improbable-outset-bs':
		
			defaultCamZoom = 0.9;
			curStage = 'tricky-beat';

			var hallowTex = Paths.getSparrowAtlas('trickybeats/tricky_floor');
			halloweenBG = new FlxSprite(-1200, 150);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Symbol 1', 24);
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;

			var stageFront:FlxSprite = new FlxSprite(-600, -250).loadGraphic(Paths.image('trickybeats/red'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
			add(halloweenBG);
		
		case 'wife-forever' |'sky':
		
			defaultCamZoom = 0.9;
			curStage = 'sky';

			var hallowTex = Paths.getSparrowAtlas('sky/bg_normal');
			halloweenBG = new FlxSprite(-200, 0);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'bg', 24 ,false);
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			if (ClientPrefs.flashing)
			{
			halloweenBG.animation.play('idle');
			}
			pissedsky = 0;
			ughsky = 0;
			add(halloweenBG);
		
		case 'god-eater':
		
			defaultCamZoom = 0.65;
			curStage = 'sky_shaggy';

			var sky = new FlxSprite(-850, -850);
			sky.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			sky.animation.addByPrefix('sky', "bg", 30);
			sky.setGraphicSize(Std.int(sky.width * 0.8));
			sky.animation.play('sky');
			sky.scrollFactor.set(0.1, 0.1);
			sky.antialiasing = ClientPrefs.globalAntialiasing;
			add(sky);

			var bgcloud = new FlxSprite(-850, -1250);
			bgcloud.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			bgcloud.animation.addByPrefix('c', "cloud_smol", 30);
			// bgcloud.setGraphicSize(Std.int(bgcloud.width * 0.8));
			bgcloud.animation.play('c');
			bgcloud.scrollFactor.set(0.3, 0.3);
			bgcloud.antialiasing = ClientPrefs.globalAntialiasing;
			add(bgcloud);

			add(new MansionDebris(-150, 400, 'norm', 0.4, 1, 0, 1));
			add(new MansionDebris(-300, 150, 'tiny', 0.4, 1.5, 0, 1));
			add(new MansionDebris(150, 200, 'spike', 0.4, 1.1, 0, 1));
			add(new MansionDebris(350, 250, 'small', 0.4, 1.5, 0, 1));

			/*
				add(new MansionDebris(-300, -1700, 'norm', 0.5, 1, 0, 1));
				add(new MansionDebris(-600, -1100, 'tiny', 0.5, 1.5, 0, 1));
				add(new MansionDebris(900, -1850, 'spike', 0.5, 1.2, 0, 1));
				add(new MansionDebris(1500, -1300, 'small', 0.5, 1.5, 0, 1));
			 */

			add(new MansionDebris(150, 850, 'norm', 0.75, 1, 0, 1));
			add(new MansionDebris(-500, 875, 'rect', 0.75, 2, 0, 1));
			add(new MansionDebris(300, 550, 'tiny', 0.75, 1.5, 0, 1));
			add(new MansionDebris(-350, 925, 'spike', 0.75, 1.2, 0, 1));
			add(new MansionDebris(-750, 650, 'small', 0.75, 1.5, 0, 1));
			add(new MansionDebris(300, 400, 'spike', 0.75, 1.3, 0, 1));
			add(new MansionDebris(500, 350, 'small', 0.75, 1.7, 0, 1));

			var fgcloud = new FlxSprite(-1150, -2900);
			fgcloud.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			fgcloud.animation.addByPrefix('c', "cloud_big", 30);
			// bgcloud.setGraphicSize(Std.int(bgcloud.width * 0.8));
			fgcloud.animation.play('c');
			fgcloud.scrollFactor.set(0.9, 0.9);
			fgcloud.antialiasing = ClientPrefs.globalAntialiasing;
			add(fgcloud);

			// var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('shaggy/bg_lemon'));
			// bg.setGraphicSize(Std.int(bg.width * 1.5));
			// bg.antialiasing = ClientPrefs.globalAntialiasing;
			// bg.scrollFactor.set(0.95, 0.95);
			// bg.active = false;
			// add(bg);

			// var techo = new FlxSprite(0, -20);
			// techo.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			// techo.animation.addByPrefix('r', "broken_techo", 30);
			// techo.setGraphicSize(Std.int(techo.frameWidth * 1.5));
			// techo.animation.play('r');
			// techo.scrollFactor.set(0.95, 0.95);
			// techo.antialiasing = ClientPrefs.globalAntialiasing;
			// add(techo);

			gf_rock = new FlxSprite(260, 350);
			gf_rock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			gf_rock.animation.addByPrefix('rock', "gf_rock", 30);
			gf_rock.animation.play('rock');
			gf_rock.scrollFactor.set(0.8, 0.8);
			gf_rock.antialiasing = ClientPrefs.globalAntialiasing;
			add(gf_rock);

			rock = new FlxSprite(600, 700);
			rock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			rock.animation.addByPrefix('rock', "rock", 30);
			rock.animation.play('rock');
			rock.scrollFactor.set(1, 1);
			rock.antialiasing = ClientPrefs.globalAntialiasing;
			add(rock);
		
		case 'manifest':
		
			defaultCamZoom = 0.9;
			curStage = 'sky-mad';

			var hallowTex = Paths.getSparrowAtlas('sky/bg_manifest');
			halloweenBG = new FlxSprite(-200, 0);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'bg', 24, false);
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			if (ClientPrefs.flashing)
				{
				halloweenBG.animation.play('idle');
				}
			pissedsky = 0;
			ughsky = 0;
			add(halloweenBG);
		
		case 'tutorial-starcatcher'
			| 'bopeebo-starcatcher'
			| 'fresh-starcatcher'
			| 'dadbattle-starcatcher':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-star';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('starcatcher/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('starcatcher/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('starcatcher/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'norway' | 'tordbot':
		
			curStage = 'eddhouse';
			var sky:FlxSprite = new FlxSprite(-162.1, -386.1);
			sky.frames = Paths.getSparrowAtlas("tord/sky");
			sky.animation.addByPrefix("bg_sky1", "bg_sky1");
			sky.animation.addByPrefix("bg_sky2", "bg_sky2");
			if (SONG.song.toLowerCase() == 'norway')
			{
				sky.animation.play("bg_sky1");
			}
			else
			{
				sky.animation.play("bg_sky2");
			}

			var bg:FlxSprite = new FlxSprite(-162.1, -386.1);
			bg.frames = Paths.getSparrowAtlas("tord/bgFront");
			bg.animation.addByPrefix("bg_normal", "bg_normal");
			bg.animation.addByPrefix("bg_destroy", "bg_destroy");
			if (SONG.song.toLowerCase() == 'norway')
			{
				bg.animation.play("bg_normal");
			}
			else
			{
				bg.animation.play("bg_destroy");
			}

			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			sky.scrollFactor.set(0.5, 0);
			if (SONG.song.toLowerCase() == 'tordbot')
				sky.scrollFactor.set();
			bg.active = false;
			sky.active = false;
			// bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			sky.updateHitbox();
			add(sky);
			add(bg);
		
		case 'headache'
			| 'nerves'
			| 'headache-duet'
			| 'nerves-duet':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-cel';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagebg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStage'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		
		case 'stronger'
			| 'megalomaniac'
			| 'reality-check':
		
			defaultCamZoom = 0.9;
			curStage = 'sans';
			var bg:FlxSprite = new FlxSprite(-300, -200).loadGraphic(Paths.image('sans/Sansbg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		
		case 'release'
			| 'release-duet'
			| 'release-rs':
		
			defaultCamZoom = 0.9;
			curStage = 'garl';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagebgAlt'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var hallowTex = Paths.getSparrowAtlas('stos/garSmoke');

			halloweenBG = new FlxSprite(150, 200);
			halloweenBG.frames = hallowTex;
			halloweenBG.setGraphicSize(Std.int(halloweenBG.width * 1.3));
			halloweenBG.animation.addByPrefix('idle', 'smokey instance');
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;

			var garded:FlxSprite = new FlxSprite(-250, 650).loadGraphic(Paths.image('stos/gardead'));

			garded.updateHitbox();
			garded.antialiasing = ClientPrefs.globalAntialiasing;
			garded.scrollFactor.set(1.3, 1.3);
			garded.active = false;

			var stageCurtains:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagealt'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.1));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			add(stageCurtains);
			add(garded);
			garlilman = 0;
		
		case 'where-are-you'
			| 'kaio-ken'
			| 'eruption'
			| 'blast'
			| 'whats-new'
			| 'super-saiyan':
		
			// dad.powerup = true;
			defaultCamZoom = 0.9;
			curStage = 'stage_2';
			var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('shaggy/bg_lemon'));
			bg.setGraphicSize(Std.int(bg.width * 1.5));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.95, 0.95);
			bg.active = false;
			add(bg);

			if (SONG.song.toLowerCase() == 'kaio-ken')
			{
				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2); // creo que esta weá no hace nada
			}
		
		case 'ugh' | 'guns' | 'stress' | 'ugh-duet' | 'guns-duet' | 'stress-duet':
		
			defaultCamZoom = 0.9;
			curStage = 'tankman1';
			var bg:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('tank/tankSky'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.1, 0.1);
			bg.active = false;
			add(bg);

			var clouds = new FlxSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20)).loadGraphic(Paths.image('tank/tankClouds'));
			clouds.antialiasing = ClientPrefs.globalAntialiasing;
			clouds.scrollFactor.set(0.1, 0.1);
    		clouds.velocity.x = FlxG.random.float(5,15);
			add(clouds);
			var stageCurtains1:FlxSprite = new FlxSprite(-300, -20).loadGraphic(Paths.image('tank/tankMountains'));
			stageCurtains1.setGraphicSize(Std.int(stageCurtains1.width * 1.2));
			stageCurtains1.updateHitbox();
			stageCurtains1.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains1.scrollFactor.set(0.2, 0.2);
			stageCurtains1.active = false;
			add(stageCurtains1);
			var stageCurtains2:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image('tank/tankBuildings'));
			stageCurtains2.setGraphicSize(Std.int(stageCurtains2.width * 1.1));
			stageCurtains2.updateHitbox();
			stageCurtains2.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains2.scrollFactor.set(0.3, 0.3);
			stageCurtains2.active = false;
			add(stageCurtains2);
			var stageCurtains3:FlxSprite = new FlxSprite(-180, 10).loadGraphic(Paths.image('tank/tankRuins'));
			stageCurtains3.setGraphicSize(Std.int(stageCurtains3.width * 1.1));
			stageCurtains3.updateHitbox();
			stageCurtains3.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains3.scrollFactor.set(0.35, 0.35);
			stageCurtains3.active = false;
			add(stageCurtains3);
			var hallowTex1 = Paths.getSparrowAtlas('tank/smokeLeft');
			var halloweenBG1:FlxSprite = new FlxSprite(-200, -100);
			halloweenBG1.frames = hallowTex1;
			halloweenBG1.animation.addByPrefix('idle', 'SmokeBlurLeft');
			halloweenBG1.animation.play('idle');
			halloweenBG1.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG1.scrollFactor.set(0.4, 0.4);
			add(halloweenBG1);
			var hallowTex2 = Paths.getSparrowAtlas('tank/smokeRight');
			var halloweenBG2:FlxSprite = new FlxSprite(1100, -100);
			halloweenBG2.frames = hallowTex2;
			halloweenBG2.animation.addByPrefix('idle', 'SmokeRight');
			halloweenBG2.animation.play('idle');
			halloweenBG2.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG2.scrollFactor.set(0.4, 0.4);
			add(halloweenBG2);
			var hallowTex = Paths.getSparrowAtlas('tank/tankWatchtower');
			halloweenBG = new FlxSprite(100, 50);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'watchtower gradient color', false);
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG.scrollFactor.set(0.55, 0.55);
			add(halloweenBG);

			steve = new FlxSprite(300, 300);
			steve.frames = Paths.getSparrowAtlas('tank/tankRolling');
			steve.animation.addByPrefix('idle', "BG tank w lighting", 24, true);
			steve.animation.play('idle', true);
			steve.antialiasing = ClientPrefs.globalAntialiasing;
			steve.scrollFactor.set(0.5, 0.5);
			add(steve);
			johns = new FlxTypedGroup<FlxSprite>();
   			add(johns);

			var stageCurtains4:FlxSprite = new FlxSprite(-420, -150).loadGraphic(Paths.image('tank/tankGround'));
			stageCurtains4.setGraphicSize(Std.int(stageCurtains4.width * 1.15));
			stageCurtains4.updateHitbox();
			stageCurtains4.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains4.scrollFactor.set(1.1, 1.1);
			stageCurtains4.active = false;
			add(stageCurtains4);

			

			var hallowTex3 = Paths.getSparrowAtlas('tank/tank0');
			halloweenBG3 = new FlxSprite(-300, 600);
			halloweenBG3.frames = hallowTex3;
			halloweenBG3.animation.addByPrefix('idle', 'fg', false);
			halloweenBG3.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG3.scrollFactor.set(1.7, 1.5);

			var hallowTex4 = Paths.getSparrowAtlas('tank/tank1');
			halloweenBG4 = new FlxSprite(-300, 700);
			halloweenBG4.frames = hallowTex4;
			halloweenBG4.animation.addByPrefix('idle', 'fg', false);
			halloweenBG4.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG4.scrollFactor.set(2.0, 0.2);

			var hallowTex5 = Paths.getSparrowAtlas('tank/tank2');
			halloweenBG5 = new FlxSprite(450, 900);
			halloweenBG5.frames = hallowTex5;
			halloweenBG5.animation.addByPrefix('idle', 'foreground', false);
			halloweenBG5.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG5.scrollFactor.set(1.5, 1.5);

			var hallowTex6 = Paths.getSparrowAtlas('tank/tank4');
			halloweenBG6 = new FlxSprite(1300, 900);
			halloweenBG6.frames = hallowTex6;
			halloweenBG6.animation.addByPrefix('idle', 'fg', false);
			halloweenBG6.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG6.scrollFactor.set(1.5, 1.5);

			var hallowTex7 = Paths.getSparrowAtlas('tank/tank5');
			halloweenBG7 = new FlxSprite(1560, 700);
			halloweenBG7.frames = hallowTex7;
			halloweenBG7.animation.addByPrefix('idle', 'fg', false);
			halloweenBG7.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG7.scrollFactor.set(1.5, 1.5);
			

			


		
		case 'expurgation':
		
			// trace("line 538");
			defaultCamZoom = 0.55;
			curStage = 'auditorHell';

			tstatic.antialiasing = ClientPrefs.globalAntialiasing;
			tstatic.scrollFactor.set(0, 0);
			tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
			tstatic.animation.add('static', [0, 1, 2], 24, true);
			tstatic.animation.play('static');

			tstatic.alpha = 0;

			var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('fourth/bg', 'clown'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 4));
			add(bg);

			hole.antialiasing = ClientPrefs.globalAntialiasing;
			hole.scrollFactor.set(0.9, 0.9);

			converHole.antialiasing = ClientPrefs.globalAntialiasing;
			converHole.scrollFactor.set(0.9, 0.9);
			converHole.setGraphicSize(Std.int(converHole.width * 1.3));
			hole.setGraphicSize(Std.int(hole.width * 1.55));

			cover.antialiasing = ClientPrefs.globalAntialiasing;
			cover.scrollFactor.set(0.9, 0.9);
			cover.setGraphicSize(Std.int(cover.width * 1.55));

			var energyWall:FlxSprite = new FlxSprite(1350, -690).loadGraphic(Paths.image("fourth/Energywall", "clown"));
			energyWall.antialiasing = ClientPrefs.globalAntialiasing;
			energyWall.scrollFactor.set(0.9, 0.9);
			add(energyWall);

			var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.image('fourth/daBackground', 'clown'));
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
			add(stageFront);
		
		case 'always-running':
		
			defaultCamZoom = 0.9;
			curStage = 'stage_tari';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('metarunner/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('metarunner/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('metarunner/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'hellclown':
		
			// trace("line 538");
			defaultCamZoom = 0.35;
			curStage = 'nevadaSpook';

			tstatic.antialiasing = ClientPrefs.globalAntialiasing;
			tstatic.scrollFactor.set(0, 0);
			tstatic.setGraphicSize(Std.int(tstatic.width * 10));
			tstatic.screenCenter(Y);
			tstatic.animation.add('static', [0, 1, 2], 24, true);
			tstatic.animation.play('static');

			tstatic.alpha = 0;

			var bg:FlxSprite = new FlxSprite(-1000, -1000).loadGraphic(Paths.image('fourth/bg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.setGraphicSize(Std.int(bg.width * 5));
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-2000, -400).loadGraphic(Paths.image('hellclwn/island_but_red'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 2.6));
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			hank = new FlxSprite(60, -170);
			hank.frames = Paths.getSparrowAtlas('hellclwn/Hank');
			hank.animation.addByPrefix('dance', 'Hank', 24);
			hank.animation.play('dance');
			hank.scrollFactor.set(0.9, 0.9);
			hank.setGraphicSize(Std.int(hank.width * 1.55));
			hank.antialiasing = ClientPrefs.globalAntialiasing;

			add(hank);
		
		case 'hellroll':
		
			defaultCamZoom = 1;
			curStage = 'shzone';
			var bg:FlxSprite = new FlxSprite(-90, -228).loadGraphic(Paths.image("shcarol/bg"));
			bg.scrollFactor.set();
			bg.active = false;

			add(bg);

			var rock:FlxSprite = new FlxSprite(-32.05, 24.8).loadGraphic(Paths.image("shcarol/rock"));
			rock.scrollFactor.set(0.6, 0.6);
			rock.active = false;

			add(rock);

			var ground:FlxSprite = new FlxSprite(-488.35, 349.25).loadGraphic(Paths.image("shcarol/ground"));
			ground.scrollFactor.set(0.8, 0.8);
			ground.active = false;

			add(ground);

			var glowshit:FlxSprite = new FlxSprite(-105.95, -252).loadGraphic(Paths.image("shcarol/glowshit"));
			glowshit.scrollFactor.set(0.8, 0.8);
			glowshit.active = false;
			glowshit.blend = 'add';

			add(glowshit);
		
		case 'trunk':
		
			defaultCamZoom = 0.7;
			curStage = 'park1';
			var hallowText = Paths.getSparrowAtlas('tree/tree_and_bg', 'shared');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowText;
			halloweenBG.animation.addByPrefix('idle', 'BackGround');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG.scrollFactor.set(0.9, 0.9);
			halloweenBG.animation.play('idle');
			add(halloweenBG);
		
		case 'warning':
		
			defaultCamZoom = 0.7;
			curStage = 'park2';
			var hallowText = Paths.getSparrowAtlas('tree/tree_and_bg2', 'shared');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowText;
			halloweenBG.animation.addByPrefix('idle', 'BackGround');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG.scrollFactor.set(0.9, 0.9);
			halloweenBG.animation.play('idle');
			add(halloweenBG);
		
		case 'revolution':
		
			defaultCamZoom = 0.6;
			curStage = 'park3';
			var hallowText = Paths.getSparrowAtlas('tree/tree_and_bg3', 'shared');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowText;
			halloweenBG.animation.addByPrefix('idle', 'BackGround');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG.scrollFactor.set(0.9, 0.9);
			halloweenBG.animation.play('idle');
			add(halloweenBG);
		
		case 'quack' | 'geesy':
			
			defaultCamZoom = 0.7;
			curStage = 'park0';
			var hallowText = Paths.getSparrowAtlas('tree/finalbg', 'shared');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowText;
			halloweenBG.animation.addByPrefix('idle', 'BackGround');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG.scrollFactor.set(0.9, 0.9);
			halloweenBG.animation.play('idle');
			add(halloweenBG);
		
		
			
		

		case 'my-battle' | 'last-chance':
		
			defaultCamZoom = 0.8;
			curStage = 'curse';
			var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/normal_stage'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		
		case 'genocide' | 'genocide-rs':
		
			defaultCamZoom = 0.8;
			curStage = 'genocide';
			/*var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/mad/youhavebeendestroyed'));
				bg.antialiasing = ClientPrefs.globalAntialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
				var fireRow:FlxTypedGroup<TabiFire> = new FlxTypedGroup<TabiFire>();
				for (i in 0...3)
				{
					fireRow.add(new TabiFire(10 + (i * 450), 200));
				}
				add(fireRow); */
			// and a 1 and a 2 and a 3 and your pc is fucked lol
			/*var prefixShit:String = 'fuckedpc/PNG_Sequence/StageFire';
				var shitList:Array<String> = [];
				for (i in 0...84)
				{
					var ourUse:Array<String> = [Std.string(i)];
					var ourUse2:Array<String> = Std.string(i).split("");
					while (ourUse2.length < 2)
					{
						ourUse.push("0");
						ourUse2.push("0");
					}
					ourUse.reverse();
					//trace(ourUse);
					shitList.push(prefixShit + ourUse.join(""));
			}*/

			siniFireBehind = new FlxTypedGroup<SiniFire>();
			siniFireFront = new FlxTypedGroup<SiniFire>();

			// genocideBG = new SequenceBG(-600, -300, shitList, true, 2560, 1400, true);
			genocideBG = new FlxSprite(-600, -300).loadGraphic(Paths.image('fire/wadsaaa'));
			genocideBG.antialiasing = ClientPrefs.globalAntialiasing;
			genocideBG.scrollFactor.set(0.9, 0.9);
			add(genocideBG);

			// Time for sini's amazing fires lol
			// this one is behind the board
			// idk how to position this
			// i guess fuck my life lol
			for (i in 0...2)
			{
				var daFire:SiniFire = new SiniFire(genocideBG.x + (720 + (((95 * 10) / 2) * i)), genocideBG.y + 180, true, false, 30, i * 10, 84);
				daFire.antialiasing = ClientPrefs.globalAntialiasing;
				daFire.scrollFactor.set(0.9, 0.9);
				daFire.scale.set(0.4, 1);
				daFire.y += 50;
				siniFireBehind.add(daFire);
			}

			add(siniFireBehind);

			// genocide board is already in genocidebg but u know shit layering for fire lol
			genocideBoard = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/boards'));
			genocideBoard.antialiasing = ClientPrefs.globalAntialiasing;
			genocideBoard.scrollFactor.set(0.9, 0.9);
			add(genocideBoard);

			// front fire shit

			var fire1:SiniFire = new SiniFire(genocideBG.x + (-100), genocideBG.y + 889, true, false, 30);
			fire1.antialiasing = ClientPrefs.globalAntialiasing;
			fire1.scrollFactor.set(0.9, 0.9);
			fire1.scale.set(2.5, 1.5);
			fire1.y -= fire1.height * 1.5;
			fire1.flipX = true;

			var fire2:SiniFire = new SiniFire((fire1.x + fire1.width) - 80, genocideBG.y + 889, true, false, 30);
			fire2.antialiasing = ClientPrefs.globalAntialiasing;
			fire2.scrollFactor.set(0.9, 0.9);
			// fire2.scale.set(2.5, 1);
			fire2.y -= fire2.height * 1;

			var fire3:SiniFire = new SiniFire((fire2.x + fire2.width) - 30, genocideBG.y + 889, true, false, 30);
			fire3.antialiasing = ClientPrefs.globalAntialiasing;
			fire3.scrollFactor.set(0.9, 0.9);
			// fire3.scale.set(2.5, 1);
			fire3.y -= fire3.height * 1;

			var fire4:SiniFire = new SiniFire((fire3.x + fire3.width) - 10, genocideBG.y + 889, true, false, 30);
			fire4.antialiasing = ClientPrefs.globalAntialiasing;
			fire4.scrollFactor.set(0.9, 0.9);
			fire4.scale.set(1.5, 1.5);
			fire4.y -= fire4.height * 1.5;

			siniFireFront.add(fire1);
			siniFireFront.add(fire2);
			siniFireFront.add(fire3);
			siniFireFront.add(fire4);

			add(siniFireFront);

			// more layering shit
			var fuckYouFurniture:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(Paths.image('fire/glowyfurniture'));
			fuckYouFurniture.antialiasing = ClientPrefs.globalAntialiasing;
			fuckYouFurniture.scrollFactor.set(0.9, 0.9);
			add(fuckYouFurniture);
		
		case 'fading':
		
			defaultCamZoom = 0.9;
			curStage = 'garf';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagebgRise'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var garded:FlxSprite = new FlxSprite(-250, 650).loadGraphic(Paths.image('stos/gardead'));

			garded.updateHitbox();
			garded.antialiasing = ClientPrefs.globalAntialiasing;
			garded.scrollFactor.set(1.3, 1.3);
			garded.active = false;

			var stageCurtains:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStageRise'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.1));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			add(stageCurtains);
			add(garded);
		
		case 'sussus-moogus' | 'sabotage':
		
			defaultCamZoom = 0.9;
			curStage = 'sabotage';
			var bg:FlxSprite = new FlxSprite(-200, -300).loadGraphic(Paths.image('amogus/polusSky'));
			bg.setGraphicSize(Std.int(bg.width * 1.5));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.5, 0.5);
			bg.active = false;
			add(bg);

			var rocks:FlxSprite = new FlxSprite(-800, -300).loadGraphic(Paths.image('amogus/polusrocks'));
			rocks.setGraphicSize(Std.int(rocks.width * 1.5));
			rocks.updateHitbox();
			rocks.antialiasing = ClientPrefs.globalAntialiasing;
			rocks.scrollFactor.set(0.6, 0.6);
			rocks.active = false;
			add(rocks);

			var rocks:FlxSprite = new FlxSprite(-450, -200).loadGraphic(Paths.image('amogus/polusWarehouse'));
			rocks.setGraphicSize(Std.int(rocks.width * 1.5));
			rocks.updateHitbox();
			rocks.antialiasing = ClientPrefs.globalAntialiasing;
			rocks.scrollFactor.set(0.9, 0.9);
			rocks.active = false;
			add(rocks);

			var rocks:FlxSprite = new FlxSprite(-1000, 0).loadGraphic(Paths.image('amogus/polusHills'));
			rocks.setGraphicSize(Std.int(rocks.width * 1.5));
			rocks.updateHitbox();
			rocks.antialiasing = ClientPrefs.globalAntialiasing;
			rocks.scrollFactor.set(0.9, 0.9);
			rocks.active = false;
			add(rocks);

			var stageFront:FlxSprite = new FlxSprite(-400, 450).loadGraphic(Paths.image('amogus/polusGround'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.5));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(1, 1);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
		
		case 'meltdown':
		
			defaultCamZoom = 0.9;
			curStage = 'meltdown';
			var bg:FlxSprite = new FlxSprite(-200, -300).loadGraphic(Paths.image('polusSky'));
			bg.setGraphicSize(Std.int(bg.width * 1.5));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.5, 0.5);
			bg.active = false;
			add(bg);

			var rocks:FlxSprite = new FlxSprite(-800, -300).loadGraphic(Paths.image('polusrocks'));
			rocks.setGraphicSize(Std.int(rocks.width * 1.5));
			rocks.updateHitbox();
			rocks.antialiasing = ClientPrefs.globalAntialiasing;
			rocks.scrollFactor.set(0.6, 0.6);
			rocks.active = false;
			add(rocks);

			var rocks:FlxSprite = new FlxSprite(-450, -200).loadGraphic(Paths.image('polusWarehouse'));
			rocks.setGraphicSize(Std.int(rocks.width * 1.5));
			rocks.updateHitbox();
			rocks.antialiasing = ClientPrefs.globalAntialiasing;
			rocks.scrollFactor.set(0.9, 0.9);
			rocks.active = false;
			add(rocks);

			var rocks:FlxSprite = new FlxSprite(-1000, 0).loadGraphic(Paths.image('polusHills'));
			rocks.setGraphicSize(Std.int(rocks.width * 1.5));
			rocks.updateHitbox();
			rocks.antialiasing = ClientPrefs.globalAntialiasing;
			rocks.scrollFactor.set(0.9, 0.9);
			rocks.active = false;
			add(rocks);

			crowd = new MogusBoppers(0, 150);
			crowd.setGraphicSize(Std.int(crowd.width * 1.5));
			crowd.updateHitbox();
			crowd.scrollFactor.set(0.9, 0.9);
			crowd.active = false;
			add(crowd);

			var stageFront:FlxSprite = new FlxSprite(-400, 450).loadGraphic(Paths.image('polusGround'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.5));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(1, 1);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
		
		case 'bopeebo-b3' 
			| 'tutorial-b3'
			| 'fresh-b3'
			| 'dadbattle-b3':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-b3';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'spookeez-b3' | 'south-b3':
		
			curStage = 'spooky-b3';
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'pico-b3' | 'philly-b3' | 'blammed-b3':
		
			curStage = 'philly-b3';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street'));
			add(street);
		
		case 'satin-panties-b3'
			| 'high-b3'
			| 'milf-b3':
		
			curStage = 'limo-b3';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('limo/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		
		case 'cocoa-b3' | 'eggnog-b3':
		
			curStage = 'mall-b3';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
			bgEscalator.antialiasing = ClientPrefs.globalAntialiasing;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
			tree.antialiasing = ClientPrefs.globalAntialiasing;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = ClientPrefs.globalAntialiasing;
			add(santa);
		
		case 'winter-horrorland-b3':
		
			curStage = 'mallEvil-b3';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
			evilTree.antialiasing = ClientPrefs.globalAntialiasing;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
			evilSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(evilSnow);
		
		case 'senpai-b3' | 'roses-b3':
		
			curStage = 'school-b3';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool'));
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet'));
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack'));
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = Paths.getPackerAtlas('weeb/weebTrees');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			if (SONG.song.toLowerCase() == 'roses-b3')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		
		case 'thorns-b3':
		
			curStage = 'schoolEvil-b3';

			var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
			var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);

				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				add(waveSprite);
				add(waveSpriteFG);
			 */
		
		case 'retricus' | 'covetous' | 'terminus':
		
			curStage = 'dream';
			defaultCamZoom = 0.8;

			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/dreambg'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.8, 0.8);
			bg.active = false;
			add(bg);

			var dreamStars:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/dreamicons'));
			dreamStars.setGraphicSize(Std.int(dreamStars.width * 0.9));
			dreamStars.updateHitbox();
			dreamStars.antialiasing = ClientPrefs.globalAntialiasing;
			dreamStars.scrollFactor.set(0.6, 0.6);
			dreamStars.active = false;
			add(dreamStars);

			var dreamStage:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('detra/dreamstage'));
			dreamStage.setGraphicSize(Std.int(dreamStage.width * 1.1));
			dreamStage.updateHitbox();
			dreamStage.antialiasing = ClientPrefs.globalAntialiasing;
			dreamStage.scrollFactor.set(1, 1);
			dreamStage.active = false;
			add(dreamStage);
		
		case 'embark' | 'facade' | 'compel':
		
			curStage = 'dreamNightmare';
			defaultCamZoom = 0.8;

			var nmBg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/nightmarebg'));
			nmBg.antialiasing = ClientPrefs.globalAntialiasing;
			nmBg.scrollFactor.set(0.1, 0.1);
			nmBg.active = false;
			add(nmBg);

			var nmStars:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/nightmareStars'));
			nmStars.setGraphicSize(Std.int(nmStars.width * 0.9));
			nmStars.updateHitbox();
			nmStars.antialiasing = ClientPrefs.globalAntialiasing;
			nmStars.scrollFactor.set(0.8, 0.8);
			nmStars.active = false;
			add(nmStars);

			var nmIcons:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/nightmareIcons'));
			nmIcons.setGraphicSize(Std.int(nmIcons.width * 0.9));
			nmIcons.updateHitbox();
			nmIcons.antialiasing = ClientPrefs.globalAntialiasing;
			nmIcons.scrollFactor.set(0.5, 0.5);
			nmIcons.active = false;
			add(nmIcons);

			var nmStage:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('detra/nightmareStage'));
			nmStage.setGraphicSize(Std.int(nmStage.width * 1.1));
			nmStage.updateHitbox();
			nmStage.antialiasing = ClientPrefs.globalAntialiasing;
			nmStage.scrollFactor.set(1, 1);
			nmStage.active = false;
			add(nmStage);
		
		case 'extremus':
		
			curStage = 'dream';
			defaultCamZoom = 0.8;

			dreamTwoBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/dreamhard'));
			dreamTwoBG.alpha = 0;
			dreamTwoBG.antialiasing = ClientPrefs.globalAntialiasing;
			dreamTwoBG.scrollFactor.set(0.8, 0.8);
			dreamTwoBG.active = false;
			add(dreamTwoBG);

			dreamTwoIcons = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/dreamiconshard'));
			dreamTwoIcons.alpha = 0;
			dreamTwoIcons.setGraphicSize(Std.int(dreamTwoIcons.width * 0.9));
			dreamTwoIcons.updateHitbox();
			dreamTwoIcons.antialiasing = ClientPrefs.globalAntialiasing;
			dreamTwoIcons.scrollFactor.set(0.6, 0.6);
			dreamTwoIcons.active = false;
			add(dreamTwoIcons);

			dreamTwoStage = new FlxSprite(-650, 600).loadGraphic(Paths.image('detra/dreamstagehard'));
			dreamTwoStage.alpha = 0;
			dreamTwoStage.setGraphicSize(Std.int(dreamTwoStage.width * 1.1));
			dreamTwoStage.updateHitbox();
			dreamTwoStage.antialiasing = ClientPrefs.globalAntialiasing;
			dreamTwoStage.scrollFactor.set(1, 1);
			dreamTwoStage.active = false;
			add(dreamTwoStage);

			dreamOneBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/dreambg'));
			dreamOneBG.antialiasing = ClientPrefs.globalAntialiasing;
			dreamOneBG.scrollFactor.set(0.8, 0.8);
			dreamOneBG.active = false;
			add(dreamOneBG);

			dreamOneIcons = new FlxSprite(-600, -200).loadGraphic(Paths.image('detra/dreamicons'));
			dreamOneIcons.setGraphicSize(Std.int(dreamOneIcons.width * 0.9));
			dreamOneIcons.updateHitbox();
			dreamOneIcons.antialiasing = ClientPrefs.globalAntialiasing;
			dreamOneIcons.scrollFactor.set(0.6, 0.6);
			dreamOneIcons.active = false;
			add(dreamOneIcons);

			dreamOneStage = new FlxSprite(-650, 600).loadGraphic(Paths.image('detra/dreamstage'));
			dreamOneStage.setGraphicSize(Std.int(dreamOneStage.width * 1.1));
			dreamOneStage.updateHitbox();
			dreamOneStage.antialiasing = ClientPrefs.globalAntialiasing;
			dreamOneStage.scrollFactor.set(1, 1);
			dreamOneStage.active = false;
			add(dreamOneStage);
		
		case 'prom' | 'synergy':
		
			defaultCamZoom = 0.7;
			curStage = 'park-1';

			halloweenBG = new FlxSprite(-600, -200).loadGraphic(Paths.image('tree/grass', 'shared'));
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			halloweenBG.scrollFactor.set(0.9, 0.9);
			add(halloweenBG);
		
		case 'the-date':
		
			defaultCamZoom = 0.7;
			curStage = 'livingroom';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('cat/bg_livingroom'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		
		case 'red-flag' | 'gtfo':
		
			defaultCamZoom = 0.7;
			curStage = 'bedroom';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('cat/bg_bedroom'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		
		case 'left-swipe':
		
			defaultCamZoom = 0.7;
			curStage = 'room104';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('cat/bg_room104'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		
		case 'smol':
		
			defaultCamZoom = 0.7;

			curStage = 'chateau';
			var bg:FlxSprite = new FlxSprite(-600, -382).loadGraphic(Paths.image('cat/bg_hall'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.1, 0.1);
			bg.active = false;
			bg.updateHitbox();
			add(bg);

			var fg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('cat/fg_hallway'));
			fg.scrollFactor.set(0.7, 0.7);
			fg.active = false;
			fg.updateHitbox;
			add(fg);
		
		case 'best-girl'
			| 'daddys-girl'
			| 'daughter-complex'
			| 'salty-love':
		
			defaultCamZoom = 0.9;
			curStage = 'stage-salty';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('salty/stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('salty/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('salty/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		
		case 'sweet-n-spooky'
			| 'sour-n-scary'
			| 'opheebop':
		
			curStage = 'spooky-salty';
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('salty/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = ClientPrefs.globalAntialiasing;
			add(halloweenBG);

			isHalloween = true;
		
		case 'protect' | 'defend' | 'safeguard':
		
			curStage = 'philly-salty';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('salty/philly/sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('salty/philly/city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('salty/philly/win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('salty/philly/behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('salty/philly/street'));
			add(street);
		
		case 'indie-star'
			| 'rising-star'
			| 'superstar':
		
			curStage = 'limo-salty';
			defaultCamZoom = 0.90;

			var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('salty/limo/limoSunset'));
			skyBG.scrollFactor.set(0.1, 0.1);
			add(skyBG);

			var bgLimo:FlxSprite = new FlxSprite(-200, 480);
			bgLimo.frames = Paths.getSparrowAtlas('salty/limo/bgLimo');
			bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
			bgLimo.animation.play('drive');
			bgLimo.scrollFactor.set(0.4, 0.4);
			add(bgLimo);

			grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
			add(grpLimoDancers);

			for (i in 0...5)
			{
				var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
				dancer.scrollFactor.set(0.4, 0.4);
				grpLimoDancers.add(dancer);
			}

			var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('salty/limo/limoOverlay'));
			overlayShit.alpha = 0.5;
			// add(overlayShit);

			// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

			// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

			// overlayShit.shader = shaderBullshit;

			var limoTex = Paths.getSparrowAtlas('salty/limo/limoDrive');

			limo = new FlxSprite(-120, 550);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = ClientPrefs.globalAntialiasing;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('salty/limo/fastCarLol'));
		
		case 'order-up' | 'rush-hour':
		
			curStage = 'mall-salty';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('salty/christmas/bgWalls'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('salty/christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('salty/christmas/bgEscalator'));
			bgEscalator.antialiasing = ClientPrefs.globalAntialiasing;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('salty/christmas/christmasTree'));
			tree.antialiasing = ClientPrefs.globalAntialiasing;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('salty/christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = ClientPrefs.globalAntialiasing;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('salty/christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('salty/christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = ClientPrefs.globalAntialiasing;
			add(santa);
		
		case 'freedom':
		
			curStage = 'mallEvil-salty';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('salty/christmas/evilBG'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('salty/christmas/evilTree'));
			evilTree.antialiasing = ClientPrefs.globalAntialiasing;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("salty/christmas/evilSnow"));
			evilSnow.antialiasing = ClientPrefs.globalAntialiasing;
			add(evilSnow);
		
		case 'buckets' | 'logarithms':
		
			curStage = 'school-salty';

			// defaultCamZoom = 0.9;

			var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky'));
			bgSky.scrollFactor.set(0.1, 0.1);
			add(bgSky);

			var repositionShit = -200;

			var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('salty/weeb/weebSchool'));
			bgSchool.scrollFactor.set(0.6, 0.90);
			add(bgSchool);

			var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('salty/weeb/weebStreet'));
			bgStreet.scrollFactor.set(0.95, 0.95);
			add(bgStreet);

			var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('salty/weeb/weebTreesBack'));
			fgTrees.scrollFactor.set(0.9, 0.9);
			add(fgTrees);

			var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
			var treetex = Paths.getPackerAtlas('salty/weeb/weebTrees');
			bgTrees.frames = treetex;
			bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
			bgTrees.animation.play('treeLoop');
			bgTrees.scrollFactor.set(0.85, 0.85);
			add(bgTrees);

			var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
			treeLeaves.frames = Paths.getSparrowAtlas('salty/weeb/petals');
			treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
			treeLeaves.animation.play('leaves');
			treeLeaves.scrollFactor.set(0.85, 0.85);
			add(treeLeaves);

			var widShit = Std.int(bgSky.width * 6);

			bgSky.setGraphicSize(widShit);
			bgSchool.setGraphicSize(widShit);
			bgStreet.setGraphicSize(widShit);
			bgTrees.setGraphicSize(Std.int(widShit * 1.4));
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			treeLeaves.setGraphicSize(widShit);

			fgTrees.updateHitbox();
			bgSky.updateHitbox();
			bgSchool.updateHitbox();
			bgStreet.updateHitbox();
			bgTrees.updateHitbox();
			treeLeaves.updateHitbox();

			bgGirls = new BackgroundGirls(-100, 190);
			bgGirls.scrollFactor.set(0.9, 0.9);

			if (SONG.song.toLowerCase() == 'logarithms')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		
		case 'terminal':
		
			curStage = 'schoolEvil-salty';

			var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
			var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

			var posX = 400;
			var posY = 200;

			var bg:FlxSprite = new FlxSprite(posX, posY);
			bg.frames = Paths.getSparrowAtlas('salty/weeb/animatedEvilSchool');
			bg.animation.addByPrefix('idle', 'background 2', 24);
			bg.animation.play('idle');
			bg.scrollFactor.set(0.8, 0.9);
			bg.scale.set(6, 6);
			add(bg);

			/* 
				var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
				bg.scale.set(6, 6);
				// bg.setGraphicSize(Std.int(bg.width * 6));
				// bg.updateHitbox();
				add(bg);

				var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
				fg.scale.set(6, 6);
				// fg.setGraphicSize(Std.int(fg.width * 6));
				// fg.updateHitbox();
				add(fg);

				wiggleShit.effectType = WiggleEffectType.DREAMY;
				wiggleShit.waveAmplitude = 0.01;
				wiggleShit.waveFrequency = 60;
				wiggleShit.waveSpeed = 0.8;
			 */

			// bg.shader = wiggleShit.shader;
			// fg.shader = wiggleShit.shader;

			/* 
				var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
				var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);

				// Using scale since setGraphicSize() doesnt work???
				waveSprite.scale.set(6, 6);
				waveSpriteFG.scale.set(6, 6);
				waveSprite.setPosition(posX, posY);
				waveSpriteFG.setPosition(posX, posY);

				waveSprite.scrollFactor.set(0.7, 0.8);
				waveSpriteFG.scrollFactor.set(0.9, 0.8);

				// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
				// waveSprite.updateHitbox();
				// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
				// waveSpriteFG.updateHitbox();

				add(waveSprite);
				add(waveSpriteFG);
			 */
		
		case 'inverted-ascension' | 'echoes' | 'artificial-lust':
		{
		
			normalStage = new FlxTypedGroup<FlxSprite>();
			add(normalStage);
			defaultCamZoom = 0.64;
			curStage = 'festival';
			var bg:FlxSprite = new FlxSprite(0, 0);
			switch (SONG.song.toLowerCase())
			{
				case 'inverted-ascension':
					bg = new FlxSprite(-550, -160).loadGraphic(Paths.image('cj/morning/bg'));
				case 'echoes':
					bg = new FlxSprite(-550, -160).loadGraphic(Paths.image('cj/dusk/bg'));
				case 'artificial-lust':
					bg = new FlxSprite(-550, -160).loadGraphic(Paths.image('cj/night/bg'));
			}
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.5, 0.5);
			bg.active = false;
			normalStage.add(bg);

			var stage:FlxSprite = new FlxSprite(-510, -260).loadGraphic(Paths.image('cj/stage'));
			stage.antialiasing = ClientPrefs.globalAntialiasing;
			stage.active = false;
			normalStage.add(stage);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...4)
			{
				var light:FlxSprite = new FlxSprite(-510, -260).loadGraphic(Paths.image('cj/light' + i));
				if (i != 0)
					light.visible = false;
				light.antialiasing = ClientPrefs.globalAntialiasing;
				phillyCityLights.add(light);
			}

			headlights = new FlxSprite(-510, -80);
			headlights.frames = Paths.getSparrowAtlas('cj/headlights');
			headlights.antialiasing = ClientPrefs.globalAntialiasing;
			headlights.animation.addByPrefix('idle', 'lightsrepeated', 24, false);
			headlights.animation.play('idle');
			add(headlights);

			frontbop = new FlxSprite(-510, 950);
			frontbop.frames = Paths.getSparrowAtlas('cj/frontboppers');
			frontbop.antialiasing = ClientPrefs.globalAntialiasing;
			frontbop.animation.addByPrefix('idle', 'frontboppers', 24, false);
			frontbop.animation.play('idle');
			normalStage.add(frontbop);

			cj = new FlxSprite(150, 400);
			cj.frames = Paths.getSparrowAtlas('cj/CJBG');
			cj.scale.set(0.9, 0.9);
			cj.updateHitbox();
			cj.antialiasing = ClientPrefs.globalAntialiasing;
			cj.animation.addByPrefix('idle', 'CJ', 24, false);
			cj.animation.play('idle');
			switch (SONG.song.toLowerCase())
			{
				case 'echoes':
					add(cj);
			}
		}
		case 'high school conflict' | 'bara no yume' | 'your reality' | 'dreams of roses':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('monika/weeb/weebSky','shared'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('monika/weeb/weebSchool','shared'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('monika/weeb/weebStreet','shared'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('monika/weeb/weebTreesBack','shared'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('monika/weeb/weebTrees','shared');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('monika/weeb/petals','shared');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					if (SONG.song.toLowerCase() == "bara no yume" || SONG.song.toLowerCase() == "dreams of roses")
					{
						bgGirls = new BackgroundGirls(-600, 190);
						bgGirls.scrollFactor.set(0.9, 0.9);
			
						bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
						bgGirls.updateHitbox();
						add(bgGirls);
								
							
					}
			}
			case 'your demise':
			{
					curStage = 'schoolEvil';
					defaultCamZoom = 0.9;

					var posX = 50;
					var posY = 200;

					//finalebgmybeloved
					var oldspace:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('finalebgmybeloved'));
					oldspace.antialiasing = false;
					oldspace.scale.set(1.65, 1.65);
					oldspace.scrollFactor.set(0.1, 0.1);
					add(oldspace);

					add(space = new FlxBackdrop(Paths.image('monika/weeb/FinaleBG_1')));
					space.velocity.set(-10, 0);
					space.antialiasing = false;
					space.scrollFactor.set(0.1, 0.1);
					space.scale.set(1.65, 1.65);

					var bg:FlxSprite = new FlxSprite(70, posY).loadGraphic(Paths.image('monika/weeb/FinaleBG_2'));
					bg.antialiasing = false;
					bg.scale.set(2.3, 2.3);
					bg.scrollFactor.set(0.4, 0.6);
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('monika/weeb/FinaleFG'));
					stageFront.antialiasing = false;
					stageFront.scale.set(1.5, 1.5);
					stageFront.scrollFactor.set(1, 1);
					add(stageFront);
			}
		default:
			defaultCamZoom = 0.9;
			curStage = 'stage';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = ClientPrefs.globalAntialiasing;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = ClientPrefs.globalAntialiasing;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
        }

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'high school conflict' | '':
				gfVersion = 'gf-doki';
			case 'nogf-pixel':
				gfVersion = 'nogf-pixel';
			case 'tankman1':
				gfVersion = 'gftank';
				if (SONG.song.toLowerCase() == 'stress' || SONG.song.toLowerCase() == 'stress-duet')
					gfVersion = 'picospeaker';
			case 'church-dark':
				gfVersion = 'gf-dark';
			case 'auditorHell':
				gfVersion = 'gf-tied';
			case 'swordarena':
				gfVersion = 'gf-mii';
			case 'arenanight':
				gfVersion = 'gf-mii';
			case 'touhou':
				gfVersion = 'gf-car';
			case 'limo-fl':
				gfVersion = 'gf-train';
			case 'whitty-crazy':
				gfVersion = 'gf-whitty-ball';
			case 'sky-mad':
				gfVersion = 'gf-manifest';
			case 'limo-neo':
				gfVersion = 'gf-car-neo';
			case 'limo-b3':
				gfVersion = 'gf-car-b3';
			case 'limo-salty':
				gfVersion = 'gf-car-salty';
			case 'limo-b':
				gfVersion = 'gf-car-b';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'mall-b3' | 'mallEvil-b3':
				gfVersion = 'gf-christmas-b3';
			case 'mall-salty' | 'mallEvil-salty':
				gfVersion = 'gf-christmas-salty';
			case 'mall-b' | 'mallEvil-b':
				gfVersion = 'gf-christmas-b';
			case 'school-b3':
				gfVersion = 'gf-pixel-b3';
			case 'school-salty':
				gfVersion = 'gf-pixel-salty';
			
				
			case 'school-neon':
				gfVersion = 'gf-pixel-2';
			case 'school-neon-2':
				gfVersion = 'gf-pixel-3';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'schoolEvil-salty':
				gfVersion = 'gf-pixel-salty';
			case 'schoolEvil-b3':
				gfVersion = 'gf-pixel-b3';
			case 'school-b':
				gfVersion = 'gf-pixel-b';
			case 'schoolEvil-b':
				gfVersion = 'gf-pixel-b';
			case 'stage-b3':
				gfVersion = 'gf-b3';
			case 'stage-salty':
				gfVersion = 'gf-salty';
			case 'school':
				if (SONG.song.toLowerCase() == 'your reality')
					gfVersion = 'nogf-pixel';
				else
					gfVersion = 'gf-pixel';
			case 'spooky-salty':
				gfVersion = 'gf-salty';
			case 'philly-salty':
				gfVersion = 'gf-salty';
			case 'stage-neo':
				gfVersion = 'gf-neo';
			case 'stage-star':
				gfVersion = 'gf-star';
			case 'spooky-b3':
				gfVersion = 'gf-b3';
			case 'spooky-neo':
				gfVersion = 'gf-neo';
			case 'philly-b3':
				gfVersion = 'gf-b3';
			case 'philly-neo':
				gfVersion = 'gf-neo';
			case 'stage-b':
				gfVersion = 'gf-b';
			case 'stage-beats':
				gfVersion = 'gf-beat';
			case 'philly-beat':
				gfVersion = 'gf-beat';
			case 'spooky-b':
				gfVersion = 'gf-b';
			case 'spooky-star':
				gfVersion = 'gf-star';
			case 'spooky-beat':
				gfVersion = 'gf-beat';
			case 'philly-b':
				gfVersion = 'gf-b';
			case 'philly-star':
				gfVersion = 'gf-star';
			case 'whitty-normal':
				gfVersion = 'gf-whitty';
			case 'hex-stage-noon':
				gfVersion = 'gf-noon';
			case 'hex-stage-night':
				gfVersion = 'gf-night';
			case 'hex-stage-hack':
				gfVersion = 'gf-hack';
			case 'curse':
				gfVersion = 'gf-tabi';
			case 'genocide':
				gfVersion = 'gf-tabi-crazy';
				var destBoombox:FlxSprite = new FlxSprite(400, 130).loadGraphic(Paths.image('tabi/mad/Destroyed_boombox'));
				destBoombox.y += (destBoombox.height - 648) * -1;
				destBoombox.y += 150;
				destBoombox.x -= 110;
				destBoombox.scale.set(1.2, 1.2);
				add(destBoombox);
			case 'sabotage' | 'meltdown':
				gfVersion = 'ggf';
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		if (curStage == 'limo-b3')
			gfVersion = 'gf-car-b3';

		if (curStage == 'limo-salty')
			gfVersion = 'gf-car-salty';

		if (curStage == 'limo-neo')
			gfVersion = 'gf-car-neo';

		if (curStage == 'limo-b')
			gfVersion = 'gf-car-b';
		if (curStage == 'limo-star')
			gfVersion = 'gf-car-star';

		if (SONG.song.toLowerCase() == 'artificial-lust')
			gfVersion = 'nogf';

		gf = new Character(400, 130, gfVersion);

		if (curStage != 'genocide')
		{
			gf.scrollFactor.set(0.95, 0.95);
		}

		if (curStage == 'nevadaSpook')
			dad = new Character(100, 100, 'tricky');
		else
			dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'gf-b3':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'gf-salty':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'gf-star':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case "spooky":
				dad.y += 200;
			case "spooky-b3":
				dad.y += 200;
			case "spooky-salty":
				dad.y += 200;
			case "spooky-neo":
				dad.y += 200;
			case "spooky-b":
				dad.y += 200;
			case "spooky-beat":
				dad.y += 200;
			case "ink":
				dad.y += 200;
				dad.x -= 100;
			case 'neko-sweet':
				dad.x -= 90;
				dad.y += 230;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'neko-crazy':
				dad.x -= 50;
				dad.y += 230;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'meowser':
				dad.x -= 300;
				dad.y += 50;
			case 'neko-schizo':
				dad.x += 50;
				dad.y += 230;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'neko-bonus':
				dad.x -= 30;
				dad.y += 270;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'nekunt':
				dad.x -= 10;
				dad.y += 480;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'bob':
				camPos.x += 600;
				dad.y += 440;
			case 'angrybob':
				camPos.x += 600;
				dad.y += 440;
			case 'hellbob':
				camPos.x += 600;
				dad.y += 510;
			case "spooky-star":
				dad.y += 200;
			case 'matt-duck':
				dad.x -= 50;
				dad.y += 330;
			case 'cj':
				camPos.x += 500;
				dad.y += 20;
			case 'duet':
				camPos.x += 300;
			case 'ruby':
				camPos.x += 500;
			case 'gaymen':
				dad.x -= 400;
				dad.y -= 400;
			case "gaw":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case "monster-salty":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'monster-christmas-salty':
				dad.y += 130;
			case 'monster-christmas-b3':
				dad.y += 130;
			case 'annie2':
				dad.y += 130;
			case 'tricky-beat':
				dad.y += 55;
				dad.x -= 100;
			case 'hex-hack':
				dad.y += 65;
			case 'tricky':
				camPos.x += 400;
				dad.y += 55;
				dad.x -= 100;
				camPos.y += 600;
			case 'trickyMask':
				dad.y += 55;
				dad.x -= 100;
				camPos.x += 400;
			case 'trickyH':
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 500);
				dad.y -= 2000;
				dad.x -= 1400;
				gf.x -= 380;
			case 'exTricky':
				dad.x -= 250;
				dad.y -= 365;
				gf.x += 345;
				gf.y -= 25;
			case 'trickyMask-beat':
				dad.y += 55;
				dad.x -= 100;
			case 'tankman':
				dad.y += 250;
				dad.x += 150;
			case 'monster-christmas-b':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'pico-salty':
				camPos.x += 600;
				dad.y += 300;
			case 'annie':
				camPos.x += 600;
				dad.y += 300;
			case 'pico-b3':
				camPos.x += 600;
				dad.y += 300;
			case 'pico-neo':
				camPos.x += 600;
				dad.y += 300;
			case 'pico-b':
				camPos.x += 600;
				dad.y += 300;
			case 'pico-beat':
				camPos.x += 600;
				dad.y += 300;
			case 'pico-star':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'parents-christmas-b3':
				dad.x -= 500;
			case 'parents-christmas-salty':
				dad.x -= 500;
			case 'parents-christmas-b':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-b3':
				dad.x += 150;
				dad.y += 360;
			case 'senpai-salty':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-2':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				case 'monika':
					dad.x += 150;
					dad.y += 360;
					camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				case 'duet-m':
					dad.x += 150;
					dad.y += 380;
					camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
				case 'monika-angry':
					dad.x += 15;
					dad.y += 360;
					camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit-salty':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-b3-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit-b3':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit-2':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case "matt":
				dad.y += 300;
			case "mattmad":
				dad.y += 300;
			case 'senpai-b':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry-b':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit-b':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'tord':
				dad.x = 214.2;
				dad.y = 55.4;
				camPos.set(218.75, 25.7);
			case 'tordbot':
				dad.x = -429.05;
				dad.y = -1424.75;
				camPos.set(391.2, -1094.15);
			case 'shcarol':
				dad.setPosition(32, -173.55);
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'duck':
				dad.x += 119;
				dad.y += 560;
			case 'tabi':
				dad.x -= 300;
			case 'tabi-crazy':
				dad.x -= 300;
				dad.y += 50;
			case 'impostor':
				camPos.y += -200;
				camPos.x += 400;
				dad.x -= 200;
				dad.y += 350;
			case 'impostor2':
				camPos.y += -200;
				camPos.x += 400;
				dad.x -= 200;
				dad.y += 350;
			case 'detra':
				dad.x = 140;
				dad.y = 280;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
			case 'vagrant':
				dad.x = 30;
				dad.y = 90;
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		}

		if (isStoryMode)
			bfsel = 1000;
		switch bfsel
		{
			case 0:
				boyfriend = new Boyfriend(770, 450, SONG.player1);
			case 1:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas');
			case 2:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel');
			case 3:
				boyfriend = new Boyfriend(770, 450, 'bf-holding-gf');
			case 4:
				boyfriend = new Boyfriend(770, 450, 'bf-b');
			case 5:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-b');
			case 6:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel-b');
			case 7:
				boyfriend = new Boyfriend(770, 450, 'bf-neo');
			case 8:
				boyfriend = new Boyfriend(770, 450, 'bf-minus');
			case 9:
				boyfriend = new Boyfriend(770, 450, 'bf-minus-beta');
			case 10:
				boyfriend = new Boyfriend(770, 520, 'bf-minus-blue');
			case 11:
				boyfriend = new Boyfriend(770, 450, 'bf-ena');
			case 12:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-ena');
			case 13:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel-ena');
			case 14:
				boyfriend = new Boyfriend(770, 450, 'bf-rs');
			case 15:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-rs');
			case 16:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel-rs');
			case 17:
				boyfriend = new Boyfriend(770, 450, 'bf-star');
			case 18:
				boyfriend = new Boyfriend(770, 450, 'bf-reanim');
			case 19:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-reanim');
			case 20:
				boyfriend = new Boyfriend(770, 450, 'bf-b3');
			case 21:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-b3');
			case 22:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel-b3');
			case 23:
				boyfriend = new Boyfriend(770, 450, 'bf-salty');
			case 24:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-salty');
			case 25:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel-salty');
			case 26:
				boyfriend = new Boyfriend(770, 450, 'bf-fresh');
			case 27:
				boyfriend = new Boyfriend(770, 450, 'bfmii');
			case 28:
				boyfriend = new Boyfriend(770, 450, 'bf-sonic');
			case 29:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-sonic');
			case 30:
				boyfriend = new Boyfriend(1000, 630, 'bf-pixel-sonic');
			default:
				boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'tankman1':
				gf.y += 10;
				gf.x -= 30;
				boyfriend.x += 40;
				dad.y -= 60;
				dad.x -= 80;

			
				if (gf.hasGun)
				{
					gf.y -= 200;
					gf.x -= 50;
					
					var john = new FlxSprite(FlxG.width + 1000, 500);
     				john.frames = Paths.getSparrowAtlas('tank/tankmanKilled1');
	        		john.antialiasing = ClientPrefs.globalAntialiasing;
			        john.animation.addByPrefix("run", "tankman running", 24, true);
        			john.animation.addByPrefix("shot", "John Shot " + FlxG.random.int(1,2), 24, false);
		    	    john.setGraphicSize(Std.int(0.8 * john.width));
        			john.updateHitbox();
			        john.animation.play("run");
    	    		tankSpeedJohn.push(0.7);
       				goingRightJohn.push(false);

					   strumTimeJohn.push(gf.animationNotes[0][0]);
					   endingOffsetJohn.push(FlxG.random.float(0.6, 1));
					   resetJohn(FlxG.width * 1.5, 600, true, john, 0);
					   johns.add(john);
					   var i = 0;
					   for (c in 1...gf.animationNotes.length)
					   {
						   if (FlxG.random.float(0, 100) < 16)
						   {
							   var jahn = john.clone();
							  
							   tankSpeedJohn.push(0.7);
							   goingRightJohn.push(false);
			   
							   strumTimeJohn.push(gf.animationNotes[c][0]);
							   endingOffsetJohn.push(FlxG.random.float(0.6, 1));
							   johns.add(jahn);
							   resetJohn(FlxG.width * 1.5, 200 + FlxG.random.int(50, 100),  2 > gf.animationNotes[c][1], jahn,i);
							   i++;
							   
						   }
					   }
				}
				else
				{
					gf.x -= 170;
					gf.y -= 75;
				}
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				gf.y += 80;
				gf.x += 80;
				gf.scale.x -= 0.1;
				gf.scale.y -= 0.1;
				gf.scrollFactor.set(0.4, 0.4);
			case 'sans':
				dad.y += 400;
			case 'touhou':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				gf.y += 80;
				gf.x += 80;
				gf.scale.x -= 0.1;
				gf.scale.y -= 0.1;
				gf.scrollFactor.set(0.4, 0.4);
			case 'limo-fl':
				boyfriend.y -= 100;
				dad.y += 100;
				gf.y += 250;
			case 'limo-salty':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				gf.y += 80;
				gf.x += 80;
				gf.scale.x -= 0.1;
				gf.scale.y -= 0.1;
				gf.scrollFactor.set(0.4, 0.4);
			case 'limo-b3':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				gf.y += 80;
				gf.x += 80;
				gf.scale.x -= 0.1;
				gf.scale.y -= 0.1;
				gf.scrollFactor.set(0.4, 0.4);
			case 'limo-star':
				boyfriend.y -= 100;
				boyfriend.x += 50;
				dad.y += 100;
				dad.x -= 200;
				gf.y -= 0;
				gf.x -= 190;
			case 'limo-b':
				boyfriend.y -= 220;
				boyfriend.x += 260;
				gf.y += 80;
				gf.x += 80;
				gf.scale.x -= 0.1;
				gf.scale.y -= 0.1;
				gf.scrollFactor.set(0.4, 0.4);
			case 'limo-neo':
				dad.y -= 60;
			case 'mall':
				boyfriend.x += 200;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'mall-b3':
				boyfriend.x += 200;
			case 'mallEvil-b3':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'mall-salty':
				boyfriend.x += 200;
			case 'mallEvil-salty':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'whitty-crazy':
				dad.x -= 30;
				gf.y += 130;
			case 'zardy':
				dad.x -= 160;
				dad.y += 50;
				boyfriend.x += 60;
				boyfriend.y += 80;
				gf.x -= 40;
				gf.y += 60;
			case 'whitty-normal':
				dad.x -= 30;
				gf.y += 125;
			case 'mall-b':
				boyfriend.x += 200;
			case 'mallEvil-b':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'nevada':
				boyfriend.y -= 0;
				boyfriend.x += 260;
			case 'auditorHell':
				boyfriend.y -= 160;
				boyfriend.x += 350;
			case 'tricky-beat':
				gf.y -= 100;
				boyfriend.x += 150;
				boyfriend.y -= 30;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

				
			
			case 'school-salty':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'school-b3':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'livingroom':
				boyfriend.x += 100;
				gf.y -= 1000;
			case 'bedroom':
				boyfriend.x += 130;
				gf.y -= 1000;
			case 'room104':
				boyfriend.x += 130;
				boyfriend.y += 120;
				gf.y -= 1000;
			case 'chateau':
				boyfriend.x += 130;
				boyfriend.y += 120;
				gf.y -= 1000;
			case 'charaut':
				dad.y += 300;
			case 'school-neon':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'sky':
				dad.y += 90;
				dad.x += 150;
				gf.x += 80;
				gf.y -= 100;
				boyfriend.x += 150;
				gf.scale.x -= 0.5;
				gf.scale.y -= 0.5;
			case 'sky-mad':
				dad.y += 180;
				dad.x += 150;
				gf.x += 120;
				gf.y -= 100;
				boyfriend.x += 150;
			case 'chara':
				dad.y += 190;
				dad.x -= 150;
				gf.x -= 100;
				gf.y -= 100;
				gf.scale.x -= 0.3;
				gf.scale.y -= 0.3;
				boyfriend.x += 100;
			case 'xgaster':
				dad.y += 200;
				gf.x -= 100;
				gf.y -= 100;
				gf.scale.x -= 0.4;
				gf.scale.y -= 0.4;
			case 'inksans':
				gf.y += 150;
				gf.scale.x -= 0.4;
				gf.scale.y -= 0.4;
				boyfriend.y += 100;
			case 'eddhouse':
				boyfriend.x = 1096.1;
				boyfriend.y = 271.7;
				gf.x = 650;
				gf.y = -115;
			case 'schoolEvil':
				
				if (SONG.song.toLowerCase() == 'your demise')
				{
					dad.y -= 69;
					dad.x += 300;
					boyfriend.x += 200;
					boyfriend.y += 260;
					gf.x += 180;
					gf.y += 300;
				}
				else
					{
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);

				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
					}
			case 'schoolEvil-b3':
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);

				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'festival':
				boyfriend.x += 150;
				boyfriend.y += 90;
				gf.x -= 20; // 117
				gf.y += 60;
				dad.x -= 80;
				dad.y += 70;
			case 'school-neon-2':
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);

				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'school-b':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'church-normal':
				gf.scale.y -= 0.1;
				gf.scale.x -= 0.1;
				gf.y -= 100;
			case 'church-selever':
				gf.scale.y -= 0.1;
				gf.scale.x -= 0.1;
				gf.y -= 100;
			case 'church-dark':
				gf.scale.y -= 0.1;
				gf.scale.x -= 0.1;
				gf.y -= 100;
			case 'church-ruv':
				gf.scale.y -= 0.1;
				gf.scale.x -= 0.1;
				gf.y -= 100;
			case 'schoolEvil-b':
				// trailArea.scrollFactor.set();
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);

				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;


			case 'sky_shaggy':
				gf.x -= 210;
				gf.y -= 300;
				gf.scrollFactor.set(0.8, 0.8);
				gf.scale.x -= 0.2;
				gf.scale.y -= 0.2;
				dad.x -= 600;
			case 'sunstage':
				dad.y -= 160;
			case 'witheredstage':
				dad.y -= 160;
			case 'hellstage':
				dad.y -= 160;
			case 'curse':
				boyfriend.setZoom(1.2);
				boyfriend.x += 300;
				gf.setZoom(1.2);
				gf.y -= 110;
				gf.x -= 50;
			case 'genocide':
				boyfriend.setZoom(1.2);
				boyfriend.x += 300;
				gf.setZoom(1);
				// gf.y -= 20;
				gf.x += 100;
				var tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);

				add(tabiTrail);
			case 'meltdown':
				gf.y -= 100;
			case 'sabotage':
				gf.y -= 100;
		}

		if (SONG.song.toLowerCase() == 'artificial-lust')
		{
			gfRGB = new Character(gf.x, gf.y, gf.curCharacter, gf.isPlayer, true);
			rgbStage.add(gfRGB);
			dadRGB = new Character(dad.x, dad.y, dad.curCharacter, dad.isPlayer, true);
			rgbStage.add(dadRGB);
			bfRGB = new Boyfriend(boyfriend.x, boyfriend.y, boyfriend.curCharacter, true);
			rgbStage.add(bfRGB);
		}
		// Shitty layering but whatev it works LOL - Yeah Ninjamuffin it works lmfao
		if (curStage == 'limo')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-b3')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-salty')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-star')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-neo')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-b')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-fl')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'limo-star')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'touhou')
		{
			add(gf);
			add(limo);
		}
		if (curStage == 'church-ruv')
		{
			add(gf);
			add(deadpill);
		}
		if (curStage == 'auditorHell')
		{
			add(gf);
			add(hole);
		}
		if (dad.curCharacter == 'trickyH')
			dad.addOtherFrames();
		add(gf);
		add(dad);

		if (curStage == 'auditorHell')
		{
			// Clown init
			cloneOne = new FlxSprite(0, 0);
			cloneTwo = new FlxSprite(0, 0);
			cloneOne.frames = CachedFrames.cachedInstance.fromSparrow('cln', 'fourth/Clone');
			cloneTwo.frames = CachedFrames.cachedInstance.fromSparrow('cln', 'fourth/Clone');
			cloneOne.alpha = 0;
			cloneTwo.alpha = 0;
			cloneOne.animation.addByPrefix('clone', 'Clone', 24, false);
			cloneTwo.animation.addByPrefix('clone', 'Clone', 24, false);
			// cover crap
			add(cloneOne);
			add(cloneTwo);
			add(cover);
			add(converHole);
			add(dad.exSpikes);
		}
		var deadass:FlxSprite = new FlxSprite(800, 650).loadGraphic(Paths.image('bfdead'));

		deadass.setGraphicSize(Std.int(deadass.width * 1));
		deadass.updateHitbox();
		deadass.antialiasing = ClientPrefs.globalAntialiasing;
		deadass.scrollFactor.set(1, 1);
		deadass.active = false;
		if (curStage == 'meltdown')
			add(deadass);
		add(boyfriend);
		if (curStage == 'tankman1')
		{
			add(halloweenBG7);
			add(halloweenBG6);
			add(halloweenBG5);
			add(halloweenBG4);
			add(halloweenBG3);
		}
		if (dad.curCharacter == 'trickyH')
		{
			gf.setGraphicSize(Std.int(gf.width * 0.8));
			boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.8));
			gf.x += 220;
		}
		if (curStage == 'nevada')
		{
			add(MAINLIGHT);
		}
		if (curStage == 'miku')
			add(upperBoppers);
		if (curStage == 'chara')
			add(stageFront);
		if (curStage == 'xgaster')
			add(stageFront);
		if (curStage == 'garl')
			add(halloweenBG);
		
		switch (curStage)
		{
			case 'curse':
				var sumtable:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/sumtable'));
				sumtable.antialiasing = ClientPrefs.globalAntialiasing;
				sumtable.scrollFactor.set(0.9, 0.9);
				sumtable.active = false;
				add(sumtable);
			case 'genocide':
				var sumsticks:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/mad/overlayingsticks'));

				sumsticks.antialiasing = ClientPrefs.globalAntialiasing;
				sumsticks.scrollFactor.set(0.9, 0.9);
				sumsticks.active = false;
				add(sumsticks);
		}
		doof = new DialogueBox(false, dialogue);
		

		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = introOrCountdown;

		doof2 = new DialogueBox(false, extra1);
		doof2.scrollFactor.set();
		doof2.finishThing = rosestart;

		doof3 = new DialogueBox(false, extra2);
		doof3.scrollFactor.set();
		doof3.finishThing = demiseendtwotwo;

		doof4 = new DialogueBox(false, extra3);
		doof4.scrollFactor.set();
		doof4.finishThing = endSong;

		if (curStage == 'church-final')
			FlxTween.tween(dad, {alpha: 1, y: dad.y - 70}, 3.5, {type: FlxTween.PINGPONG, startDelay: 0.0});
		Conductor.songPosition = -5000;
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (ClientPrefs.downScroll)
			strumLine = new FlxSprite(10, 600).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		if (ClientPrefs.noteSplashes)
		{
		add(grpNoteSplashes);
		}
		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();
		// startCountdown();
		generateSong(SONG.song);
		// add(strumLine);
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		FlxG.fixedTimestep = false;
		if (ClientPrefs.downScroll)
		{
			healthBarBG = new FlxSprite(0, FlxG.height * 0.1).loadGraphic(Paths.image('healthBar'));
		}
		else
		{
			healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		}
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (SONG.song.toLowerCase() != 'genocide')
		{
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		}
		else
		{
			healthBar.createFilledBar(0xFF333333, 0xFF66FF33);
		}
		// healthBar
		add(healthBar);
		if (!curStage.startsWith('mall'))
		{
			scoreTxt = new FlxText(healthBarBG.x - 10, healthBarBG.y + 50, 0, "", 20);
			scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			scoreTxt.scrollFactor.set();
		}
		else
		{
			scoreTxt = new FlxText(healthBarBG.x - 10, healthBarBG.y + 50, 0, "", 20);
			scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
			scoreTxt.scrollFactor.set();
		}
		if (!curStage.startsWith('mall'))
		{
			songtxt = new FlxText(healthBarBG.x - 10, healthBarBG.y - 500, 0, "", 20);
			songtxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songtxt.scrollFactor.set();
		}
		else
		{
			songtxt = new FlxText(healthBarBG.x - 10, healthBarBG.y - 500, 0, "", 20);
			songtxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.BLACK, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
			songtxt.scrollFactor.set();
		}
		
		add(scoreTxt);
		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);
		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		if (ClientPrefs.noteSplashes)
			{
		grpNoteSplashes.cameras = [camHUD];
			}
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		songtxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		doof2.cameras = [camHUD];
		doof3.cameras = [camHUD];
		doof4.cameras = [camHUD];
		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;
		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland" | "w-hl-b-sides" | "winter-horrorland-duet":
					blackScreen = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);

					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;
						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'my-battle' | 'last-chance' | 'genocide':
					schoolIntro(doof);
				
				case 'roses-duet':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				
				case 'senpai-b-sides':
					schoolIntro(doof);
				case 'roses-b-sides':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns-b-sides':
					schoolIntro(doof);
				case 'thorns-rs':
					schoolIntro(doof);
				case 'senpai-b3':
					schoolIntro();
				case 'thorns-b3':
					schoolIntro();
				case 'echoes' | 'inverted-ascension' | 'artificial-lust':
					dialogueOrCountdown();
				case 'roses-b3':
					schoolIntro();
				case 'high school conflict':
					schoolIntro(doof);
				case 'bara no yume':
					schoolIntro(doof2);
				case 'your demise':
					if (showCutscene)
						{
							GFScary(doof);
						} 
						else 
						{
							DarkStart(doof);
						}
					
					
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}
		switch (curStage)
		{
			case 'hellstage':
				add(bobmadshake);
		}
		super.create();
	}
	function GFScary(?dialogueBox:DialogueBox):Void
		{
			camHUD.visible = false;
			inCutscene = true;
			var GFFakeout:FlxSprite = new FlxSprite();
			GFFakeout.frames = Paths.getSparrowAtlas('GF_Fakeout_Cryemoji');
			GFFakeout.animation.addByPrefix('idle', 'GFFakeout', 24, false);
			GFFakeout.setGraphicSize(Std.int(GFFakeout.width * 1.12));
			GFFakeout.scrollFactor.set();
			GFFakeout.updateHitbox();
			GFFakeout.screenCenter();
	
			// Variables from the default evilSchool stage
			var schoolFakeout:FlxSprite = new FlxSprite(400, 200);
			schoolFakeout.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
			schoolFakeout.animation.addByPrefix('idle', 'background 2', 24);
			schoolFakeout.animation.play('idle');
			schoolFakeout.scrollFactor.set(0.8, 0.9);
			schoolFakeout.scale.set(6, 6);
			add(schoolFakeout);
			FlxG.sound.play(Paths.sound('awhellnaw'));	// THEY ON THAT SPUNCHBOB SHIT
	
			new FlxTimer().start(1.3, function(timer:FlxTimer) {
				add(GFFakeout);
				GFFakeout.animation.play('idle');
				FlxG.sound.play(Paths.sound('GFFakeout'));
			});
			
			new FlxTimer().start(23.3, function(swagTimer:FlxTimer) 
				{
					remove(schoolFakeout);
					remove(GFFakeout);
					FlxG.camera.zoom = defaultCamZoom;
					remove(gf);
					// I know this looks messy, but it works 
					boyfriend.visible = false;
					dad.visible = false;
					healthBar.visible = false;
					healthBarBG.visible = false;
					
					add(whiteflash);
					add(blackScreen);
					new FlxTimer().start(2, function(godlike:FlxTimer)
						{
							if (dialogueBox != null)
								{
									
									healthBar.visible = true;
									healthBarBG.visible = true;
									camHUD.visible = true;
									inCutscene = true;
									add(dialogueBox);
								}
								else
									{
										startCountdown();
									}
						});
				});
		}	
	
		function DarkStart(?dialogueBox:DialogueBox):Void
			{
				add(whiteflash);
				add(blackScreen);
				remove(gf);
				startCountdown();
			}
			
		function roseend(?dialogueBox:DialogueBox):Void
			{
				inCutscene = true;
				startedCountdown = false;
				generatedMusic = false;
				canPause = false;
				vocals.stop();
				FlxG.sound.music.stop();
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				if (dialogueBox != null)
					{
						// I didn't wanna make all these invisible but for some god forsaken reason,
						// the end dialogue started having the same fucking issues as the beginning dialogue.
						strumLineNotes.visible = false;
						scoreTxt.visible = false;
						healthBarBG.visible = false;
						healthBar.visible = false;
						iconP1.visible = false;
						iconP2.visible = false;
					
						camFollow.setPosition(dad.getMidpoint().x + 50, boyfriend.getMidpoint().y - 300);
						add(dialogueBox);
					}
				else
					{
				endSong();
					}
				trace(inCutscene);
			}
		
		function rosestart():Void
			{
				dad.playAnim('cutscenetransition');
				new FlxTimer().start(1.2, function(godlike:FlxTimer)
				{
					dad.playAnim('idle');
					startCountdown();
				});
			}
	
		function demiseend(?dialogueBox:DialogueBox):Void
			{
				camZooming = false;
				inCutscene = true;
				startedCountdown = false;
				generatedMusic = false;
				canPause = false;
				FlxG.sound.music.pause();
				vocals.pause();
				vocals.stop();
				FlxG.sound.music.stop();
				remove(strumLineNotes);
				remove(scoreTxt);
				remove(healthBarBG);
				remove(healthBar);
				remove(iconP1);
				remove(iconP2);
				
				camFollow.setPosition(dad.getMidpoint().x + 100, boyfriend.getMidpoint().y - 250);
				if (dialogueBox != null)
					{
						add(dialogueBox);
					}
				else
					{
						demiseendtwo(doof4);
					}
					trace(inCutscene);
			}
	
	
			function demiseendtwotwo():Void
				{
					var endsceneone:FlxSprite = new FlxSprite();
					endsceneone.frames = Paths.getSparrowAtlas('Funnicutscene/End1');
					endsceneone.animation.addByPrefix('idle', 'Endscene', 24, false);
					endsceneone.setGraphicSize(Std.int(endsceneone.width * 1.12));
					endsceneone.scrollFactor.set();
					endsceneone.updateHitbox();
					endsceneone.screenCenter();
	
					paused = true;
	
					FlxG.sound.playMusic(Paths.music('cutscene_jargon_shmargon'), 0);
					FlxG.sound.music.fadeIn(.5, 0, 0.8);
					FlxG.camera.fade(FlxColor.WHITE, 0, false);
					camHUD.visible = false;
					add(endsceneone);
					endsceneone.animation.play('idle');
					FlxG.camera.fade(FlxColor.WHITE, 1, true, function(){}, true);
	
					new FlxTimer().start(2.2, function(swagTimer:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('dah'));
						});
	
					new FlxTimer().start(3.8, function(swagTimer:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.BLACK, 2, false);
							new FlxTimer().start(2.2, function(swagTimer:FlxTimer)
								{
									remove(endsceneone);
									demiseendtwo(doof4);
								});
						});
	
				}
	
			function demiseendtwo(?dialogueBox:DialogueBox):Void
				{
					var endscenetwo:FlxSprite = new FlxSprite();
					endscenetwo.frames = Paths.getSparrowAtlas('Funnicutscene/monikasenpaistanding');
					endscenetwo.animation.addByPrefix('idle', 'Endscenetwo', 24, false);
					endscenetwo.setGraphicSize(Std.int(endscenetwo.width * 1.12));
					endscenetwo.scrollFactor.set();
					endscenetwo.updateHitbox();
					endscenetwo.screenCenter();
					
							new FlxTimer().start(3, function(swagTimer:FlxTimer)
								{
									add(endscenetwo);
									endscenetwo.animation.play('idle');
									FlxG.camera.fade(FlxColor.BLACK, 3, true, function()
										{
											if (dialogueBox != null)
												{
													camHUD.visible = true;
													camFollow.setPosition(dad.getMidpoint().x + 100, boyfriend.getMidpoint().y - 250);
													add(dialogueBox);
												}
											else
												{
													endSong();
												}
									}, true);
								});
				}

	function introOrCountdown():Void
	{
		if (SONG.song.toLowerCase() == 'inverted-ascension' && dad.curCharacter == 'cj')
		{
			dad.playAnim('intro', true);
			dad.animation.pause();
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				dad.playAnim('intro', true);
				FlxG.sound.play(Paths.sound('woosh', 'CJ'));

				new FlxTimer().start(3, function(tmr:FlxTimer)
				{
					startCountdown();
				});
			});
		}
		else
			startCountdown();
	}

	function dialogueOrCountdown():Void
	{
		if (dialogue == null)
			startCountdown();
		else
			schoolIntro();
	}

	function doStopSign(sign:Int = 0, fuck:Bool = false)
	{
		trace('sign ' + sign);
		var daSign:FlxSprite = new FlxSprite(0, 0);
		// CachedFrames.cachedInstance.get('sign')

		daSign.frames = CachedFrames.cachedInstance.fromSparrow('sign', 'fourth/mech/Sign_Post_Mechanic');

		daSign.setGraphicSize(Std.int(daSign.width * 0.67));

		daSign.cameras = [camHUD];

		switch (sign)
		{
			case 0:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 1', 24, false);
				daSign.x = FlxG.width - 650;
				daSign.angle = -90;
				daSign.y = -300;
			case 1:
			/*daSign.animation.addByPrefix('sign','Signature Stop Sign 2',20, false);
				daSign.x = FlxG.width - 670;
				daSign.angle = -90; */ // this one just doesn't work???
			case 2:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 3', 24, false);
				daSign.x = FlxG.width - 780;
				daSign.angle = -90;
				if (ClientPrefs.downScroll)
					daSign.y = -395;
				else
					daSign.y = -980;
			case 3:
				daSign.animation.addByPrefix('sign', 'Signature Stop Sign 4', 24, false);
				daSign.x = FlxG.width - 1070;
				daSign.angle = -90;
				daSign.y = -145;
		}
		add(daSign);
		daSign.flipX = fuck;
		daSign.animation.play('sign');
		daSign.animation.finishCallback = function(pog:String)
		{
			trace('ended sign');
			remove(daSign);
		}

		samShit = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		samShit.alpha = 0.05;
		samShit.color = FlxColor.BLACK;
		add(samShit);
		samShit.visible = false;
	}

	var totalDamageTaken:Float = 0;
	var shouldBeDead:Bool = false;
	var interupt = false;

	// basic explanation of this is:
	// get the health to go to
	// tween the gremlin to the icon
	// play the grab animation and do some funny maths,
	// to figure out where to tween to.
	// lerp the health with the tween progress
	// if you loose any health, cancel the tween.
	// and fall off.
	// Once it finishes, fall off.

	function doGremlin(hpToTake:Int, duration:Int, persist:Bool = false)
	{
		interupt = false;

		grabbed = true;

		totalDamageTaken = 0;

		var gramlan:FlxSprite = new FlxSprite(0, 0);

		gramlan.frames = CachedFrames.cachedInstance.fromSparrow('grem', 'fourth/mech/HP GREMLIN');

		gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));

		gramlan.cameras = [camHUD];

		gramlan.x = iconP1.x;
		gramlan.y = healthBarBG.y - 325;

		gramlan.animation.addByIndices('come', 'HP Gremlin ANIMATION', [0, 1], "", 24, false);
		gramlan.animation.addByIndices('grab', 'HP Gremlin ANIMATION', [
			2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24
		], "", 24, false);
		gramlan.animation.addByIndices('hold', 'HP Gremlin ANIMATION', [25, 26, 27, 28], "", 24);
		gramlan.animation.addByIndices('release', 'HP Gremlin ANIMATION', [29, 30, 31, 32, 33], "", 24, false);

		gramlan.antialiasing = ClientPrefs.globalAntialiasing;

		add(gramlan);

		if (ClientPrefs.downScroll)
		{
			gramlan.flipY = true;
			gramlan.y -= 150;
		}

		// over use of flxtween :)

		var startHealth = health;
		var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health

		var perct = toHealth / 2 * 100;

		trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');

		var onc:Bool = false;

		FlxG.sound.play(Paths.sound('fourth/GremlinWoosh', 'clown'));

		gramlan.animation.play('come');
		new FlxTimer().start(0.14, function(tmr:FlxTimer)
		{
			gramlan.animation.play('grab');
			FlxTween.tween(gramlan, {x: iconP1.x - 140}, 1, {
				ease: FlxEase.elasticIn,
				onComplete: function(tween:FlxTween)
				{
					trace('I got em');
					gramlan.animation.play('hold');
					FlxTween.tween(gramlan, {
						x: (healthBar.x + (healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01) - 26)) - 75
					}, duration, {
						onUpdate: function(tween:FlxTween)
						{
							// lerp the health so it looks pog
							if (interupt && !onc && !persist)
							{
								onc = true;
								trace('oh shit');
								gramlan.animation.play('release');
								gramlan.animation.finishCallback = function(pog:String)
								{
									gramlan.alpha = 0;
								}
							}
							else if (!interupt || persist)
							{
								var pp = FlxMath.lerp(startHealth, toHealth, tween.percent);
								if (pp <= 0)
									pp = 0.1;
								health = pp;
							}

							if (shouldBeDead)
								health = 0;
						},
						onComplete: function(tween:FlxTween)
						{
							if (interupt && !persist)
							{
								remove(gramlan);
								grabbed = false;
							}
							else
							{
								trace('oh shit');
								gramlan.animation.play('release');
								if (persist && totalDamageTaken >= 0.7)
									health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
								gramlan.animation.finishCallback = function(pog:String)
								{
									remove(gramlan);
								}
								grabbed = false;
							}
						}
					});
				}
			});
		});
	}

	var cloneOne:FlxSprite;
	var cloneTwo:FlxSprite;

	function doClone(side:Int)
	{
		switch (side)
		{
			case 0:
				if (cloneOne.alpha == 1)
					return;
				cloneOne.x = dad.x - 20;
				cloneOne.y = dad.y + 140;
				cloneOne.alpha = 1;

				cloneOne.animation.play('clone');
				cloneOne.animation.finishCallback = function(pog:String)
				{
					cloneOne.alpha = 0;
				}
			case 1:
				if (cloneTwo.alpha == 1)
					return;
				cloneTwo.x = dad.x + 390;
				cloneTwo.y = dad.y + 140;
				cloneTwo.alpha = 1;

				cloneTwo.animation.play('clone');
				cloneTwo.animation.finishCallback = function(pog:String)
				{
					cloneTwo.alpha = 0;
				}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		if (SONG.song.toLowerCase() == 'thorns-b-sides')
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF44D5ED);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		if (SONG.song.toLowerCase() == 'thorns-b-sides')
			senpaiEvil.frames = Paths.getSparrowAtlas('bside/weeb/senpaiCrazy');

		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses'
			|| SONG.song.toLowerCase() == 'roses-duet'
			|| SONG.song.toLowerCase() == 'roses-b-sides'
			|| SONG.song.toLowerCase() == 'thorns'
			|| SONG.song.toLowerCase() == 'thorns-duet'
			|| SONG.song.toLowerCase() == 'thorns-b-sides'
			|| SONG.song.toLowerCase() == 'thorns-rs'
			|| SONG.song.toLowerCase() == 'roses-rs'
			|| SONG.song.toLowerCase() == 'thorns-b3'
			|| SONG.song.toLowerCase() == 'roses-b3')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns'
				|| SONG.song.toLowerCase() == 'thorns-b-sides'
				|| SONG.song.toLowerCase() == 'thorns-duet'
				|| SONG.song.toLowerCase() == 'thorns-rs'
				|| SONG.song.toLowerCase() == 'thorns-b3')
			{
				add(red);
			}
		}
		if (SONG.song.toLowerCase() == 'bara no yume')
			{
				dad.playAnim('cutsceneidle');
				remove(black);
			}	

		if (SONG.song.toLowerCase() == 'bara no yume' || SONG.song.toLowerCase() == 'high school conflict' || SONG.song.toLowerCase() == 'your demise')
		{
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
		
					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
							{
								inCutscene = true;
								add(dialogueBox);
		
							}
							else
								{
									trace(dialogueBox);
									startCountdown();
									remove(black);
								}
					}
				});
			
		}
		
		else
		{
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					black.alpha -= 0.15;
		
					if (black.alpha > 0)
					{
						tmr.reset(0.3);
					}
					else
					{
						if (dialogueBox != null)
						{
							inCutscene = true;
		
							if (SONG.song.toLowerCase() == 'thorns'
								|| SONG.song.toLowerCase() == 'thorns-b-sides'
								|| SONG.song.toLowerCase() == 'thorns-b3')
							{
								add(senpaiEvil);
								senpaiEvil.alpha = 0;
								new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
								{
									senpaiEvil.alpha += 0.15;
									if (senpaiEvil.alpha < 1)
									{
										swagTimer.reset();
									}
									else
									{
										senpaiEvil.animation.play('idle');
										FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
										{
											remove(senpaiEvil);
											remove(red);
											FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
											{
												add(dialogueBox);
											}, true);
										});
										new FlxTimer().start(3.2, function(deadTime:FlxTimer)
										{
											FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
										});
									}
								});
							}
							else
							{
								add(dialogueBox);
							}
						}
						else
							startCountdown();
		
						remove(black);
					}
				});
		}
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	var noticeB:Array<FlxText> = [];
	var nShadowB:Array<FlxText> = [];

	function startCountdown():Void
	{
		inCutscene = false;
		showCutscene = false;
		hudArrows = [];
		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		if (SONG.song.toLowerCase() == "kaio-ken")
		{
			new FlxTimer().start(0.002, function(cbt:FlxTimer)
			{
				if (ctrTime == 0)
				{
					var cText = "A      S      D";


					notice = new FlxText(0, 0, 0, cText, 32);
					notice.x = FlxG.width * 0.572;
					notice.y = 120;
					if (ClientPrefs.downScroll)
					{
						notice.y = FlxG.height - 200;
					}
					notice.scrollFactor.set();

					nShadow = new FlxText(0, 0, 0, cText, 32);
					nShadow.x = notice.x + 4;
					nShadow.y = notice.y + 4;
					nShadow.scrollFactor.set();

					nShadow.alpha = notice.alpha;
					nShadow.color = 0x00000000;

					notice.alpha = 0;

					add(nShadow);
					add(notice);
				}
				else
				{
					if (ctrTime < 300)
					{
						if (notice.alpha < 1)
						{
							notice.alpha += 0.02;
						}
					}
					else
					{
						notice.alpha -= 0.02;
					}
				}
				nShadow.alpha = notice.alpha;

				ctrTime++;
				cbt.reset(0.004 / (FlxG.elapsed / (1 / 60)));
			});
		}
		if (SONG.song.toLowerCase() == "god-eater")
		{
			new FlxTimer().start(0.002, function(cbt:FlxTimer)
			{
				if (ctrTime == 0)
				{
					var cText:Array<String> = ['A', 'S', 'D', 'F', 'S\nP\nA\nC\nE', 'H', 'J', 'K', 'L'];

					var nJx = 100;
					for (i in 0...9)
					{
						noticeB[i] = new FlxText(0, 0, 0, cText[i], 32);
						noticeB[i].x = FlxG.width * 0.5 + nJx * i + 55;
						noticeB[i].y = 20;
						if (ClientPrefs.downScroll)
						{
							noticeB[i].y = FlxG.height - 120;
							switch (i)
							{
								case 4:
									noticeB[i].y -= 160;
								case 8:
									if (FlxG.save.data.dfjk == 2)
										noticeB[i].y -= 190;
							}
						}
						noticeB[i].scrollFactor.set();
						// notice[i].alpha = 0;

						nShadowB[i] = new FlxText(0, 0, 0, cText[i], 32);
						nShadowB[i].x = noticeB[i].x + 4;
						nShadowB[i].y = noticeB[i].y + 4;
						nShadowB[i].scrollFactor.set();

						nShadowB[i].alpha = noticeB[i].alpha;
						nShadowB[i].color = 0x00000000;

						// notice.alpha = 0;

						add(nShadowB[i]);
						add(noticeB[i]);
					}
				}
				else
				{
					for (i in 0...9)
					{
						if (ctrTime < 600)
						{
							if (noticeB[i].alpha < 1)
							{
								noticeB[i].alpha += 0.02;
							}
						}
						else
						{
							noticeB[i].alpha -= 0.02;
						}
					}
				}
				for (i in 0...9)
				{
					nShadowB[i].alpha = noticeB[i].alpha;
				}
				ctrTime++;
				cbt.reset(0.004);
			});
		}

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('school-neon', ['neon/pixelUI/ready-pixel', 'neon/pixelUI/set-pixel', 'neon/pixelUI/date-pixel']);
			introAssets.set('school-neon-2', ['neon/pixelUI/ready-pixel', 'neon/pixelUI/set-pixel', 'neon/pixelUI/date-pixel']);
			introAssets.set('schoolEvil', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('school-b', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('schoolEvil-b', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('school-b3', ['weeb/pixelUI/ready-pixel', 'weeb/pixelUI/set-pixel', 'weeb/pixelUI/date-pixel']);
			introAssets.set('school-salty', [
				'salty/weeb/pixelUI/ready-pixel',
				'salty/weeb/pixelUI/set-pixel',
				'salty/weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil-b3', [
				'b3/weeb/pixelUI/ready-pixel',
				'b3/weeb/pixelUI/set-pixel',
				'b3/weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil-salty', [
				'salty/weeb/pixelUI/ready-pixel',
				'salty/weeb/pixelUI/set-pixel',
				'salty/weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}
			if (SONG.song.toLowerCase() == 'your demise')
				altSuffix = '-glitch';

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					songMiss = 0;
					squaredown = 0;
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
		if (SONG.song.toLowerCase() == 'expurgation') // start the grem time
		{
			new FlxTimer().start(25, function(tmr:FlxTimer)
			{
				if (curStep < 2400)
				{
					if (canPause && !paused && health >= 1.5 && !grabbed)
						doGremlin(40, 3);
					trace('checka ' + health);
					tmr.reset(25);
				}
			});
		}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	var grabbed = false;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = songOutro;
		vocals.play();

		#if desktop
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var mn:Int = keyAmmo[mania];
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var playerNotes:Array<Int> = [0, 1, 2, 3, 8, 9, 10, 11];

			for (songNotes in section.sectionNotes)
			{
				var daNoteData:Int = 0;
				var daStrumTime:Float = songNotes[0];
				var gottaHitNote:Bool = false;
				if (mania == 0 || mania == 1 || mania == 2)
				{
					daNoteData = Std.int(songNotes[1] % mn);

					gottaHitNote = section.mustHitSection;

					if (songNotes[1] >= mn)
					{
						gottaHitNote = !section.mustHitSection;
					}
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	var hudArrows:Array<FlxSprite>;
	var hudArrXPos:Array<Float>;
	var hudArrYPos:Array<Float>;

	private function generateStaticArrows(player:Int):Void
	{
		if (player == 1)
		{
			hudArrXPos = [];
			hudArrYPos = [];
		}
		for (i in 0...keyAmmo[mania])
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			hudArrows.push(babyArrow);

			

			switch (curStage)
			{
				case 'school-neon' | 'school-neon-2':
					babyArrow.loadGraphic(Paths.image('neon/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				case 'school' | 'schoolEvil' | 'school-b' | 'schoolEvil-b':
					babyArrow.loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				case 'school-b3' | 'schoolEvil-b3':
					babyArrow.loadGraphic(Paths.image('b3/weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;
					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				case 'school-salty' | 'schoolEvil-salty':
					babyArrow.loadGraphic(Paths.image('b3/weeb/pixelUI/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);

					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
					}
				default:
					if (NoteSkinState.neo == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-neo');
					if (NoteSkinState.xe == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-xe');
					if (NoteSkinState.normal == 1)
						babyArrow.frames = Paths.getSparrowAtlas('shaggy/NOTE_assets-shaggy');
					if (NoteSkinState.star == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-star');
					if (NoteSkinState.sarv == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets2');
					if (NoteSkinState.beats == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-beats');
					if (NoteSkinState.tabi == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-tabi');
					if (NoteSkinState.starlight == 1)
						babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets-starlight');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					babyArrow.antialiasing = ClientPrefs.globalAntialiasing;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

					var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					var pPre:Array<String> = ['left', 'down', 'up', 'right'];
					switch (mania)
					{
						case 1:
							nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
							pPre = ['left', 'up', 'right', 'yel', 'down', 'dark'];
						case 2:
							nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
							pPre = ['left', 'down', 'up', 'right', 'white', 'yel', 'violet', 'black', 'dark'];
							babyArrow.x -= Note.tooMuch;
					}
					babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
					babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
					babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode || curSong.toLowerCase() == 'kaio-ken')
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;
			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			if (player == 1)
			{
				hudArrXPos.push(babyArrow.x);
				hudArrYPos.push(babyArrow.y);
				playerStrums.add(babyArrow);
			}
			if (player == 0)
			{
				cpuStrums.add(babyArrow);
			}

			cpuStrums.forEach(function(spr:FlxSprite)
			{
				spr.centerOffsets(); // CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if desktop
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		if (curStage == 'tankman1')
			moveTank();
			if (curSong == 'Stress' || curSong == 'Stress-Duet')
			{
				var i = 0;
    for (spr in johns.members) {
        if (spr.x >= 1.2 * FlxG.width || spr.x <= -0.5 * FlxG.width)
            spr.visible = false;
        else
            spr.visible = true;
        if (spr.animation.curAnim.name == "run") {
            var fuck = 0.74 * FlxG.width + endingOffsetJohn[i];
            if (goingRightJohn[i]) {
                fuck = 0.02 * FlxG.width - endingOffsetJohn[i];
                spr.x = fuck + (Conductor.songPosition - strumTimeJohn[i]) * tankSpeedJohn[i];
                spr.flipX = true;
            } else {
                spr.x = fuck - (Conductor.songPosition - strumTimeJohn[i]) * tankSpeedJohn[i];
                spr.flipX = false;
            }
        }
        if (Conductor.songPosition > strumTimeJohn[i]) {
            spr.animation.play("shot");
            if (goingRightJohn[i]) {
                spr.offset.y = 200;
                spr.offset.x = 300;
            }
        }
        if (spr.animation.curAnim.name == "shot" && spr.animation.curAnim.curFrame >= spr.animation.curAnim.frames.length - 1) {
            spr.kill();
        }
        i++;
    }
			}
		

		
		floatshit += 0.1;
		#if !debug
		perfectMode = false;
		#end

		if (isGenocide && storyDifficulty > 0 && minusHealth)
		{
			if (health > 0)
			{
				health -= 0.001;
			}
		}

		if (isGenocide)
		{
			setBrightness(((health / 2) - 1 < 0) ? 0 : (((health / 2) - 1) * 2) / 32);
			setContrast(((health / 2) - 1 < 0) ? 1 : 1 + ((health / 2) - 1) / 8);
		}
		else
		{
			setBrightness(0.0);
			setContrast(1.0);
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;

			case 'philly-neo':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'annie':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'anders_1':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'philly-star':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'philly-beat':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}

			case 'philly-b3':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}

			case 'philly-salty':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}
		super.update(elapsed);
		playerStrums.forEach(function(spr:FlxSprite)
		{
			spr.x = hudArrXPos[spr.ID]; // spr.offset.set(spr.frameWidth / 2, spr.frameHeight / 2);
			if (spr.animation.curAnim.name == 'confirm')
			{
				var jj:Array<Float> = [0, 3, 9];
				spr.x = hudArrXPos[spr.ID] + jj[mania];
			}
		});

		if (songMiss != 0)
		{
			if (combo != 0)
			{
				scoreTxt.text = "Missed:" + songMiss + "  |  " + "Score:" + songScore + " (" + songtrueScore + ")" + "  |  " + "Combo: " + (combo - 1)
					+ "  |  Kade Input: " + babymodep;

				if (PauseSubState.sickmode == "Yes")
				{
					scoreTxt.text = "Missed:" + "NO MISS" + "  |  " + "Score:" + songScore + " (" + "NO MISS" + ")" + "  |  " + "Combo: " + (combo - 1)
						+ "  |  Kade Input: ";
				}
				else
					scoreTxt.text = "Missed:" + songMiss + "  |  " + "Score:" + songScore + " (" + songtrueScore + ")" + "  |  " + "Combo: " + (combo - 1)
						+ "  |  Kade Input: " + babymodep;
			}
			else
			{
				if (PauseSubState.sickmode == "Yes")
				{
					scoreTxt.text = "Missed:" + "NO MISS" + "  |  " + "Score:" + songScore + " (" + "NO MISS" + ")" + "  |  " + "Combo: " + "0"
						+ "  |  Kade Input: " + "DISABLED";
				}
				else
					scoreTxt.text = "Missed:" + songMiss + "  |  " + "Score:" + songScore + " (" + songtrueScore + ")" + "  |  " + "Combo: " + "0"
						+ "  |  Kade Input: " + babymodep;
			}
		}
		if (songMiss == 0)
		{
			if (combo != 0)
			{
				if (PauseSubState.sickmode == "Yes")
				{
					scoreTxt.text = "Missed:" + "NO MISS" + "  |  " + "Score:" + songScore + " (" + "NO MISS" + ")" + "  |  " + "Combo: " + (combo - 1)
						+ "  |  Kade Input: " + "DISABLED" + "  |  Perfect Run";
				}
				else
					scoreTxt.text = "Missed:" + songMiss + "  |  " + "Score:" + songScore + " (" + songtrueScore + ")" + "  |  " + "Combo: " + (combo - 1)
						+ "  |  Kade Input: " + babymodep + "  |  Perfect Run";
			}
			else
			{
				if (PauseSubState.sickmode == "Yes")
				{
					scoreTxt.text = "Missed:" + "NO MISS" + "  |  " + "Score:" + songScore + " (" + "NO MISS" + ")" + "  |  " + "Combo: " + "0"
						+ "  |  Kade Input: " + "DISABLED" + "  |  Perfect Run";
				}
				else
					scoreTxt.text = "Missed:" + songMiss + "  |  " + "Score:" + songScore + " (" + songtrueScore + ")" + "  |  " + "Combo: " + "0"
						+ "  |  Kade Input: " + babymodep + "  |  Perfect Run";
			}
		}
		songtxt.text = "Time remaining: " + songTime;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		if (dad.curCharacter == "shcarol")
		{
			dad.y += Math.sin(floatshit);
		}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (!(crazyMode))
		{
			if (health > 2)
				health = 2;
		}
		else
		{
			var p2ToUse:Float = healthBar.x
				+ (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01))
				- (iconP2.width - iconOffset);
			if (iconP2.x - iconP2.width / 2 < healthBar.x && iconP2.x > p2ToUse)
			{
				healthBarBG.offset.x = iconP2.x - p2ToUse;
				healthBar.offset.x = iconP2.x - p2ToUse;
			}
			else
			{
				healthBarBG.offset.x = 0;
				healthBar.offset.x = 0;
			}
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = p2ToUse;
			if (health > 3)
				health = 3;
		}

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (curBeat % 4 == 0)
			{
				// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
			}

			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
				if (SONG.player2 != "tordbot")
					camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'festival':
						camFollow.x = FlxMath.lerp(camFollow.x, dad.getMidpoint().x + 395.97, 0.5);
						camFollow.y = FlxMath.lerp(camFollow.y, dad.getMidpoint().y + 20.69, 0.5);
				}

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'trickyMask':
						camFollow.y = dad.getMidpoint().y + 25;
					case 'trickyH':
						camFollow.y = dad.getMidpoint().y + 375;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-b3':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-salty':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-2':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'carol':
						camFollow.y = dad.getMidpoint().y + 100;
						camFollow.x = dad.getMidpoint().x + 270;
					case 'bowserhead':
						camFollow.y = dad.getMidpoint().y + 20;
						camFollow.x = dad.getMidpoint().x + 100;
					case 'xchara':
						camFollow.y = dad.getMidpoint().y - 20;
					case 'belle':
						camFollow.y = dad.getMidpoint().y + 100;
					case 'gaymen':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-b3-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
						case 'monika':
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						case 'duet-m':
							camFollow.y = dad.getMidpoint().y - 400;
							camFollow.x = dad.getMidpoint().x + 0;
						case 'monika-angry':
							camFollow.y = dad.getMidpoint().y - 390;
							camFollow.x = dad.getMidpoint().x - 350;
					case 'ruby':
						camFollow.x = FlxMath.lerp(camFollow.x, dad.getMidpoint().x + 415.97, 0.5);
					case 'senpai-b':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry-b':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'tankman':
						camFollow.x = dad.getMidpoint().x + 170;
					case 'tordbot':
						camFollow.y = dad.getMidpoint().y - 850;
						camFollow.x = dad.getMidpoint().x;
					case 'tabi':
						camFollow.y = dad.getMidpoint().y;
						camFollow.x = dad.getMidpoint().x + 530;
						FlxTween.tween(FlxG.camera, {zoom: 0.6}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
					case 'tabi-crazy':
						camFollow.y = dad.getMidpoint().y - 100;
						camFollow.x = dad.getMidpoint().x + 260;
						FlxTween.tween(FlxG.camera, {zoom: 0.8}, (Conductor.stepCrochet * 4 / 2000), {ease: FlxEase.elasticInOut});
					case 'vagrant':
						camFollow.y = dad.getMidpoint().y - 40;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
				if (SONG.song.toLowerCase() == 'tutorial-starcatcher')
				{
					tweenCamIn();
				}
				if (SONG.song.toLowerCase() == 'tutorial-b3')
				{
					tweenCamIn();
				}
				if (SONG.player2 == "tordbot")
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				if (boyfriend.curCharacter.startsWith("bf-tabi"))
				{
					camFollow.setPosition(boyfriend.getMidpoint().x - 530, dad.getMidpoint().y);
					if (boyfriend.curCharacter.contains("-crazy"))
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, (Conductor.stepCrochet * 4 / 2000), {ease: FlxEase.elasticInOut});
					}
					else
					{
						FlxTween.tween(FlxG.camera, {zoom: 0.55}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
					}
				}

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'limo-star':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'touhou':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'limo-neo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'limo-b3':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'limo-salty':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'limo-b':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'festival':
						camFollow.x = FlxMath.lerp(camFollow.x, boyfriend.getMidpoint().x - 202.33, 0.5);
						camFollow.y = FlxMath.lerp(camFollow.y, boyfriend.getMidpoint().y - 196.69, 0.5);
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'mall-b3':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'mall-salty':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'mall-b':
						camFollow.y = boyfriend.getMidpoint().y - 200;
						case 'school':
							switch (curSong.toLowerCase())
							{
								case "your reality":
									camFollow.x = boyfriend.getMidpoint().x - 500;
									camFollow.y = boyfriend.getMidpoint().y - 600;
								case "bara no yume":
									camFollow.x = boyfriend.getMidpoint().x - 300;
									camFollow.y = boyfriend.getMidpoint().y - 200;
								default:
									camFollow.x = boyfriend.getMidpoint().x - 200;
									camFollow.y = boyfriend.getMidpoint().y - 200;
							}
					case 'school-neon':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 240;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil-b3':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil-salty':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-salty':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-b3':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-neon-2':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 240;
					case 'school-b':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil-b':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'inksans':
						camFollow.y = boyfriend.getMidpoint().y - 190;
					case 'dreamNightmare':
						camFollow.y = boyfriend.getMidpoint().y - 300;
				}

				if (SONG.song.toLowerCase() == 'tutorial-starcatcher')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
				if (SONG.song.toLowerCase() == 'tutorial-b3')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		
		// CHEAT = brandon's a pussy
		if (controls.CHEAT)
		{
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			//DO NOT PASTE THAT CODE HERE IT BROKE THE WHOLE SYSTEM FOR NOT HITTED NOTES//
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
	
					daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
					if (ClientPrefs.downScroll)
						daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
	
					// i am so fucking sorry for this if condition
					if (daNote.isSustainNote
						&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
	
						swagRect.y /= daNote.scale.y;
						swagRect.height -= swagRect.y;
	
						daNote.clipRect = swagRect;
					}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;
						if (SONG.song != 'Tutorial-Starcatcher')
							camZooming = true;
						if (SONG.song != 'Tutorial-B3')
							camZooming = true;
	
						var altAnim:String = "";
	
						if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}
						if (daNote.noteType == 1)
							altAnim = '-alt';
	
						if (curSong == 'Zavodila')
							switch (Math.abs(daNote.noteData))
							{
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
									gf.playAnim('scared', true);
	
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
									gf.playAnim('scared', true);
								case 2:
									dad.playAnim('singUP' + altAnim, true);
									gf.playAnim('scared', true);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
									gf.playAnim('scared', true);
							}
						if (curSong == 'Gospel')
							switch (Math.abs(daNote.noteData))
							{
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
									curl2.angle += 2;
	
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
									curl2.angle += 2;
								case 2:
									dad.playAnim('singUP' + altAnim, true);
									curl2.angle += 2;
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
									curl2.angle += 2;
							}
						else if (mania == 0)
						{
							if (tankmanreal == 0){
							switch (Math.abs(daNote.noteData))
							{
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
								case 2:
									if (dad.curCharacter == 'tankman')
										if (curStep == 60)
											dad.playAnim('ugh', true);
										else if (curStep == 444)
											dad.playAnim('ugh', true);
										else if (curStep == 524)
											dad.playAnim('ugh', true);
										else if (curStep == 828)
											dad.playAnim('ugh', true);
										else
											dad.playAnim('singUP' + altAnim, true);
									else
										dad.playAnim('singUP' + altAnim, true);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
							}
							}
							else 
							{
								trace('ascending');
							}
						}
						else if (mania == 1)
						{
							switch (Math.abs(daNote.noteData))
							{
								case 1:
									dad.playAnim('singUP' + altAnim, true);
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
								case 2:
									dad.playAnim('singRIGHT' + altAnim, true);
								case 3:
									dad.playAnim('singLEFT' + altAnim, true);
								case 4:
									dad.playAnim('singDOWN' + altAnim, true);
								case 5:
									dad.playAnim('singRIGHT' + altAnim, true);
							}
						}
						else
						{
							switch (Math.abs(daNote.noteData))
							{
								case 0:
									dad.playAnim('singLEFT' + altAnim, true);
								case 1:
									dad.playAnim('singDOWN' + altAnim, true);
								case 2:
									dad.playAnim('singUP' + altAnim, true);
								case 3:
									dad.playAnim('singRIGHT' + altAnim, true);
								case 4:
									dad.playAnim('singUP' + altAnim, true);
								case 5:
									dad.playAnim('singLEFT' + altAnim, true);
								case 6:
									dad.playAnim('singDOWN' + altAnim, true);
								case 7:
									dad.playAnim('singUP' + altAnim, true);
								case 8:
									dad.playAnim('singRIGHT' + altAnim, true);
							}
						}
						cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (tankmanreal == 1){spr.alpha = 0;}
								else {spr.alpha = 1;}
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								}
								else
									spr.centerOffsets();
							});
						dad.holdTimer = 0;
	
						if (crazyMode)
						{
							if (health > 0 && justDoItMakeYourDreamsComeTrue)
							{
								if (daNote.isSustainNote)
								{
									health -= 0.0005;
								}
								else
								{
									// health -= 0.04;
									health -= 0.03;
								}
							}
						}
	
						chromaticDance(true);
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					} // WIP interpolation shit? Need to fix the pause issue
	
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if (!ClientPrefs.downScroll && daNote.y < -daNote.height || ClientPrefs.downScroll && daNote.y >= (strumLine.y + 106))
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
							health += 0.002;
						}
						if (daNote.mustPress && !daNote.wasGoodHit)
						{
							if (daNote.noteType == 2)
								{
									vocals.volume = 1;
								}
							else
								{
									health -= 0.0475;
							vocals.volume = 0;
							combo = 0;
							songMiss += 1;
							songScore -= 10;
							if (sickmode == "Yes")
							{
								FlxG.resetState();
							}
								}
							
						}
	
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}

		
		
		cpuStrums.forEach(function(spr:FlxSprite)
		{
			if (tankmanreal == 1){spr.alpha = 0;}
			else {spr.alpha = 1;}
			if (spr.animation.finished)
			{
				
				spr.animation.play('static');
				spr.centerOffsets();
			}
		});
		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
		if (FlxG.keys.justPressed.TWO)
			endSong();
	}

	function songOutro():Void
		{
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			canPause = false;

			if (isStoryMode)
			{
				switch (curSong.toLowerCase())
				{
					case 'high school conflict':
						roseend(doof4);
					case 'bara no yume':
						roseend(doof4);
					case 'your demise':
						demiseend(doof3);
					default:
						endSong();
				}
			}
			else
				{
					switch (curSong.toLowerCase())
					{
						default:
							endSong();
					}
				}
				
		}

	function endSong():Void
	{
		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;
			new FlxTimer().start(0.003, function(fadear:FlxTimer)
			{
				var decAl:Float = 0.01;
				for (i in 0...hudArrows.length)
				{
					hudArrows[i].alpha -= decAl;
				}
				healthBarBG.alpha -= decAl;
				healthBar.alpha -= decAl;
				iconP1.alpha -= decAl;
				iconP2.alpha -= decAl;
				scoreTxt.alpha -= decAl;
				fadear.reset(0.003);
			});

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				if (BackgroundMusicState.normal == 1)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
				if (BackgroundMusicState.neo == 1)
					FlxG.sound.playMusic(Paths.music('freakyMenu-n'));
				if (BackgroundMusicState.hex == 1)
					FlxG.sound.playMusic(Paths.music('freakyMenu-h'));
				if (BackgroundMusicState.bsides == 1)
					FlxG.sound.playMusic(Paths.music('freakyMenu-b'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				if (SONG.song.toLowerCase() == 'eggnog')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				if (SONG.song.toLowerCase() == 'eggnog-b-sides')
				{
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Paths.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();
				if (ClientPrefs.week7Cut)	
				{
					if (SONG.song == 'Guns')
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/gunsCutscene.webm", new PlayState()));
					else if (SONG.song == 'Stress')
						LoadingState.loadAndSwitchState(new VideoState("assets/videos/stressCutscene.webm", new PlayState()));
					else
						showCutscene = true;
						LoadingState.loadAndSwitchState(new PlayState());
				}
				else
					showCutscene = true;
					LoadingState.loadAndSwitchState(new PlayState());
			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";
		
		var healthDrain:Float = 0;
		if (daNote.noteType == 2)
			{
				health -= 100;
			}
		if (SONG.song.toLowerCase() == 'hellclown')
			healthDrain = 0.04;

		if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
		{
			daRating = 'shit';
			
			score = 50;
			interupt = true;
			if (sickmode == "Yes")
			{
				FlxG.resetState();
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
		{
			daRating = 'bad';
			score = 100;
		
			interupt = true;
			if (sickmode == "Yes")
			{
				FlxG.resetState();
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.35 || noteDiff < Conductor.safeZoneOffset * -0.35)
		{
			daRating = 'good';
			score = 200;
			health += 0.04;
			if (sickmode == "Yes")
			{
				FlxG.resetState();
			}
		}
		else if (noteDiff < Conductor.safeZoneOffset * 0.34 && noteDiff > Conductor.safeZoneOffset * -0.34)
		{
			score = 350;
			daRating = "sick";
			health += 0.05;
			if (ClientPrefs.noteSplashes)
				{
			if (mania == 0){
			if (!daNote.isSustainNote)
				{
					var recycledNote = grpNoteSplashes.recycle(NoteSplash);
					recycledNote.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
					grpNoteSplashes.add(recycledNote);
				}
			}
			}
		}

		songScore += score;
		songtrueScore += score;

		/* if (combo > 60)
				daRating = 'sick';
			else if (combo > 12)
				daRating = 'good'
			else if (combo > 4)
				daRating = 'bad';
		 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (curStage.startsWith('school'))
		{
			if (curStage == 'school-neon' || curStage == 'school-neon-2')
			{
				pixelShitPart1 = 'neon/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
			else if (curStage.endsWith('b3'))
				{
					pixelShitPart1 = 'b3/weeb/pixelUI/';
					pixelShitPart2 = '';
				}
			else
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
			
		}
		if (curStage.endsWith('-b'))
		{
			pixelShitPart1 = 'bside/b/';
			pixelShitPart2 = '';
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'bside/weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}

		}

		if (curStage.endsWith('-neo'))
		{
			pixelShitPart1 = 'neo/';
			pixelShitPart2 = '';
		}
		if (curStage.endsWith('touhou'))
		{
			pixelShitPart1 = 'touhou/';
			pixelShitPart2 = '';
		}
		

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school'))
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Float> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10.0));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school'))
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;
	var l1Hold:Bool = false;
	var uHold:Bool = false;
	var r1Hold:Bool = false;
	var l2Hold:Bool = false;
	var dHold:Bool = false;
	var r2Hold:Bool = false;
	var n0Hold:Bool = false;
	var n1Hold:Bool = false;
	var n2Hold:Bool = false;
	var n3Hold:Bool = false;
	var n4Hold:Bool = false;
	var n5Hold:Bool = false;
	var n6Hold:Bool = false;
	var n7Hold:Bool = false;
	var n8Hold:Bool = false;
	var reachBeat:Float;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var l1 = controls.L1;
		var u = controls.U1;
		var r1 = controls.R1;
		var l2 = controls.L2;
		var d = controls.D1;
		var r2 = controls.R2;

		var l1P = controls.L1_P;
		var uP = controls.U1_P;
		var r1P = controls.R1_P;
		var l2P = controls.L2_P;
		var dP = controls.D1_P;
		var r2P = controls.R2_P;

		var l1R = controls.L1_R;
		var uR = controls.U1_R;
		var r1R = controls.R1_R;
		var l2R = controls.L2_R;
		var dR = controls.D1_R;
		var r2R = controls.R2_R;

		var n0 = controls.N0;
		var n1 = controls.N1;
		var n2 = controls.N2;
		var n3 = controls.N3;
		var n4 = controls.N4;
		var n5 = controls.N5;
		var n6 = controls.N6;
		var n7 = controls.N7;
		var n8 = controls.N8;

		var n0P = controls.N0_P;
		var n1P = controls.N1_P;
		var n2P = controls.N2_P;
		var n3P = controls.N3_P;
		var n4P = controls.N4_P;
		var n5P = controls.N5_P;
		var n6P = controls.N6_P;
		var n7P = controls.N7_P;
		var n8P = controls.N8_P;

		var n0R = controls.N0_R;
		var n1R = controls.N1_R;
		var n2R = controls.N2_R;
		var n3R = controls.N3_R;
		var n4R = controls.N4_R;
		var n5R = controls.N5_R;
		var n6R = controls.N6_R;
		var n7R = controls.N7_R;
		var n8R = controls.N8_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		var ankey = (upP || rightP || downP || leftP);
		if (mania == 1)
		{
			ankey = (l1P || uP || r1P || l2P || dP || r2P);
			controlArray = [l1P, uP, r1P, l2P, dP, r2P];
		}
		else if (mania == 2)
		{
			ankey = (n0P || n1P || n2P || n3P || n4P || n5P || n6P || n7P || n8P);
			controlArray = [n0P, n1P, n2P, n3P, n4P, n5P, n6P, n7P, n8P];
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (ankey && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);
				}
				
			});

			if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					if (perfectMode)
						noteCheck(true, daNote);
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{
								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
									if (!inIgnoreList)
										badNoteCheck();
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							noteCheck(controlArray[daNote.noteData], daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								noteCheck(controlArray[coolNote.noteData], coolNote);
							}
						}
					}
					else // regular notes?
					{
						noteCheck(controlArray[daNote.noteData], daNote);
					}
					/* 
						if (controlArray[daNote.noteData])
							goodNoteHit(daNote);
					 */
					// trace(daNote.noteData);
					/* 
							switch (daNote.noteData)
							{
								case 2: // NOTES YOU JUST PRESSED
									if (upP || rightP || downP || leftP)
										noteCheck(upP, daNote);
								case 3:
									if (upP || rightP || downP || leftP)
										noteCheck(rightP, daNote);
								case 1:
									if (upP || rightP || downP || leftP)
										noteCheck(downP, daNote);
								case 0:
									if (upP || rightP || downP || leftP)
										noteCheck(leftP, daNote);
							}
	
						//this is already done in noteCheck / goodNoteHit
						if (daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					 */
				}
			else
			{
				badNoteCheck();
			}
		}

		var condition = ((up || right || down || left) && generatedMusic);
		if (mania == 1)
		{
			condition = ((l1 || u || r1 || l2 || d || r2) && generatedMusic);
		}
		else if (mania == 2)
		{
			condition = ((n0 || n1 || n2 || n3 || n4 || n5 || n6 || n7 || n8)
				&& generatedMusic
				|| (n0Hold || n1Hold || n2Hold || n3Hold || n4Hold || n5Hold || n6Hold || n7Hold || n8Hold)
				&& generatedMusic);
		}
		if (condition)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					if (mania == 0)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
					else if (mania == 1)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 0:
								if (l1 || l1Hold)
									goodNoteHit(daNote);
							case 1:
								if (u || uHold)
									goodNoteHit(daNote);
							case 2:
								if (r1 || r1Hold)
									goodNoteHit(daNote);
							case 3:
								if (l2 || l2Hold)
									goodNoteHit(daNote);
							case 4:
								if (d || dHold)
									goodNoteHit(daNote);
							case 5:
								if (r2 || r2Hold)
									goodNoteHit(daNote);
						}
					}
					else
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 0:
								if (n0 || n0Hold)
									goodNoteHit(daNote);
							case 1:
								if (n1 || n1Hold)
									goodNoteHit(daNote);
							case 2:
								if (n2 || n2Hold)
									goodNoteHit(daNote);
							case 3:
								if (n3 || n3Hold)
									goodNoteHit(daNote);
							case 4:
								if (n4 || n4Hold)
									goodNoteHit(daNote);
							case 5:
								if (n5 || n5Hold)
									goodNoteHit(daNote);
							case 6:
								if (n6 || n6Hold)
									goodNoteHit(daNote);
							case 7:
								if (n7 || n7Hold)
									goodNoteHit(daNote);
							case 8:
								if (n8 || n8Hold)
									goodNoteHit(daNote);
						}
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			if (mania == 0)
			{
				switch (spr.ID)
				{
					case 2:
						if (upP && spr.animation.curAnim.name != 'confirm')
						{
							spr.animation.play('pressed');
							trace('play');
						}
						if (upR)
						{
							spr.animation.play('static');
						}
					case 3:
						if (rightP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (rightR)
						{
							spr.animation.play('static');
						}
					case 1:
						if (downP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (downR)
						{
							spr.animation.play('static');
						}
					case 0:
						if (leftP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (leftR)
						{
							spr.animation.play('static');
						}
				}
			}
			else if (mania == 1)
			{
				switch (spr.ID)
				{
					case 0:
						if (l1P && spr.animation.curAnim.name != 'confirm')
						{
							spr.animation.play('pressed');
							trace('play');
						}
						if (l1R)
						{
							spr.animation.play('static');
						}
					case 1:
						if (uP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (uR)
						{
							spr.animation.play('static');
						}
					case 2:
						if (r1P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (r1R)
						{
							spr.animation.play('static');
						}
					case 3:
						if (l2P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (l2R)
						{
							spr.animation.play('static');
						}
					case 4:
						if (dP && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (dR)
						{
							spr.animation.play('static');
						}
					case 5:
						if (r2P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (r2R)
						{
							spr.animation.play('static');
						}
				}
			}
			else if (mania == 2)
			{
				switch (spr.ID)
				{
					case 0:
						if (n0P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n0R)
							spr.animation.play('static');
					case 1:
						if (n1P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n1R)
							spr.animation.play('static');
					case 2:
						if (n2P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n2R)
							spr.animation.play('static');
					case 3:
						if (n3P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n3R)
							spr.animation.play('static');
					case 4:
						if (n4P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n4R)
							spr.animation.play('static');
					case 5:
						if (n5P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n5R)
							spr.animation.play('static');
					case 6:
						if (n6P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n6R)
							spr.animation.play('static');
					case 7:
						if (n7P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n7R)
							spr.animation.play('static');
					case 8:
						if (n8P && spr.animation.curAnim.name != 'confirm')
							spr.animation.play('pressed');
						if (n8R)
							spr.animation.play('static');
				}
			}

			if (spr.animation.curAnim.name == 'confirm'
				&& !curStage.startsWith('school')
				&& !curStage.startsWith('school-b')
				&& !curStage.startsWith('schoolEvil-b'))
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1):Void
	{
		minusHealth = true;

		if (!boyfriend.stunned)
		{
			if (PauseSubState.babymode == "No")
			{
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				songMiss += 1;
				combo = 0;
				health -= 0.04;
				songScore -= 10;

				if (PauseSubState.sickmode == "Yes")
				{
					FlxG.resetState();
				}

				FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
				// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
				// FlxG.log.add('played imss note');

				boyfriend.stunned = true;

				// get stunned for 5 seconds
				new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
				{
					boyfriend.stunned = false;
				});
				if (mania == 0)
					switch (direction)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
					}
				else
					switch (direction)
					{
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
						case 4:
							boyfriend.playAnim('singDOWNmiss', true);
						case 5:
							boyfriend.playAnim('singRIGHTmiss', true);
					}
			}
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;
		var l1P = controls.L1_P;
		var uP = controls.U1_P;
		var r1P = controls.R1_P;
		var l2P = controls.L2_P;
		var dP = controls.D1_P;
		var r2P = controls.R2_P;
		var n0P = controls.N0_P;
		var n1P = controls.N1_P;
		var n2P = controls.N2_P;
		var n3P = controls.N3_P;
		var n4P = controls.N4_P;
		var n5P = controls.N5_P;
		var n6P = controls.N6_P;
		var n7P = controls.N7_P;
		var n8P = controls.N8_P;

		if (mania == 0)
		{
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
		}
		else if (mania == 1)
		{
			if (l1P)
				noteMiss(0);
			else if (uP)
				noteMiss(1);
			else if (r1P)
				noteMiss(2);
			else if (l2P)
				noteMiss(3);
			else if (dP)
				noteMiss(4);
			else if (r2P)
				noteMiss(5);
		}
		else
		{
			if (n0P)
				noteMiss(0);
			if (n1P)
				noteMiss(1);
			if (n2P)
				noteMiss(2);
			if (n3P)
				noteMiss(3);
			if (n4P)
				noteMiss(4);
			if (n5P)
				noteMiss(5);
			if (n6P)
				noteMiss(6);
			if (n7P)
				noteMiss(7);
			if (n8P)
				noteMiss(8);
		}
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
		{
			badNoteCheck();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		minusHealth = false;

		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				combo += 1;
				combo -= 0.0000000000000000001;
			}

			

			if (crazyMode)
			{
				health += 0.05;
				camGame.shake(0.008, 0.02, null, true);
			}

			// if (isGenocide && storyDifficulty > 0 &&)
			// {
			// 	health += 0.05;
			// }

			if (curSong == 'Gospel')
			{
				switch (note.noteData)
				{
					case 0:
						curl2.angle -= 2;
					case 1:
						curl2.angle -= 2;
					case 2:
						curl2.angle -= 2;
					case 3:
						curl2.angle -= 2;
				}
			}
			var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
			if (mania == 1)
			{
				sDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
			}
			else if (mania == 2)
			{
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			}
			boyfriend.playAnim('sing' + sDir[note.noteData], true);

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var isbobmad:Bool = true;

	function shakescreen()
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			Lib.application.window.move(Lib.application.window.x + FlxG.random.int(-10, 10), Lib.application.window.y + FlxG.random.int(-8, 8));
		}, 50);
	}

	function resetBobismad():Void
	{
		camHUD.visible = true;
		bobsound.pause();
		bobmadshake.visible = false;
		bobsound.volume = 0;
		isbobmad = true;
	}

	function Bobismad()
	{
		camHUD.visible = false;
		bobmadshake.visible = true;
		bobsound.play();
		bobsound.volume = 1;
		isbobmad = false;
		shakescreen();
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			resetBobismad();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var stepOfLast = 0;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		flashSprite.alpha -= 0.08;
		if (SONG.song.toLowerCase() == 'your demise')
			{
				switch (curStep)
				{
					case 132:
						boyfriend.visible = true;
						dad.visible = true;
						remove(blackScreen);

						new FlxTimer().start(0.03, function(tmr:FlxTimer)
							{
								whiteflash.alpha -= 0.15;
								if (whiteflash.alpha > 0)
									{
										tmr.reset(0.03);
									}
									else
										{
											remove(whiteflash);
										}
							});
					
					case 889:
						FlxG.camera.fade(FlxColor.BLACK, 2, false);
				}
			}

		if (SONG.song.toLowerCase() == 'medley')
		{
			if (curStep == 3664)
			{
				furybg.visible = true;

				bowserbodylol.visible = true;

				furybackgroundthings.visible = true;

				furybellshrine.visible = true;

				catbell.visible = true;

				shakeEffect = true;

				redglow = new FlxSprite(0, -250).loadGraphic(Paths.image('redglow'));
				redglow.setGraphicSize(Std.int(redglow.width * 1.3));
				redglow.updateHitbox();
				redglow.visible = true;
				redglow.antialiasing = ClientPrefs.globalAntialiasing;
				redglow.scrollFactor.set(1, 1);
				redglow.active = false;
				add(redglow);

				redfilter = new FlxSprite(0, 0).loadGraphic(Paths.image('redfilter'));
				redfilter.setGraphicSize(Std.int(redfilter.width * 1));
				redfilter.updateHitbox();
				redfilter.visible = true;
				redfilter.antialiasing = ClientPrefs.globalAntialiasing;
				redfilter.scrollFactor.set(0, 0);
				redfilter.active = false;
				add(redfilter);

				remove(gf);

				remove(dad);

				dad = new Character(-50, -300, 'bowserhead');
				add(dad);
			}
			if (curStep == 3680)
			{
				shakeEffect = false;

				slightShakeEffect = true;
			}

			if (curStep == 3993)
			{
				furybg.visible = false;

				bowserbodylol.visible = false;

				furybackgroundthings.visible = false;

				furybellshrine.visible = false;

				catbell.visible = false;

				redfilter.visible = false;
				redglow.visible = false;

				justwhite = new FlxSprite(0, 0).loadGraphic(Paths.image('justwhite'));
				justwhite.setGraphicSize(Std.int(justwhite.width * 1.3));
				justwhite.updateHitbox();
				justwhite.visible = true;
				justwhite.antialiasing = ClientPrefs.globalAntialiasing;
				justwhite.scrollFactor.set(0, 0);
				justwhite.active = false;
				add(justwhite);

				remove(dad);
				dad = new Character(50, 250, 'catshine');
				add(dad);
			}

			if (curStep == 4039)
			{
				slightShakeEffect = false;

				remove(justwhite);
			}
		}

		if (curStage == 'auditorHell' && curStep != stepOfLast)
		{
			switch (curStep)
			{
				case 384:
					doStopSign(0);
				case 511:
					doStopSign(2);
					doStopSign(0);
				case 610:
					doStopSign(3);
				case 720:
					doStopSign(2);
				case 991:
					doStopSign(3);
				case 1184:
					doStopSign(2);
				case 1218:
					doStopSign(0);
				case 1235:
					doStopSign(0, true);
				case 1200:
					doStopSign(3);
				case 1328:
					doStopSign(0, true);
					doStopSign(2);
				case 1439:
					doStopSign(3, true);
				case 1567:
					doStopSign(0);
				case 1584:
					doStopSign(0, true);
				case 1600:
					doStopSign(2);
				case 1706:
					doStopSign(3);
				case 1917:
					doStopSign(0);
				case 1923:
					doStopSign(0, true);
				case 1927:
					doStopSign(0);
				case 1932:
					doStopSign(0, true);
				case 2032:
					doStopSign(2);
					doStopSign(0);
				case 2036:
					doStopSign(0, true);
				case 2162:
					doStopSign(2);
					doStopSign(3);
				case 2193:
					doStopSign(0);
				case 2202:
					doStopSign(0, true);
				case 2239:
					doStopSign(2, true);
				case 2258:
					doStopSign(0, true);
				case 2304:
					doStopSign(0, true);
					doStopSign(0);
				case 2326:
					doStopSign(0, true);
				case 2336:
					doStopSign(3);
				case 2447:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2480:
					doStopSign(0, true);
					doStopSign(0);
				case 2512:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2544:
					doStopSign(0, true);
					doStopSign(0);
				case 2575:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2608:
					doStopSign(0, true);
					doStopSign(0);
				case 2604:
					doStopSign(0, true);
				case 2655:
					doGremlin(20, 13, true);
			}
			stepOfLast = curStep;
		}

		if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
		{
			if (curStep == 247)
			{
				dad.playAnim('garFarewell', true);
			}
		}

		if (dad.curCharacter == 'garcelloghosty' && SONG.song.toLowerCase() == 'fading')
		{
			if (curStep == 240)
			{
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					dad.alpha -= 0.05;
					iconP2.alpha -= 0.05;

					if (dad.alpha > 0)
					{
						tmr.reset(0.1);
					}
				});
			}
		}

		if (dad.curCharacter == 'garcellodead' && SONG.song.toLowerCase() == 'release')
		{
			if (curStep == 835)
				garlilman = 1;
			if (curStep == 847)
				garlilman = 0;
		}
		if (dad.curCharacter == 'garcellodead' && SONG.song.toLowerCase() == 'release-rs')
		{
			if (curStep == 900)
				garlilman = 1;
			if (curStep == 910)
				garlilman = 0;
		}
		if (dad.curCharacter == 'zardy' && curStep == 2425)
		{
			FlxTween.tween(dad, {alpha: 0.3}, 2.5, {startDelay: 0.0});
		}
		if (dad.curCharacter == 'zardy' && curStep == 2950)
		{
			FlxTween.tween(dad, {alpha: 0.0}, 1.5, {startDelay: 0.0});
		}
		if (dad.curCharacter == 'spooky-neo' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		if (dad.curCharacter == 'spooky-b' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		if (dad.curCharacter == 'sky-annoyed' && curStep > 511)
		{
			if (curStep == 1143)
				ughsky = 1;
			else
				pissedsky = 1;
		}
		if (dad.curCharacter == 'tankman' && curStep > 734 && SONG.song.toLowerCase() == 'stress' || dad.curCharacter == 'tankman' && curStep > 734 && SONG.song.toLowerCase() == 'stress-duet')
		{
			if (curStep == 735)
				tankmangood = 1;
			if (curStep == 763)
				tankmangood = 0;
		}
		if (dad.curCharacter == 'tankman' && curStep == 896 && SONG.song.toLowerCase() == 'guns' || dad.curCharacter == 'tankman' && curStep == 896 && SONG.song.toLowerCase() == 'guns-duet')
			{
				FlxTween.tween(dad, {alpha: 1, y: dad.y - 1850}, 9.0, {startDelay: 0.0});

				

				tankmanreal = 1;

			}
		if (dad.curCharacter == 'tankman' && curStep == 1087 && SONG.song.toLowerCase() == 'guns' || dad.curCharacter == 'tankman' && curStep == 1087 && SONG.song.toLowerCase() == 'guns-duet')
			{
			if (tankmanreal == 1){
				FlxTween.tween(dad, {alpha: 1, y: dad.y + 1850}, 5.0, {onComplete: function(twn:FlxTween)
					{
						FlxG.sound.play(Paths.sound('ugh'), 1.0);
						dad.playAnim('ugh', true);
					}
				});
				tankmanreal = 0;
				


			}
	
			}
		if (tankmanreal == 1)
		{
			
				
			new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					dad.playAnim('singLEFT', true);
					new FlxTimer().start(0.3, function(tmr:FlxTimer)
						{
							dad.playAnim('singUP', true);
							new FlxTimer().start(0.3, function(tmr:FlxTimer)
								{
									dad.playAnim('singDOWN', true);
									new FlxTimer().start(0.3, function(tmr:FlxTimer)
										{
											dad.playAnim('singRIGHT', true);	
										});
								});
						});
				});
		
				
					
					

		}
		if (dad.curCharacter == 'garcellodead' && curStep == 837)
		{
			dad.playAnim('ugh', true);
		}

		if (curStep == 1802 && curSong == 'Sussus-Moogus')
		{
			gf.playAnim('dead', false);
		}
		if (curStep == 1794 && curSong == 'Sussus-Moogus')
		{
			dad.playAnim('shoot1', false);
		}
		if (curStep == 1620 && curSong == 'Sabotage')
		{
			FlxG.sound.play(Paths.soundRandom('gunshot', 0, 15));
			dad.playAnim('shoot2', false);
		}
		if (curStep == 1640 && curSong == 'Sabotage')
		{
			boyfriend.playAnim('scaredamong', false);
		}
		if (curStep == 1647 && curSong == 'Sabotage')
		{
			boyfriend.playAnim('deadamong', false);
		}
		if (curStep == 1647 && curSong == 'Sabotage')
		{
			boyfriend.playAnim('deadamong', false);
		}
		if (curStep == 2048 && curSong == 'Meltdown')
		{
			boyfriend.playAnim('hey', false);
		}
		if (curStep == 1812 && curSong == 'Sussus-Moogus')
		{
			dad.playAnim('idle', true);
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var beatOfFuck:Int = 0;

	function bgFlash():Void
	{
		// oops im stupid so commented out the tweening version
		// flashSprite.alpha = 0;
		// FlxTween.tween(flashSprite.alpha, 0.4, 0.15);
		trace('BG FLASH FUNNY');
		flashSprite.alpha = 0.4;
	}

	function shakeNote():Void
	{
		/*var offsetShit:Float = 10;
			if (noteShaked)
			{
				noteShaked = !noteShaked;
				for (i in 0...strumLineNotes.length)
				{
					FlxTween.tween(strumLineNotes.members[i], {x: strumLineX[i] + (offsetShit * -1)}, (60 / Conductor.bpm));
				}
			} else {
				noteShaked = !noteShaked;
				for (i in 0...strumLineNotes.length)
				{
					FlxTween.tween(strumLineNotes.members[i], {x: strumLineX[i] + (offsetShit * 1)}, (60 / Conductor.bpm));
				}
		}*/
		// im tired of rip ram shit
		// noteCam2.shake(0.005, (60 / Conductor.bpm), null, true, FlxAxes.X);
	}

	public function screenDance():Void
	{
		if (!screenDanced)
		{
			Lib.application.window.x += Std.int(Lib.application.window.width / 100);
		}
		else
		{
			Lib.application.window.x -= Std.int(Lib.application.window.width / 100);
		}
		screenDanced = !screenDanced;
	}

	public function resetChromeShit2(?tmr:FlxTimer):Void
	{
		if (!paused)
		{
			setChrome(0.0);
			chromDanced = false;
		}
	}

	public function chromaticDance(tabiTurn:Bool):Void
	{
		if (isGenocide)
		{
			var maxHealth:Float = 2;
			if (crazyMode)
			{
				maxHealth = 3;
			}
			chromDanced = !chromDanced;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (curStage == 'festival')
		{
			if (SONG.song.toLowerCase() == 'artificial-lust')
			{
				if (bopped)
					rgbheadlights.animation.play('idle', true);
				else
					rgbheadlights.animation.play('idle2', true);
				bopped = !bopped;
			}
			headlights.animation.play('idle', true);
			frontbop.animation.play('idle', true);
			if (SONG.song.toLowerCase() == 'artificial-lust')
				rgbfrontbop.animation.play('idle', true);
			if (SONG.song.toLowerCase() == 'echoes')
			{
				cj.animation.play('idle', true);
			}
		}

		if (isGenocide)
		{
			shakeNote();
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (curStage == 'meltdown')
		{
			crowd.dance();
		}

		var sussusBeats = [94, 95, 288, 296, 304, 312, 318, 319];
		var saboBeats = [16, 24, 32, 40, 48, 56, 62, 63, 272, 280, 288, 296, 302, 303, 376, 384, 892];
		var meltBeats = [
			0, 16, 32, 48, 64, 72, 80, 88, 96, 104, 112, 120, 126, 127, 200, 208, 216, 224, 232, 240, 248, 256, 272, 288, 304, 320, 336, 352, 368, 382, 464,
			480, 496, 512
		];
		var _b = 0;
		// FlxG.watch.addQuick("Flash Timer", _cb); debug stuff

		add(flashSprite);
		flashSprite.alpha = 0;
		flashSprite.scrollFactor.set(0, 0);

		if (curSong == 'Sussus-Moogus') // sussus flashes
		{
			if (curBeat == 97 || curBeat == 192 || curBeat == 320)
				_cb = 1;
			if (curBeat > 98 && curBeat < 160 || curBeat > 192 && curBeat < 224 || curBeat > 320 && curBeat < 382 || curBeat == 98 || curBeat == 160
				|| curBeat == 192 || curBeat == 224 || curBeat == 320 || curBeat == 382)
			{
				_cb++;
				if (_cb == 2)
				{
					bgFlash();
					_cb = 0;
				}
			}
			while (_b < sussusBeats.length)
			{
				var susflash = sussusBeats[_b];
				++_b;
				if (curBeat == susflash)
				{
					bgFlash();
				}
			}
		}
		if (curSong == 'Sabotage') // sabotage flashes
		{
			while (_b < saboBeats.length)
			{
				var sabflash = saboBeats[_b];
				++_b;
				if (curBeat == sabflash)
				{
					bgFlash();
				}
			}

			if (curBeat == 63 || curBeat == 304)
				_cb = 3;
			if (curBeat > 64 && curBeat < 124 || curBeat > 304 && curBeat < 370 || curBeat == 64 || curBeat == 124 || curBeat == 304 || curBeat == 370)
			{
				_cb++;
				if (_cb == 4)
				{
					bgFlash();
					_cb = 0;
				}
			}
		}
		if (curSong == 'Meltdown') // meltdown flashes
		{
			while (_b < meltBeats.length)
			{
				var meltflash = meltBeats[_b];
				++_b;
				if (curBeat == meltflash)
				{
					bgFlash();
				}
			}
			if (curBeat == 127)
				_cb = 3;
			if (curBeat == 382)
				_cb = 1;
			if (curBeat > 128 && curBeat < 192 || curBeat > 382 && curBeat < 448 || curBeat == 128 || curBeat == 192 || curBeat == 382 || curBeat == 448)
			{
				_cb++;
				if (_cb == 4)
				{
					bgFlash();
					_cb = 0;
				}
			}
		}

		if (curBeat == 326 && SONG.song == 'Extremus')
		{
			dreamOneBG.alpha = 0;
			dreamOneIcons.alpha = 0;
			dreamOneStage.alpha = 0;

			dreamTwoBG.alpha = 1;
			dreamTwoIcons.alpha = 1;
			dreamTwoStage.alpha = 1;
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		if (curStage == 'auditorHell')
		{
			if (curBeat % 8 == 4 && beatOfFuck != curBeat)
			{
				beatOfFuck = curBeat;
				doClone(FlxG.random.int(0, 1));
			}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (ClientPrefs.camZooms){
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && curSong.toLowerCase() != 'nyaw')
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curSong.toLowerCase() == 'nyaw' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0 && curBeat != 283 && curBeat != 282)
		{
			{
				phillyCityLights.forEach(function(light:FlxSprite)
				{
					light.visible = false;
				});

				curLight = FlxG.random.int(0, phillyCityLights.length - 1);

				phillyCityLights.members[curLight].visible = true;
				// phillyCityLights.members[curLight].alpha = 1;
			}
			FlxG.camera.zoom += 0.02;
			camHUD.zoom += 0.022;
		}
		if (curSong.toLowerCase() == 'nyaw' && curBeat == 282)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, .5, {
				ease: FlxEase.quadInOut,
			});
		}
		if (curSong.toLowerCase() == 'hairball' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0)
		{
			FlxG.camera.zoom += 0.017;
			camHUD.zoom += 0.02;
		}
		if (curSong.toLowerCase() == 'hairball' && curBeat % 1 == 0)
		{
			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			curLight = FlxG.random.int(0, phillyCityLights.length - 1);

			phillyCityLights.members[curLight].visible = true;
			// phillyCityLights.members[curLight].alpha = 1;
		}
		if (curSong.toLowerCase() == 'beathoven' && curBeat % 1 == 0)
		{
			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			curLight = FlxG.random.int(0, phillyCityLights.length - 1);

			phillyCityLights.members[curLight].visible = true;
			// phillyCityLights.members[curLight].alpha = 1;
		}
		if (curSong.toLowerCase() == 'wocky' && curBeat % 2 == 0)
		{
			phillyCityLights.forEach(function(light:FlxSprite)
			{
				light.visible = false;
			});

			curLight = FlxG.random.int(0, phillyCityLights.length - 1);

			phillyCityLights.members[curLight].visible = true;
			// phillyCityLights.members[curLight].alpha = 1;
		}
		if (curSong.toLowerCase() == 'beathoven' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
		{
			FlxG.camera.zoom += 0.014;
			camHUD.zoom += 0.015;
		}
		if (curSong.toLowerCase() == 'wocky' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
		{
			FlxG.camera.zoom += 0.016;
			camHUD.zoom += 0.015;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			if (curSong != 'Sussus-Moogus')
			{
				gf.dance();
			}
			else if (curSong == 'Sussus-Moogus' && curStep <= 1801)
			{
				gf.dance();
			}
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}
		if (curBeat == 283 && curSong == 'Nyaw')
		{
			boyfriend.playAnim('hey', true);
		}
		if (curBeat == 434 && curSong == 'Nyaw')
		{
			dad.playAnim('stare', true);
			new FlxTimer().start(1.1, function(tmr:FlxTimer)
			{
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				add(black);
			});
		}
		if (curBeat == 31 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat == 135 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat == 363 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat == 203 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Nyaw')
		{
			bottomBoppers.animation.play('bop', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Hairball')
		{
			littleGuys.animation.play('bop', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Beathoven')
		{
			littleGuys.animation.play('bop', true);
		}
		if (curBeat % 2 == 1 && curSong == 'Nyaw')
		{
			upperBoppers.animation.play('bop', true);
		}
		if (curBeat % 2 == 1 && curSong == 'Hairball')
		{
			upperBoppers.animation.play('bop', true);
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);

			
		}
		if (curBeat == 532 && curSong.toLowerCase() == "expurgation")
		{
			dad.playAnim('Hank', true);
		}

		if (curBeat == 536 && curSong.toLowerCase() == "expurgation")
		{
			dad.playAnim('idle', true);
		}

		
		if (curBeat % 2 == 0 && curStage == "tankman1")
		{
			halloweenBG.animation.play('idle', true);
			halloweenBG3.animation.play('idle', true);
			halloweenBG4.animation.play('idle', true);
			halloweenBG5.animation.play('idle', true);
			halloweenBG6.animation.play('idle', true);
			halloweenBG7.animation.play('idle', true);
		}

		switch (curStage)
		{
			case 'school':
				if (SONG.song.toLowerCase() == 'high school conflict' || SONG.song.toLowerCase() == 'your reality')
					trace('NOPE');
				else
					bgGirls.dance();
			case 'school-b':
				bgGirls.dance();
			case 'school-b3':
				bgGirls.dance();
			case 'school-salty':
				bgGirls.dance();
			case 'bowserstage':
				bottomBoppers.animation.play('bop', true);
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'mall-b3':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'mall-salty':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'mall-b':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'miku':
				upperBoppers.animation.play('bop', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();

			case 'limo-b':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'limo-b3':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'limo-salty':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case 'touhou':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case "festival":
				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case 'kapi':
				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}
			case "philly-star":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case "philly-b":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case "philly-beat":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case "philly-b3":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

			case "philly-salty":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case "anders_1":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}

			case "anders_2":
				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

			case "philly-neo":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case "annie":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'hellstage':
				if (FlxG.random.bool(10) && isbobmad && curSong.toLowerCase() == 'run')
					Bobismad();
		}
	}
	var tankAngle:Float = FlxG.random.int(-90, 45);
	var tankSpeed:Float = FlxG.random.float(5, 7);
	var tankX = 400;
	function moveTank() {
    
        tankAngle += FlxG.elapsed * tankSpeed;
        steve.angle = tankAngle - 90 + 15;
        steve.x = tankX + 1500 * FlxMath.fastCos(FlxAngle.asRadians(tankAngle + 180));
        steve.y = 1300 + 1100 * FlxMath.fastSin(FlxAngle.asRadians(tankAngle + 180));
    }
	function resetJohn(x:Float, y:Int, goingRight:Bool, spr:FlxSprite, johnNum:Int) {
		
		spr.x = x;
		spr.y = y;
		goingRightJohn[johnNum] = goingRight;
		endingOffsetJohn[johnNum] = FlxG.random.float(50, 200);
		tankSpeedJohn[johnNum] = FlxG.random.float(0.6, 1);
		 spr.flipX = if (goingRight) true else false;
	}

}

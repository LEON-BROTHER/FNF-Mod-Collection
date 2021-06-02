package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import PauseSubState;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
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

	public static var bfsel:Int = 0;

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

	private var dad:Character;
	var s_ending:Bool = false;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	public static var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;

	public static var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Float = 0;

	public var curLight:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public static var theFunne:Bool = true;

	var funneEffect:FlxSprite;
	var burst:FlxSprite;
	var rock:FlxSprite;
	var gf_rock:FlxSprite;
	var doorFrame:FlxSprite;
	var dfS:Float = 1;

	var gf_launched:Bool = false;
	var sh_r:Float = 600;
	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var curl1:FlxSprite;
	var curl2:FlxSprite;
	var curl3:FlxSprite;
	var isHalloween:Bool = false;
	var lightchara:Int = 0;
	var godCutEnd:Bool = false;
	var godMoveBf:Bool = true;
	var godMoveGf:Bool = false;
	var godMoveSh:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;
	var stageFront:FlxSprite;
	var gaster:FlxSprite;
	var deadpill:FlxSprite;

	var squaredown:Int = 0;
	var squareoverwrite:FlxSprite;
	var squareoverwrite1:FlxSprite;

	public var charactergaster:FlxSprite;

	var squareoverwrite2:FlxSprite;
	var squareoverwrite3:FlxSprite;
	var squareoverwrite4:FlxSprite;
	var squareoverwrite5:FlxSprite;

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
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		mania = SONG.mania;

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
		}

		if (SONG.song.toLowerCase() == 'spookeez'
			|| SONG.song.toLowerCase() == 'monster'
			|| SONG.song.toLowerCase() == 'south'
			|| SONG.song.toLowerCase() == 'spookeez-duet'
			|| SONG.song.toLowerCase() == 'monster-duet'
			|| SONG.song.toLowerCase() == 'south-duet')
		{
			curStage = "spooky";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}
		else if (SONG.song.toLowerCase() == 'megalo-strike-back')
		{
			curStage = "charaut";
			defaultCamZoom = 0.90;

			halloweenBG = new FlxSprite(-250, -100).loadGraphic(Paths.image('utchara/chara-bg'));
			halloweenBG.scrollFactor.set(0.5, 0.5);
			halloweenBG.setGraphicSize(Std.int(halloweenBG.width * 1.15));
			halloweenBG.antialiasing = true;
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'pico'
			|| SONG.song.toLowerCase() == 'blammed'
			|| SONG.song.toLowerCase() == 'philly'
			|| SONG.song.toLowerCase() == 'pico-duet'
			|| SONG.song.toLowerCase() == 'blammed-duet'
			|| SONG.song.toLowerCase() == 'philly-duet'
			|| SONG.song.toLowerCase() == 'philly-carol'
			|| SONG.song.toLowerCase() == 'carol-roll'
			|| SONG.song.toLowerCase() == 'blammed-carol')
		{
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
				light.antialiasing = true;
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
		}
		else if (SONG.song.toLowerCase() == 'diminished' || SONG.song.toLowerCase() == 'pentafluoride')
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
				light.antialiasing = true;
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
		else if (SONG.song.toLowerCase() == 'psychoneurotic')
		{
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
			halloweenBG.antialiasing = true;
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
				light.antialiasing = true;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('anders/backrailing_c'));
			streetBehind.setGraphicSize(Std.int(streetBehind.width * 1.25));
			add(streetBehind);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('anders/platform_c'));
			street.setGraphicSize(Std.int(street.width * 1.25));
			add(street);
		}
		else if (SONG.song.toLowerCase() == 'good-enough' || SONG.song.toLowerCase() == 'lover' || SONG.song.toLowerCase() == 'tug-of-war')
		{
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
				light.antialiasing = true;
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
		}
		else if (SONG.song.toLowerCase() == 'pico-starcatcher'
			|| SONG.song.toLowerCase() == 'blammed-starcatcher'
			|| SONG.song.toLowerCase() == 'philly-starcatcher')
		{
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
				light.antialiasing = true;
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
		}
		else if (SONG.song.toLowerCase() == 'pico-b-sides'
			|| SONG.song.toLowerCase() == 'blammed-b-sides'
			|| SONG.song.toLowerCase() == 'philly-b-sides'
			|| SONG.song.toLowerCase() == 'pico-b-sides-duet'
			|| SONG.song.toLowerCase() == 'blammed-b-sides-duet'
			|| SONG.song.toLowerCase() == 'philly-b-sides-duet')
		{
			curStage = 'philly-b';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('sky'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('city'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('win' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = true;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('behindTrain'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('train'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('street'));
			add(street);
		}
		else if (SONG.song.toLowerCase() == 'eferu-chan'
			|| SONG.song.toLowerCase() == 'fruity-reeverb'
			|| SONG.song.toLowerCase() == 'fl-slayer')
		{
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
			limo.antialiasing = true;
		}
		else if (SONG.song.toLowerCase() == 'milf'
			|| SONG.song.toLowerCase() == 'satin-panties'
			|| SONG.song.toLowerCase() == 'high'
			|| SONG.song.toLowerCase() == 'milf-duet'
			|| SONG.song.toLowerCase() == 'satin-panties-duet'
			|| SONG.song.toLowerCase() == 'high-duet'
			|| SONG.song.toLowerCase() == 'ex-girlfriend')
		{
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
			limo.antialiasing = true;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		}
		else if (SONG.song.toLowerCase() == 'milf-starcatcher'
			|| SONG.song.toLowerCase() == 'satin-panties-starcatcher'
			|| SONG.song.toLowerCase() == 'high-starcatcher')
		{
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
			limo.antialiasing = true;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('starcatcher/limo/fastCarLol'));
		}
		else if (SONG.song.toLowerCase() == 'night-of-nights'
			|| SONG.song.toLowerCase() == 'lunar-dial'
			|| SONG.song.toLowerCase() == 'the-pocket-watch-of-blood')
		{
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
			limo.antialiasing = true;
		}
		else if (SONG.song.toLowerCase() == 'milf-b-sides'
			|| SONG.song.toLowerCase() == 'satin-panties-b-sides'
			|| SONG.song.toLowerCase() == 'high-b-sides'
			|| SONG.song.toLowerCase() == 'milf-b-sides-duet'
			|| SONG.song.toLowerCase() == 'satin-panties-b-sides-duet'
			|| SONG.song.toLowerCase() == 'high-b-sides-duet')
		{
			curStage = 'limo-b';
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
			limo.antialiasing = true;

			fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol'));
		}
		else if (SONG.song.toLowerCase() == 'milf-neo'
			|| SONG.song.toLowerCase() == 'satin-panties-neo'
			|| SONG.song.toLowerCase() == 'high-neo')
		{
			curStage = 'limo-neo';
			defaultCamZoom = 0.70;

			var skyBG:FlxSprite = new FlxSprite(-300, -300).loadGraphic(Paths.image('limoSunset-neo'));
			skyBG.scrollFactor.set(0.1, 0.1);
			skyBG.setGraphicSize(Std.int(skyBG.width * 1));
			add(skyBG);

			var limoTex = Paths.getSparrowAtlas('limoDrive-neo');
			limo = new FlxSprite(-340, 760);
			limo.frames = limoTex;
			limo.animation.addByPrefix('drive', "Limo stage", 24);
			limo.animation.play('drive');
			limo.antialiasing = true;
		}
		else if (SONG.song.toLowerCase() == 'cocoa'
			|| SONG.song.toLowerCase() == 'eggnog'
			|| SONG.song.toLowerCase() == 'cocoa-duet'
			|| SONG.song.toLowerCase() == 'eggnog-duet')
		{
			curStage = 'mall';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = true;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
			bgEscalator.antialiasing = true;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
			tree.antialiasing = true;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = true;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = true;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = true;
			add(santa);
		}
		else if (SONG.song.toLowerCase() == 'cocoa-b-sides'
			|| SONG.song.toLowerCase() == 'eggnog-b-sides'
			|| SONG.song.toLowerCase() == 'cocoa-b-sides-duet'
			|| SONG.song.toLowerCase() == 'eggnog-b-sides-duet')
		{
			curStage = 'mall-b';

			defaultCamZoom = 0.80;

			var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			upperBoppers = new FlxSprite(-240, -90);
			upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop');
			upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
			upperBoppers.antialiasing = true;
			upperBoppers.scrollFactor.set(0.33, 0.33);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator'));
			bgEscalator.antialiasing = true;
			bgEscalator.scrollFactor.set(0.3, 0.3);
			bgEscalator.active = false;
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree'));
			tree.antialiasing = true;
			tree.scrollFactor.set(0.40, 0.40);
			add(tree);

			bottomBoppers = new FlxSprite(-300, 140);
			bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop');
			bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
			bottomBoppers.antialiasing = true;
			bottomBoppers.scrollFactor.set(0.9, 0.9);
			bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
			bottomBoppers.updateHitbox();
			add(bottomBoppers);

			var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow'));
			fgSnow.active = false;
			fgSnow.antialiasing = true;
			add(fgSnow);

			santa = new FlxSprite(-840, 150);
			santa.frames = Paths.getSparrowAtlas('christmas/santa');
			santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
			santa.antialiasing = true;
			add(santa);
		}
		else if (SONG.song.toLowerCase() == 'winter-horrorland' || SONG.song.toLowerCase() == 'winter-horrorland-duet')
		{
			curStage = 'mallEvil';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
			evilTree.antialiasing = true;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
			evilSnow.antialiasing = true;
			add(evilSnow);
		}
		else if (SONG.song.toLowerCase() == 'animal')
		{
			curStage = 'annie2';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('annie/evilBG'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('annie/evilTree'));
			evilTree.antialiasing = true;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 825).loadGraphic(Paths.image("annie/evilSnow"));
			evilSnow.antialiasing = true;
			add(evilSnow);
		}
		else if (SONG.song.toLowerCase() == 'w-hl-b-sides')
		{
			curStage = 'mallEvil-b';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree'));
			evilTree.antialiasing = true;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow"));
			evilSnow.antialiasing = true;
			add(evilSnow);
		}
		else if (SONG.song.toLowerCase() == 'ronald-mcdonald')
		{
			curStage = 'Ronald-Stage';
			var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('ronald-BG'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.2, 0.2);
			bg.active = false;
			bg.setGraphicSize(Std.int(bg.width * 0.8));
			bg.updateHitbox();
			add(bg);

			var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('Tree'));
			evilTree.antialiasing = true;
			evilTree.scrollFactor.set(0.2, 0.2);
			add(evilTree);

			var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("ronald-floor"));
			evilSnow.antialiasing = true;
			add(evilSnow);
		}
		else if (SONG.song.toLowerCase() == 'senpai'
			|| SONG.song.toLowerCase() == 'roses'
			|| SONG.song.toLowerCase() == 'senpai-duet'
			|| SONG.song.toLowerCase() == 'roses-duet'
			|| SONG.song.toLowerCase() == 'high-school-conflict')
		{
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

			if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'roses-duet')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		}
		else if (SONG.song.toLowerCase() == 'highrise' || SONG.song.toLowerCase() == 'ordinance')
		{
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
		}
		else if (SONG.song.toLowerCase() == 'thorns' || SONG.song.toLowerCase() == 'thorns-duet')
		{
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
		}
		else if (SONG.song.toLowerCase() == 'transgression')
		{
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
		}
		else if (SONG.song.toLowerCase() == 'senpai-b-sides'
			|| SONG.song.toLowerCase() == 'roses-b-sides'
			|| SONG.song.toLowerCase() == 'senpai-b-sides-duet'
			|| SONG.song.toLowerCase() == 'roses-b-sides-duet')
		{
			curStage = 'school-b';

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

			if (SONG.song.toLowerCase() == 'roses-b-sides' || SONG.song.toLowerCase() == 'roses-b-sides')
			{
				bgGirls.getScared();
			}

			bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
			bgGirls.updateHitbox();
			add(bgGirls);
		}
		else if (SONG.song.toLowerCase() == 'thorns-b-sides' || SONG.song.toLowerCase() == 'thorns-b-sides-duet')
		{
			curStage = 'schoolEvil-b';

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
		}
		else if (SONG.song.toLowerCase() == 'bopeebo-neo'
			|| SONG.song.toLowerCase() == 'fresh-neo'
			|| SONG.song.toLowerCase() == 'dadbattle-neo')
		{
			defaultCamZoom = 0.9;
			curStage = 'stage-neo';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback-neo'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront-neo'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains-neo'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}
		else if (SONG.song.toLowerCase() == 'bopeebo-beatstreets'
			|| SONG.song.toLowerCase() == 'fresh-beatstreets'
			|| SONG.song.toLowerCase() == 'dadbattle-beatstreets')
		{
			defaultCamZoom = 0.9;
			curStage = 'stage-beats';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('beats/stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('beats/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('beats/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}
		else if (SONG.song.toLowerCase() == 'wocky' || SONG.song.toLowerCase() == 'beathoven')
		{
			defaultCamZoom = 0.9;
			curStage = 'kapi';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('kapi/stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('kapi/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 1...4)
			{
				var light:FlxSprite = new FlxSprite(100, 100).loadGraphic(Paths.image('kapi/light' + i));
				light.scrollFactor.set(-600, -200);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = true;
				phillyCityLights.add(light);
			}
		}
		else if (SONG.song.toLowerCase() == 'flatzone')
		{
			curStage = "gaw";

			var hallowTex = Paths.getSparrowAtlas('kapi/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'spookeez-neo' || SONG.song.toLowerCase() == 'south-neo')
		{
			curStage = "spooky-neo";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('halloween_neo');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}
		else if (SONG.song.toLowerCase() == 'spookeez-b-sides'
			|| SONG.song.toLowerCase() == 'south-b-sides'
			|| SONG.song.toLowerCase() == 'spookeez-b-sides-duet'
			|| SONG.song.toLowerCase() == 'south-b-sides-duet')
		{
			curStage = "spooky-b";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('halloween_g');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}
		else if (SONG.song.toLowerCase() == 'spookeez-starcatcher'
			|| SONG.song.toLowerCase() == 'south-starcatcher'
			|| SONG.song.toLowerCase() == 'sugar-rush')
		{
			curStage = "spooky-star";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('starcatcher/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}
		else if (SONG.song.toLowerCase() == 'spookeez-beatstreets' || SONG.song.toLowerCase() == 'south-beatstreets')
		{
			curStage = "spooky-beat";
			halloweenLevel = true;

			var hallowTex = Paths.getSparrowAtlas('starcatcher/halloween_bg');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}
		else if (SONG.song.toLowerCase() == 'pico-neo'
			|| SONG.song.toLowerCase() == 'blammed-neo'
			|| SONG.song.toLowerCase() == 'philly-neo')
		{
			curStage = 'philly-neo';

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('sky-neo'));
			bg.scrollFactor.set(0.1, 0.1);
			add(bg);

			var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('city-neo'));
			city.scrollFactor.set(0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 0.85));
			city.updateHitbox();
			add(city);

			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...5)
			{
				var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('win-neo' + i));
				light.scrollFactor.set(0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				light.antialiasing = true;
				phillyCityLights.add(light);
			}

			var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('behindTrain-neo'));
			add(streetBehind);

			phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('train-neo'));
			add(phillyTrain);

			trainSound = new FlxSound().loadEmbedded(Paths.sound('police_passes'));
			FlxG.sound.list.add(trainSound);

			// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

			var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('street-neo'));
			add(street);
		}
		else if (SONG.song.toLowerCase() == 'pico-beatstreets'
			|| SONG.song.toLowerCase() == 'blammed-beatstreets'
			|| SONG.song.toLowerCase() == 'philly-beatstreets')
		{
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
				light.antialiasing = true;
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
		}
		else if (SONG.song.toLowerCase() == 'bopeebo-b-sides'
			|| SONG.song.toLowerCase() == 'fresh-b-sides'
			|| SONG.song.toLowerCase() == 'dadbattle-b-sides'
			|| SONG.song.toLowerCase() == 'bopeebo-b-sides-duet'
			|| SONG.song.toLowerCase() == 'fresh-b-sides-duet'
			|| SONG.song.toLowerCase() == 'dadbattle-b-sides-duet')
		{
			defaultCamZoom = 0.9;
			curStage = 'stage-b';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}
		else if (SONG.song.toLowerCase() == 'dunk' || SONG.song.toLowerCase() == 'encore')
		{
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-normal';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback-hex'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront-hex'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		}
		else if (SONG.song.toLowerCase() == 'overwrite')
		{
			defaultCamZoom = 0.7;
			curStage = 'chara';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('chara/overwrite_bg'));
			bg.setGraphicSize(Std.int(bg.width * 1.0));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			stageFront = new FlxSprite(-600, -200).loadGraphic(Paths.image('chara/overwrite_light'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.0));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.alpha = 0.7;
			stageFront.active = false;
			squareoverwrite = new FlxSprite(-500, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite.setGraphicSize(Std.int(squareoverwrite.width * 1.0));
			squareoverwrite.updateHitbox();
			squareoverwrite.antialiasing = true;
			squareoverwrite.scrollFactor.set(0.9, 0.9);
			squareoverwrite.active = false;
			squareoverwrite.setGraphicSize(Std.int(squareoverwrite.height * 1.0));
			add(squareoverwrite);

			var squareoverwrite1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite1.setGraphicSize(Std.int(squareoverwrite1.width * 1.0));
			squareoverwrite1.updateHitbox();
			squareoverwrite1.antialiasing = true;
			squareoverwrite1.scrollFactor.set(0.9, 0.9);
			squareoverwrite1.active = false;
			squareoverwrite1.setGraphicSize(Std.int(squareoverwrite1.height * 1.0));
			add(squareoverwrite1);
			var squareoverwrite2:FlxSprite = new FlxSprite(500, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite2.setGraphicSize(Std.int(squareoverwrite2.width * 1.0));
			squareoverwrite2.updateHitbox();
			squareoverwrite2.antialiasing = true;
			squareoverwrite2.scrollFactor.set(0.9, 0.9);
			squareoverwrite2.active = false;
			squareoverwrite2.setGraphicSize(Std.int(squareoverwrite2.height * 1.0));
			add(squareoverwrite2);
			var squareoverwrite3:FlxSprite = new FlxSprite(1000, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite3.setGraphicSize(Std.int(squareoverwrite3.width * 1.0));
			squareoverwrite3.updateHitbox();
			squareoverwrite3.antialiasing = true;
			squareoverwrite3.scrollFactor.set(0.9, 0.9);
			squareoverwrite3.active = false;
			squareoverwrite3.setGraphicSize(Std.int(squareoverwrite3.height * 1.0));
			add(squareoverwrite3);
			var squareoverwrite4:FlxSprite = new FlxSprite(1500, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite4.setGraphicSize(Std.int(squareoverwrite4.width * 1.0));
			squareoverwrite4.updateHitbox();
			squareoverwrite4.antialiasing = true;
			squareoverwrite4.scrollFactor.set(0.9, 0.9);
			squareoverwrite4.active = false;
			squareoverwrite4.setGraphicSize(Std.int(squareoverwrite4.height * 1.0));
			add(squareoverwrite4);
			var squareoverwrite5:FlxSprite = new FlxSprite(2000, 0).loadGraphic(Paths.image('chara/overwrite_square'));
			squareoverwrite5.setGraphicSize(Std.int(squareoverwrite5.width * 1.0));
			squareoverwrite5.updateHitbox();
			squareoverwrite5.antialiasing = true;
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
		}
		else if (SONG.song.toLowerCase() == 'relighted')
		{
			defaultCamZoom = 0.7;
			curStage = 'xgaster';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('gaster/overwrite_bg'));
			bg.setGraphicSize(Std.int(bg.width * 1.0));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			stageFront = new FlxSprite(-600, -200).loadGraphic(Paths.image('gaster/overwrite_light'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.0));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.alpha = 0.7;
			stageFront.active = false;
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			gaster = new FlxSprite(-500, 500);
			gaster.frames = hallowTex;
			gaster.animation.addByPrefix('idle', 'fire_iddle');
			gaster.animation.play('idle');
			gaster.antialiasing = true;
			add(gaster);
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster1:FlxSprite = new FlxSprite(-150, 300);
			gaster1.frames = hallowTex;
			gaster1.animation.addByPrefix('idle', 'fire_iddle');
			gaster1.animation.play('idle');
			gaster1.antialiasing = true;
			add(gaster1);
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster2:FlxSprite = new FlxSprite(100, 50);
			gaster2.frames = hallowTex;
			gaster2.animation.addByPrefix('idle', 'fire_iddle');
			gaster2.animation.play('idle');
			gaster2.antialiasing = true;
			add(gaster2);

			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster3:FlxSprite = new FlxSprite(900, 50);
			gaster3.frames = hallowTex;
			gaster3.animation.addByPrefix('idle', 'fire_iddle');
			gaster3.animation.play('idle');
			gaster3.antialiasing = true;
			add(gaster3);

			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster4:FlxSprite = new FlxSprite(1250, 300);
			gaster4.frames = hallowTex;
			gaster4.animation.addByPrefix('idle', 'fire_iddle');
			gaster4.animation.play('idle');
			gaster4.antialiasing = true;
			add(gaster4);
			var hallowTex = Paths.getSparrowAtlas('gaster/rpgfire');
			var gaster5:FlxSprite = new FlxSprite(1600, 500);
			gaster5.frames = hallowTex;
			gaster5.animation.addByPrefix('idle', 'fire_iddle');
			gaster5.animation.play('idle');
			gaster5.antialiasing = true;

			add(gaster5);
			FlxTween.tween(stageFront, {alpha: 1,}, 2.5, {type: FlxTween.PINGPONG, startDelay: 0.0});
		}
		else if (SONG.song.toLowerCase() == 'light-it-up'
			|| SONG.song.toLowerCase() == 'ruckus'
			|| SONG.song.toLowerCase() == 'target-practice')
		{
			defaultCamZoom = 0.8;
			curStage = 'swordarena';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('arena-bg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.setGraphicSize(Std.int(bg.width * 1));
			bg.active = false;
			add(bg);

			var bgBoppers:FlxSprite = new FlxSprite(-600, 140);
			bgBoppers.frames = Paths.getSparrowAtlas('arena-characters');
			bgBoppers.animation.addByPrefix('bop', "bg-characters", 24);
			bgBoppers.animation.play('bop');
			bgBoppers.antialiasing = true;
			bgBoppers.scrollFactor.set(0.99, 0.9);
			bgBoppers.setGraphicSize(Std.int(bgBoppers.width * 1));
			bgBoppers.updateHitbox();
			add(bgBoppers);

			var bgRail:FlxSprite = new FlxSprite(-600, 320).loadGraphic(Paths.image('railing'));
			bgRail.antialiasing = true;
			bgRail.scrollFactor.set(0.9, 0.9);
			bgRail.active = false;
			bgRail.setGraphicSize(Std.int(bgRail.width * 1));
			bgRail.updateHitbox();
			add(bgRail);
		}
		else if (SONG.song.toLowerCase() == 'sporting' || SONG.song.toLowerCase() == 'boxing-match')
		{
			defaultCamZoom = 0.9;
			curStage = 'arenanight';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('boxingnight1'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0, 0);
			bg.setGraphicSize(Std.int(bg.width * 1));
			bg.active = false;
			add(bg);

			var bg2:FlxSprite = new FlxSprite(-800, -200).loadGraphic(Paths.image('boxingnight2'));
			bg2.antialiasing = true;
			bg2.scrollFactor.set(1.2, 1.2);
			bg2.setGraphicSize(Std.int(bg.width * 1.3));
			bg2.active = false;
			add(bg2);

			var bg3:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('boxingnight3'));
			bg3.antialiasing = true;
			bg3.scrollFactor.set(0.9, 0.9);
			bg3.setGraphicSize(Std.int(bg.width * 0.9));
			bg3.active = false;
			add(bg3);
		}
		else if (SONG.song.toLowerCase() == 'inkingmistake')
		{
			defaultCamZoom = 0.7;
			curStage = 'inksans';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg0'));
			bg.setGraphicSize(Std.int(bg.width * 1.0));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			var squareoverwrite5:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg1'));
			squareoverwrite5.setGraphicSize(Std.int(squareoverwrite5.width * 1.0));
			squareoverwrite5.antialiasing = true;
			squareoverwrite5.scrollFactor.set(0.9, 0.9);
			squareoverwrite5.active = false;
			add(squareoverwrite5);
			var squareoverwrite4:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg2'));
			squareoverwrite4.setGraphicSize(Std.int(squareoverwrite4.width * 1.0));
			squareoverwrite4.antialiasing = true;
			squareoverwrite4.scrollFactor.set(0.9, 0.9);
			squareoverwrite4.active = false;
			add(squareoverwrite4);

			var squareoverwrite3:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg3'));
			squareoverwrite3.setGraphicSize(Std.int(squareoverwrite3.width * 1.0));
			squareoverwrite3.antialiasing = true;
			squareoverwrite3.scrollFactor.set(0.9, 0.9);
			squareoverwrite3.active = false;
			add(squareoverwrite3);

			var squareoverwrite2:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg4'));
			squareoverwrite2.setGraphicSize(Std.int(squareoverwrite2.width * 1.0));
			squareoverwrite2.antialiasing = true;
			squareoverwrite2.scrollFactor.set(0.9, 0.9);
			squareoverwrite2.active = false;
			add(squareoverwrite2);
			var squareoverwrite1:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg5'));
			squareoverwrite1.setGraphicSize(Std.int(squareoverwrite1.width * 1.0));
			squareoverwrite1.antialiasing = true;
			squareoverwrite1.scrollFactor.set(0.9, 0.9);
			squareoverwrite1.active = false;
			add(squareoverwrite1);
			var squareoverwrite:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/bg6'));
			squareoverwrite.setGraphicSize(Std.int(squareoverwrite.width * 1.0));
			squareoverwrite.antialiasing = true;
			squareoverwrite.scrollFactor.set(0.9, 0.9);
			squareoverwrite.active = false;
			add(squareoverwrite);

			var stageFront:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/ground'));
			stageFront.setGraphicSize(Std.int(bg.width * 1.0));
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
			gaster = new FlxSprite(-320, 70);
			var hallowTex = Paths.getSparrowAtlas('inksans/xgasterink');
			gaster.frames = hallowTex;
			gaster.animation.addByPrefix('idle', 'Xgasterink idle dance instance 1');
			gaster.animation.play('idle');
			gaster.antialiasing = true;
			add(gaster);
			FlxTween.tween(gaster, {alpha: 0.2, y: gaster.y - 50}, 2.0, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite, {alpha: 1, y: squareoverwrite.y - 50}, 4, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite1, {alpha: 1, y: squareoverwrite1.y - 50}, 3, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite2, {alpha: 1, y: squareoverwrite2.y - 50}, 2.7, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite3, {alpha: 1, y: squareoverwrite3.y - 50}, 5.2, {type: FlxTween.PINGPONG, startDelay: 0.0});
			FlxTween.tween(squareoverwrite4, {alpha: 1, y: squareoverwrite4.y - 50}, 4.2, {type: FlxTween.PINGPONG, startDelay: 0.0});

			var squareoverwrite6:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('inksans/fg'));
			squareoverwrite6.setGraphicSize(Std.int(squareoverwrite6.width * 1.0));
			squareoverwrite6.antialiasing = true;
			squareoverwrite6.scrollFactor.set(0.9, 0.9);
			squareoverwrite6.active = false;
			add(squareoverwrite6);
		}
		else if (SONG.song.toLowerCase() == 'ram')
		{
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-noon';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback-noon'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront-noon'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		}
		else if (SONG.song.toLowerCase() == 'popipo'
			|| SONG.song.toLowerCase() == 'siu'
			|| SONG.song.toLowerCase() == 'chug'
			|| SONG.song.toLowerCase() == 'disappearance'
			|| SONG.song.toLowerCase() == 'aishite')
		{
			defaultCamZoom = 0.9;
			curStage = 'miku';
			var bg:FlxSprite = new FlxSprite(-325, -50).loadGraphic(Paths.image('miku/stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
			upperBoppers = new FlxSprite(20, 670);
			upperBoppers.frames = Paths.getSparrowAtlas('miku/bunch_of_simps');
			upperBoppers.animation.addByPrefix('bop', "Downer Crowd Bob", 24, false);
			upperBoppers.antialiasing = true;
			upperBoppers.scrollFactor.set(0.9, 0.9);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.9));
			upperBoppers.updateHitbox();
		}
		else if (SONG.song.toLowerCase() == 'hello-world')
		{
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-night';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback-night'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront-night'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		}
		else if (SONG.song.toLowerCase() == 'glitcher')
		{
			defaultCamZoom = 0.9;
			curStage = 'hex-stage-hack';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback-hack'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront-hack'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		}
		else if (SONG.song.toLowerCase() == 'lo-fight' || SONG.song.toLowerCase() == 'overhead')
		{
			defaultCamZoom = 0.8;
			curStage = 'whitty-normal';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('whittyBack'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('whittyFront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		}
		else if (SONG.song.toLowerCase() == 'parish')
		{
			defaultCamZoom = 0.8;
			curStage = 'church-normal';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('bg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('floor'));
			bg1.antialiasing = true;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('pillars'));
			bg2.antialiasing = true;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
		}
		else if (SONG.song.toLowerCase() == 'casanova')
		{
			defaultCamZoom = 0.8;
			curStage = 'church-selever';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church4/bg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church4/floor'));
			bg1.antialiasing = true;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church4/pillars'));
			bg2.antialiasing = true;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
		}
		else if (SONG.song.toLowerCase() == 'worship')
		{
			defaultCamZoom = 0.8;
			curStage = 'church-dark';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('bg-dark'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('floor-dark'));
			bg1.antialiasing = true;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('pillars-dark'));
			bg2.antialiasing = true;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
		}
		else if (SONG.song.toLowerCase() == 'zavodila')
		{
			defaultCamZoom = 0.8;
			curStage = 'church-ruv';
			var bg:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church2/bg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church2/floor'));
			bg1.antialiasing = true;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church2/pillars'));
			bg2.antialiasing = true;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
			deadpill = new FlxSprite(-300, -600).loadGraphic(Paths.image('church2/pillarbroke'));
			deadpill.antialiasing = true;
			deadpill.scrollFactor.set(0.9, 0.9);
			deadpill.active = false;
		}
		else if (SONG.song.toLowerCase() == 'gospel')
		{
			defaultCamZoom = 0.8;
			curStage = 'church-final';
			var bg:FlxSprite = new FlxSprite(-300, -550).loadGraphic(Paths.image('church3/bg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var bg1:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church3/floor'));
			bg1.antialiasing = true;
			bg1.scrollFactor.set(0.9, 0.9);
			bg1.active = false;
			add(bg1);
			var bg2:FlxSprite = new FlxSprite(-300, -600).loadGraphic(Paths.image('church3/pillars'));
			bg2.antialiasing = true;
			bg2.scrollFactor.set(0.9, 0.9);
			bg2.active = false;
			add(bg2);
			curl1 = new FlxSprite(-300, -600).loadGraphic(Paths.image('church3/circ2'));
			curl1.antialiasing = true;
			curl1.scrollFactor.set(0.9, 0.9);
			curl1.active = false;

			curl2 = new FlxSprite(360, -300).loadGraphic(Paths.image('church3/circ1'));
			curl2.antialiasing = true;
			curl2.scrollFactor.set(0.9, 0.9);
			curl2.active = false;

			curl3 = new FlxSprite(-300, -600).loadGraphic(Paths.image('church3/circ0'));
			curl3.antialiasing = true;
			curl3.scrollFactor.set(0.9, 0.9);
			curl3.active = false;
			add(curl1);
			add(curl2);
			add(curl3);
		}
		else if (SONG.song.toLowerCase() == 'ballistic')
		{
			defaultCamZoom = 0.8;
			curStage = 'whitty-crazy';

			var hallowTex = Paths.getSparrowAtlas('BallisticBackground');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Background Whitty Moving', 24);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'foolhardy' || SONG.song.toLowerCase() == 'foolhardy-duet')
		{
			defaultCamZoom = 0.8;
			curStage = 'zardy';

			var hallowTex = Paths.getSparrowAtlas('Maze');
			halloweenBG = new FlxSprite(-600, -200);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Stage', 24);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'madness'
			|| SONG.song.toLowerCase() == 'improbable-outset'
			|| SONG.song.toLowerCase() == 'madness-duet'
			|| SONG.song.toLowerCase() == 'improbable-outset-duet')
		{
			defaultCamZoom = 0.9;
			curStage = 'tricky';

			var hallowTex = Paths.getSparrowAtlas('tricky_floor');
			halloweenBG = new FlxSprite(-1200, 150);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Symbol 1', 24);
			halloweenBG.antialiasing = true;

			var stageFront:FlxSprite = new FlxSprite(-600, -250).loadGraphic(Paths.image('red'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'madness-beatstreets' || SONG.song.toLowerCase() == 'improbable-outset-bs')
		{
			defaultCamZoom = 0.9;
			curStage = 'tricky-beat';

			var hallowTex = Paths.getSparrowAtlas('trickybeats/tricky_floor');
			halloweenBG = new FlxSprite(-1200, 150);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'Symbol 1', 24);
			halloweenBG.antialiasing = true;

			var stageFront:FlxSprite = new FlxSprite(-600, -250).loadGraphic(Paths.image('trickybeats/red'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'wife-forever' || SONG.song.toLowerCase() == 'sky')
		{
			defaultCamZoom = 0.9;
			curStage = 'sky';

			var hallowTex = Paths.getSparrowAtlas('bg_normal');
			halloweenBG = new FlxSprite(-200, 0);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'bg', 24);
			halloweenBG.antialiasing = true;
			halloweenBG.animation.play('idle');
			pissedsky = 0;
			ughsky = 0;
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'god-eater')
		{
			defaultCamZoom = 0.65;
			curStage = 'sky_shaggy';

			var sky = new FlxSprite(-850, -850);
			sky.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			sky.animation.addByPrefix('sky', "bg", 30);
			sky.setGraphicSize(Std.int(sky.width * 0.8));
			sky.animation.play('sky');
			sky.scrollFactor.set(0.1, 0.1);
			sky.antialiasing = true;
			add(sky);

			var bgcloud = new FlxSprite(-850, -1250);
			bgcloud.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			bgcloud.animation.addByPrefix('c', "cloud_smol", 30);
			// bgcloud.setGraphicSize(Std.int(bgcloud.width * 0.8));
			bgcloud.animation.play('c');
			bgcloud.scrollFactor.set(0.3, 0.3);
			bgcloud.antialiasing = true;
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
			fgcloud.antialiasing = true;
			add(fgcloud);

			// var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('shaggy/bg_lemon'));
			// bg.setGraphicSize(Std.int(bg.width * 1.5));
			// bg.antialiasing = true;
			// bg.scrollFactor.set(0.95, 0.95);
			// bg.active = false;
			// add(bg);

			// var techo = new FlxSprite(0, -20);
			// techo.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			// techo.animation.addByPrefix('r', "broken_techo", 30);
			// techo.setGraphicSize(Std.int(techo.frameWidth * 1.5));
			// techo.animation.play('r');
			// techo.scrollFactor.set(0.95, 0.95);
			// techo.antialiasing = true;
			// add(techo);

			gf_rock = new FlxSprite(260, 350);
			gf_rock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			gf_rock.animation.addByPrefix('rock', "gf_rock", 30);
			gf_rock.animation.play('rock');
			gf_rock.scrollFactor.set(0.8, 0.8);
			gf_rock.antialiasing = true;
			add(gf_rock);

			rock = new FlxSprite(600, 700);
			rock.frames = Paths.getSparrowAtlas('shaggy/god_bg');
			rock.animation.addByPrefix('rock', "rock", 30);
			rock.animation.play('rock');
			rock.scrollFactor.set(1, 1);
			rock.antialiasing = true;
			add(rock);
		}
		else if (SONG.song.toLowerCase() == 'manifest')
		{
			defaultCamZoom = 0.9;
			curStage = 'sky-mad';

			var hallowTex = Paths.getSparrowAtlas('bg_manifest');
			halloweenBG = new FlxSprite(-200, 0);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'bg', 24);
			halloweenBG.antialiasing = true;
			halloweenBG.animation.play('idle');
			pissedsky = 0;
			ughsky = 0;
			add(halloweenBG);
		}
		else if (SONG.song.toLowerCase() == 'tutorial-starcatcher'
			|| SONG.song.toLowerCase() == 'bopeebo-starcatcher'
			|| SONG.song.toLowerCase() == 'fresh-starcatcher'
			|| SONG.song.toLowerCase() == 'dadbattle-starcatcher')
		{
			defaultCamZoom = 0.9;
			curStage = 'stage-star';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('starcatcher/stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('starcatcher/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('starcatcher/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}
		else if (SONG.song.toLowerCase() == 'norway' || SONG.song.toLowerCase() == 'tordbot')
		{
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

			bg.antialiasing = true;
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
		}
		else if (SONG.song.toLowerCase() == 'headache'
			|| SONG.song.toLowerCase() == 'nerves'
			|| SONG.song.toLowerCase() == 'headache-duet'
			|| SONG.song.toLowerCase() == 'nerves-duet')
		{
			defaultCamZoom = 0.9;
			curStage = 'stage-cel';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagebg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStage'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);
		}
		else if (SONG.song.toLowerCase() == 'stronger'
			|| SONG.song.toLowerCase() == 'megalomaniac'
			|| SONG.song.toLowerCase() == 'reality-check')
		{
			defaultCamZoom = 0.9;
			curStage = 'sans';
			var bg:FlxSprite = new FlxSprite(-300, -200).loadGraphic(Paths.image('sans/Sansbg'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);
		}
		else if (SONG.song.toLowerCase() == 'release' || SONG.song.toLowerCase() == 'release-duet')
		{
			defaultCamZoom = 0.9;
			curStage = 'garl';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagebgAlt'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var hallowTex = Paths.getSparrowAtlas('stos/garSmoke');

			halloweenBG = new FlxSprite(150, 200);
			halloweenBG.frames = hallowTex;
			halloweenBG.setGraphicSize(Std.int(halloweenBG.width * 1.3));
			halloweenBG.animation.addByPrefix('idle', 'smokey instance');
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;

			var garded:FlxSprite = new FlxSprite(-250, 650).loadGraphic(Paths.image('stos/gardead'));

			garded.updateHitbox();
			garded.antialiasing = true;
			garded.scrollFactor.set(1.3, 1.3);
			garded.active = false;

			var stageCurtains:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stos/garStagealt'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.1));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;
			add(stageCurtains);
			add(garded);
			garlilman = 0;
		}
		else if (SONG.song.toLowerCase() == 'where-are-you'
			|| SONG.song.toLowerCase() == 'kaio-ken'
			|| SONG.song.toLowerCase() == 'eruption'
			|| SONG.song.toLowerCase() == 'blast'
			|| SONG.song.toLowerCase() == 'whats-new'
			|| SONG.song.toLowerCase() == 'super-saiyan')
		{
			// dad.powerup = true;
			defaultCamZoom = 0.9;
			curStage = 'stage_2';
			var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('shaggy/bg_lemon'));
			bg.setGraphicSize(Std.int(bg.width * 1.5));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.95, 0.95);
			bg.active = false;
			add(bg);

			if (SONG.song.toLowerCase() == 'kaio-ken')
			{
				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2); // creo que esta weá no hace nada
			}
		}
		else if (SONG.song.toLowerCase() == 'ugh' || SONG.song.toLowerCase() == 'guns')
		{
			defaultCamZoom = 0.9;
			curStage = 'tankman1';
			var bg:FlxSprite = new FlxSprite(-400, -300).loadGraphic(Paths.image('tank/tankSky'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.1, 0.1);
			bg.active = false;
			add(bg);

			var stageCurtains:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('tank/tankClouds'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.3));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(0.1, 0.1);
			stageCurtains.active = false;
			add(stageCurtains);
			var stageCurtains1:FlxSprite = new FlxSprite(-120, -100).loadGraphic(Paths.image('tank/tankMountains'));
			stageCurtains1.setGraphicSize(Std.int(stageCurtains.width * 0.7));
			stageCurtains1.updateHitbox();
			stageCurtains1.antialiasing = true;
			stageCurtains1.scrollFactor.set(0.1, 0.1);
			stageCurtains1.active = false;
			add(stageCurtains1);
			var stageCurtains2:FlxSprite = new FlxSprite(-180, 10).loadGraphic(Paths.image('tank/tankBuildings'));
			stageCurtains2.setGraphicSize(Std.int(stageCurtains2.width * 1.1));
			stageCurtains2.updateHitbox();
			stageCurtains2.antialiasing = true;
			stageCurtains2.scrollFactor.set(0.1, 0.1);
			stageCurtains2.active = false;
			add(stageCurtains2);
			var stageCurtains3:FlxSprite = new FlxSprite(-180, 10).loadGraphic(Paths.image('tank/tankRuins'));
			stageCurtains3.setGraphicSize(Std.int(stageCurtains3.width * 1.1));
			stageCurtains3.updateHitbox();
			stageCurtains3.antialiasing = true;
			stageCurtains3.scrollFactor.set(0.1, 0.1);
			stageCurtains3.active = false;
			add(stageCurtains3);
			var stageCurtains4:FlxSprite = new FlxSprite(-250, 40).loadGraphic(Paths.image('tank/tankGround'));
			stageCurtains4.setGraphicSize(Std.int(stageCurtains.width * 0.7));
			stageCurtains4.updateHitbox();
			stageCurtains4.antialiasing = true;
			stageCurtains4.scrollFactor.set(1.1, 1.1);
			stageCurtains4.active = false;
			add(stageCurtains4);
		}
		else if (SONG.song.toLowerCase() == 'stress')
		{
			defaultCamZoom = 0.9;
			curStage = 'tankman2';
			var bg:FlxSprite = new FlxSprite(-400, -300).loadGraphic(Paths.image('tank/tankSky'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.1, 0.1);
			bg.active = false;
			add(bg);

			var stageCurtains:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('tank/tankClouds'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.3));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(0.1, 0.1);
			stageCurtains.active = false;
			add(stageCurtains);
			var stageCurtains1:FlxSprite = new FlxSprite(-100, 100).loadGraphic(Paths.image('tank/tankMountains'));
			stageCurtains1.setGraphicSize(Std.int(stageCurtains.width * 0.7));
			stageCurtains1.updateHitbox();
			stageCurtains1.antialiasing = true;
			stageCurtains1.scrollFactor.set(0.1, 0.1);
			stageCurtains1.active = false;
			add(stageCurtains1);
			var stageCurtains2:FlxSprite = new FlxSprite(-150, 100).loadGraphic(Paths.image('tank/tankBuildings'));
			stageCurtains2.setGraphicSize(Std.int(stageCurtains2.width * 4.0));
			stageCurtains2.updateHitbox();
			stageCurtains2.antialiasing = true;
			stageCurtains2.scrollFactor.set(0.1, 0.1);
			stageCurtains2.active = false;
			add(stageCurtains2);
			var stageCurtains3:FlxSprite = new FlxSprite(-150, 100).loadGraphic(Paths.image('tank/tankRuins'));
			stageCurtains3.setGraphicSize(Std.int(stageCurtains3.width * 4.0));
			stageCurtains3.updateHitbox();
			stageCurtains3.antialiasing = true;
			stageCurtains3.scrollFactor.set(0.1, 0.1);
			stageCurtains3.active = false;
			add(stageCurtains3);
			var stageCurtains4:FlxSprite = new FlxSprite(-250, 0).loadGraphic(Paths.image('tank/tankGround'));
			stageCurtains4.setGraphicSize(Std.int(stageCurtains.width * 0.7));
			stageCurtains4.updateHitbox();
			stageCurtains4.antialiasing = true;
			stageCurtains4.scrollFactor.set(1.1, 1.1);
			stageCurtains4.active = false;
			add(stageCurtains4);
		}
		else if (SONG.song.toLowerCase() == 'always-running')
		{
			defaultCamZoom = 0.9;
			curStage = 'stage_tari';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('metarunner/stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('metarunner/stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('metarunner/stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}
		else
		{
			defaultCamZoom = 0.9;
			curStage = 'stage';
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}

		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'limo':
				gfVersion = 'gf-car';
			case 'tankman1':
				gfVersion = 'gftank';
			case 'church-dark':
				gfVersion = 'gf-dark';
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
			case 'limo-b':
				gfVersion = 'gf-car-b';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'mall-b' | 'mallEvil-b':
				gfVersion = 'gf-christmas-b';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'school-neon':
				gfVersion = 'gf-pixel-2';
			case 'school-neon-2':
				gfVersion = 'gf-pixel-3';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'school-b':
				gfVersion = 'gf-pixel-b';
			case 'schoolEvil-b':
				gfVersion = 'gf-pixel-b';
			case 'stage-neo':
				gfVersion = 'gf-neo';
			case 'stage-star':
				gfVersion = 'gf-star';
			case 'spooky-neo':
				gfVersion = 'gf-neo';
			case 'philly-neo':
				gfVersion = 'gf-neo';
			case 'stage-b':
				gfVersion = 'gf-b';
			case 'stage-beats':
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
		}

		if (curStage == 'limo')
			gfVersion = 'gf-car';

		if (curStage == 'limo-neo')
			gfVersion = 'gf-car-neo';

		if (curStage == 'limo-b')
			gfVersion = 'gf-car-b';
		if (curStage == 'limo-star')
			gfVersion = 'gf-car-star';

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

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
			case "spooky-neo":
				dad.y += 200;
			case "spooky-b":
				dad.y += 200;
			case "spooky-beat":
				dad.y += 200;
			case "ink":
				dad.y += 200;
				dad.x -= 100;
			case "spooky-star":
				dad.y += 200;
			case "gaw":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'annie2':
				dad.y += 130;
			case 'tricky-beat':
				dad.y += 55;
				dad.x -= 100;
			case 'tricky':
				dad.y += 55;
				dad.x -= 100;
			case 'hex-hack':
				dad.y += 65;
			case 'trickyMask':
				dad.y += 55;
				dad.x -= 100;
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
			case 'annie':
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
			case 'parents-christmas-b':
				dad.x -= 500;
			case 'senpai':
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
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
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
			case 'shaggy':
				camFollow.y = dad.getMidpoint().y - 100;
				camFollow.x = dad.getMidpoint().x - 100;
			case 'tord':
				dad.x = 214.2;
				dad.y = 55.4;
				camPos.set(218.75, 25.7);
			case 'tordbot':
				dad.x = -429.05;
				dad.y = -1424.75;
				camPos.set(391.2, -1094.15);
		}

		switch bfsel
		{
			case 0:
				boyfriend = new Boyfriend(770, 450, 'bf');
			case 1:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas');
			case 2:
				boyfriend = new Boyfriend(770, 450, 'bf-pixel');
			case 3:
				boyfriend = new Boyfriend(770, 150, 'dad');
			case 4:
				boyfriend = new Boyfriend(770, 250, 'spooky');
			case 5:
				boyfriend = new Boyfriend(770, 150, 'monster');
			case 6:
				boyfriend = new Boyfriend(770, 350, 'pico');
			case 7:
				boyfriend = new Boyfriend(770, 150, 'mom');
			case 8:
				boyfriend = new Boyfriend(770, 150, 'parents-christmas');
			case 9:
				boyfriend = new Boyfriend(770, 150, 'monster-christmas');
			case 10:
				boyfriend = new Boyfriend(900, 450, 'senpai');
			case 11:
				boyfriend = new Boyfriend(900, 450, 'senpai-angry');
			case 12:
				boyfriend = new Boyfriend(770, 250, 'spirit');
			case 13:
				boyfriend = new Boyfriend(770, 420, 'annie');
			case 14:
				boyfriend = new Boyfriend(770, 200, 'annie2');
			case 15:
				boyfriend = new Boyfriend(770, 150, 'anders');
			case 16:
				boyfriend = new Boyfriend(770, 150, 'anders-fearsome');
			case 17:
				boyfriend = new Boyfriend(770, 450, 'bf-b');
			case 18:
				boyfriend = new Boyfriend(770, 450, 'bf-christmas-b');
			case 19:
				boyfriend = new Boyfriend(770, 450, 'bf-pixel-b');
			case 20:
				boyfriend = new Boyfriend(770, 150, 'dad-b');
			case 21:
				boyfriend = new Boyfriend(770, 250, 'spooky-b');
			case 22:
				boyfriend = new Boyfriend(770, 350, 'pico-b');
			case 23:
				boyfriend = new Boyfriend(770, 150, 'mom-b');
			case 24:
				boyfriend = new Boyfriend(770, 150, 'parents-christmas-b');
			case 25:
				boyfriend = new Boyfriend(770, 150, 'monster-christmas-b');
			case 26:
				boyfriend = new Boyfriend(900, 450, 'senpai-b');
			case 27:
				boyfriend = new Boyfriend(900, 450, 'senpai-angry-b');
			case 28:
				boyfriend = new Boyfriend(770, 250, 'spirit-b');
			default:
				boyfriend = new Boyfriend(770, 450, SONG.player1);
		}

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'tankman1':
				gf.x -= 200;
				dad.x -= 150;
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
			case 'tricky':
				gf.y -= 100;
				boyfriend.x += 150;
				boyfriend.y -= 30;
			case 'tricky-beat':
				gf.y -= 100;
				boyfriend.x += 150;
				boyfriend.y -= 30;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
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
		}

		// Shitty layering but whatev it works LOL - Yeah Ninjamuffin it works lmfao
		if (curStage == 'limo')
			add(limo);
		if (curStage == 'limo-neo')
			add(limo);
		if (curStage == 'limo-b')
			add(limo);
		if (curStage == 'limo-fl')
			add(limo);
		if (curStage == 'limo-star')
			add(gf);
		add(limo);
		if (curStage == 'touhou')
			add(limo);

		if (curStage != 'tankman2')
			if (curStage != 'limo-star')
				if (curStage != 'eddhouse')
					add(gf);
		if (curStage == 'church-ruv')
			add(deadpill);
		add(dad);
		add(boyfriend);
		if (curStage == 'miku')
			add(upperBoppers);
		if (curStage == 'chara')
			add(stageFront);
		if (curStage == 'xgaster')
			add(stageFront);
		if (curStage == 'garl')
			add(halloweenBG);
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		if (curStage == 'church-final')
			FlxTween.tween(dad, {alpha: 1, y: dad.y - 70}, 3.5, {type: FlxTween.PINGPONG, startDelay: 0.0});

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		if (FlxG.save.data.down == 'down')
			strumLine = new FlxSprite(10, 600).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

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

		if (FlxG.save.data.down == 'down')
		{
			healthBarBG = new FlxSprite(0, FlxG.height * 0.1).loadGraphic(Paths.image('healthBar'));
			healthBarBG.screenCenter(X);
			healthBarBG.scrollFactor.set();
			add(healthBarBG);

			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
			healthBar.scrollFactor.set();
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			// healthBar
			add(healthBar);
		}
		else
		{
			healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
			healthBarBG.screenCenter(X);
			healthBarBG.scrollFactor.set();
			add(healthBarBG);

			healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
			healthBar.scrollFactor.set();
			healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			// healthBar
			add(healthBar);
		}
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

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		songtxt.cameras = [camHUD];

		doof.cameras = [camHUD];

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
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
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
				case 'senpai-duet':
					schoolIntro(doof);
				case 'roses-duet':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns-duet':
					schoolIntro(doof);
				case 'senpai-b-sides':
					schoolIntro(doof);
				case 'roses-b-sides':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns-b-sides':
					schoolIntro(doof);
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

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
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
			|| SONG.song.toLowerCase() == 'thorns-b-sides')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns'
				|| SONG.song.toLowerCase() == 'thorns-b-sides'
				|| SONG.song.toLowerCase() == 'thorns-duet')
			{
				add(red);
			}
		}

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

					if (SONG.song.toLowerCase() == 'thorns' || SONG.song.toLowerCase() == 'thorns-b-sides')
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

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;
	var noticeB:Array<FlxText> = [];
	var nShadowB:Array<FlxText> = [];

	function startCountdown():Void
	{
		inCutscene = false;
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

					if (FlxG.save.data.controlstype == 'qwop')
					{
						cText = "Q      W      E      I      O      P";
					}

					if (FlxG.save.data.controlstype == 'dfjk')
					{
						cText = "S      D      F      J      K      L";
					}

					notice = new FlxText(0, 0, 0, cText, 32);
					notice.x = FlxG.width * 0.572;
					notice.y = 120;
					if (FlxG.save.data.down == 'down')
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
						if (FlxG.save.data.down == 'down')
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

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3'), 0.6);
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
					FlxG.sound.play(Paths.sound('intro2'), 0.6);
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
					FlxG.sound.play(Paths.sound('intro1'), 0.6);
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
					FlxG.sound.play(Paths.sound('introGo'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = endSong;
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

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % mn);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] >= mn)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					if (FlxG.save.data.down == 'down')
						var sustainNote:Note = new Note(daStrumTime - (Conductor.stepCrochet * susNote) - Conductor.stepCrochet, daNoteData, oldNote, true);
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
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					babyArrow.antialiasing = true;
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

	public function godIntro()
	{
		dad.playAnim('back', true);
		new FlxTimer().start(3, function(tmr:FlxTimer)
		{
			dad.playAnim('snap', true);
			new FlxTimer().start(0.85, function(tmr2:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('snap'));
				FlxG.sound.play(Paths.sound('undSnap'));
				sShake = 10;
				// pon el sonido con los efectos circulares
				new FlxTimer().start(0.06, function(tmr3:FlxTimer)
				{
					dad.playAnim('snapped', true);
				});
				new FlxTimer().start(1.5, function(tmr4:FlxTimer)
				{
					// la camara tiembla y puede ser que aparezcan rocas?
					new FlxTimer().start(0.001, function(shkUp:FlxTimer)
					{
						sShake += 0.51;
						if (!godCutEnd)
							shkUp.reset(0.001);
					});
					new FlxTimer().start(1, function(tmr5:FlxTimer)
					{
						add(new MansionDebris(-300, -120, 'ceil', 1, 1, -4, -40));
						add(new MansionDebris(0, -120, 'ceil', 1, 1, -4, -5));
						add(new MansionDebris(200, -120, 'ceil', 1, 1, -4, 40));

						sShake += 5;
						FlxG.sound.play(Paths.sound('ascend'));
						boyfriend.playAnim('hit');
						godCutEnd = true;
						new FlxTimer().start(0.4, function(tmr6:FlxTimer)
						{
							godMoveGf = true;
							boyfriend.playAnim('hit');
						});
						new FlxTimer().start(1, function(tmr9:FlxTimer)
						{
							boyfriend.playAnim('scared', true);
						});
						new FlxTimer().start(2, function(tmr7:FlxTimer)
						{
							dad.playAnim('idle', true);
							FlxG.sound.play(Paths.sound('shagFly'));
							godMoveSh = true;
							new FlxTimer().start(1.5, function(tmr8:FlxTimer)
							{
								startCountdown();
							});
						});
					});
				});
			});
		});
		new FlxTimer().start(0.001, function(shk:FlxTimer)
		{
			if (sShake > 0)
			{
				sShake -= 0.5;
				FlxG.camera.angle = FlxG.random.float(-sShake, sShake);
			}
			shk.reset(0.001);
		});
	}

	var sShake:Float = 0;

	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

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

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

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

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-2':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'carol':
						camFollow.y = dad.getMidpoint().y + 100;
						camFollow.x = dad.getMidpoint().x + 270;
					case 'xchara':
						camFollow.y = dad.getMidpoint().y - 20;
					case 'belle':
						camFollow.y = dad.getMidpoint().y + 100;
					case 'monika':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
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
				if (SONG.player2 == "tordbot")
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

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
					case 'limo-b':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'mall-b':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school-neon':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 240;
					case 'schoolEvil':
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
				}

				if (SONG.song.toLowerCase() == 'tutorial-starcatcher')
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
		if (controls.RESET)
		{
			FlxG.resetState();
			trace("RESET = True");
		}

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
				if (FlxG.save.data.down == 'down')
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

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
					{
						if (SONG.notes[Math.floor(curStep / 16)].altAnim)
							altAnim = '-alt';
					}

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

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (FlxG.save.data.down == 'down')
				{
					if (daNote.y >= (strumLine.y + 106))
					{
						if (daNote.isSustainNote && daNote.wasGoodHit)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
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

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else
				{
					if (daNote.y < -daNote.height)
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
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
						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			});
		}

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
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
					NGio.unlockMedal(60961);
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

	private function popUpScore(strumtime:Float):Void
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

		if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
		{
			daRating = 'shit';
			score = 50;
			if (sickmode == "Yes")
			{
				FlxG.resetState();
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
		{
			daRating = 'bad';
			score = 100;
			if (sickmode == "Yes")
			{
				FlxG.resetState();
			}
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
		{
			daRating = 'good';
			score = 200;
			if (sickmode == "Yes")
			{
				FlxG.resetState();
			}
		}
		else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
		{
			score = 350;

			daRating = "sick";
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
			else
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
		}
		if (curStage.endsWith('-b'))
		{
			pixelShitPart1 = 'b/';
			pixelShitPart2 = '';
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
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
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
				numScore.antialiasing = true;
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
		if (!boyfriend.stunned)
		{
			if (PauseSubState.babymode == "No")
			{
				health -= 0.04;
				if (combo > 5 && gf.animOffsets.exists('sad'))
				{
					gf.playAnim('sad');
				}
				combo = 0;
				songMiss += 1;
				if (PauseSubState.sickmode == "Yes")
				{
					FlxG.resetState();
				}

				songScore -= 10;

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
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
				combo -= 0.0000000000000000001;
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

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

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (dad.curCharacter == 'garcellodead')
		{
			if (curStep == 835)
				garlilman = 1;
			if (curStep == 847)
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
		if (dad.curCharacter == 'tankman' && curStep > 734 && SONG.song.toLowerCase() == 'stress')
		{
			if (curStep == 735)
				tankmangood = 1;
			if (curStep == 763)
				tankmangood = 0;
		}
		if (dad.curCharacter == 'garcellodead' && curStep == 837)
		{
			dad.playAnim('ugh', true);
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
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
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.playAnim('idle');
		}

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				dad.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();
			case 'school-b':
				bgGirls.dance();

			case 'mall':
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
		}
	}
}

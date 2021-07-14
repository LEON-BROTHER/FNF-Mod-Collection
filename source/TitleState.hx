package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var undertaleenter:Bool = false;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var nexttext:Bool = false;
	var undertale:Bool = false;
	var minecraft:Bool = false;
	var dialogue:Alphabet;
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueList:Array<String> = [];
	var manyyear:Int = 0;
	var menustart:Int = 0;

	var swagDialogue:FlxTypeText;

	

	public var finishThing:Void->Void;


	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT

		super.create();

		

		FlxG.save.bind('funkin', 'ninjamuffin99');

		if (FlxG.save.data.controlstype == null)
			FlxG.save.data.controlstype = 'wasd';
		if (FlxG.save.data.down == null)
			FlxG.save.data.down = 'up';
		if (FlxG.save.data.week7Cut == null)
			FlxG.save.data.week7Cut = 'Yes';
		if (FlxG.save.data.bobCrash == null)
			FlxG.save.data.bobCrash = 'No';
		FlxG.save.flush();
		trace('Controls: ' + FlxG.save.data.controlstype);
		trace('Week 7 Cutscene: ' + FlxG.save.data.week7Cut);
		trace('Bob Crash: ' + FlxG.save.data.bobCrash);
		trace('Scroll?: ' + FlxG.save.data.down);

		CachedFrames.loadEverything();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}
		menustart = FlxG.random.int(1, 10);

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (menustart == 3)
				undertale = true;
			else if (menustart == 5)
				minecraft = true;
			else
				trace('no special start shit');
			

			startIntro();
		});
		#end

		#if desktop
		DiscordClient.initialize();
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			if (undertale)
				{
				FlxG.sound.playMusic(Paths.music('undertalebegin'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
				}
			if (!minecraft && !undertale)
				{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
				}

			
		}

		
		persistentUpdate = true;

		
		FlxG.mouse.visible = false;

		if (!undertale && !minecraft)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);
		Conductor.changeBPM(102);
		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		
		
		
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('start_rss');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
		}
		else if (minecraft)
		{
			var bgback:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('minecraft/bg'));
			bgback.screenCenter(X);
			bgback.screenCenter(Y);
			add(bgback);
			var bgun:FlxSprite = new FlxSprite(-900 ,570).makeGraphic(1280, 50, FlxColor.WHITE);
			add(bgun);
			var bgback1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('minecraft/load'));
			bgback1.screenCenter(X);
			bgback1.screenCenter(Y);
			add(bgback1);
			
			
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
			FlxTween.tween(bgun, {x: bgun.x + 40}, 2.0, {startDelay: 0.0});																										
			new FlxTimer().start(4, function(tmr:FlxTimer)
				{
				FlxTween.tween(bgun, {x: bgun.x + 200}, 1.0, {startDelay: 0.0});																										
				new FlxTimer().start(2, function(tmr:FlxTimer)
					{
					FlxTween.tween(bgun, {x: bgun.x + 100}, 6.0, {startDelay: 0.0});																										
					new FlxTimer().start(7, function(tmr:FlxTimer)
						{
						FlxTween.tween(bgun, {x: bgun.x + 500}, 4.0, {startDelay: 0.0});																										
						new FlxTimer().start(5, function(tmr:FlxTimer)
							{
								new FlxTimer().start(0.1, function(tmr:FlxTimer)
									{
										FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
										FlxG.sound.music.fadeIn(4, 0, 0.7);
										// Get current version of Kade Engine
										
										var http = new haxe.Http("https://raw.githubusercontent.com/LEON-BROTHER/mod-version/main/update.txt");
										var returnedData:Array<String> = [];
										
										http.onData = function (data:String)
										{
											returnedData[0] = data.substring(0, data.indexOf(';'));
											returnedData[1] = data.substring(data.indexOf('-'), data.length);
											  if (!MainMenuState.modversion.contains(returnedData[0].trim()) && !OutdatedSubState.leftState)
											{
												trace('outdated lmao! ' + returnedData[0] + ' != ' + MainMenuState.modversion);
												OutdatedSubState.needVer = returnedData[0];
												OutdatedSubState.currChanges = returnedData[1];
												FlxG.switchState(new OutdatedSubState());
											}
											else
											{
												FlxG.switchState(new MainMenuState());
											}
										}
										
										http.onError = function (error) {
										  trace('error: $error');
										  FlxG.switchState(new MainMenuState()); // fail but we go anyway
										}
										
										http.request();
									});																									
							
							});
						});
					});
				});
			});

		}
		else
		{
			
			dialogueList = CoolUtil.coolTextFile(Paths.txt('undertale/dialog'));
			var undertaleintro11:FlxSprite = new FlxSprite(480, -200).loadGraphic(Paths.image('undertale/intro11'));
			undertaleintro11.updateHitbox();
			undertaleintro11.setGraphicSize(Std.int(undertaleintro11.width * 2.5));
			undertaleintro11.visible = false;
		
			
			add(undertaleintro11);
			var undertaleintro0:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro0'));
			undertaleintro0.updateHitbox();
			undertaleintro0.setGraphicSize(Std.int(undertaleintro0.width * 2.5));
			undertaleintro0.screenCenter(X);
			undertaleintro0.screenCenter(Y);
			add(undertaleintro0);
			
			var undertaleintro1:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro1'));
			undertaleintro1.updateHitbox();
			undertaleintro1.setGraphicSize(Std.int(undertaleintro1.width * 2.5));
			undertaleintro1.screenCenter(X);
			undertaleintro1.screenCenter(Y);
			add(undertaleintro1);
			undertaleintro1.visible = false;
			var undertaleintro2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro2'));
			undertaleintro2.updateHitbox();
			undertaleintro2.setGraphicSize(Std.int(undertaleintro2.width * 2.5));
			undertaleintro2.screenCenter(X);
			undertaleintro2.screenCenter(Y);
			add(undertaleintro2);
			undertaleintro2.visible = false;
			var undertaleintro3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro3'));
			undertaleintro3.updateHitbox();
			undertaleintro3.setGraphicSize(Std.int(undertaleintro3.width * 2.5));
			undertaleintro3.screenCenter(X);
			undertaleintro3.screenCenter(Y);
			add(undertaleintro3);
			undertaleintro3.visible = false;
			var undertaleintro4:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro4'));
			undertaleintro4.updateHitbox();
			undertaleintro4.setGraphicSize(Std.int(undertaleintro4.width * 2.5));
			undertaleintro4.screenCenter(X);
			undertaleintro4.screenCenter(Y);
			add(undertaleintro4);
			undertaleintro4.visible = false;
			var undertaleintro5:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro5'));
			undertaleintro5.updateHitbox();
			undertaleintro5.setGraphicSize(Std.int(undertaleintro5.width * 2.5));
			undertaleintro5.screenCenter(X);
			undertaleintro5.screenCenter(Y);
			add(undertaleintro5);
			undertaleintro5.visible = false;
			var undertaleintro6:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro6'));
			undertaleintro6.updateHitbox();
			undertaleintro6.setGraphicSize(Std.int(undertaleintro6.width * 2.5));
			undertaleintro6.screenCenter(X);
			undertaleintro6.screenCenter(Y);
			add(undertaleintro6);
			undertaleintro6.visible = false;
			var undertaleintro7:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro7'));
			undertaleintro7.updateHitbox();
			undertaleintro7.setGraphicSize(Std.int(undertaleintro7.width * 2.5));
			undertaleintro7.screenCenter(X);
			undertaleintro7.screenCenter(Y);
			add(undertaleintro7);
			undertaleintro7.visible = false;
			var undertaleintro8:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro8'));
			undertaleintro8.updateHitbox();
			undertaleintro8.setGraphicSize(Std.int(undertaleintro8.width * 2.5));
			undertaleintro8.screenCenter(X);
			undertaleintro8.screenCenter(Y);
			add(undertaleintro8);
			undertaleintro8.visible = false;
			var undertaleintro9:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro9'));
			undertaleintro9.updateHitbox();
			undertaleintro9.setGraphicSize(Std.int(undertaleintro9.width * 2.5));
			undertaleintro9.screenCenter(X);
			undertaleintro9.screenCenter(Y);
			add(undertaleintro9);
			undertaleintro9.visible = false;
			var undertaleintro10:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/intro10'));
			undertaleintro10.updateHitbox();
			undertaleintro10.setGraphicSize(Std.int(undertaleintro10.width * 2.5));
			undertaleintro10.screenCenter(X);
			undertaleintro10.screenCenter(Y);
			add(undertaleintro10);
			undertaleintro10.visible = false;
			var bgund:FlxSprite = new FlxSprite(350 ,0).makeGraphic(600, 130, FlxColor.BLACK);
			add(bgund);
			var bgun:FlxSprite = new FlxSprite(350 ,405).makeGraphic(600, 700, FlxColor.BLACK);
			add(bgun);

			var hasDialog = true;
		
		swagDialogue = new FlxTypeText(300, 500, Std.int(FlxG.width * 0.6), "", 50);
		swagDialogue.font = 'Determination Mono Web';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('sound'), 0.6)];
		
		add(swagDialogue);
		dialogue = new Alphabet(0, 80, "", false, true);
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		add(bg);
		

		new FlxTimer().start(7, function(tmr:FlxTimer)
			{
				FlxG.camera.flash(FlxColor.BLACK, 1);
				undertaleintro0.visible = false;
				undertaleintro1.visible = true;
				nexttext = true;
				new FlxTimer().start(5, function(tmr:FlxTimer)
					{
						FlxG.camera.flash(FlxColor.BLACK, 1);
						undertaleintro1.visible = false;
						undertaleintro2.visible = true;
						nexttext = true;
						new FlxTimer().start(5, function(tmr:FlxTimer)
							{
								FlxG.camera.flash(FlxColor.BLACK, 1);
								undertaleintro2.visible = false;
								undertaleintro3.visible = true;
								nexttext = true;
								new FlxTimer().start(5, function(tmr:FlxTimer)
									{
										FlxG.camera.flash(FlxColor.BLACK, 1);
										undertaleintro3.visible = false;
										undertaleintro4.visible = true;
										manyyear = 1;
										nexttext = true;
										new FlxTimer().start(5, function(tmr:FlxTimer)
											{
												FlxG.camera.flash(FlxColor.BLACK, 1);
												undertaleintro4.visible = false;
												undertaleintro5.visible = true;
												
												nexttext = true;
												new FlxTimer().start(5, function(tmr:FlxTimer)
													{
														FlxG.camera.flash(FlxColor.BLACK, 1);
														undertaleintro5.visible = false;
														undertaleintro6.visible = true;
														
														nexttext = true;
														
														new FlxTimer().start(5, function(tmr:FlxTimer)
															{
																FlxG.camera.flash(FlxColor.BLACK, 1);
																undertaleintro6.visible = false;
																undertaleintro7.visible = true;
																nexttext = true;
																
																new FlxTimer().start(5, function(tmr:FlxTimer)
																	{
																		FlxG.camera.flash(FlxColor.BLACK, 1);
																		undertaleintro7.visible = false;
																		undertaleintro8.visible = true;
																		new FlxTimer().start(5, function(tmr:FlxTimer)
																			{
																				FlxG.camera.flash(FlxColor.BLACK, 1);
																				undertaleintro8.visible = false;
																				undertaleintro9.visible = true;
																				new FlxTimer().start(5, function(tmr:FlxTimer)
																					{
																						FlxG.camera.flash(FlxColor.BLACK, 1);
																						undertaleintro9.visible = false;
																						undertaleintro10.visible = true;
																						
																						new FlxTimer().start(5, function(tmr:FlxTimer)
																							{
																								FlxG.camera.flash(FlxColor.BLACK, 1);
																								undertaleintro10.visible = false;
																								undertaleintro11.visible = true;
																								new FlxTimer().start(5, function(tmr:FlxTimer)
																									{
																										FlxTween.tween(undertaleintro11, {y: undertaleintro11.y + 500}, 10.0, {startDelay: 0.0});
																										new FlxTimer().start(10, function(tmr:FlxTimer)
																											{
																												FlxTween.tween(bg, {alpha: 1}, 8.0, {startDelay: 0.0});
																												new FlxTimer().start(10, function(tmr:FlxTimer)
																													{
																														
																														titlescreen();
				
																													});
		
																											});
																									});
																								
																							});
																					});
																				
																			});
																		
																	});
															});
													});
											});
									});
							});
					});
			});
		}
	}
	function titlescreen()
	{
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.sound('intro'), 1);
		var undertalelogo:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/cool'));
			undertalelogo.updateHitbox();
			undertalelogo.setGraphicSize(Std.int(undertalelogo.width * 0.8));
			undertalelogo.screenCenter(X);
			undertalelogo.screenCenter(Y);
			undertalelogo.y -= 50;
			add(undertalelogo);
			new FlxTimer().start(2, function(tmr:FlxTimer)
				{
					
				
					var undertalelenterimg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('undertale/enter'));
					undertalelenterimg.updateHitbox();
					undertalelenterimg.setGraphicSize(Std.int(undertalelenterimg.width * 0.8));
					undertalelenterimg.screenCenter(X);
					undertalelenterimg.screenCenter(Y);
					undertalelenterimg.alpha = 0.5;
					undertalelenterimg.y += 70;
					add(undertalelenterimg);
					undertaleenter = true;
				});
			
	
				

	}
	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	var once:Bool = false;

	override function update(elapsed:Float)
	{
		

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (!undertale && !minecraft) 
		{	
		if (pressedEnter && !transitioning && skippedIntro)
		{
		

			titleText.animation.play('press');

			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;

			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Get current version of Kade Engine
				
				var http = new haxe.Http("https://raw.githubusercontent.com/LEON-BROTHER/mod-version/main/update.txt");
				var returnedData:Array<String> = [];
				
				http.onData = function (data:String)
				{
					returnedData[0] = data.substring(0, data.indexOf(';'));
					returnedData[1] = data.substring(data.indexOf('-'), data.length);
				  	if (!MainMenuState.modversion.contains(returnedData[0].trim()) && !OutdatedSubState.leftState)
					{
						trace('outdated lmao! ' + returnedData[0] + ' != ' + MainMenuState.modversion);
						OutdatedSubState.needVer = returnedData[0];
						OutdatedSubState.currChanges = returnedData[1];
						FlxG.switchState(new OutdatedSubState());
					}
					else
					{
						FlxG.switchState(new MainMenuState());
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				}
				
				http.request();
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && CachedFrames.cachedInstance.loaded && canSkip)
		{
			skipIntro();
		}
		}
		else if (minecraft)
		{

		}
		else
	
		{	
			swagDialogue.color = FlxColor.WHITE;

			
			

			dialogueOpened = true;
	
	if (dialogueOpened && !dialogueStarted)
	{
		startDialogue();
		dialogueStarted = true;
	}

	if (nexttext && dialogueStarted)
	{
		nexttext = false;
		remove(dialogue);

		

		if (dialogueList[1] == null && dialogueList[0] != null)
		{
			if (!isEnding)
			{
				isEnding = true;

				

				
				
					swagDialogue.alpha = 0;
				
				
			}	
		}
		else
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
	}
		if (undertaleenter && pressedEnter)
		{
			new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					// Get current version of Kade Engine
					
					var http = new haxe.Http("https://raw.githubusercontent.com/LEON-BROTHER/mod-version/main/update.txt");
					var returnedData:Array<String> = [];
					
					http.onData = function (data:String)
					{
						returnedData[0] = data.substring(0, data.indexOf(';'));
						returnedData[1] = data.substring(data.indexOf('-'), data.length);
						  if (!MainMenuState.modversion.contains(returnedData[0].trim()) && !OutdatedSubState.leftState)
						{
							trace('outdated lmao! ' + returnedData[0] + ' != ' + MainMenuState.modversion);
							OutdatedSubState.needVer = returnedData[0];
							OutdatedSubState.currChanges = returnedData[1];
							FlxG.switchState(new OutdatedSubState());
						}
						else
						{
							FlxG.switchState(new MainMenuState());
						}
					}
					
					http.onError = function (error) {
					  trace('error: $error');
					  FlxG.switchState(new MainMenuState()); // fail but we go anyway
					}
					
					http.request();
				});	
		}
	
	}
	

		

		super.update(elapsed);
	}
	
	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
if (manyyear == 1)
		swagDialogue.start(0.08, true);
else
	swagDialogue.start(0.04, true);
	}

		

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		
		
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}

	var canSkip = false;

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (!undertale && !minecraft)
		{
		logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (danceLeft)
		{
			gfDance.animation.play('danceRight');
			
		}
		else
		{
			gfDance.animation.play('danceLeft');
		
		}
		FlxG.log.add(curBeat);

		if (FlxG.save.data.titleChanges == 'Yes')
		{
			switch (curBeat)
			{
				case 5:
					createCoolText(['leon brother', 'TheGabenZone', 'the makers of', 'fnf', 'and the mod makers']);
				// credTextShit.visible = true;
				case 6:
					addMoreText('present');
				// credTextShit.text += '\npresent...';
				// credTextShit.addText();
				case 7:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = 'In association \nwith';
				// credTextShit.screenCenter();
				case 9:
					createCoolText([curWacky[0]]);
				// credTextShit.visible = true;
				case 11:
					addMoreText(curWacky[1]);
				// credTextShit.text += '\nlmao';
				case 12:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = "Friday";
				// credTextShit.screenCenter();
				case 13:
					addMoreText('Friday');
				// credTextShit.visible = true;
				case 14:
					addMoreText('Night');
				// credTextShit.text += '\nNight';
				case 15:
					addMoreText('Funkin');
					addMoreText('mod collection'); // credTextShit.text += '\nFunkin';

				case 16:
					skipIntro();

				
			}
		}
		else
		{
			switch (curBeat)
			{
				case 5:
					createCoolText(['leon brother', 'TheGabenZone', 'the makers of', 'fnf', 'and the mod makers']);
				// credTextShit.visible = true;
				case 6:
					addMoreText('present');
				// credTextShit.text += '\npresent...';
				// credTextShit.addText();
				case 7:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = 'In association \nwith';
				// credTextShit.screenCenter();
				case 9:
					createCoolText([curWacky[0]]);
				// credTextShit.visible = true;
				case 11:
					addMoreText(curWacky[1]);
				// credTextShit.text += '\nlmao';
				case 12:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = "Friday";
				// credTextShit.screenCenter();
				case 13:
					addMoreText('Friday');
				// credTextShit.visible = true;
				case 14:
					addMoreText('Night');
				// credTextShit.text += '\nNight';
				case 15:
					addMoreText('Funkin');
					addMoreText('mod collection'); // credTextShit.text += '\nFunkin';

				case 16:
					skipIntro();
			}
		}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}

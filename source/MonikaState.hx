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
import flixel.addons.display.FlxBackdrop;
import flixel.graphics.FlxGraphic;
import flixel.addons.text.FlxTypeText;
import flixel.FlxCamera;
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
import lime.app.Application;
import openfl.Assets;
import flixel.FlxObject;
using StringTools;

class MonikaState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var selectedSomethin:Bool = false;
	var credGroup:FlxGroup;
	var dialoguetext = [
		'"..."',
		'',
		'UGH',
		'and see',
		'if its working'
	];
	var dialognum:Int = 0;
	var undertaleenter:Bool = false;
	var canpress:Bool = false;
	
	
	var dialogstarted:Bool = false;
	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueList:Array<String> = [];
	var manyyear:Int = 0;
	var menustart:Int = 0;
	var dialogue:Alphabet;
	var curSelected:Int = 0;
	

	var menuItems:FlxTypedGroup<FlxSprite>;
	var crediticons:FlxTypedGroup<FlxSprite>;
	var fixdiff:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['fnf', 'dev', 'git'];
	#else
	var optionShit:Array<String> = ['fnf'];
	#end

	var dokiintrodone:Bool = false;
	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;
	var logo:FlxSprite;
	var magenta:FlxSprite;


	var backdrop:FlxBackdrop;
	var grpLocks:FlxTypedGroup<FlxSprite>;
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var swagDialogue:FlxTypeText;

	

	public var finishThing:Void->Void;


	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	

	override public function create():Void
	{
		persistentUpdate = true;
		
		
		dialognum = 0;
			
		swagDialogue = new FlxTypeText(250, 580, Std.int(FlxG.width * 0.6), "Test UGH", 20);
		swagDialogue.font = 'Aller';
		
		swagDialogue.color = 0xFFD2D2D2;
		swagDialogue.antialiasing = true;
		
		
		
		

		
			
		
		
	

			startdoki();
		
		
			super.create();
		
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	
	
	
	function startdoki()
		{
			FlxG.sound.play(Paths.sound('glitchesddlc'), 1);
			FlxG.sound.music.stop();
		
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			add(bg);
		
			var bgd:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
			add(bgd);
			var logodan:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ddlc/glitch'));
			logodan.updateHitbox();
			
			logodan.antialiasing = true;
			logodan.screenCenter(X);
			logodan.screenCenter(Y);
			add(logodan);

			var bgd1:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
			add(bgd1);
			
			new FlxTimer().start(1.0, function(tmr:FlxTimer)
				{
					FlxTween.tween(bgd1, {alpha: 0}, 0.3, {startDelay: 0.0});
					new FlxTimer().start(1.7, function(tmr:FlxTimer)
						{
							FlxTween.tween(bgd1, {alpha: 1}, 0.7, {onComplete: function(twn:FlxTween)
								{
									logodan.visible = false;
									logodan.kill();
									bgd1.kill();
									bgd.kill();

									new FlxTimer().start(2.0, function(tmr:FlxTimer)
									{
										monkastart();
									});

								}
							});
							
							

						});
				});


		}
	
	function monkastart()
	{
		var dialoguetext = [
			'"..."',
			'test',
			'UGH',
			'and see',
			'if its working'
		];
		
		var textbox:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ddlc/textbox'));
		textbox.updateHitbox();
		textbox.screenCenter(X);
		textbox.y += 570;
		textbox.antialiasing = true;
		add(textbox);	
		var boxname:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ddlc/namebox'));
		boxname.updateHitbox();
		boxname.screenCenter(X);
		boxname.y = textbox.y - 38;
		boxname.x -= 300;
		boxname.antialiasing = true;
		add(boxname);	
		var name:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ddlc/monika'));
		name.updateHitbox();
		name.setGraphicSize(Std.int(name.width * 1.5));
		name.screenCenter(X);
		name.y = boxname.y + 10;
		name.x = boxname.x + 49;
		name.antialiasing = true;
		add(name);	
		add(swagDialogue);
		
		
					
	}
	var transitioning:Bool = false;
	var once:Bool = false;

	override function update(elapsed:Float)
	{
		

		if (!dialogstarted)
			{
			dialogstarted = true;
			swagDialogue.resetText(dialoguetext[dialognum]);
			swagDialogue.start(0.04, false);
			canpress = true;
			dialognum += 1;	
			}
		if (FlxG.keys.justPressed.ANY && canpress)
			{
			canpress = false;
			if (dialoguetext[dialognum] != null)
			{
			swagDialogue.resetText(dialoguetext[dialognum]);
			swagDialogue.start(0.04, false);
			dialognum += 1;	
			canpress = true;
			}
			else
			{
				trace('dead');
			}
		
			
			}

super.update(elapsed);
	}
}
	




	





	
		




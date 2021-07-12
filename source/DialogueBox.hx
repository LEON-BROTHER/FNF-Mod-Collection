package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	var whittyfont:Bool = false;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'senpai-b-sides':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns-b-sides':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'high school conflict':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'fading':
				FlxG.sound.playMusic(Paths.music('city_ambience'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}
	

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
			case 'high school conflict':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('monika/weeb/dialogueBox-monika');
					box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
					box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'bara no yume':
					hasDialog = true;
					FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
					box.frames = Paths.getSparrowAtlas('monika/weeb/dialogueBox-monika');
					box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
					box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'your demise':
				    hasDialog = true;
					box.frames = Paths.getSparrowAtlas('monika/weeb/dialogueBox-monika');
					box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
					box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'senpai-b-sides':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses-b-sides':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('bside/weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns-b-sides':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('bside/weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				case 'headache':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('stos/garBox');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'nerves':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('garWeak'));

				box.frames = Paths.getSparrowAtlas('stos/garBox');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'release':
				hasDialog = true;

				box.frames = Paths.getSparrowAtlas('stos/garBox');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'fading':
				hasDialog = true;
				
				box.frames = Paths.getSparrowAtlas('stos/garBox');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
			case 'lo-fight' | 'overhead' | 'ballistic':
					hasDialog = true;
					box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
					box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
					box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);
					box.antialiasing = true;
				
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		
			if (PlayState.SONG.song.toLowerCase()=='headache')
			{
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Default', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.antialiasing = true;
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				}
				else if (PlayState.SONG.song.toLowerCase()=='nerves')
				{
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Nervous', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.antialiasing = true;
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				}
				else if (PlayState.SONG.song.toLowerCase()=='release')
				{
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Ghost', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.antialiasing = true;
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				}
				else if (PlayState.SONG.song.toLowerCase()=='fading')
				{
				portraitLeft = new FlxSprite(130, 100);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/gardialogue');
				portraitLeft.animation.addByPrefix('enter', 'gar Dippy', 24, false);
				// portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
				portraitLeft.antialiasing = true;
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				}



		if (PlayState.SONG.song.toLowerCase()=='high school conflict' || PlayState.SONG.song.toLowerCase()=='bara no yume' || PlayState.SONG.song.toLowerCase()=='your demise')
			{
		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/monika');
		portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
			}
		else if (PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns')  {
			portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		}
		else if (PlayState.SONG.song.toLowerCase()=='headache' || PlayState.SONG.song.toLowerCase()=='nerves' || PlayState.SONG.song.toLowerCase()=='release' || PlayState.SONG.song.toLowerCase()=='fading')
			{
			portraitRight = new FlxSprite(770, 200);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bf_norm');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait Enter', 24, false);
			// portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.4));
			portraitRight.antialiasing = true;
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
			}
		else if (PlayState.SONG.song.toLowerCase() == 'lo-fight' || PlayState.SONG.song.toLowerCase() == 'overhead' || PlayState.SONG.song.toLowerCase() == 'ballistic')
		{	
			portraitLeft = new FlxSprite(200, FlxG.height - 525);
					portraitLeft.frames = Paths.getSparrowAtlas('whitty/whittyPort');
					
					whittyfont = true;
					switch(PlayState.SONG.song.toLowerCase())
					{
						case 'lo-fight':
							portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Normal', 24, false);
						case 'lo-fight-b-side':
							portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Normal', 24, false);
						case 'overhead':
							portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Agitated', 24, false);
						case 'overhead-b-side':
							portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Agitated', 24, false);
						case 'ballistic':
							portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Crazy', 24, true);
						case 'ballistic-b-side':
							portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Crazy', 24, true);
					}

					portraitLeft.antialiasing = true;
					portraitLeft.updateHitbox();
					portraitLeft.scrollFactor.set();
					add(portraitLeft);
					portraitLeft.visible = false;
	
					portraitRight = new FlxSprite(800, FlxG.height - 489);
					portraitRight.frames = Paths.getSparrowAtlas('whitty/boyfriendPort');
					portraitRight.animation.addByPrefix('enter', 'BF portrait enter', 24, true);
					portraitRight.antialiasing = true;
					portraitRight.updateHitbox();
					portraitRight.scrollFactor.set();
					add(portraitRight);
					portraitRight.visible = false;

					portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.8));
					portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.8));
			}
		else
		{
			portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;
		

		portraitRight = new FlxSprite(0, 40);
		portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		}

	
		
		box.animation.play('normalOpen');
		if (whittyfont)
			{
				box.y = FlxG.height - 345;
				box.x = 20;
			}
		else
			{
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			}
		box.updateHitbox();
		add(box);
		
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
			face.setGraphicSize(Std.int(face.width * 6));
			add(face);
		}
		if (PlayState.SONG.song.toLowerCase() == 'thorns-b-sides')
		{
			var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('bside/weeb/spiritFaceForward'));
			face.setGraphicSize(Std.int(face.width * 6));
			add(face);
		}
		

		box.screenCenter(X);
		

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}
		

		
		if (whittyfont)
			{
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'VCR OSD Mono';
			}
		else {
			dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		}
		if (whittyfont)
		{
			dropText.color = FlxColor.RED;
			dropText.antialiasing = true;
		}
		else
			{
				dropText.color = 0xFFD89494;
			}
		
		add(dropText);
		
		
		if (whittyfont)
		{
			swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'VCR OSD Mono';
		}
		else
		{
		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		}
		if (whittyfont)
		{
			swagDialogue.color = FlxColor.BLACK;
			swagDialogue.antialiasing = true;
		}
		else
			{
				swagDialogue.color = 0xFF3F2021;
			}

		
		

		
			
		if (PlayState.SONG.song.toLowerCase() == 'ballistic' || PlayState.SONG.song.toLowerCase() == 'b-ballistic')
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ballistic'), 0.6)];
		else if (PlayState.SONG.song.toLowerCase() == 'lo-fight' || PlayState.SONG.song.toLowerCase() == 'overhead')
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('whitty'), 0.6)];
		else
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		else if (PlayState.SONG.song.toLowerCase()=='headache' || PlayState.SONG.song.toLowerCase()=='nerves')
			{
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
			}
			else if (PlayState.SONG.song.toLowerCase()=='release')
			{
				swagDialogue.color = 0xFF0DF07E;
				dropText.color = FlxColor.BLACK;
			}
			else if (PlayState.SONG.song.toLowerCase()=='fading')
			{
				swagDialogue.color = 0xFF0DF07E;
				dropText.color = FlxColor.BLACK;
			}
		if (PlayState.SONG.song.toLowerCase() == 'roses-b-sides')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns-b-sides')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);

			if (PlayState.SONG.song.toLowerCase() !='headache' && PlayState.SONG.song.toLowerCase() != 'nerves' && PlayState.SONG.song.toLowerCase() != 'release' && PlayState.SONG.song.toLowerCase() != 'fading')
			FlxG.sound.play(Paths.sound('clickText'), 0.8);
			else
			FlxG.sound.play(Paths.sound('Generic_Text'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'senpai-b-sides' || PlayState.SONG.song.toLowerCase() == 'thorns-b-sides' || PlayState.SONG.song.toLowerCase() == 'fading')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
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
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'monika':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.frames = Paths.getSparrowAtlas('monika/weeb/monika');
					portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitLeft.animation.play('enter');
				}
			case 'monikahappy':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.frames = Paths.getSparrowAtlas('monika/weeb/monikahappy');
					portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitLeft.animation.play('enter');
				}
			case 'monikagasp':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/monikagasp');
					portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRight.animation.play('enter');
				}
				case 'monikagaspleft':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitRight.visible)
					{
						portraitRight.visible = true;
						portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/monikagaspleft');
						portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
						portraitRight.animation.play('enter');
					}
				case 'monikahmm':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitRight.visible)
						{
							portraitRight.visible = true;
							portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/monikahmm');
							portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
							portraitRight.animation.play('enter');
						}
				case 'monikauhoh':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitRight.visible)
						{
							portraitRight.visible = true;
							portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/monikauhohright');
							portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
							portraitRight.animation.play('enter');
						}
			case 'monikauhohleft':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitRight.visible)
						{
							portraitRight.visible = true;
							portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/monikauhohleft');
							portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
							portraitRight.animation.play('enter');
						}
			case 'monikasad':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/monikasad');
					portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRight.animation.play('enter');
				}
			case 'bf1':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
				case 'bf':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/bf');
					portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRight.animation.play('enter');
				}

			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.animation.play('enter');
					}
				case 'bf-b':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitRight.visible)
					{
						portraitRight.visible = true;
						portraitRight.frames = Paths.getSparrowAtlas('bside/weeb/bfPortrait');
						portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
						portraitRight.animation.play('enter');
						
					}
			case 'bfwhat':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/bfwhat');
					portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitRight.animation.play('enter');
				}
			case 'bfangry':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitRight.visible)
					{
						portraitRight.visible = true;
						portraitRight.frames = Paths.getSparrowAtlas('monika/weeb/bfangry');
						portraitRight.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
						portraitRight.animation.play('enter');
					}
			case 'dad-w':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
					
					if (PlayState.SONG.song.toLowerCase() == 'ballistic')
						swagDialogue.sounds =  [FlxG.sound.load(Paths.sound('ballistic', 'shared'), 0.6)];
					else if (PlayState.SONG.song.toLowerCase() == 'lo-fight' || PlayState.SONG.song.toLowerCase() == 'overhead')
						swagDialogue.sounds =  [FlxG.sound.load(Paths.sound('whitty', 'shared'), 0.6)];
				}
			case 'bf-w':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					trace('bf pog!!!');
					portraitRight.animation.play('enter');
					swagDialogue.sounds =  [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				}
			case 'senpai':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.frames = Paths.getSparrowAtlas('monika/weeb/senpai');
					portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitLeft.animation.play('enter');
				}
				case 'senpai-b':
					portraitRight.visible = false;
					portraitLeft.visible = false;
					if (!portraitLeft.visible)
					{
						portraitLeft.visible = true;
						portraitLeft.frames = Paths.getSparrowAtlas('bside/weeb/senpaiPortrait');
						portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
						portraitLeft.animation.play('enter');
					}
					case 'spirit-b':
						portraitRight.visible = false;
						portraitLeft.visible = false;
						if (!portraitLeft.visible)
						{
							portraitLeft.visible = true;
							portraitLeft.frames = Paths.getSparrowAtlas('bside/weeb/');
							portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
							portraitLeft.animation.play('enter');
						}

			case 'senpaihappy':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.frames = Paths.getSparrowAtlas('monika/weeb/senpaihappy');
					portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitLeft.animation.play('enter');
				}
			case 'senpaihmm':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.frames = Paths.getSparrowAtlas('monika/weeb/senpaihmm');
					portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitLeft.animation.play('enter');
				}
			case 'whodis':
				portraitRight.visible = false;
				portraitLeft.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.frames = Paths.getSparrowAtlas('monika/weeb/whodis');
					portraitLeft.animation.addByPrefix('enter', 'Portrait Enter instance', 24, false);
					portraitLeft.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}

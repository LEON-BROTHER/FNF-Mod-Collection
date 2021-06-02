package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class DisclaimerState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public var txt:FlxText;

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = "v" + Application.current.meta.get('version');
		txt = new FlxText(0, 0, FlxG.width,
			"The Character XGaster does not work in the final song but still..."
			+ "\nHave fun!"
			+ "\nPress Enter to continue...",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		txt.updateHitbox();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new FreeplayState());
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new FreeplayState());
		}
		if (controls.RESET)
		{
			
			txt = new FlxText(0, 400, FlxG.width,
			"You found Marcy's Discord Tag marcy#0069",
			32);
			txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
			txt.screenCenter(X);
			add(txt);
		
		}
		super.update(elapsed);
	}
}

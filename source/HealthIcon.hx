package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bfkapi', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('bf-pixel-2', [21, 21], 0, false, isPlayer);
		animation.add('bf-pixel-minus', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('flchan', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('dad-neo', [24, 25], 0, false, isPlayer);
		animation.add('bf-neo', [26, 27], 0, false, isPlayer);
		animation.add('spooky-neo', [28, 29], 0, false, isPlayer);
		animation.add('pico-neo', [30, 31], 0, false, isPlayer);
		animation.add('bf-car-neo', [26, 27], 0, false, isPlayer);
		animation.add('mom-car-neo', [32, 33], 0, false, isPlayer);
		animation.add('bf-b', [34, 35], 0, false, isPlayer);
		animation.add('dad-b', [42, 43], 0, false, isPlayer);
		animation.add('ronald', [51, 52], 0, false, isPlayer);
		animation.add('spooky-b', [36, 37], 0, false, isPlayer);
		animation.add('pico-b', [38, 39], 0, false, isPlayer);
		animation.add('mom-car-b', [40, 41], 0, false, isPlayer);
		animation.add('bf-car-b', [34, 35], 0, false, isPlayer);
		animation.add('parents-christmas-b', [44, 45], 0, false, isPlayer);
		animation.add('bf-christmas-b', [34, 35], 0, false, isPlayer);
		animation.add('monster-christmas-b', [46, 47], 0, false, isPlayer);
		animation.add('senpai-b', [49, 49], 0, false, isPlayer);
		animation.add('senpai-angry-b', [49, 49], 0, false, isPlayer);
		animation.add('spirit-b', [50], 0, false, isPlayer);
		animation.add('bf-pixel-b', [48], 0, false, isPlayer);
		animation.add('whitty', [53, 54], 0, false, isPlayer);
		animation.add('whitty-crazy', [55, 56], 0, false, isPlayer);
		animation.add('tricky', [60, 61], 0, false, isPlayer);
		animation.add('trickyMask', [57, 58], 0, false, isPlayer);
		animation.add('carol', [63, 62], 0, false, isPlayer);
		animation.add('ex-gf', [64, 65], 0, false, isPlayer);
		animation.add('monika', [70], 0, false, isPlayer);
		animation.add('hex', [66, 67], 0, false, isPlayer);
		animation.add('hex-noon', [66, 67], 0, false, isPlayer);
		animation.add('bf-noon', [0, 1], 0, false, isPlayer);
		animation.add('hex-night', [66, 67], 0, false, isPlayer);
		animation.add('bf-night', [0, 1], 0, false, isPlayer);
		animation.add('hex-hack', [68, 69], 0, false, isPlayer);
		animation.add('bf-hack', [0, 1], 0, false, isPlayer);
		animation.add('zardy', [71, 72], 0, false, isPlayer);
		animation.add('sarvente', [73, 74], 0, false, isPlayer);
		animation.add('sky', [75, 76], 0, false, isPlayer);
		animation.add('sky-annoyed', [75, 76], 0, false, isPlayer);
		animation.add('sky-mad', [77], 0, false, isPlayer);
		animation.add('miku', [78, 79], 0, false, isPlayer);
		animation.add('miku-mad', [78, 79], 0, false, isPlayer);
		animation.add('xchara', [97, 96], 0, false, isPlayer);
		animation.add('touhou', [80, 81], 0, false, isPlayer);
		animation.add('brother', [82, 83], 0, false, isPlayer);
		animation.add('bf-star', [84, 85], 0, false, isPlayer);
		animation.add('gf-star', [86, 87], 0, false, isPlayer);
		animation.add('dad-star', [88, 89], 0, false, isPlayer);
		animation.add('spooky-star', [90, 91], 0, false, isPlayer);
		animation.add('pico-star', [92, 93], 0, false, isPlayer);
		animation.add('mom-car-star', [94, 95], 0, false, isPlayer);
		animation.add('bf-car-star', [84, 85], 0, false, isPlayer);
		animation.add('bf-holding-gf', [0, 1], 0, false, isPlayer);
		animation.add('ink', [98, 99], 0, false, isPlayer);
		animation.add('xgaster', [100, 101], 0, false, isPlayer);
		animation.add('matt', [102, 103], 0, false, isPlayer);
		animation.add('mattmad', [102, 103], 0, false, isPlayer);
		animation.add('sarvente-dark', [104, 105], 0, false, isPlayer);
		animation.add('bf-dark', [106, 107], 0, false, isPlayer);
		animation.add('ruv', [108, 109], 0, false, isPlayer);
		animation.add('luci-sarv', [110, 111], 0, false, isPlayer);
		animation.add('bfmii', [0, 1], 0, false, isPlayer);
		animation.add('bf-beat', [112, 113], 0, false, isPlayer);
		animation.add('dad-beat', [118, 119], 0, false, isPlayer);
		animation.add('spooky-beat', [114, 115], 0, false, isPlayer);
		animation.add('pico-beat', [116, 117], 0, false, isPlayer);
		animation.add('tricky-beat', [122, 123], 0, false, isPlayer);
		animation.add('trickyMask-beat', [120, 121], 0, false, isPlayer);
		animation.add('garcello', [124, 125], 0, false, isPlayer);
		animation.add('garcellotired', [126, 127], 0, false, isPlayer);
		animation.add('garcellodead', [128, 129], 0, false, isPlayer);
		animation.add('selever', [130, 131], 0, false, isPlayer);
		animation.add('sans', [132, 133], 0, false, isPlayer);
		animation.add('sans2', [134, 135], 0, false, isPlayer);
		animation.add('sans3', [136, 137], 0, false, isPlayer);
		animation.add('senpai-2', [138, 138], 0, false, isPlayer);
		animation.add('spirit-2', [139, 139], 0, false, isPlayer);
		animation.add('chara', [140, 141], 0, false, isPlayer);
		animation.add('gaw', [142, 143], 0, false, isPlayer);
		animation.add('kapi', [144, 145], 0, false, isPlayer);
		animation.add('dadmad', [144, 145], 0, false, isPlayer);
		animation.add('annie', [146, 147], 0, false, isPlayer);
		animation.add('annie2', [148, 149], 0, false, isPlayer);
		animation.add('tord', [150, 151], 0, false, isPlayer);
		animation.add('tordbot', [152, 153], 0, false, isPlayer);
		animation.add('shaggy', [154, 155], 0, false, isPlayer);
		animation.add('pshaggy', [187, 188], 0, false, isPlayer);
		animation.add('anders', [156, 157], 0, false, isPlayer);
		animation.add('anders-fearsome', [158, 159], 0, false, isPlayer);
		animation.add('tari', [160, 161], 0, false, isPlayer);
		animation.add('belle', [162, 163], 0, false, isPlayer);
		animation.add('bob', [164, 165], 0, false, isPlayer);
		animation.add('angrybob', [164, 165], 0, false, isPlayer);
		animation.add('hellbob', [166, 166], 0, false, isPlayer);
		animation.add('trickyH', [167, 168], 0, false, isPlayer);
		animation.add('exTricky', [169, 170], 0, false, isPlayer);
		animation.add('shcarol', [171, 172], 0, false, isPlayer);
		animation.add('tree', [173, 174], 0, false, isPlayer);
		animation.add('tree2', [175, 176], 0, false, isPlayer);
		animation.add('tree3', [177, 178], 0, false, isPlayer);
		animation.add('duck', [179, 180], 0, false, isPlayer);
		animation.add('tabi', [181, 182], 0, false, isPlayer);
		animation.add('tabi-crazy', [183, 184], 0, false, isPlayer);
		animation.add('bf-tabi', [0, 1], 0, false, isPlayer);
		animation.add('bf-tabi-crazy', [0, 1], 0, false, isPlayer);
		animation.add('bf-hell', [0, 1], 0, false, isPlayer);
		animation.add('bf-ena', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas-ena', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel-ena', [21, 21], 0, false, isPlayer);
		animation.add('garcelloghosty', [128, 129], 0, false, isPlayer);
		animation.add('impostor', [185, 186], 0, false, isPlayer);
		animation.add('impostor2', [185, 186], 0, false, isPlayer);
		animation.add('bfg', [0, 1], 0, false, isPlayer);
		animation.add('ggf', [0, 1], 0, false, isPlayer);
		animation.add('bf-rs', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas-rs', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel-rs', [21, 21], 0, false, isPlayer);

		animation.play(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}

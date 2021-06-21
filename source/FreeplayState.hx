package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		if (CategoryState.playlist == 1)
		{
			if (StoryMenuState.weekUnlocked[0] || isDebug)
				addWeek(['Tutorial'], 0, ['gf']);
			if (StoryMenuState.weekUnlocked[1] || isDebug)
				addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);

			if (StoryMenuState.weekUnlocked[2] || isDebug)
				addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);

			if (StoryMenuState.weekUnlocked[3] || isDebug)
				addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

			if (StoryMenuState.weekUnlocked[4] || isDebug)
				addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);

			if (StoryMenuState.weekUnlocked[5] || isDebug)
				addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);

			if (StoryMenuState.weekUnlocked[6] || isDebug)
				addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);
			if (StoryMenuState.weekUnlocked[7] || isDebug)
				addWeek(['Ugh', 'Guns', 'Stress'], 7, ['tankman']);
		}
		if (CategoryState.playlist == 2)
		{
			if (StoryMenuState.weekUnlocked[7] || isDebug)
				addWeek(['Bopeebo-Neo', 'Fresh-Neo', 'Dadbattle-Neo'], 7, ['dad-neo']);
			if (StoryMenuState.weekUnlocked[8] || isDebug)
				addWeek(['Spookeez-Neo', 'South-Neo'], 8, ['spooky-neo']);
			if (StoryMenuState.weekUnlocked[9] || isDebug)
				addWeek(['Pico-Neo', 'Philly-Neo', 'Blammed-Neo'], 9, ['pico-neo']);
			if (StoryMenuState.weekUnlocked[10] || isDebug)
				addWeek(['Satin-Panties-Neo', 'High-Neo', 'Milf-Neo'], 10, ['mom-car-neo']);
		}
		if (CategoryState.playlist == 3)
		{
			if (StoryMenuState.weekUnlocked[12] || isDebug)
				addWeek(['Bopeebo-B-Sides', 'Fresh-B-Sides', 'Dadbattle-B-Sides'], 12, ['dad-b']);
			if (StoryMenuState.weekUnlocked[13] || isDebug)
				addWeek(['Spookeez-B-Sides', 'South-B-Sides'], 13, ['spooky-b']);
			if (StoryMenuState.weekUnlocked[14] || isDebug)
				addWeek(['Pico-B-Sides', 'Philly-B-Sides', 'Blammed-B-Sides'], 14, ['pico-b']);
			if (StoryMenuState.weekUnlocked[15] || isDebug)
				addWeek(['Satin-Panties-B-Sides', 'High-B-Sides', 'Milf-B-Sides'], 15, ['mom-car-b']);
			if (StoryMenuState.weekUnlocked[16] || isDebug)
				addWeek(['Cocoa-B-Sides', 'Eggnog-B-Sides', 'W-HL-B-Sides'], 16, ['parents-christmas-b', 'parents-christmas-b', 'monster-christmas-b']);
			if (StoryMenuState.weekUnlocked[17] || isDebug)
				addWeek(['Senpai-B-Sides', 'Roses-B-Sides', 'Thorns-B-Sides'], 17, ['senpai-b', 'senpai-b', 'spirit-b']);
		}
		if (CategoryState.playlist == 27)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Sunshine', 'Withered'], 35, ['bob', 'angrybob']);

			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run',
					'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run', 'Run'
				], 35, ['hellbob']);
		}

		if (CategoryState.playlist == 28)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Improbable-Outset',
					'Madness',
					'Improbable-Outset-Duet',
					'Madness-Duet',
					'Expurgation'
				], 35, ['trickyMask', 'tricky', 'trickyMask', 'tricky', 'exTricky']);
		}

		if (CategoryState.playlist == 29)
		{
			if (StoryMenuState.weekUnlocked[18] || isDebug)
				addWeek(['Lo-Fight', 'Overhead', 'Ballistic', 'Ballistic-Old'], 18, ['whitty', 'whitty', 'whitty-crazy', 'whitty-crazy']);
		}

		if (CategoryState.playlist == 30)
		{
			if (StoryMenuState.weekUnlocked[30] || isDebug)
				addWeek(['Foolhardy', 'Foolhardy-Duet'], 30, ['zardy']);
		}
		if (CategoryState.playlist == 5)
		{
			if (StoryMenuState.weekUnlocked[22] || isDebug)
				addWeek(['Bopeebo-Duet', 'Fresh-Duet', 'Dadbattle-Duet'], 22, ['dad']);
			if (StoryMenuState.weekUnlocked[2] || isDebug)
				addWeek(['Spookeez-Duet', 'South-Duet', 'Monster-Duet'], 2, ['spooky', 'spooky', 'monster']);
			if (StoryMenuState.weekUnlocked[24] || isDebug)
				addWeek(['Pico-Duet', 'Philly-Duet', 'Blammed-Duet'], 24, ['pico']);
			if (StoryMenuState.weekUnlocked[25] || isDebug)
				addWeek(['Satin-Panties-Duet', 'High-Duet', 'Milf-Duet'], 25, ['mom-car']);
			if (StoryMenuState.weekUnlocked[26] || isDebug)
				addWeek(['Cocoa-Duet', 'Eggnog-Duet', 'Winter-Horrorland-Duet'], 26, ['parents-christmas', 'parents-christmas', 'monster-christmas']);
			if (StoryMenuState.weekUnlocked[27] || isDebug)
				addWeek(['Senpai-Duet', 'Roses-Duet', 'Thorns-Duet'], 27, ['senpai', 'senpai', 'spirit']);
		}
		if (CategoryState.playlist == 7)
		{
			if (StoryMenuState.weekUnlocked[29] || isDebug)
				addWeek(['Dunk', 'RAM', 'Hello-World', 'Glitcher', 'Encore'], 29, ['hex', 'hex', 'hex', 'hex-hack', 'hex',]);
		}
		if (CategoryState.playlist == 6)
		{
			if (StoryMenuState.weekUnlocked[11])
				addWeek(['Ronald-McDonald'], 11, ['ronald', 'bf']);
			if (StoryMenuState.weekUnlocked[21] || isDebug)
				addWeek(['Ex-Girlfriend'], 21, ['ex-gf']);
			if (StoryMenuState.weekUnlocked[28] || isDebug)
				addWeek(['High-School-Conflict'], 28, ['monika']);
			if (StoryMenuState.weekUnlocked[1] || isDebug)
				addWeek(['Fresh-Remix'], 1, ['dad']);
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Always-Running'], 35, ['belle']);
		}
		if (CategoryState.playlist == 8)
		{
			if (StoryMenuState.weekUnlocked[12] || isDebug)
				addWeek(['Bopeebo-B-Sides-Duet', 'Fresh-B-Sides-Duet', 'Dadbattle-B-Sides-Duet'], 12, ['dad-b']);
			if (StoryMenuState.weekUnlocked[13] || isDebug)
				addWeek(['Spookeez-B-Sides-Duet', 'South-B-Sides-Duet'], 13, ['spooky-b']);
			if (StoryMenuState.weekUnlocked[14] || isDebug)
				addWeek(['Pico-B-Sides-Duet', 'Philly-B-Sides-Duet', 'Blammed-B-Sides-Duet'], 14, ['pico-b']);
			if (StoryMenuState.weekUnlocked[15] || isDebug)
				addWeek(['Satin-Panties-B-Sides-Duet', 'High-B-Sides-Duet', 'Milf-B-Sides-Duet'], 15, ['mom-car-b']);
			if (StoryMenuState.weekUnlocked[16] || isDebug)
				addWeek(['Cocoa-B-Sides-Duet', 'Eggnog-B-Sides-Duet'], 16, ['parents-christmas-b']);
			if (StoryMenuState.weekUnlocked[17] || isDebug)
				addWeek(['Senpai-B-Sides-Duet', 'Roses-B-Sides-Duet', 'Thorns-B-Sides-Duet'], 17, ['senpai-b', 'senpai-b', 'spirit-b']);
		}
		if (CategoryState.playlist == 9)
		{
			if (StoryMenuState.weekUnlocked[20] || isDebug)
				addWeek(['Carol-Roll', 'Philly-Carol', 'Blammed-Carol', 'Hellroll'], 20, ['carol', 'carol', 'carol', 'shcarol']);
		}
		if (CategoryState.playlist == 10)
		{
			if (StoryMenuState.weekUnlocked[33] || isDebug)
				addWeek(['Wife-Forever', 'Sky', 'Manifest'], 33, ['sky', 'sky', 'sky-mad']);
		}
		if (CategoryState.playlist == 11)
		{
			if (StoryMenuState.weekUnlocked[33] || isDebug)
				addWeek(['PoPiPo', 'Aishite', 'Siu', 'Disappearance', 'Chug'], 34, ['miku']);
		}
		if (CategoryState.playlist == 12)
		{
			if (StoryMenuState.weekUnlocked[34] || isDebug)
				addWeek(['The-Pocket-Watch-Of-Blood', 'Lunar-Dial', 'Night-of-Nights'], 34, ['touhou']);
		}
		if (CategoryState.playlist == 13)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Tutorial-Starcatcher', 'Bopeebo-Starcatcher', 'Fresh-Starcatcher', 'Dadbattle-Starcatcher', 'Spookeez-Starcatcher', 'South-Starcatcher',
					'Sugar-Rush', 'Pico-Starcatcher', 'Philly-Starcatcher', 'Blammed-Starcatcher', 'Satin-Panties-Starcatcher', 'High-Starcatcher',
					'Milf-Starcatcher'
				], 35, [
					'gf-star', 'dad-star', 'dad-star', 'dad-star', 'spooky-star', 'spooky-star', 'spooky-star', 'pico-star', 'pico-star', 'pico-star',
					'mom-car-star', 'mom-car-star', 'mom-car-star'
				]);
		}
		if (CategoryState.playlist == 14)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Light-It-Up', 'Ruckus', 'Target-Practice', 'Sporting', 'Boxing-Match'], 35, ['matt', 'matt', 'matt', 'mattmad', 'mattmad']);
		}
		if (CategoryState.playlist == 15)
		{
			if (StoryMenuState.weekUnlocked[1] || isDebug)
				addWeek(['Overwrite', 'inkingmistake', 'relighted'], 1, ['xchara', 'ink', 'xgaster']);
		}
		if (CategoryState.playlist == 16)
		{
			if (StoryMenuState.weekUnlocked[32] || isDebug)
				addWeek(['parish', 'Worship', 'Zavodila', 'Gospel', 'Casanova'], 32, ['sarvente', 'sarvente-dark', 'ruv', 'luci-sarv', 'selever']);
		}
		if (CategoryState.playlist == 17)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Bopeebo-Beatstreets', 'Fresh-Beatstreets', 'Dadbattle-Beatstreets'], 35, ['dad-beat']);
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Spookeez-Beatstreets', 'South-Beatstreets'], 35, ['spooky-beat']);
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Pico-Beatstreets', 'Philly-Beatstreets', 'Blammed-Beatstreets'], 35, ['pico-beat']);
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Improbable-Outset-BS', 'Madness-Beatstreets'], 35, ['trickyMask-beat', 'tricky-beat']);
		}
		if (CategoryState.playlist == 18)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Headache',
					'Nerves',
					'Release',
					'Fading',
					'Headache-Duet',
					'Nerves-Duet',
					'Release-Duet'
				], 35, [
					'garcello',
					'garcellotired',
					'garcellodead',
					'garcellodead',
					'garcello',
					'garcellotired',
					'garcellodead'
				]);
		}
		if (CategoryState.playlist == 19)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Stronger', 'Megalomaniac', 'Reality-Check'], 35, ['sans', 'sans2', 'sans3']);
		}
		if (CategoryState.playlist == 20)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['HighRise', 'Ordinance', 'Transgression'], 35, ['senpai-2', 'senpai-2', 'spirit-2']);
		}
		if (CategoryState.playlist == 21)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Megalo-Strike-Back'], 35, ['chara']);
		}
		if (CategoryState.playlist == 22)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Wocky', 'Beathoven', 'Hairball', 'Nyaw', 'Flatzone'], 35, ['kapi', 'kapi', 'kapi', 'kapi', 'gaw']);
		}
		if (CategoryState.playlist == 23)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Good-Enough', 'Lover', 'Tug-Of-War', 'Animal'], 35, ['annie', 'annie', 'annie', 'annie2']);
		}
		if (CategoryState.playlist == 24)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Norway', 'Tordbot'], 35, ['tord', 'tordbot']);
		}
		if (CategoryState.playlist == 25)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Where-are-you',
					'Eruption',
					'Kaio-ken',
					'Whats-new',
					'Blast',
					'Super-saiyan',
					'GOD-EATER'
				], 35, ['shaggy', 'shaggy', 'shaggy', 'shaggy', 'shaggy', 'shaggy', 'pshaggy']);
		}
		if (CategoryState.playlist == 26)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Pentafluoride', 'Diminished', 'Psychoneurotic'], 35, ['anders', 'anders', 'anders-fearsome']);
		}

		if (CategoryState.playlist == 31)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Trunk', 'Warning', 'Revolution', 'Quack', 'Geesy', 'Synergy', 'Prom'], 35,
					['tree', 'tree2', 'tree3', 'duck', 'duck', 'matt-duck', 'tree']);
		}

		if (CategoryState.playlist == 32)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['My-Battle', 'Last-Chance', 'Genocide'], 35, ['tabi', 'tabi', 'tabi-crazy']);
		}

		if (CategoryState.playlist == 33)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Ballistic-RS', 'Blammed-RS', 'Foolhardy-RS', 'Genocide-RS', 'Glitcher-RS', 'Gospel-RS', 'Lo-Fight-RS', 'RAM-RS', 'Release-RS',
					'Roses-RS', 'Thorns-RS', 'Zavodila-RS'
				], 35, [
					'whitty-crazy', 'pico', 'zardy', 'tabi-crazy', 'hex-hack', 'luci-sarv', 'whitty', 'hex', 'garcellodead', 'senpai-angry', 'spirit', 'ruv'
				]);
		}

		if (CategoryState.playlist == 34)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Sussus-Moogus', 'Sabotage', 'Meltdown'], 35, ['impostor', 'impostor', 'impostor']);
		}

		if (CategoryState.playlist == 35)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					     'Tutorial-B3', 'Bopeebo-B3', 'Fresh-B3', 'Dadbattle-B3', 'Spookeez-B3',             'South-B3',   'Pico-B3', 'Philly-B3', 'Blammed-B3',
					'Satin-Panties-B3',    'High-B3',  'Milf-B3',     'Cocoa-B3',   'Eggnog-B3', 'Winter-Horrorland-B3', 'Senpai-B3',  'Roses-B3',  'Thorns-B3'
				], 35, [
					'gf-b3', 'dad-b3', 'dad-b3', 'dad-b3', 'spooky-b3', 'spooky-b3', 'pico-b3', 'pico-b3', 'pico-b3', 'mom-car-b3', 'mom-car-b3',
					'mom-car-b3', 'parents-christmas-b3', 'parents-christmas-b3', 'monster-christmas-b3', 'senpai-b3', 'senpai-b3', 'spirit-b3'
				]);
		}

		if (CategoryState.playlist == 36)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Retricus', 'Covetous', 'Terminus', 'Embark', 'Facade', 'Compel', 'Extremus'], 35,
					['detra', 'detra', 'detra', 'vagrant', 'vagrant', 'vagrant', 'detra']);
		}

		if (CategoryState.playlist == 37)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['The-Date', 'Red-Flag', 'GTFO', 'Left-Swipe', 'Smol'], 35, ['neko-sweet', 'neko-crazy', 'neko-schizo', 'neko-bonus', 'nekunt']);
		}

		if (CategoryState.playlist == 38)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek([
					'Best-Girl', 'Daddys-Girl', 'Salty-Love', 'Daughter-Complex', 'Sweet-N-Spooky', 'Sour-N-Scary', 'Opheebop', 'Protect', 'Defend',
					'Safeguard', 'Indie-Star', 'Rising-Star', 'Superstar', 'Order-Up', 'Rush-Hour', 'Freedom', 'Buckets', 'Logarithms', 'Terminal'
				], 35, [
					'gf-salty', 'dad-salty', 'dad-salty', 'dad-salty', 'spooky-salty', 'spooky-salty', 'monster-salty', 'pico-salty', 'pico-salty',
					'pico-salty', 'mom-car-salty', 'mom-car-salty', 'mom-car-salty', 'manager-salty', 'manager-salty', 'monster-christmas-salty',
					'senpai-salty', 'senpai-salty', 'spirit-salty'
				]);
		}

		if (CategoryState.playlist == 39)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Inverted-Ascension', 'Echoes', 'Artificial-Lust'], 35, ['cj', 'ruby', 'duet']);
		}

		if (CategoryState.playlist == 40)
		{
			if (StoryMenuState.weekUnlocked[35] || isDebug)
				addWeek(['Medley'], 35, ['meowser']);
		}

		/* 

			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */
		/*
			Credits:
			Die Mod Creators
			GamerMichi_
			RED Timmy Stone
		 */

		// LOAD MUSIC

		// LOAD CHARACTERS
		var bg:FlxSprite;

		bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
		{
			changeDiff(-1);
		}
		if (controls.RIGHT_P)
		{
			changeDiff(1);
		}
		if (controls.BACK)
		{
			FlxG.switchState(new CategoryState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;

			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			FlxG.switchState(new ChangePlayerState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		if (CategoryState.playlist == 33)
		{
			curDifficulty = 2;
			curDifficulty += change;

			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 2;

			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end

			switch (curDifficulty)
			{
				case 2:
					diffText.text = "HARD";
			}
		}
		else
		{
			curDifficulty += change;

			if (curDifficulty < 0)
				curDifficulty = 2;
			if (curDifficulty > 2)
				curDifficulty = 0;

			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			#end

			switch (curDifficulty)
			{
				case 0:
					diffText.text = "EASY";
				case 1:
					diffText.text = 'NORMAL';
				case 2:
					diffText.text = "HARD";
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		if (CategoryState.chara != 1)
			FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}

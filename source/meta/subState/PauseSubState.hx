package meta.subState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.font.Alphabet;
import meta.state.PlayState;
import meta.state.*;
import meta.state.menus.*;

class PauseSubState extends MusicBeatSubState
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to Options', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	public function new(x:Float, y:Float)
	{
		super();
		#if debug
		// trace('pause call');
		#end

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		#if debug
		// trace('pause background');
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += CoolUtil.dashToSpace(PlayState.SONG.song);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		#if debug
		// trace('pause info');
		#end

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyFromNumber(PlayState.storyDifficulty);
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var blueballedTxt:FlxText = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedTxt.text = "Blue Balled: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		var mayoTxt:FlxText = new FlxText(20, 15 + 96, 0, "", 32);
		mayoTxt.text = "Director: Stardust Tunes";
		mayoTxt.scrollFactor.set();
		mayoTxt.setFormat(Paths.font('vcr.ttf'), 32);
		mayoTxt.updateHitbox();
		add(mayoTxt);

		var musicTxt:FlxText = new FlxText(20, 15 + 128, 0, "", 32);
		musicTxt.text = "Musician: Stardust Tunes";
		musicTxt.scrollFactor.set();
		musicTxt.setFormat(Paths.font('vcr.ttf'), 32);
		musicTxt.updateHitbox();
		add(musicTxt);

		var artTxt:FlxText = new FlxText(20, 15 + 160, 0, "", 32);
		artTxt.text = "Artists: Kip, Father Carmine, Ryve, Bitofaboomer";
		artTxt.scrollFactor.set();
		artTxt.setFormat(Paths.font('vcr.ttf'), 32);
		artTxt.updateHitbox();
		add(artTxt);

		var painTxt:FlxText = new FlxText(20, 15 + 192, 0, "", 32);
		painTxt.text = "Programmer: peakjuggler";
		painTxt.scrollFactor.set();
		painTxt.setFormat(Paths.font('vcr.ttf'), 32);
		painTxt.updateHitbox();
		add(painTxt);

		var chartTxt:FlxText = new FlxText(20, 15 + 224, 0, "", 32);
		chartTxt.text = "Charting: 10ju";
		chartTxt.scrollFactor.set();
		chartTxt.setFormat(Paths.font('vcr.ttf'), 32);
		chartTxt.updateHitbox();
		add(chartTxt);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		mayoTxt.alpha = 0;
		musicTxt.alpha = 0;
		artTxt.alpha = 0;
		painTxt.alpha = 0;
		chartTxt.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);
		mayoTxt.x = FlxG.width - (mayoTxt.width + 20);
		musicTxt.x = FlxG.width - (musicTxt.width + 20);
		artTxt.x = FlxG.width - (artTxt.width + 20);
		painTxt.x = FlxG.width - (painTxt.width + 20);
		chartTxt.x = FlxG.width - (chartTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(mayoTxt, {alpha: 1, y: mayoTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
		FlxTween.tween(musicTxt, {alpha: 1, y: musicTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.1});
		FlxTween.tween(artTxt, {alpha: 1, y: artTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.3});
		FlxTween.tween(painTxt, {alpha: 1, y: painTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.5});
		FlxTween.tween(chartTxt, {alpha: 1, y: chartTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 1.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		#if debug
		// trace('change selection');
		#end

		changeSelection();

		#if debug
		// trace('cameras');
		#end

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		#if debug
		// trace('cameras done');
		#end
	}

	override function update(elapsed:Float)
	{
		#if debug
		// trace('call event');
		#end

		super.update(elapsed);

		#if debug
		// trace('updated event');
		#end

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					Main.switchState(this, new PlayState());
				case "Exit to Options":
					PlayState.resetMusic();

					Main.switchState(this, new OptionsMenuState());
				case "Exit to menu":
					PlayState.resetMusic();

					if (PlayState.isStoryMode)
						Main.switchState(this, new StoryMenuState());
					else
						Main.switchState(this, new FreeplayState());
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			//Main.switchState(this, new Reward());
			trace('THE J PRESS');
		}

		#if debug
		// trace('music volume increased');
		#end

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		#if debug
		// trace('mid selection');
		#end

		for (item in grpMenuShit.members)
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

		#if debug
		// trace('finished selection');
		#end
		//
	}
}

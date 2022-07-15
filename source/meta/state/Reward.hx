package meta.state;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
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
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import meta.data.dependency.FNFSprite;
import meta.state.menus.*;
import openfl.Assets;

class Reward extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";
	var pauseMusic:FlxSound;

	override function create()
	{
		super.create();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var regularSky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + 'night' + '/darkSky'));
		regularSky.screenCenter();
		regularSky.setGraphicSize(Std.int(regularSky.width * 1.7));
		add(regularSky);

		var credText:FlxText = new FlxText(0, 0);
		credText.text = 'Thanks for playing!';
		credText.setFormat(Paths.font("vcr.ttf"), 64);
		credText.screenCenter(X);
        add(credText);

        var credText2:FlxText = new FlxText(0, 300);
		credText2.text = 'If you want an extra challenge,';
		credText2.setFormat(Paths.font("vcr.ttf"), 36);
		credText2.screenCenter(X);
        add(credText2);

		var credText4:FlxText = new FlxText(0, 350);
		credText4.text = 'give the "Stellar" difficulty a try.';
		credText4.setFormat(Paths.font("vcr.ttf"), 36); // hi ember
		credText4.screenCenter(X);
        add(credText4);

		var credText3:FlxText = new FlxText(0, 400);
		credText3.text = 'It has completely remixed tracks and charts';
		credText3.setFormat(Paths.font("vcr.ttf"), 36);
		credText3.screenCenter(X);
        add(credText3);

		var credText5:FlxText = new FlxText(0, 450);
		credText5.text = 'There is two bonus songs to try out in freeplay.';
		credText5.setFormat(Paths.font("vcr.ttf"), 36);
		credText5.screenCenter(X);
        add(credText5);

		var credText6:FlxText = new FlxText(0, 650);
		credText6.text = 'Press Enter to return to the Main Menu!';
		credText6.setFormat(Paths.font("vcr.ttf"), 36);
		credText6.screenCenter(X);
        add(credText6);

        FlxTween.tween(credText, {y: -300 + 20}, 0.4, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
        FlxTween.tween(credText2, {y: -700 + 20}, 0.8, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
		FlxTween.tween(credText4, {y: -800 + 20}, 0.9, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
		FlxTween.tween(credText3, {y: -900 + 20}, 1.0, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
		FlxTween.tween(credText5, {y: -1000 + 20}, 1.2, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
		FlxTween.tween(credText6, {y: -1200 + 20}, 1.6, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			Main.switchState(this, new MainMenuState());
		}
		super.update(elapsed);

		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;
	}
}
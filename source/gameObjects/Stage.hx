package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.addons.display.FlxTiledSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.MusicBeat.MusicBeatState;
import meta.data.Song.SwagSong;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;
	public var sun:FNFSprite;
	public var night:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;
	var flash:FNFSprite;
	var flash1:FNFSprite;
	var pyro:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'still-dandy':
					curStage = 'noon';
				case 'coastline', 'mediocrity':
					curStage = 'sunset';
				case 'ad-astra', 'saturnalia', 'finale':
					curStage = 'night';
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'spooky':
				curStage = 'spooky';
				// halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/halloween_bg');

				halloweenBG = new FNFSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

			// isHalloween = true;
			case 'philly':
				curStage = 'philly';

				var bg:FNFSprite = new FNFSprite(-100).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FNFSprite = new FNFSprite(-10).loadGraphic(Paths.image('backgrounds/' + curStage + '/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FNFSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FNFSprite = new FNFSprite(city.x).loadGraphic(Paths.image('backgrounds/' + curStage + '/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FNFSprite = new FNFSprite(-40, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/behindTrain'));
				add(streetBehind);

				phillyTrain = new FNFSprite(2000, 360).loadGraphic(Paths.image('backgrounds/' + curStage + '/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FNFSprite = new FNFSprite().loadGraphic(AssetPaths.win0.png);

				var street:FNFSprite = new FNFSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
			case 'highway':
				curStage = 'highway';
				PlayState.defaultCamZoom = 0.90;

				var skyBG:FNFSprite = new FNFSprite(-120, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FNFSprite = new FNFSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bgLimo');
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

				var overlayShit:FNFSprite = new FNFSprite(-500, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');

				limo = new FNFSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FNFSprite(-300, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fastCarLol'));
			// loadArray.add(limo);
			case 'mall':
				curStage = 'mall';
				PlayState.defaultCamZoom = 0.80;

				var bg:FNFSprite = new FNFSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FNFSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FNFSprite = new FNFSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FNFSprite = new FNFSprite(370, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FNFSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FNFSprite = new FNFSprite(-600, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FNFSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				curStage = 'mallEvil';
				var bg:FNFSprite = new FNFSprite(-400, -500).loadGraphic(Paths.image('backgrounds/mall/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FNFSprite = new FNFSprite(300, -300).loadGraphic(Paths.image('backgrounds/mall/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FNFSprite = new FNFSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mall/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'school':
				curStage = 'school';

				// defaultCamZoom = 0.9;

				var bgSky = new FNFSprite().loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FNFSprite = new FNFSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);

				var bgStreet:FNFSprite = new FNFSprite(repositionShit).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);

				var fgTrees:FNFSprite = new FNFSprite(repositionShit + 170, 130).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);

				var bgTrees:FNFSprite = new FNFSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('backgrounds/' + curStage + '/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);

				var treeLeaves:FNFSprite = new FNFSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/petals');
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

				if (PlayState.SONG.song.toLowerCase() == 'roses')
					bgGirls.getScared();

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case 'sunset': // THANK YOU SHUBS!!!!!!!!
				curStage = 'sunset';
	
				PlayState.defaultCamZoom = 0.50;
				// this code is rlly lazy but it works and thats all i need
				var sunsetSky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/sussySky'));
				sunsetSky.screenCenter(X);
				sunsetSky.y = -300;
				sunsetSky.setGraphicSize(Std.int(sunsetSky.width * 1.2));
				sunsetSky.scrollFactor.set(0.3, 0.9);
				add(sunsetSky);
	
				var cheepCheep = new FlxTiledSprite(null, 199900, 2050, true, false);
				cheepCheep.loadGraphic(Paths.image('backgrounds/' + curStage + '/beachyBeach'));
				cheepCheep.x -= cheepCheep.width / 2;
				cheepCheep.y = 100;
				cheepCheep.scrollFactor.set(0.3, 0.9);
				cheepCheep.active = true;
				add(cheepCheep);
	
				var rockyRoad = new FlxTiledSprite(null, 199900, 2050, true, false);
				rockyRoad.loadGraphic(Paths.image('backgrounds/' + curStage + '/rocksRocks'));
				rockyRoad.x -= rockyRoad.width / 2;
				rockyRoad.y = -20;
				rockyRoad.scrollFactor.set(0.3, 0.9);
				rockyRoad.active = true;
				add(rockyRoad);
	
				var clouds1 = new FlxTiledSprite(null, 290000, 4050, true, false);
				clouds1.loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudShit'));
				clouds1.x -= clouds1.width / 2;
				clouds1.y = 350;
				clouds1.scrollFactor.set(0.3, 0.9);
				clouds1.active = true;
				add(clouds1);
	
				var clouds2 = new FlxTiledSprite(null, 990000, 6050, true, false);
				clouds2.loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudShit'));
				clouds2.x -= clouds2.width / 2;
				clouds2.y = 650;
				clouds2.scrollFactor.set(0.3, 0.9);
				clouds2.active = true;
				add(clouds2);
					
				var cutter = new FNFSprite(-1330, -100);
				cutter.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/sunsetCutter');
				cutter.animation.addByPrefix('idle', 'sunsetCutter', 24, true);
				cutter.animation.play('idle');
				cutter.antialiasing = true;
				cutter.setGraphicSize(Std.int(cutter.width * 1.4));
				cutter.updateHitbox();
				add(cutter);

				sun = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlayShit'));
				sun.setGraphicSize(Std.int(sun.width * 1.8));
				sun.scrollFactor.set(0, 0);
				sun.blend = MULTIPLY;
				sun.alpha = 0.4;
				sun.screenCenter();
				

				rockyRoad.velocity.x = -400;
				cheepCheep.velocity.x = -500;
				clouds1.velocity.x = -300;
				clouds2.velocity.x = -1400;
			case 'noon': // THANK YOU SHUBS!!!!!!!!
				curStage = 'noon';
			
				PlayState.defaultCamZoom = 0.50;
				// this code is rlly lazy but it works and thats all i need
				var regularSky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/blueSky'));
				regularSky.screenCenter(X);
				regularSky.y = -300;
				regularSky.x += 200;
				regularSky.setGraphicSize(Std.int(regularSky.width * 1.2));
				regularSky.scrollFactor.set(0.3, 0.9);
				add(regularSky);

				var cloudy = new FlxTiledSprite(null, 90000, 4050, true, false);
				cloudy.loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudShit'));
				cloudy.x -= cloudy.width / 2;
				cloudy.y = 350;
				cloudy.scrollFactor.set(0.3, 0.9);
				cloudy.active = true;
				add(cloudy);

				var clouds3 = new FlxTiledSprite(null, 990000, 6050, true, false);
				clouds3.loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudShit'));
				clouds3.x -= clouds3.width / 2;
				clouds3.y = 650;
				clouds3.scrollFactor.set(0.3, 0.9);
				clouds3.active = true;
				add(clouds3);
				
				var cloudCutter = new FNFSprite(-1330, -100);
				cloudCutter.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/noonCutter');
				cloudCutter.animation.addByPrefix('idle', 'noonCutter', 24, true);
				cloudCutter.animation.play('idle');
				cloudCutter.antialiasing = true;
				cloudCutter.setGraphicSize(Std.int(cloudCutter.width * 1.4));
				cloudCutter.updateHitbox();
				add(cloudCutter);

				cloudy.velocity.x = -300;
				clouds3.velocity.x = -1400;
			case 'night': // THANK YOU SHUBS!!!!!!!!
				curStage = 'night';
			
				PlayState.defaultCamZoom = 0.50;
				// this code is rlly lazy but it works and thats all i need
				var regularSky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/darkSky'));
				regularSky.screenCenter(X);
				regularSky.y = -300;
				regularSky.x += 200;
				regularSky.setGraphicSize(Std.int(regularSky.width * 1.7));
				regularSky.scrollFactor.set(0.3, 0.9);
				add(regularSky);

				var cloudy = new FlxTiledSprite(null, 9990000, 4050, true, false);
				cloudy.loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudShit'));
				cloudy.x -= cloudy.width / 2;
				cloudy.y = 350;
				cloudy.scrollFactor.set(0.3, 0.9);
				cloudy.active = true;
				add(cloudy);

				flash1 = new FNFSprite(-1330, 300);
				flash1.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/flashFuck');
				flash1.animation.addByPrefix('idle', 'bg graiden', 24, false);
				flash1.antialiasing = true;
				//flash1.blend = ADD;
				flash1.setGraphicSize(Std.int(flash1.width * 1.6));
				flash1.updateHitbox();
				flash1.visible = false;
				add(flash1);

				var clouds3 = new FlxTiledSprite(null, 9990000, 6050, true, false);
				clouds3.loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudShit'));
				clouds3.x -= clouds3.width / 2;
				clouds3.y = 650;
				clouds3.scrollFactor.set(0.3, 0.9);
				clouds3.active = true;
				add(clouds3);

				pyro = new FNFSprite(-330, -100);
				pyro.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/fireWorkz');
				pyro.animation.addByPrefix('idle', 'Fireworks overall', 24, false);
				pyro.antialiasing = true;
				pyro.updateHitbox();
				pyro.visible = false;
				add(pyro);

				flash = new FNFSprite(-1330, 600);
				flash.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/flashFuck');
				flash.animation.addByPrefix('idle', 'bg graiden', 24, false);
				flash.antialiasing = true;
				flash.setGraphicSize(Std.int(flash.width * 1.6));
				flash.updateHitbox();
				flash.visible = false;
				add(flash);
				
				var cloudCutter = new FNFSprite(-1330, -100);
				cloudCutter.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/nightCutter');
				cloudCutter.animation.addByPrefix('idle', 'nightCutter', 24, true);
				cloudCutter.animation.play('idle');
				cloudCutter.antialiasing = true;
				cloudCutter.setGraphicSize(Std.int(cloudCutter.width * 1.4));
				cloudCutter.updateHitbox();
				add(cloudCutter);

				night = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlayShit'));
				night.setGraphicSize(Std.int(night.width * 1.8));
				night.scrollFactor.set(0, 0);
				night.blend = MULTIPLY;
				night.alpha = 0.4;
				night.screenCenter();

				clouds3.velocity.x = -1400;

				cloudy.velocity.x = -300;
				
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'noon':
				gfVersion = 'gf';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
				case 'spirit':
					var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
					evilTrail.changeValuesEnabled(false, false, false, false);
					add(evilTrail);
					*/
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'sunset', 'noon', 'night':
				gf.y += 30;
				gf.x -= 150;
				dad.y += 55;
				dad.x -= 300;
				boyfriend.y += 20;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'night':
				if(PlayState.SONG.song.toLowerCase() == 'saturnalia'){
					flash.visible = true;
					flash1.visible = true;
					pyro.visible = true;

					pyro.animation.play('idle');

					if (curBeat % 4 == 0){
						trace('lav boobies');
						flash.animation.play('idle');
						flash1.animation.play('idle');
					}
				}

			case 'school':
				bgGirls.dance();

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
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
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
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

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}

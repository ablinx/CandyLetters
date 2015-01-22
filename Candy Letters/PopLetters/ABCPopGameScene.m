//  ABCPopGameScene.m
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import "ABCPopGameScene.h"
#import "SimpleAudioEngine.h"
#import "CongratsScene.h"
#import "HomeScene.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAITrackedViewController.h"


static int NO_OF_ALPHABETS_TO_PICK = 2;
static BOOL isSmallLetter;

@implementation ABCPopGameScene

@synthesize alphabets, randomAlphabets, stars, voices,voice,emitter,alphabetToFind,selectedAlphabet,timer;

int x;
int y;
float rotateBy;
CGSize windowSize;
int currentSelectedIndex;
int counter;
int targetX;
int targetY;
int noOfCorrectHits;
int starPositionX;
BOOL isTouched;
int currentAlphabetIndex;


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ABCPopGameScene *layer = [ABCPopGameScene node];

	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void) loadSmallAlphabets
{
	NSString *fileName = nil;
	
	NSMutableArray *imagesPath = [[NSMutableArray alloc] init];
	
	[imagesPath addObject:@"a_small.png"];
	[imagesPath addObject:@"b_small.png"];
	[imagesPath addObject:@"c_small.png"];
	[imagesPath addObject:@"d_small.png"];
	[imagesPath addObject:@"e_small.png"];
	[imagesPath addObject:@"f_small.png"];
	[imagesPath addObject:@"g_small.png"];
	[imagesPath addObject:@"h_small.png"];
	[imagesPath addObject:@"i_small.png"];
	[imagesPath addObject:@"j_small.png"];
	[imagesPath addObject:@"k_small.png"];
	[imagesPath addObject:@"l_small.png"];
	[imagesPath addObject:@"m_small.png"];
	[imagesPath addObject:@"n_small.png"];
	[imagesPath addObject:@"o_small.png"];
	[imagesPath addObject:@"p_small.png"];
	[imagesPath addObject:@"q_small.png"];
	[imagesPath addObject:@"r_small.png"];
	[imagesPath addObject:@"s_small.png"];
	[imagesPath addObject:@"t_small.png"];
	[imagesPath addObject:@"u_small.png"];
	[imagesPath addObject:@"v_small.png"];
	[imagesPath addObject:@"w_small.png"];
	[imagesPath addObject:@"x_small.png"];
	[imagesPath addObject:@"y_small.png"];
	[imagesPath addObject:@"z_small.png"];
	
	for(int i=0;i<=imagesPath.count - 1; i++)
	{
		fileName = [[imagesPath objectAtIndex:i] lastPathComponent];
		
		CCSprite *sprite = [CCSprite spriteWithFile:fileName];
		
		fileName = [fileName stringByDeletingPathExtension];
		
		NSString *data = [[fileName componentsSeparatedByString:@"_"] objectAtIndex:0];
		
		sprite.userData = data;
		
		[alphabets addObject:sprite];
	}
	
	[imagesPath release];
	imagesPath = nil;
	
}


-(void) loadAllAlphabets
{
	NSBundle *bundle = [NSBundle mainBundle];
	
	NSArray *imagesPath = [bundle pathsForResourcesOfType:@"png" inDirectory:nil];
	
	alphabets = [[NSMutableArray alloc] init];
	
	if([ABCPopGameScene getIsSmallLetter] == YES)
	{
		[self loadSmallAlphabets];
		return;
	}
	
	NSString *fileName = nil;
	
	for(int i=0; i<= imagesPath.count -1 ; i++)
	{
		fileName = [[imagesPath objectAtIndex:i] lastPathComponent];
		
		if([fileName isEqualToString:@"A.png"])
		{
			continue;
		}
		
		if ([fileName length] > 5) {  //all the alphabet files are a single letter
			continue;
		}
		
		CCSprite *sprite = [CCSprite spriteWithFile:fileName];
        
		sprite.userData = [[fileName stringByDeletingPathExtension] uppercaseString];
        
		[alphabets addObject:sprite];
		
	}
}


-(void) generateRandomCoordinates
{
	x = arc4random() % (int) windowSize.width;
	y = arc4random() % (int) windowSize.height;
}


-(void) startAnimation:(CCSprite *) sprite
{
	int rotateDegrees = arc4random() % 360;
	
	[self generateRandomCoordinates];
	
	id actionMove = [CCMoveTo actionWithDuration:3.0 position:ccp(x,y)];
	id actionRotate = [CCRotateBy actionWithDuration:0.6 angle:rotateDegrees];
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(finishedMoving:)];
	
	[sprite runAction:[CCSequence actions:actionMove,actionRotate, actionMoveDone, nil]];
}



-(void) addAlphabetsOnScreen
{
    
	for (int i=0; i<=randomAlphabets.count -1; i++) {
		
		CCSprite *sprite = [randomAlphabets objectAtIndex:i];
		
		[self generateRandomCoordinates];
		
		sprite.position = ccp(x,y);
		[self addChild:sprite];
		
		[self startAnimation:sprite];
	}
	
}



-(void) playBackgroundMusic
{
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"kids_singing_background.mp3"];
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2];
}



-(int) getRandomNumber:(NSMutableArray *) array
{
	int randomNumber = (arc4random() % (array.count -1));
	
	return randomNumber;
}



-(void) pickAGroupOfRandomAlphabets
{
	randomAlphabets = [[NSMutableArray alloc] init];
	
	for(int i=1; i<=NO_OF_ALPHABETS_TO_PICK; i++)
	{
		int randomNumber = [self getRandomNumber:alphabets];
		
		CCSprite *sprite = [alphabets objectAtIndex:randomNumber];
		
		BOOL isAlreadyAdded = [randomAlphabets containsObject:sprite];
		
		if(isAlreadyAdded == NO)
		{
			[randomAlphabets addObject:sprite];
		}
		else
		{
			i-= 1;
		}
	}
}



-(void) pickAlphabetToFind
{
	int randomNumber = [self getRandomNumber:randomAlphabets];
	
	alphabetToFind = [randomAlphabets objectAtIndex:randomNumber];
	
	
	NSString *ud = alphabetToFind.userData;
	// find the alphabet in the voices array
	
	if([ABCPopGameScene getIsSmallLetter] == YES)
	{
		self.selectedAlphabet = [[ud componentsSeparatedByString:@"_"] objectAtIndex:0];
	}
	else
	{
        self.selectedAlphabet = ud;
	}
	
	self.voice = nil;
	
	for (int i=0; i<=voices.count-1; i++) {
        
		self.voice = [[[voices objectAtIndex:i] stringByDeletingPathExtension] uppercaseString];
		
		if([self.voice isEqualToString:[ud uppercaseString]])
		{
			break;
		}
		
	}
    
	[[SimpleAudioEngine sharedEngine] playEffect:[[self.voice lowercaseString] stringByAppendingString:@".mp3"]];
}



-(void) preLoadAllVoices
{
	for(int i=0; i<=voices.count-1; i++)
	{
		self.voice = [voices objectAtIndex:i];
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:self.voice];
	}
}



-(void) populateAllVoices
{
	voices = [[NSMutableArray alloc] init];
	
	[voices addObject:@"a.mp3"];
	[voices addObject:@"b.mp3"];
	[voices addObject:@"c.mp3"];
	[voices addObject:@"d.mp3"];
	[voices addObject:@"e.mp3"];
	[voices addObject:@"f.mp3"];
	[voices addObject:@"g.mp3"];
	[voices addObject:@"h.mp3"];
	[voices addObject:@"i.mp3"];
	[voices addObject:@"j.mp3"];
	[voices addObject:@"k.mp3"];
	[voices addObject:@"l.mp3"];
	[voices addObject:@"m.mp3"];
	[voices addObject:@"n.mp3"];
	[voices addObject:@"o.mp3"];
	[voices addObject:@"p.mp3"];
	[voices addObject:@"q.mp3"];
	[voices addObject:@"r.mp3"];
	[voices addObject:@"s.mp3"];
	[voices addObject:@"t.mp3"];
	[voices addObject:@"u.mp3"];
	[voices addObject:@"v.mp3"];
	[voices addObject:@"w.mp3"];
	[voices addObject:@"x.mp3"];
	[voices addObject:@"y.mp3"];
	[voices addObject:@"z.mp3"];
    
	
	[self preLoadAllVoices];
}



-(void)repeatAlphabet:(id)sender
{
	[[SimpleAudioEngine sharedEngine] playEffect:[[self.voice lowercaseString] stringByAppendingString:@".mp3"]];
}



-(void) loadHome:(CCMenuItem *) menuItem
{
	[[CCDirector sharedDirector] replaceScene:[HomeScene scene]];
    [self stopSound];
    
}



-(void) stopSound
{
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}



-(void) addRepeatButtonOnScreen
{
    
	CCMenuItemImage * menuItem1 =[CCMenuItemImage itemWithNormalImage:@"menuBubbles.png"
														selectedImage: @"menuBubbles.png"
															   target:self
															 selector:@selector(loadHome:)];
    
	CCMenu *menu = [CCMenu menuWithItems:menuItem1,nil];
	menu.position = ccp(windowSize.width/1.1, windowSize.height/1.08);
    [menu alignItemsHorizontallyWithPadding:5];
	
	[self addChild:menu];
}



+(void) setIsSmallLetter:(BOOL) val
{
	isSmallLetter = val;
}



+(BOOL) getIsSmallLetter
{
	return isSmallLetter;
}


-(id) init
{
	[self playBackgroundMusic];
    
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"baloonpop.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"ding.caf"];
    
	[self populateAllVoices];
	
	self.isTouchEnabled = YES;
	isTouched = NO;
	
	stars = [[NSMutableArray alloc] init];
	
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
        NSMutableArray *backgrounds = [[NSMutableArray alloc] init];
        
        
        [backgrounds addObject:@"bgBubbles.png"];
        
        int randomNumber = (arc4random() % (backgrounds.count));
        
        NSString *backgroundFileName = [backgrounds objectAtIndex:randomNumber];
        
        CCSprite *background = [CCSprite spriteWithFile:backgroundFileName];
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        if(winSize.height==568.0)
        {
            background = [CCSprite spriteWithFile:@"bgBubbles-568h@2x.png"];
        }
        
        background.anchorPoint = CGPointMake(0,0);
        
        // release backgrounds
        [backgrounds release];
        backgrounds = nil;
        
        
        [self addChild:background z:-1];
        
		x = 154;
		y = 235;
		rotateBy = 0;
		counter = 0;
		noOfCorrectHits = 0;
		
		self.isTouchEnabled = YES;
		
		[self loadAllAlphabets];
		
		windowSize = [[CCDirector sharedDirector] winSize];
		
		[self addRepeatButtonOnScreen];
        
        [self pickAGroupOfRandomAlphabets];
		[self pickAlphabetToFind];
		[self addAlphabetsOnScreen];
       
        // Registering Google Analytics
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ABCGameScreen"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
	}
	
	return self;
}



-(void) playDingSound
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"ding.caf"];
}



-(void) playHitSound
{
	[[SimpleAudioEngine sharedEngine] playEffect:@"baloonpop.mp3"];
}



-(void) addStar
{
	for(int i=0; i<=noOfCorrectHits -1; i++)
	{
		CCSprite *sprite = [CCSprite spriteWithFile:@"redStar.png"];
		sprite.tag = i;
        sprite.position = ccp(windowSize.width/8.9, windowSize.height/1.08);
		
		[stars addObject:sprite];
		
		[self addChild:sprite];
		
		[sprite runAction:[CCRotateBy actionWithDuration:0.9 angle:360]];
		
		[self playDingSound];
	}
    
	starPositionX += 35;
}



-(void) explodeAlphabet
{
    emitter = [[CCParticleExplosion alloc] init];
	
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:[[self.selectedAlphabet lowercaseString] stringByAppendingString:@".png"]];
    emitter.position = ccp(self.alphabetToFind.position.x,self.alphabetToFind.position.y);
    [self addChild:emitter];
}



-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	float distance = pow(alphabetToFind.position.x - location.x, 2) + pow(alphabetToFind.position.y - location.y, 2);
	distance = sqrt(distance);
	
	if(distance <= 50 && isTouched == NO)
	{
		isTouched = YES;
		
		noOfCorrectHits += 1;
		
		[self explodeAlphabet];
		
		[self playHitSound];
		
		
		[alphabetToFind stopAllActions];
		
		id disappear = [CCFadeTo actionWithDuration:.5 opacity:0];
		id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(removeAlphabetToFindFromView:)];
		
		[alphabetToFind runAction:[CCSequence actions:disappear,actionMoveDone, nil]];
	}
}



-(void) addNewAlphabet
{
	if(noOfCorrectHits >= 5)
	{
        // DIFICULTY HERE
		if(NO_OF_ALPHABETS_TO_PICK <= 4)
		{
			NO_OF_ALPHABETS_TO_PICK +=1;
			// add the star
			[self addStar];
		}
		else
		{
			starPositionX = 0;
			NO_OF_ALPHABETS_TO_PICK = 2;
			[[CCDirector sharedDirector] replaceScene:[CongratsScene scene]];
            [self stopSound];
			return;
		}
		noOfCorrectHits = 0;
	}
		
	
	for(int i=0; i<=randomAlphabets.count -1 ; i++)
	{
		CCSprite *sprite = [randomAlphabets objectAtIndex:i];
		[self removeChild:sprite cleanup:YES];
	}
    
	// remove alphabet from the collection
	
	[randomAlphabets removeAllObjects];
	[randomAlphabets release];
	
	[alphabets removeAllObjects];
	[alphabets release];
    
	[self loadAllAlphabets];
	
	[self pickAGroupOfRandomAlphabets];
	
	[self pickAlphabetToFind];
	
	[self addAlphabetsOnScreen];
	
	// reset isTouched
	isTouched = NO;
}



-(void) removeAlphabetToFindFromView:(id) sender
{
	CCSprite *sprite = (CCSprite *) sender;
	[sprite stopAllActions];
	[self removeChild:sprite cleanup:YES];
	
	// add new random alphabet to the view
	[self addNewAlphabet];
}



-(void) finishedMoving:(id) sender
{
	if(counter == randomAlphabets.count)
	{
		counter = 0;
	}
	
	CCSprite *sprite = [randomAlphabets objectAtIndex:counter];
	
	[self generateRandomCoordinates];
	
	[self startAnimation:sprite];
	
	counter +=1;
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[alphabets release];
	alphabets = nil;
	
	[randomAlphabets release];
	randomAlphabets = nil;
	
	[stars release];
	stars = nil;
	
	[voices release];
	voices = nil;
	
	[voice release];
    voice = nil;
	
	[selectedAlphabet release];
	selectedAlphabet = nil;
	
    
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
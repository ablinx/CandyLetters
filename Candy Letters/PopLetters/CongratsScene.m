//  CongratsScene.m
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import "CongratsScene.h"
#import "ABCPopGameScene.h"
#import "SimpleAudioEngine.h"
#import "HomeScene.h"
#import "ShopView.h"


#import <UIKit/UIKit.h>

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAITrackedViewController.h"


@implementation CongratsScene

@synthesize emitter;


+(id) scene
{


	CCScene *scene = [CCScene node];
	CongratsScene *layer = [CongratsScene node];

	[scene addChild:layer];
	
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"congrats.mp3"];
    
	return scene;
}





-(void) restartGame:(CCMenuItem *) item
{
	// load the game scene
	[[CCDirector sharedDirector] replaceScene:[HomeScene scene]];
}


-(void) loadShop:(CCMenuItem *) item
{
    [[CCDirector sharedDirector] replaceScene:[ShopView scene]];
}



-(id)init
{
	if( (self=[super init] ))
        
	{
        CCSprite *background = [CCSprite spriteWithFile:@"bgCongrats.png"];
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        if(winSize.height==568.0)
        {
            background = [CCSprite spriteWithFile:@"bgCongrats-568h@2x.png"];
        }
        
        background.anchorPoint = CGPointMake(0,0);
        [self addChild:background z:-1];
        
		emitter = [[CCParticleSnow alloc] init];
		emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
		[self addChild:emitter];
		
        //CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"congrats.mp3"];
		
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        CCMenuItem *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"playAgain.png" selectedImage:@"playAgain.png" target:self selector:@selector(restartGame:)];
        menuItem1.tag = 1;
        
        CCMenuItem *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"store.png" selectedImage:@"store.png" target:self selector:@selector(loadShop:)];
        menuItem2.tag = 2;
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
        menu.position = ccp(windowSize.width/2, windowSize.height/3);
        [menu alignItemsHorizontallyWithPadding:15];
        [self addChild:menu];
        
        // Registering Google Analytics
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"CongratsScreen"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
	}
	
	return self;
}





-(void) dealloc
{
	[emitter release];
	emitter = nil;
	
	[super dealloc];
}

@end
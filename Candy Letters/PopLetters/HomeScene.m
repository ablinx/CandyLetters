//  HomeScene.m
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import "HomeScene.h"
#import "ABCPopGameScene.h"
#import <UIKit/UIKit.h>
#import "ShopView.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAITrackedViewController.h"



@implementation HomeScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	HomeScene *layer = [HomeScene node];
	
	[scene addChild:layer];
	
	return scene;
}

-(id) init
{
	if( (self=[super init] ))
	{
		isTouchEnabled_ = YES;
        
        CCSprite *background = [CCSprite spriteWithFile:@"bgHomeMenu.png"];
        
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        if(winSize.height==568.0)
        {
            background = [CCSprite spriteWithFile:@"bgHomeMenu-568h@2x.png"];
        }
        
        background.anchorPoint = ccp(0,0);
        
        [self addChild:background z:-1];
        
		[self createMenu];
        
        // Registering Google Analytics
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"MainScreen"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
	}
	
	return self;
}


-(void) startGame:(CCMenuItem *) menuItem
{
	[ABCPopGameScene setIsSmallLetter:menuItem.tag == 1 ? YES : NO];
	[[CCDirector sharedDirector] replaceScene:[ABCPopGameScene scene]];
}

-(void) loadShop:(CCMenuItem *) item
{
    [[CCDirector sharedDirector] replaceScene:[ShopView scene]];
}

-(void) createMenu
{
    
	CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    CCMenuItem *menuItem1 = [CCMenuItemImage itemWithNormalImage:@"storeHome.png" selectedImage:@"storeHome.png" target:self selector:@selector(loadShop:)];
    
    CCMenuItem *menuItem2 = [CCMenuItemImage itemWithNormalImage:@"butStart.png" selectedImage:@"butStart.png" target:self selector:@selector(startGame:)];
    menuItem2.tag = 2;
    
    CCMenu *menu = [CCMenu menuWithItems:menuItem2, menuItem1, nil];
    menu.position = ccp(windowSize.width/2, windowSize.height/2);
    [menu alignItemsHorizontallyWithPadding:15];
	[self addChild:menu];

}

-(void) dealloc
{
	[super dealloc];
}



@end
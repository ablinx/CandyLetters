//  ShopViewController.m
//
//  Copyright (c) 2015 Ablinx. All rights reserved.
//

#import "ShopView.h"
#import "cocos2d.h"
#import "HomeScene.h"


#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "GAITrackedViewController.h"


@implementation ShopView
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    ShopView *shopView = [ShopView node];
    [scene addChild: shopView];
    return scene;
}

-(void) addRepeatButtonOnScreen
{
    
	CCMenuItemImage * menuItem1 =[CCMenuItemImage itemWithNormalImage:@"playAgainSmall.png"
														selectedImage: @"playAgainSmall.png"
															   target:self
															 selector:@selector(loadHome:)];
	
	CCMenu *menu = [CCMenu menuWithItems:menuItem1,nil];
    
	menu.position = ccp(offset/2, offset/2);
    
	
	[self addChild:menu];
}

-(void) addShopReloadButtonOnScreen
{
    
	CCMenuItemImage * menuItem2 =[CCMenuItemImage itemWithNormalImage:@"shopReload.png"
														selectedImage: @"shopReload.png"
															   target:self
															 selector:@selector(loadShop:)];
	
	CCMenu *menu2 = [CCMenu menuWithItems:menuItem2,nil];
    
	menu2.position = ccp(offset*5, offset/2);
    
	
	[self addChild:menu2];
}




-(id) init
{
    if( self = [super init]){
        screenSize = [[CCDirector sharedDirector] winSize];
        offset = screenSize.height/12;
        CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(236,236,236,1)];
        [self addChild:colorLayer];
        [self addWebView];
        [self addRepeatButtonOnScreen];
        [self addShopReloadButtonOnScreen];
        
        // Registering Google Analytics
        id tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"ShopScreen"];
        [tracker send:[[GAIDictionaryBuilder createAppView] build]];
        
    }
    return self;

}

-(void) addWebView
{
    
    webview = [[[UIWebView alloc]init]autorelease];
    
    [webview init];
    webview.frame = CGRectMake(0, 0, screenSize.width, screenSize.height- offset);
    NSString *urlAddress = @"https://ablinx.com/store/candyletters";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObject = [NSURLRequest requestWithURL:url];
    [webview loadRequest:requestObject];
    
    UIView* glView = [[CCDirector sharedDirector] view];
    glView.opaque=YES;
    [glView addSubview:webview.viewForBaselineLayout];
    
}


-(void) loadHome:(CCMenuItem *) menuItem
{
    [webview removeFromSuperview];
	[[CCDirector sharedDirector] replaceScene:[HomeScene scene]];
    
}

-(void) loadShop:(CCMenuItem *) menuItem
{
    [webview removeFromSuperview];
	[[CCDirector sharedDirector] replaceScene:[ShopView scene]];
    
}

- (void) dealloc{
    [super dealloc];
}
@end

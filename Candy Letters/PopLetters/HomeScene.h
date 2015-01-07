//  HomeScene.h
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HomeScene : CCLayer {
    CGSize winSize;
}

+(id) scene;
-(void) createMenu;

@end

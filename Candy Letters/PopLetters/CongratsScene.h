//  CongratsScene.h
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CongratsScene : CCScene {
    CCParticleSnow *emitter;
    CGSize winSize;
}

+(id) scene;

@property (nonatomic,retain) CCParticleSnow *emitter;

@end

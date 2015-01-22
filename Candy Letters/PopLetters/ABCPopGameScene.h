//  ABCPopGameScene.h
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ABCPopGameScene : CCLayer {
    NSMutableArray *alphabets;
	NSMutableArray *randomAlphabets;
	NSMutableArray *stars;
	NSMutableArray *voices;
	BOOL isGameEnded;
	NSString *voice;
	CCParticleExplosion *emitter;
	NSString *selectedAlphabet;
	CCSprite *alphabetToFind;
	NSTimer *timer;
    CGSize winSize;
}

+(id) scene;

@property (nonatomic, retain) NSMutableArray *alphabets;
@property (nonatomic, retain) NSMutableArray *randomAlphabets;
@property (nonatomic, retain) NSMutableArray *stars;
@property (nonatomic, retain) NSMutableArray *voices;
@property (nonatomic, retain) NSString *voice;
@property (readwrite,retain) CCParticleExplosion *emitter;
@property (nonatomic,retain) NSString *selectedAlphabet;
@property (nonatomic,retain) CCSprite *alphabetToFind;
@property (nonatomic,retain) NSTimer *timer;
@property (nonatomic,assign) BOOL isSmallLetter;

+(void) setIsSmallLetter:(BOOL)val;

@end

//  ShopViewController.h
//
//  Copyright 2015 Ablinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface ShopView: CCLayer
{
    UIWebView *webview;
    int offset;
    CGSize screenSize;
}
+(CCScene *) scene;
@end

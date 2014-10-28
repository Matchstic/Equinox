//
//  EQCache.h
//  Equinox
//
//  Created by Matt Clarke on 30/03/2014.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "EQNamedImage.h"

@class CUINamedImage;

@interface EQCache : NSObject

+(id)imageForBundleID:(NSString *)bundle andNamedImage:(CUINamedImage*)imgur; // Fuck yeah polymorphism!
+(BOOL)loadedThemesContainsIconFileWithBundleID:(NSString *)bundle andNamedImage:(CUINamedImage*)imgur;
+(void)loadThemedImageNamesForBundle:(NSBundle*)bundle;

+(void)killCachedImages;

@end

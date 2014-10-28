//
//  CarFileCache.m
//  Equinox
//
//  Created by Matt Clarke on 30/03/2014.
//
// I have a huge feeling ~ipad images won't work!

#import "EQCache.h"
#import "EQResources.h"
#import <UIKit/UIKit.h>

static NSMutableSet *cachedImageNames;
static NSMutableSet *cachedImages;

@interface CUINamedImage (Additions)
-(id)renditionKeyName;
@end

@interface CUIThemeFacet : NSObject
+ (unsigned int)themeForBundleIdentifier:(id)arg1 error:(id*)arg2;
@end

@implementation EQCache

+(id)imageForBundleID:(NSString *)bundle andNamedImage:(CUINamedImage*)nam {
    UIImage *img;
    EQNamedImage *namedImg;
    
    NSRange range = [bundle rangeOfString:@" "];
    if (range.location != NSNotFound) {
        bundle = [bundle substringToIndex:range.location];
        
        NSString *suffix = (nam.scale == 2.0 ? @"@2x" : @"");
        NSString *filename = [NSString stringWithFormat:@"%@%@.png", nam.name, suffix];
        
        // First, try to load from our cache
        for (NSDictionary *dict in cachedImages) { // Each bundle ID has it's own cached dictionary.
            if ([dict objectForKey:filename] && [[dict objectForKey:@"bundle"] isEqualToString:bundle]) {
                namedImg = [dict objectForKey:filename];
                NSLog(@"*** [Equinox] :: DEBUG :: Returning cached image for %@", filename);
            }
        }
    
        for (NSDictionary *dict in cachedImageNames) {
            if (namedImg)
                break;
            
            NSArray *array = [dict objectForKey:bundle];
            
            if ([array containsObject:filename]) {
                NSLog(@"*** [Equinox] :: DEBUG :: Theme %@ contains image %@", [dict objectForKey:@"theme"], filename);
                
                // We have our theme dictionary. Now, find the UIImage associated with that
            
                NSString *fullFilePath = [NSString stringWithFormat:@"/Library/Themes/%@/Equinox/%@/%@", [dict objectForKey:@"theme"], bundle, filename];
                NSLog(@"*** [Equinox] :: DEBUG :: File path == %@", fullFilePath);
                img = [UIImage imageWithContentsOfFile:fullFilePath];
            
                NSError *err;
                namedImg = [[EQNamedImage alloc] initWithName:nam.name usingRenditionKey:[nam renditionKeyName] fromTheme:[CUIThemeFacet themeForBundleIdentifier:bundle error:&err]];
                namedImg.image2 = [img CGImage];
                namedImg.size2 = [img size];
            
                namedImg.scale2 = [nam scale];
                //namedImg.edgeInsets2 = nam.edgeInsets; // Must fix this!
                namedImg.resizingMode2 = nam.resizingMode;
                namedImg.opacity2 = nam.opacity;
                namedImg.blendMode2 = nam.blendMode;
                namedImg.hasSliceInformation2 = nam.hasSliceInformation;
                
                // We have our image, now need to cache it.
                
                NSMutableDictionary *dictionary;
                for (NSMutableDictionary *dict in cachedImages) {
                    if ([[dict objectForKey:@"bundle"] isEqualToString:bundle])
                        // Gotcha
                        dictionary = dict;
                }
                
                if (!dictionary) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:bundle forKey:@"bundle"];
                }
                
                [dictionary setObject:namedImg forKey:filename];
                
                [cachedImages addObject:dict];
            }
        }
    }
    
    return namedImg;
}

+(void)loadThemedImageNamesForBundle:(NSBundle *)bundle {
    if (!bundle)
        return;
    
    // Scan through each theme installed on the user's device.
    // Cache these names
    
    if (!cachedImageNames) {
        cachedImageNames = [[NSMutableSet alloc] init];
    }

    NSString *path = [bundle bundleIdentifier];
   
    if (path) {
    
        for (NSDictionary *dict in cachedImageNames) {
            if ([dict objectForKey:path])
                // Already loaded
                return;
        }
        
        NSMutableSet *tempCache = [NSMutableSet set];
    
        for (NSString *theme in [EQResources enabledWBThemes]) {
            
            NSLog(@"*** [Equinox] :: DEBUG :: caching images from %@ for theme %@", path, theme);
        
            NSMutableDictionary *dict;
            BOOL containsAlready = NO;
            
            for (NSDictionary *dictionary in cachedImageNames) {
                if ([[dict objectForKey:@"theme"] isEqualToString:[theme stringByAppendingString:@".theme"]]) {
                    NSLog(@"*** [Equinox] :: DEBUG :: Theme already exists, loading from existing dictionary");
                    dict = (NSMutableDictionary*)dictionary;
                    containsAlready = YES;
                }
            }
            
            if (!dict) {
                NSLog(@"*** [Equinox] :: DEBUG :: Creating new dictionary");
                dict = [NSMutableDictionary dictionary];
                [dict setObject:[theme stringByAppendingString:@".theme"] forKey:@"theme"];
            }
    
            NSError *error;
            NSString *bundlePath = [NSString stringWithFormat:@"/Library/Themes/%@.theme/Equinox/%@", theme, path];
            NSMutableArray *array = [NSMutableArray array]; // Create a new array for this bundle ID.
            for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:bundlePath error:&error]) {
                // If we've already loaded this name, fail.
                if (![tempCache containsObject:file]) {
                    NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", bundlePath, file];
        
                    BOOL isDir = NO;
                    [[NSFileManager defaultManager] fileExistsAtPath:fullFileName isDirectory:&isDir];
                    
                    if (!isDir)
                        [array addObject:file];
                    
                    [tempCache addObject:file];
                    
                    NSLog(@"*** [Equinox] :: caching image name %@ for theme %@", file, theme);
                }
            }
            
            [dict setObject:array forKey:path]; // Each theme contains an array per bundle ID.
            
            if (!containsAlready)
                [cachedImageNames addObject:dict];
        }
    }
}

+(BOOL)loadedThemesContainsIconFileWithBundleID:(NSString *)bundle andNamedImage:(CUINamedImage*)nam {
    if (!nam)
        return NO;
    NSRange range = [bundle rangeOfString:@" "];
    if (range.location != NSNotFound) {
        bundle = [bundle substringToIndex:range.location];
        
        BOOL contains = NO;
    
        for (NSDictionary *dict in cachedImageNames) {
            NSArray *array = [dict objectForKey:bundle];
        
            if (array) {
                NSLog(@"*** [Equinox] :: DEBUG :: Checking %@ for bundle ID %@ and image %@", [dict objectForKey:@"theme"], bundle, nam.name);
                
                // We have our theme dictionary. Now, find the UIImage associated with that
                NSString *suffix = (nam.scale == 2.0 ? @"@2x" : @"");
                NSString *filename = [NSString stringWithFormat:@"%@%@.png", nam.name, suffix];
            
                if ([array containsObject:filename])
                    contains = YES;
            }
        }
        
        return contains;
    }
    
    return NO;
}

+(void)reloadCaches {
    NSLog(@"Reloading caches");
    [cachedImageNames removeAllObjects];
    [cachedImages removeAllObjects];
}

+(void)killCachedImages {
    [cachedImages removeAllObjects];
}

@end

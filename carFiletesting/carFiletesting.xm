/*
 
 Equinox
 A revolution in iOS 7+ theming.
 
 Copyright (c) 2014, Matt Clarke (Matchstic)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
*/

#import <UIKit/UIKit.h>
#import "EQCache.h"
#import "EQResources.h"
#import <dispatch/dispatch.h>

/*
 Notes
 
 deviceIdiom; 1 = iPhone, 2 = iPad
*/

@class CUICommonAssetStorage, NSString, NSLock, NSMutableDictionary;

@interface CUICommonAssetStorage : NSObject
- (id)allRenditionNames;
- (id)allAssetKeys;
@end

@interface CUIStructuredThemeStore : NSObject
- (id)themeStore;
- (id)lookupAssetForKey:(id)arg1;
- (id)bundleID;
- (id)cache;
@end

@interface CUIStructuredThemeStore (RuntimeAdditions)
-(CUICommonAssetStorage*)assetStore;
@end

@interface CUICatalog : NSObject
- (unsigned int)_themeRef;
- (id)imageWithName:(id)arg1 scaleFactor:(CGFloat)arg2 deviceIdiom:(int)arg3;
- (id)imageWithName:(id)arg1 scaleFactor:(CGFloat)arg2;
- (id)_baseKeyForName:(id)arg1;
- (id)_resolvedRenditionKeyForName:(id)arg1 scaleFactor:(CGFloat)arg2 deviceIdiom:(int)arg3 deviceSubtype:(unsigned int)arg4;
- (id)imageWithName:(id)arg1 scaleFactor:(CGFloat)arg2 deviceIdiom:(int)arg3 deviceSubtype:(unsigned int)arg4;
- (id)initWithName:(id)arg1 fromBundle:(id)arg2 error:(id*)arg3;
- (CUIStructuredThemeStore*)_themeStore;
- (id)initWithName:(id)arg1 fromBundle:(id)arg2;
- (id)imageByStylingImage:(CGImage)arg1 stylePresetName:(id)arg2 styleConfiguration:(id)arg3 foregroundColor:(CGColor)arg4 scale:(CGFloat)arg5;
@end

// The magic happens right here

%hook CUICatalog

-(id)initWithName:(id)arg1 fromBundle:(id)arg2 error:(id*)arg3 {
    [EQCache loadThemedImageNamesForBundle:arg2];
    
    NSString *path = [arg2 bundleIdentifier];
    NSLog(@"*** [Equinox :: UIKit] - Bundle ID of CUICatalog is %@", path);
    
    CUICatalog *catalog = %orig;
    
    // We can dump the whole .car at this point.
    if ([EQResources logImages] && catalog) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *bundle;
        NSArray *keynames;
        if ([catalog class] == [objc_getClass("CUICatalog") class]) {
            NSRange range = [[[self _themeStore] bundleID] rangeOfString:@" "];
            if (range.location != NSNotFound)
                bundle = [[[self _themeStore] bundleID] substringToIndex:range.location];
        
            keynames = [[[catalog _themeStore] assetStore] allRenditionNames];
        }
        for (NSString* name in keynames) {
            // Two Retina (iPhone/iPad) and two non-retina
            
            // Non-retina iPhone
            // Ensure not themed already
            UIImage *imgurnonret;
            CUINamedImage *nonret = [catalog imageWithName:name scaleFactor:1.0 deviceIdiom:1 deviceSubtype:0];
            if (nonret && ![EQCache loadedThemesContainsIconFileWithBundleID:[[self _themeStore] bundleID] andNamedImage:nonret]) {
                NSString *suffix = (nonret.scale == 2.0 ? @"@2x" : @"");
                NSString *filename = [NSString stringWithFormat:@"%@%@.png", nonret.name, suffix];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@/%@", bundle, filename]]) { // Only write once
                    
                    // Create UIImage
                    imgurnonret = [UIImage imageWithCGImage:(struct CGImage*)nonret.image];
                    
                    NSError *err;
                    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@", bundle] isDirectory:nil])
                        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@", bundle] withIntermediateDirectories:YES attributes:nil error:&err];
                    
                    [UIImagePNGRepresentation(imgurnonret) writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@/%@", bundle, filename] atomically:YES];
                    
                    NSLog(@"*** Saving %@ to disk", filename);
                }
            }
            
            UIImage *imgurret;
            CUINamedImage *ret = [catalog imageWithName:name scaleFactor:2.0 deviceIdiom:1 deviceSubtype:0];
            if (ret && ![EQCache loadedThemesContainsIconFileWithBundleID:[[self _themeStore] bundleID] andNamedImage:ret]) {
                NSString *suffix = (ret.scale == 2.0 ? @"@2x" : @"");
                NSString *filename = [NSString stringWithFormat:@"%@%@.png", ret.name, suffix];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@/%@", bundle, filename]]) {// Only write once
                    
                    // Create UIImage
                    imgurret = [UIImage imageWithCGImage:(struct CGImage*)ret.image];
                    
                    NSError *err;
                    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@", bundle] isDirectory:nil])
                        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@", bundle] withIntermediateDirectories:YES attributes:nil error:&err];
                    
                    [UIImagePNGRepresentation(imgurret) writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@/%@", bundle, filename] atomically:YES];
                    
                    NSLog(@"*** Saving %@ to disk", filename);
                }
            }
        }
        });
    }
    
    return catalog;
}

-(id)imageWithName:(id)arg1 scaleFactor:(CGFloat)arg2 deviceIdiom:(int)arg3 deviceSubtype:(unsigned int)arg4 {
    CUINamedImage *img = %orig;
    
    if ([EQCache loadedThemesContainsIconFileWithBundleID:[[self _themeStore] bundleID] andNamedImage:img]) {
        CUINamedImage *retur = [EQCache imageForBundleID:[[self _themeStore] bundleID] andNamedImage:img];
        return retur;
    } else {
        return img;
    }
}

%end

%hook CUINamedImage

%new
-(id)renditionKeyName {
    return MSHookIvar<CUIRenditionKey*>(self, "_key");
}

%end

%hook CUIStructuredThemeStore

%new
-(CUICommonAssetStorage*)assetStore {
    return MSHookIvar<CUICommonAssetStorage*>(self, "_store");
}

%end

%hook UIApplication

-(void)didReceiveMemoryWarning {
    %orig;
    
    // Save some memory
    [EQCache killCachedImages];
}

%end

%group SpringBoard



%end


%group Preferences

// TODO: Load iconCache from WinterBoard themes, rather than /var/mobile/Library/Equinox

%hook PrefsListController

-(id)init {
    
    id prefs = %orig;
    
    // Grab our icons from cache
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    // For WB loading, you need to adjust the filepath for the current enabled theme that has prefs icons
    // Run through enabled WB themes, and check which is the first to contain 
    
    NSError *err;
    NSArray *folder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Equinox/com.apple.Preferences/iconCache" error:&err];
    if (folder) {
        for (NSString *filename in folder) {
            if (([filename rangeOfString:@"@2x"].location != NSNotFound) && [UIScreen mainScreen].scale == 2.0) {
                // Load Retina image
                UIImage *img;
                if ([filename rangeOfString:@"png"].location != NSNotFound)
                    img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/com.apple.Preferences/iconCache/%@", filename]];
                    
                    if (img) {
                        // Save image into dictionary
                        NSRange range = [filename rangeOfString:@"@2x.png"];
                        NSString *file;
                        if (range.location != NSNotFound) {
                            file = [filename substringToIndex:range.location];
                            
                            [dict setObject:img forKey:file];
                        }
                    }
                
            } else if ([UIScreen mainScreen].scale == 1.0) {
                // Non-Retina image needs to be loaded
                UIImage *img;
                if ([filename rangeOfString:@"png"].location != NSNotFound)
                    img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/com.apple.Preferences/iconCache/%@", filename]];
                    
                    if (img) {
                        // Save image into dictionary
                        
                        // Get filename without extension
                        NSRange range = [filename rangeOfString:@".png"];
                        NSString *file;
                        if (range.location != NSNotFound) {
                            file = [filename substringToIndex:range.location];
                            
                            [dict setObject:img forKey:file];
                        }
                    }
            }
        }
    }
    
    // Images are now loaded. Populate with the keys and objects from original dictionary
    
    if ([dict count] == 0)
        return prefs;
    
    NSDictionary *dict2 = MSHookIvar<NSDictionary*>(self, "_iconCache");
    
    for (NSString *key in dict2) {
        if (![dict objectForKey:key]) {
            // Alright! We're good to add this image
            [dict setObject:[dict2 objectForKey:key] forKey:key];
        }
    }
    
    MSHookIvar<NSDictionary*>(self, "_iconCache") = dict;
    
    return prefs;
}

%end

%end

// handle reloading settings when needed

static void EQSettingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[EQResources reloadSettings];
}

%ctor {
    %init;
    
    // Load in code dependant on where we are.
    // Always load UIKit
    
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundle isEqualToString:@"com.apple.springboard"])
        %init(SpringBoard);
    else if ([bundle isEqualToString:@"com.apple.Preferences"])
        %init(Preferences);
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, EQSettingsChanged, CFSTR("com.matchstic.Equinox/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

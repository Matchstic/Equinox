#line 1 "/Users/Matt/iOS/Projects/carFiletesting/carFiletesting/carFiletesting.xm"























#import <UIKit/UIKit.h>
#import "EQCache.h"
#import "EQResources.h"
#import <dispatch/dispatch.h>














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



#include <logos/logos.h>
#include <substrate.h>
@class CUIStructuredThemeStore; @class CUINamedImage; @class PrefsListController; @class CUICatalog; @class UIApplication; 
static id (*_logos_orig$_ungrouped$CUICatalog$initWithName$fromBundle$error$)(CUICatalog*, SEL, id, id, id*); static id _logos_method$_ungrouped$CUICatalog$initWithName$fromBundle$error$(CUICatalog*, SEL, id, id, id*); static id (*_logos_orig$_ungrouped$CUICatalog$imageWithName$scaleFactor$deviceIdiom$deviceSubtype$)(CUICatalog*, SEL, id, CGFloat, int, unsigned int); static id _logos_method$_ungrouped$CUICatalog$imageWithName$scaleFactor$deviceIdiom$deviceSubtype$(CUICatalog*, SEL, id, CGFloat, int, unsigned int); static id _logos_method$_ungrouped$CUINamedImage$renditionKeyName(CUINamedImage*, SEL); static CUICommonAssetStorage* _logos_method$_ungrouped$CUIStructuredThemeStore$assetStore(CUIStructuredThemeStore*, SEL); static void (*_logos_orig$_ungrouped$UIApplication$didReceiveMemoryWarning)(UIApplication*, SEL); static void _logos_method$_ungrouped$UIApplication$didReceiveMemoryWarning(UIApplication*, SEL); 

#line 75 "/Users/Matt/iOS/Projects/carFiletesting/carFiletesting/carFiletesting.xm"


static id _logos_method$_ungrouped$CUICatalog$initWithName$fromBundle$error$(CUICatalog* self, SEL _cmd, id arg1, id arg2, id* arg3) {
    [EQCache loadThemedImageNamesForBundle:arg2];
    
    NSString *path = [arg2 bundleIdentifier];
    NSLog(@"*** [Equinox :: UIKit] - Bundle ID of CUICatalog is %@", path);
    
    CUICatalog *catalog = _logos_orig$_ungrouped$CUICatalog$initWithName$fromBundle$error$(self, _cmd, arg1, arg2, arg3);
    
    
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
            
            
            
            
            UIImage *imgurnonret;
            CUINamedImage *nonret = [catalog imageWithName:name scaleFactor:1.0 deviceIdiom:1 deviceSubtype:0];
            if (nonret && ![EQCache loadedThemesContainsIconFileWithBundleID:[[self _themeStore] bundleID] andNamedImage:nonret]) {
                NSString *suffix = (nonret.scale == 2.0 ? @"@2x" : @"");
                NSString *filename = [NSString stringWithFormat:@"%@%@.png", nonret.name, suffix];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@/%@", bundle, filename]]) { 
                    
                    
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
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/LoggedImages/iPhone/%@/%@", bundle, filename]]) {
                    
                    
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

static id _logos_method$_ungrouped$CUICatalog$imageWithName$scaleFactor$deviceIdiom$deviceSubtype$(CUICatalog* self, SEL _cmd, id arg1, CGFloat arg2, int arg3, unsigned int arg4) {
    CUINamedImage *img = _logos_orig$_ungrouped$CUICatalog$imageWithName$scaleFactor$deviceIdiom$deviceSubtype$(self, _cmd, arg1, arg2, arg3, arg4);
    
    if ([EQCache loadedThemesContainsIconFileWithBundleID:[[self _themeStore] bundleID] andNamedImage:img]) {
        CUINamedImage *retur = [EQCache imageForBundleID:[[self _themeStore] bundleID] andNamedImage:img];
        return retur;
    } else {
        return img;
    }
}






static id _logos_method$_ungrouped$CUINamedImage$renditionKeyName(CUINamedImage* self, SEL _cmd) {
    return MSHookIvar<CUIRenditionKey*>(self, "_key");
}






static CUICommonAssetStorage* _logos_method$_ungrouped$CUIStructuredThemeStore$assetStore(CUIStructuredThemeStore* self, SEL _cmd) {
    return MSHookIvar<CUICommonAssetStorage*>(self, "_store");
}





static void _logos_method$_ungrouped$UIApplication$didReceiveMemoryWarning(UIApplication* self, SEL _cmd) {
    _logos_orig$_ungrouped$UIApplication$didReceiveMemoryWarning(self, _cmd);
    
    
    [EQCache killCachedImages];
}










static id (*_logos_orig$Preferences$PrefsListController$init)(PrefsListController*, SEL); static id _logos_method$Preferences$PrefsListController$init(PrefsListController*, SEL); 



static id _logos_method$Preferences$PrefsListController$init(PrefsListController* self, SEL _cmd) {
    
    id prefs = _logos_orig$Preferences$PrefsListController$init(self, _cmd);
    
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    
    
    
    
    NSError *err;
    NSArray *folder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Equinox/com.apple.Preferences/iconCache" error:&err];
    if (folder) {
        for (NSString *filename in folder) {
            if (([filename rangeOfString:@"@2x"].location != NSNotFound) && [UIScreen mainScreen].scale == 2.0) {
                
                UIImage *img;
                if ([filename rangeOfString:@"png"].location != NSNotFound)
                    img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/com.apple.Preferences/iconCache/%@", filename]];
                    
                    if (img) {
                        
                        NSRange range = [filename rangeOfString:@"@2x.png"];
                        NSString *file;
                        if (range.location != NSNotFound) {
                            file = [filename substringToIndex:range.location];
                            
                            [dict setObject:img forKey:file];
                        }
                    }
                
            } else if ([UIScreen mainScreen].scale == 1.0) {
                
                UIImage *img;
                if ([filename rangeOfString:@"png"].location != NSNotFound)
                    img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Equinox/com.apple.Preferences/iconCache/%@", filename]];
                    
                    if (img) {
                        
                        
                        
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
    
    
    
    if ([dict count] == 0)
        return prefs;
    
    NSDictionary *dict2 = MSHookIvar<NSDictionary*>(self, "_iconCache");
    
    for (NSString *key in dict2) {
        if (![dict objectForKey:key]) {
            
            [dict setObject:[dict2 objectForKey:key] forKey:key];
        }
    }
    
    MSHookIvar<NSDictionary*>(self, "_iconCache") = dict;
    
    return prefs;
}







static void TDSettingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[EQResources reloadSettings];
}

static __attribute__((constructor)) void _logosLocalCtor_4b7341e2() {
    {Class _logos_class$_ungrouped$CUICatalog = objc_getClass("CUICatalog"); MSHookMessageEx(_logos_class$_ungrouped$CUICatalog, @selector(initWithName:fromBundle:error:), (IMP)&_logos_method$_ungrouped$CUICatalog$initWithName$fromBundle$error$, (IMP*)&_logos_orig$_ungrouped$CUICatalog$initWithName$fromBundle$error$);MSHookMessageEx(_logos_class$_ungrouped$CUICatalog, @selector(imageWithName:scaleFactor:deviceIdiom:deviceSubtype:), (IMP)&_logos_method$_ungrouped$CUICatalog$imageWithName$scaleFactor$deviceIdiom$deviceSubtype$, (IMP*)&_logos_orig$_ungrouped$CUICatalog$imageWithName$scaleFactor$deviceIdiom$deviceSubtype$);Class _logos_class$_ungrouped$CUINamedImage = objc_getClass("CUINamedImage"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CUINamedImage, @selector(renditionKeyName), (IMP)&_logos_method$_ungrouped$CUINamedImage$renditionKeyName, _typeEncoding); }Class _logos_class$_ungrouped$CUIStructuredThemeStore = objc_getClass("CUIStructuredThemeStore"); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(CUICommonAssetStorage*), strlen(@encode(CUICommonAssetStorage*))); i += strlen(@encode(CUICommonAssetStorage*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$CUIStructuredThemeStore, @selector(assetStore), (IMP)&_logos_method$_ungrouped$CUIStructuredThemeStore$assetStore, _typeEncoding); }Class _logos_class$_ungrouped$UIApplication = objc_getClass("UIApplication"); MSHookMessageEx(_logos_class$_ungrouped$UIApplication, @selector(didReceiveMemoryWarning), (IMP)&_logos_method$_ungrouped$UIApplication$didReceiveMemoryWarning, (IMP*)&_logos_orig$_ungrouped$UIApplication$didReceiveMemoryWarning);}
    
    
    
    
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundle isEqualToString:@"com.apple.springboard"])
        {}
    else if ([bundle isEqualToString:@"com.apple.Preferences"])
        {Class _logos_class$Preferences$PrefsListController = objc_getClass("PrefsListController"); MSHookMessageEx(_logos_class$Preferences$PrefsListController, @selector(init), (IMP)&_logos_method$Preferences$PrefsListController$init, (IMP*)&_logos_orig$Preferences$PrefsListController$init);}
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, TDSettingsChanged, CFSTR("com.matchstic.Equinox/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

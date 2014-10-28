//
//  EQResources.m
//  Equinox
//
//  Created by Matt Clarke on 31/03/2014.
//
//

#import "EQResources.h"

static NSDictionary *settings;
static NSArray *enabledWBThemes; // This is reset on respring, so no need to worry!

@implementation EQResources

+(BOOL)logImages {
    if (!settings)
        settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.Equinox.plist"];
    
    id temp = settings[@"logImages"];
    return (temp ? [temp boolValue] : NO);
}

+(NSArray*)enabledWBThemes {
    if (enabledWBThemes)
        return enabledWBThemes;
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.saurik.WinterBoard.plist"];
    NSArray *themes = [dict objectForKey:@"Themes"];
    
    NSMutableArray *enabledThemes = [NSMutableArray new];
    
    for (NSDictionary *theme in themes) {
        if ([[theme objectForKey:@"Active"] boolValue]) {
            // Sweet! Add the name to our array
            [enabledThemes addObject:[theme objectForKey:@"Name"]]; // Theme does not include the .theme suffix
        }
    }
    
    enabledWBThemes = (NSArray*)enabledThemes;
    
    return enabledWBThemes;
}

+(void)reloadSettings {
    // TODO: Fix for iOS 8.
    settings = nil;
    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.Equinox.plist"];
}

@end

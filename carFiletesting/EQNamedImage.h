//
//  EQNamedImage.h
//  Equinox
//
//  Created by Matt Clarke on 30/03/2014.
//
//  Polymorphism <3

#import "EQCache.h"

@class CUIRenditionKey, NSString;

@interface CUINamedImage : NSObject  {
    CUIRenditionKey *_key;
    unsigned int _storageRef;
    NSString *_name;
}

@property(copy) NSString * name;
@property(readonly) id image; // CGImage
@property(readonly) CGSize size;
@property(readonly) float scale;
@property(readonly) id edgeInsets;
@property(readonly) int resizingMode;
@property(readonly) float opacity;
@property(readonly) int blendMode;
@property(readonly) BOOL hasSliceInformation;

- (CGSize)size;
- (float)opacity;
- (id)initWithName:(id)arg1 usingRenditionKey:(id)arg2 fromTheme:(unsigned int)arg3;
- (int)resizingMode;
- (id)edgeInsets;
- (id)_rendition;
- (float)positionOfSliceBoundary:(int)arg1;
- (id)_renditionForSpecificKey:(id)arg1;
- (id)_themeStore;
- (int)blendMode;
- (id)image;
- (id)name;
- (void)dealloc;
- (id)description;
- (BOOL)hasSliceInformation;
- (float)scale;
- (void)setName:(NSString*)arg1;

@end


@interface EQNamedImage : CUINamedImage

//@property(copy) NSString * name2;
@property struct CGImage *image2; // CGImage
@property CGSize size2;
@property float scale2;
@property (strong) id edgeInsets2;
@property int resizingMode2;
@property float opacity2;
@property int blendMode2;
@property BOOL hasSliceInformation2;

@end

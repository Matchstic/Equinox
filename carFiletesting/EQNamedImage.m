//
//  EQNamedImage.m
//  Equinox
//
//  Created by Matt Clarke on 30/03/2014.
//
//

#import "EQNamedImage.h"

@implementation EQNamedImage

// Property overrides

-(CGSize)size {
    return self.size2;
}
-(float)opacity {
    return self.opacity2;
}
-(int)resizingMode {
    return self.resizingMode2;
}
/*-(id)edgeInsets {
    return self.edgeInsets2;
}*/
-(int)blendMode {
    return self.blendMode2;
}
-(id)image {
    return (id)self.image2;
}

-(BOOL)hasSliceInformation {
    return self.hasSliceInformation2;
}
-(float)scale {
    return self.scale2;
}

@end

//
//  SPGerberGCode.m
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberGCode.h"
#import "SPGerberRenderingContext.h"

@implementation SPGerberGCode

- (void)applyToContext:(SPGerberRenderingContext *)context
{
    switch (self.code) {
        case PFGerberGCodeEnable360DegreeCircularInterpolation:
            context.fullCircleInterpolationEnabled = YES;
            break;
        case PFGerberGCodeInchs:
            context.usingInches = YES;
            break;
        default:
            break;
    }
}

@end

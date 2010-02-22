//
//  SPGerberDCode.m
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberDCode.h"
#import "SPGerberRenderingContext.h"

@implementation SPGerberDCode

- (void)applyToContext:(SPGerberRenderingContext*)context
{
    switch (self.code)
    {
        case SPGerberExposureOn:
            break;
        case SPGerberExposureOff:
            break;
        case SPGerberExposureFlash:
            break;
        default:
            [context setActiveAperture:self.code];
            break;
    }
}

@end

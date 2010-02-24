//
//  SPGerberOffset.m
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberOffset.h"
#import "SPGerberRenderingContext.h"

@implementation SPGerberOffset

@synthesize aOffset;
@synthesize bOffset;

- (void)applyToContext:(SPGerberRenderingContext *)context
{
    context.offset = SPMakeVec(self.aOffset, self.bOffset, 0.0);
}

@end

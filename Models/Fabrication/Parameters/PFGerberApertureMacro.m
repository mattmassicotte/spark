//
//  PFGerberApertureMacro.m
//  Spark
//
//  Created by Matt Massicotte on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PFGerberApertureMacro.h"

@implementation PFGerberApertureMacro

@synthesize name;
@synthesize type;

- (void)setType:(PFGerberApertureMacroPrimitiveType)newType
{
    if (newType == PFGerberApertureMacroOtherLineVector)
        newType = PFGerberApertureMacroLineVector;
    
    type = newType;
}

@end

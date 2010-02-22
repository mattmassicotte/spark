//
//  PFGerberApertureDefinition.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberApertureDefinition.h"
#import "SPGerberRenderingContext.h"

@implementation SPGerberApertureDefinition

@synthesize apertureType;
@synthesize dCode;
@synthesize macroName;
@synthesize modifiers;

- (id)init
{
    self = [super init];
    if (self)
    {
        modifiers = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [modifiers release];
    
    [super dealloc];
}

- (NSString*)description
{
    NSMutableString* string;
    
    string = [NSMutableString stringWithString:@"<Aperture Definition: "];
    
    switch (self.apertureType)
    {
        case SPGerberApertureCircle:         [string appendString:@"Circle"];              break;
        case SPGerberApertureRectangle:      [string appendString:@"Rectangle"];           break;
        case SPGerberApertureObround:        [string appendString:@"Obround"];             break;
        case SPGerberAperturePolygon:        [string appendString:@"Polygon"];             break;
        case SPGerberApertureMacroReference: [string appendFormat:@"Macro %@", macroName]; break;
        default:
            return [super description];
    }
    
    [string appendString:@">"];
    
    return string;
}

- (void)addModifier:(NSNumber*)modifier
{
    [modifiers addObject:modifier];
}

- (void)applyToContext:(SPGerberRenderingContext *)context
{
    [context addApertureDefinition:self];
}

@end

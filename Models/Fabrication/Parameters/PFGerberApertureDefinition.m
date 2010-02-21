//
//  PFGerberApertureDefinition.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PFGerberApertureDefinition.h"

@implementation PFGerberApertureDefinition

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
        case PFGerberApertureCircle:         [string appendString:@"Circle"];              break;
        case PFGerberApertureRectangle:      [string appendString:@"Rectangle"];           break;
        case PFGerberApertureObround:        [string appendString:@"Obround"];             break;
        case PFGerberAperturePolygon:        [string appendString:@"Polygon"];             break;
        case PFGerberApertureMacroReference: [string appendFormat:@"Macro %@", macroName]; break;
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

@end

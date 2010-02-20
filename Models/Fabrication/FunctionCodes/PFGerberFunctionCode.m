//
//  PFGerberFunctionCode.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PFGerberFunctionCode.h"

@implementation PFGerberFunctionCode

@synthesize type;
@synthesize code;
@synthesize xValue;
@synthesize yValue;
@synthesize iValue;
@synthesize jValue;
@synthesize dCode;

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (NSString*)description
{
    NSMutableString* string;
    
    string = [NSMutableString string];
    
    [string appendFormat:@"<"];
    switch (self.type)
    {
        case PFGerberFunctionCodeNCode: [string appendFormat:@"N"]; break;
        case PFGerberFunctionCodeGCode: [string appendFormat:@"G"]; break;
        case PFGerberFunctionCodeDCode: [string appendFormat:@"D"]; break;
        case PFGerberFunctionCodeMCode: [string appendFormat:@"M"]; break;
        default:
            return [super description];
    }
    
    [string appendFormat:@"-Code %d>", self.code];
    
    return string;
}

@end

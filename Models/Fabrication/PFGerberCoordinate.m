//
//  PFGerberCoordinate.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PFGerberCoordinate.h"

@implementation PFGerberCoordinate

- (void)dealloc
{
    [x release];
    [y release];
    [i release];
    [j release];
    
    [super dealloc];
}

@synthesize x;
@synthesize y;
@synthesize i;
@synthesize j;
@synthesize exposureType;

- (NSString*)description
{
    NSMutableString* string;
    
    string = [NSMutableString string];
    [string appendFormat:@"<X:%@ Y:%@ I:%@ J:%@", self.x, self.y, self.i, self.j];
    [string appendFormat:@"%d>", self.exposureType];
    
    return string;
}

@end

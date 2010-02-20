//
//  NSScannerExtensions.m
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSScannerExtensions.h"

@implementation NSScanner (NSScannerExtensions)

- (void)advance
{
    [self advanceBy:1];
}

- (void)advanceBy:(NSUInteger)count
{
    [self setScanLocation:[self scanLocation] + count];
}

- (unichar)currentCharacter
{
    if ([self isAtEnd])
        return 0;
    
    return [[self string] characterAtIndex:[self scanLocation]];
}

@end

//
//  SPGerberParserProtelTest.m
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberParserProtelTest.h"

@implementation SPGerberParserProtelTest

- (void)testMechanicalLayer
{
    [self loadTestDocument:@"/Example Gerbers/protel_output.GM1"];
    
    NSLog(@"%@", mockDelegate.elements);
    
    STAssertTrue([[mockDelegate elementAtIndex:1] usingInches], @"usingInches should be true");
    
    AssertGCode([mockDelegate elementAtIndex:2], 70);
    AssertGCode([mockDelegate elementAtIndex:3], 1);
    AssertGCode([mockDelegate elementAtIndex:4], 75);
    
    AssertRectangleAperture([mockDelegate elementAtIndex:5], 10, 0.06, 0.65);
    AssertCircleAperture([mockDelegate elementAtIndex:11],   16, 0.04);
    AssertCircleAperture([mockDelegate elementAtIndex:64],   69, 0.058);
    
    AssertDCode([mockDelegate elementAtIndex:65], 17);
    
    AssertLinearCoordinate([mockDelegate elementAtIndex:66], -1594.0, 4550.0, SPGerberExposureOff);
    
    AssertMCode([mockDelegate elementAtIndex:75], 2);
}

@end

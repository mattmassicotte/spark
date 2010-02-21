//
//  SPGerberParserTest.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberParserBasicTest.h"

@implementation SPGerberParserBasicTest

- (void)testBasicDocument
{
	[self loadTestDocument:@"/Test Gerbers/basic_document.GTL"];
    
    STAssertTrue(mockDelegate.didStartDocumentCalled, @"DidStartDocument must be called");
    
    STAssertTrue([[mockDelegate elementAtIndex:0] omitLeadingZeros], @"L should set omitLeadingZeros");
    STAssertFalse([[mockDelegate elementAtIndex:0] omitTrailingZeros], @"L should not set omitTrailingZeros");
    
    STAssertTrue([[mockDelegate elementAtIndex:1] usingInches], @"usingInches should be true");
    
    AssertMCode([mockDelegate elementAtIndex:2], 2);
    
    STAssertEquals([[mockDelegate elements] count], (NSUInteger)3, @"There should be three elements in this document");
    
    STAssertTrue(mockDelegate.didEndDocumentCalled, @"DidEndDocument must be called");
}

- (void)testArcCoordinate
{
    [self loadTestDocument:@"/Test Gerbers/single_arc_coordinate.GTL"];
    
    AssertArcCoordinate([mockDelegate elementAtIndex:2], 10.0, 11.0, 12.0, 13.0, PFGerberExposureOff);
}

- (void)testImagePolarity
{
    [self loadTestDocument:@"/Test Gerbers/image_polarity.gtl"];
    
    STAssertTrue([[mockDelegate elementAtIndex:0] isPositive], @"image polarity should be defined and true");
}

- (void)testLayerPolarity
{
    [self loadTestDocument:@"/Test Gerbers/layer_polarity.gtl"];
    
    STAssertTrue([[mockDelegate elementAtIndex:0] isDark], @"layer polarity should be defined and true");
}

- (void)testApertureMacro
{
    [self loadTestDocument:@"/Test Gerbers/aperture_macro.gtl"];
}

- (void)testFunctionCodeWithCoordinate
{
    [self loadTestDocument:@"/Test Gerbers/g03_with_coordinate.gtl"];
    
    AssertGCode([mockDelegate elementAtIndex:2], 3);
    AssertArcCoordinate([mockDelegate elementAtIndex:3], 3750.0, 1000.0, 250.0, 0.0, PFGerberExposureOn);
    AssertMCode([mockDelegate elementAtIndex:4], 2);
}

- (void)testBoxesExample
{
    [self loadTestDocument:@"/Spec Gerbers/boxes.GTL"];
    
    AssertGCode([mockDelegate elementAtIndex:0], 4);
  
    STAssertTrue([[mockDelegate elementAtIndex:2] usingInches], @"usingInches should be true");
    
    STAssertTrue([[mockDelegate elementAtIndex:3] aOffset] == 0.0, @"A offset should be 0.0");
    STAssertTrue([[mockDelegate elementAtIndex:3] bOffset] == 0.0, @"B offset should be 0.0");

    STAssertTrue([[mockDelegate elementAtIndex:4] aScale] == 1.0, @"A scale should be 0.0");
    STAssertTrue([[mockDelegate elementAtIndex:4] bScale] == 1.0, @"B scale should be 0.0");

    AssertCircleAperture([mockDelegate elementAtIndex:5], 10, 0.01);
    
    STAssertEqualObjects([[mockDelegate elementAtIndex:6] name], @"BOXES", @"Layer name should be BOXES");
    
    AssertGCode([mockDelegate elementAtIndex:7], 54);
    AssertDCode([mockDelegate elementAtIndex:8], 10);

    AssertLinearCoordinate([mockDelegate elementAtIndex:9],      0.0,     0.0, PFGerberExposureOff);
    AssertLinearCoordinate([mockDelegate elementAtIndex:10],  5000.0,     0.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:11],  5000.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:12],     0.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:13],     0.0,     0.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:14],  6000.0,     0.0, PFGerberExposureNotSpecified);
    AssertLinearCoordinate([mockDelegate elementAtIndex:15], 11000.0,     0.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:16], 11000.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:17],  6000.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:18],  6000.0,     0.0, PFGerberExposureOn);
    
    AssertDCode([mockDelegate elementAtIndex:19], 2);
    
    AssertMCode([mockDelegate elementAtIndex:20], 2);
}

@end

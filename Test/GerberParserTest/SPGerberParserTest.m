//
//  SPGerberParserTest.m
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberParserTest.h"
#import "MockGerberParserDelegate.h"
#import "SPFabrication.h"

#define AssertFunctionCode(element, expectedType, expectedCode) \
STAssertEquals([(SPGerberFunctionCode*)element type], expectedType, @""); \
STAssertEquals([(SPGerberFunctionCode*)element code], (NSUInteger)expectedCode, @"")

#define AssertLinearCoordinate(element, expectedX, expectedY, expectedExposure) \
STAssertEquals([[(PFGerberCoordinate*)element x] doubleValue], expectedX, @""); \
STAssertEquals([[(PFGerberCoordinate*)element y] doubleValue], expectedY, @""); \
STAssertNil([(PFGerberCoordinate*)element i], @""); \
STAssertNil([(PFGerberCoordinate*)element j], @""); \
STAssertEquals([(PFGerberCoordinate*)element exposureType], expectedExposure, @"")

#define AssertArcCoordinate(element, expectedX, expectedY, expectedI, expectedJ, expectedExposure) \
STAssertEquals([[(PFGerberCoordinate*)element x] doubleValue], expectedX, @""); \
STAssertEquals([[(PFGerberCoordinate*)element y] doubleValue], expectedY, @""); \
STAssertEquals([[(PFGerberCoordinate*)element i] doubleValue], expectedI, @""); \
STAssertEquals([[(PFGerberCoordinate*)element j] doubleValue], expectedJ, @""); \
STAssertEquals([(PFGerberCoordinate*)element exposureType], expectedExposure, @"")

#define AssertRectangleAperture(element, expectedDCode, xSize, ySize) \
STAssertEquals([(PFGerberApertureDefinition*)element apertureType], PFGerberApertureRectangle, @""); \
STAssertEquals([(PFGerberApertureDefinition*)element dCode], (NSUInteger)expectedDCode, @""); \
STAssertEquals([[[(PFGerberApertureDefinition*)element modifiers] objectAtIndex:0] doubleValue], xSize, @""); \
STAssertEquals([[[(PFGerberApertureDefinition*)element modifiers] objectAtIndex:1] doubleValue], ySize, @"")

#define AssertCircleAperture(element, expectedDCode, xSize) \
STAssertEquals([(PFGerberApertureDefinition*)element apertureType], PFGerberApertureCircle, @""); \
STAssertEquals([(PFGerberApertureDefinition*)element dCode], (NSUInteger)expectedDCode, @""); \
STAssertEquals([[[(PFGerberApertureDefinition*)element modifiers] objectAtIndex:0] doubleValue], xSize, @"")

@interface SPGerberParserTest ()

- (void)loadDocument:(NSString*)path;
- (void)loadTestDocument:(NSString*)path;

@end

@implementation SPGerberParserTest

- (void)setUp
{
    mockDelegate = [MockGerberParserDelegate new];
}

- (void)tearDown
{
    [mockDelegate release];
    mockDelegate = nil;
    
    [parser release];
    parser = nil;
}

- (void)testBasicDocument
{
	[self loadTestDocument:@"/Test Gerbers/basic_document.GTL"];
    
    STAssertTrue(mockDelegate.didStartDocumentCalled, @"DidStartDocument must be called");
    
    STAssertTrue([[mockDelegate elementAtIndex:0] omitLeadingZeros], @"L should set omitLeadingZeros");
    STAssertFalse([[mockDelegate elementAtIndex:0] omitTrailingZeros], @"L should not set omitTrailingZeros");
    
    STAssertNotNil(mockDelegate.usingInches, @"usingInches should not be nil");
    STAssertTrue([mockDelegate.usingInches boolValue], @"usingInches should be true");
    
    AssertFunctionCode([mockDelegate elementAtIndex:1], PFGerberFunctionCodeMCode, 2);
    
    STAssertEquals([[mockDelegate elements] count], (NSUInteger)2, @"There should be two elements in this document");
    
    STAssertTrue(mockDelegate.didEndDocumentCalled, @"DidEndDocument must be called");
}

- (void)testArcCoordinate
{
    [self loadTestDocument:@"/Test Gerbers/single_arc_coordinate.GTL"];
    
    AssertArcCoordinate([mockDelegate elementAtIndex:1], 10.0, 11.0, 12.0, 13.0, PFGerberExposureOff);
}

- (void)testImagePolarity
{
    [self loadTestDocument:@"/Test Gerbers/image_polarity.gtl"];
    
    STAssertTrue([mockDelegate.imagePolarityPositive boolValue], @"image polarity should be defined and true");
}

- (void)testLayerPolarity
{
    [self loadTestDocument:@"/Test Gerbers/layer_polarity.gtl"];
    
    STAssertTrue([mockDelegate.layerPolarityPositive boolValue], @"layer polarity should be defined and true");
}

- (void)testApertureMacro
{
    [self loadTestDocument:@"/Test Gerbers/aperture_macro.gtl"];
}

- (void)testBoxesExample
{
    [self loadTestDocument:@"/Example Gerbers/gerber_document_boxes.GTL"];
    
    AssertFunctionCode([mockDelegate elementAtIndex:0], PFGerberFunctionCodeGCode, 4);
    
    STAssertTrue([mockDelegate.usingInches boolValue], @"usingInches should be true");
    
    STAssertNotNil([mockDelegate aOffset], @"A offset should be set");
    STAssertNotNil([mockDelegate bOffset], @"B offset should be set");
    STAssertEquals([[mockDelegate aOffset] doubleValue], 0.0, @"A offset should be zero");
    STAssertEquals([[mockDelegate bOffset] doubleValue], 0.0, @"B offset should be zero");
    
    STAssertNotNil([mockDelegate aScale], @"A scale should be set");
    STAssertNotNil([mockDelegate bScale], @"B scale should be set");
    STAssertEquals([[mockDelegate aScale] doubleValue], 1.0, @"A scale should be 1.0");
    STAssertEquals([[mockDelegate bScale] doubleValue], 1.0, @"B scale should be 1.0");
    
    AssertCircleAperture([mockDelegate elementAtIndex:2], 10, 0.01);
    
    STAssertEqualObjects([[mockDelegate layerNames] objectAtIndex:0], @"BOXES", @"Layer should be called BOXES");
    
    AssertFunctionCode([mockDelegate elementAtIndex:3], PFGerberFunctionCodeGCode, 54);
    STAssertEquals([[mockDelegate elementAtIndex:3] dCode], (NSUInteger)10, @"Should be G54D10");
    
    AssertLinearCoordinate([mockDelegate elementAtIndex:4],      0.0,     0.0, PFGerberExposureOff);
    AssertLinearCoordinate([mockDelegate elementAtIndex:5],   5000.0,     0.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:6],   5000.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:7],      0.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:8],      0.0,     0.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:9],   6000.0,     0.0, PFGerberExposureNotSpecified);
    AssertLinearCoordinate([mockDelegate elementAtIndex:10], 11000.0,     0.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:11], 11000.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:12],  6000.0,  5000.0, PFGerberExposureOn);
    AssertLinearCoordinate([mockDelegate elementAtIndex:13],  6000.0,     0.0, PFGerberExposureOn);
    
    AssertFunctionCode([mockDelegate elementAtIndex:14], PFGerberFunctionCodeDCode, 2);
    
    AssertFunctionCode([mockDelegate elementAtIndex:15], PFGerberFunctionCodeMCode, 2);
}

- (void)testProtelOutputMechanicalLayer
{
    [self loadTestDocument:@"/Example Gerbers/protel_output.GM1"];
    
    STAssertTrue([mockDelegate.usingInches boolValue], @"usingInches should be true");
    
    AssertFunctionCode([mockDelegate elementAtIndex:1], PFGerberFunctionCodeGCode, 70);
    AssertFunctionCode([mockDelegate elementAtIndex:2], PFGerberFunctionCodeGCode, 1);
    AssertFunctionCode([mockDelegate elementAtIndex:3], PFGerberFunctionCodeGCode, 75);
    
    AssertRectangleAperture([mockDelegate elementAtIndex:4], 10, 0.06, 0.65);
    AssertCircleAperture([mockDelegate elementAtIndex:10],   16, 0.04);
    AssertCircleAperture([mockDelegate elementAtIndex:63],   69, 0.058);
    
    AssertFunctionCode([mockDelegate elementAtIndex:64], PFGerberFunctionCodeDCode, 17);
    
    AssertLinearCoordinate([mockDelegate elementAtIndex:65], -1594.0, 4550.0, PFGerberExposureOff);
    
    AssertFunctionCode([mockDelegate elementAtIndex:74], PFGerberFunctionCodeMCode, 2);
}

#pragma mark Helpers

- (void)loadDocument:(NSString*)path
{
	parser = [[SPGerberParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
	parser.delegate = mockDelegate;
    
	[parser parse];
}

- (void)loadTestDocument:(NSString*)path
{
    [self loadDocument:[@"Test/Test Documents" stringByAppendingString:path]];
}

@end

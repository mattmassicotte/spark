/*
 *  SPGerberParsingAssertions.h
 *  Spark
 *
 *  Created by Matt Massicotte on 2/20/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#define AssertGCode(element, expectedCode) \
STAssertTrue([element isMemberOfClass:[SPGerberGCode class]], @""); \
STAssertEquals([(SPGerberFunctionCode*)element code], (NSUInteger)expectedCode, @"")

#define AssertMCode(element, expectedCode) \
STAssertTrue([element isMemberOfClass:[SPGerberMCode class]], @""); \
STAssertEquals([(SPGerberMCode*)element code], (NSUInteger)expectedCode, @"")

#define AssertDCode(element, expectedCode) \
STAssertTrue([element isMemberOfClass:[SPGerberDCode class]], @""); \
STAssertEquals([(SPGerberDCode*)element code], (NSUInteger)expectedCode, @"")

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

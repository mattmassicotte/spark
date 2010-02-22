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
STAssertEquals([[(SPGerberCoordinate*)element x] doubleValue], expectedX, @""); \
STAssertEquals([[(SPGerberCoordinate*)element y] doubleValue], expectedY, @""); \
STAssertNil([(SPGerberCoordinate*)element i], @""); \
STAssertNil([(SPGerberCoordinate*)element j], @""); \
STAssertEquals([(SPGerberCoordinate*)element exposureType], expectedExposure, @"")

#define AssertArcCoordinate(element, expectedX, expectedY, expectedI, expectedJ, expectedExposure) \
STAssertEquals([[(SPGerberCoordinate*)element x] doubleValue], expectedX, @""); \
STAssertEquals([[(SPGerberCoordinate*)element y] doubleValue], expectedY, @""); \
STAssertEquals([[(SPGerberCoordinate*)element i] doubleValue], expectedI, @""); \
STAssertEquals([[(SPGerberCoordinate*)element j] doubleValue], expectedJ, @""); \
STAssertEquals([(SPGerberCoordinate*)element exposureType], expectedExposure, @"")

#define AssertRectangleAperture(element, expectedDCode, xSize, ySize) \
STAssertEquals([(SPGerberApertureDefinition*)element apertureType], SPGerberApertureRectangle, @""); \
STAssertEquals([(SPGerberApertureDefinition*)element dCode], (NSUInteger)expectedDCode, @""); \
STAssertEquals([[[(SPGerberApertureDefinition*)element modifiers] objectAtIndex:0] doubleValue], xSize, @""); \
STAssertEquals([[[(SPGerberApertureDefinition*)element modifiers] objectAtIndex:1] doubleValue], ySize, @"")

#define AssertCircleAperture(element, expectedDCode, xSize) \
STAssertEquals([(SPGerberApertureDefinition*)element apertureType], SPGerberApertureCircle, @""); \
STAssertEquals([(SPGerberApertureDefinition*)element dCode], (NSUInteger)expectedDCode, @""); \
STAssertEquals([[[(SPGerberApertureDefinition*)element modifiers] objectAtIndex:0] doubleValue], xSize, @"")

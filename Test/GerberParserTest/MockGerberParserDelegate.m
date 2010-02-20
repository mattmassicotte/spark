//
//  MockGerberParserDelegate.m
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MockGerberParserDelegate.h"

@implementation MockGerberParserDelegate

- (id)init
{
    self = [super init];
    if (self)
    {
        self.didStartDocumentCalled = NO;
        self.didEndDocumentCalled = NO;
        self.usingInches = nil;
        self.aOffset = nil;
        self.bOffset = nil;
        self.aScale = nil;
        self.bScale = nil;
        
        elements   = [NSMutableArray new];
        layerNames = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [elements release];
    [layerNames release];
    
    [super dealloc];
}

@synthesize didStartDocumentCalled;
@synthesize didEndDocumentCalled;
@synthesize usingInches;
@synthesize aOffset;
@synthesize bOffset;
@synthesize aScale;
@synthesize bScale;
@synthesize elements;
@synthesize layerNames;
@synthesize imagePolarityPositive;
@synthesize layerPolarityPositive;

- (id)elementAtIndex:(NSUInteger)index
{
    return [elements objectAtIndex:index];
}

- (void)parserDidStartDocument:(SPGerberParser*)parser
{
    self.didStartDocumentCalled = YES;
}

- (void)parserDidEndDocument:(SPGerberParser*)parser
{
    self.didEndDocumentCalled = YES;
}

- (void)parser:(SPGerberParser*)parser foundFormat:(PFGerberFormat*)format
{
    [elements addObject:format];
}

- (void)parser:(SPGerberParser*)parser foundModeOfUnits:(BOOL)inInches
{
    self.usingInches = [NSNumber numberWithBool:inInches];
}

- (void)parser:(SPGerberParser*)parser foundOffsetForA:(double)theAOffset andB:(double)theBOffset
{
    self.aOffset = [NSNumber numberWithDouble:theAOffset];
    self.bOffset = [NSNumber numberWithDouble:theBOffset];
}

- (void)parser:(SPGerberParser*)parser foundScaleFactorForA:(double)theAScale andB:(double)theBScale
{
    self.aScale = [NSNumber numberWithDouble:theAScale];
    self.bScale = [NSNumber numberWithDouble:theBScale];
}

- (void)parser:(SPGerberParser*)parser foundApertureDefinition:(PFGerberApertureDefinition*)definition
{
    [elements addObject:definition];
}

- (void)parser:(SPGerberParser*)parser foundLayer:(NSString*)name
{
    [layerNames addObject:name];
}

- (void)parser:(SPGerberParser *)parser foundImagePolarity:(BOOL)positivePolarity
{
    self.imagePolarityPositive = [NSNumber numberWithBool:positivePolarity];
}

- (void)parser:(SPGerberParser *)parser foundLayerPolarity:(BOOL)positivePolarity
{
    self.layerPolarityPositive = [NSNumber numberWithBool:positivePolarity];
}

- (void)parser:(SPGerberParser*)parser foundFunctionCode:(PFGerberFunctionCode*)code
{
    [elements addObject:code];
}

- (void)parser:(SPGerberParser*)parser foundCoordinate:(PFGerberCoordinate*)coordinate
{
    [elements addObject:coordinate];
}

@end

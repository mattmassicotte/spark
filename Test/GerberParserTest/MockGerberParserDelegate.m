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
        
        elements = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [elements release];
    
    [super dealloc];
}

@synthesize didStartDocumentCalled;
@synthesize didEndDocumentCalled;
@synthesize elements;

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

- (void)parser:(SPGerberParser*)parser foundStatement:(SPGerberStatement*)statement
{
    [elements addObject:statement];
}

@end

//
//  SPGerberParserTest.h
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MockGerberParserDelegate.h"
#import "SPFabrication.h"
#import "SPGerberParsingAssertions.h"

@class SPGerberParser, MockGerberParserDelegate;

@interface SPGerberParserTest : SenTestCase
{
    SPGerberParser*           parser;
    MockGerberParserDelegate* mockDelegate;
}

- (void)loadDocument:(NSString*)path;
- (void)loadTestDocument:(NSString*)path;

@end

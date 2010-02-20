//
//  SPGerberParserTest.h
//  Spark
//
//  Created by Matt Massicotte on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class SPGerberParser, MockGerberParserDelegate;

@interface SPGerberParserTest : SenTestCase
{
    SPGerberParser*           parser;
    MockGerberParserDelegate* mockDelegate;
}

@end

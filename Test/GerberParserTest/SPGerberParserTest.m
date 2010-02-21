//
//  SPGerberParserTest.m
//  Spark
//
//  Created by Matt Massicotte on 2/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPGerberParserTest.h"

@implementation SPGerberParserTest

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

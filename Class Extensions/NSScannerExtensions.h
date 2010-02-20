//
//  NSScannerExtensions.h
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSScanner (NSScannerExtensions)

- (void)advance;
- (void)advanceBy:(NSUInteger)count;

- (unichar)currentCharacter;

@end

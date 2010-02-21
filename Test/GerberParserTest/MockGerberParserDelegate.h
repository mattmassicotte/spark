//
//  MockGerberParserDelegate.h
//  Spark
//
//  Created by Matt Massicotte on 2/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SPFabrication.h"

@class PFGerberFormat;

@protocol SPGerberParserDelegate;

@interface MockGerberParserDelegate : NSObject <SPGerberParserDelegate>
{
    BOOL            didStartDocumentCalled;
    BOOL            didEndDocumentCalled;

    NSMutableArray* elements;
}

@property (nonatomic)                   BOOL      didStartDocumentCalled;
@property (nonatomic)                   BOOL      didEndDocumentCalled;
@property (nonatomic, retain, readonly) NSArray*  elements;

- (id)elementAtIndex:(NSUInteger)index;

@end

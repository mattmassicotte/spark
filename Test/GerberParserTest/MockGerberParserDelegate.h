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
    
    NSNumber*       usingInches;
    NSNumber*       aOffset;
    NSNumber*       bOffset;
    NSNumber*       aScale;
    NSNumber*       bScale;
    
    NSMutableArray* elements;
    
    NSMutableArray* layerNames;
    
    NSNumber*       imagePolarityPositive;
    NSNumber*       layerPolarityPositive;
}

@property (nonatomic)                   BOOL      didStartDocumentCalled;
@property (nonatomic)                   BOOL      didEndDocumentCalled;
@property (nonatomic, retain)           NSNumber* usingInches;
@property (nonatomic, retain)           NSNumber* aOffset;
@property (nonatomic, retain)           NSNumber* bOffset;
@property (nonatomic, retain)           NSNumber* aScale;
@property (nonatomic, retain)           NSNumber* bScale;
@property (nonatomic, retain)           NSNumber* imagePolarityPositive;
@property (nonatomic, retain)           NSNumber* layerPolarityPositive;

@property (nonatomic, retain, readonly) NSArray*  elements;
@property (nonatomic, retain, readonly) NSArray*  layerNames;

- (id)elementAtIndex:(NSUInteger)index;

@end

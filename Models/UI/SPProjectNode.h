//
//  SPProjectNode.h
//  Spark
//
//  Created by Matt Massicotte on 9/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SPProjectNode : NSObject
{
}

+ (id)node;

@property (nonatomic, retain, readonly) NSString* displayName;
@property (nonatomic, assign, readonly) BOOL      isHeader;
@property (nonatomic, assign, readonly) BOOL      isLeaf;
@property (nonatomic, retain, readonly) NSArray*  children;

@end

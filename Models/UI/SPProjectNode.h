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
	NSString*				title;
	NSManagedObjectContext*	managedObjectContext;
	NSManagedObject*		managedObject;
	NSArray*				children;
}

+ (id)nodeWithContext:(NSManagedObjectContext*)context;

@property (retain)				NSManagedObjectContext*	managedObjectContext;
@property (retain)				NSManagedObject*		managedObject;

@property (copy)				NSString*	title;
@property (assign, readonly)	BOOL		isHeader;
@property (assign, readonly)	BOOL		isLeaf;
@property (retain)				NSArray*	children;
@property (assign, readonly)	NSString*	entityName;

@end

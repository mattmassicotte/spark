//
//  GraphicalRep.h
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class DesignElement;
@class Definition;
@class Primitive;

@interface GraphicalRep : NSManagedObject  
{
	NSUInteger	numberOfFacets;
	
	GLdouble*	vertexBuffer;
	GLdouble*	normalBuffer;
	GLdouble*	colorBuffer;
}

// CoreData Accessors
@property (nonatomic, retain) NSSet*		primitives;
@property (nonatomic, retain) Definition*	definition;
@property (nonatomic, retain) NSSet*		elements;

// instance accessors
@property (assign, readonly) NSUInteger	numberOfFacets;
@property (assign, readonly) GLdouble*	vertexBuffer;
@property (assign, readonly) GLdouble*	normalBuffer;
@property (assign, readonly) GLdouble*	colorBuffer;

- (void)prepareBuffers;

@end


@interface GraphicalRep (CoreDataGeneratedAccessors)
- (void)addPrimitivesObject:(Primitive *)value;
- (void)removePrimitivesObject:(Primitive *)value;
- (void)addPrimitives:(NSSet *)value;
- (void)removePrimitives:(NSSet *)value;

- (void)addElementsObject:(DesignElement *)value;
- (void)removeElementsObject:(DesignElement *)value;
- (void)addElements:(NSSet *)value;
- (void)removeElements:(NSSet *)value;

@end


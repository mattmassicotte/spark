//
//  Primitive.h
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SPGeometry.h"

@class GraphicalRep;

@interface Primitive : NSManagedObject  
{
}

+ (BOOL)isNameOfPrimitive:(NSString*)name;
+ (Primitive*)addPrimitiveWithName:(NSString*)name toGraphicalRep:(GraphicalRep*)rep;

@property (nonatomic, retain) GraphicalRep*		graphicalRep;
@property (nonatomic, retain) NSNumber*			height;
@property (nonatomic, retain) NSNumber*			zPosition;
@property (nonatomic, retain) NSString*			identifier;

@property(nonatomic, assign, readonly) SPVec	color;
@property(nonatomic, assign, readonly) GLdouble	zBottom;
@property(nonatomic, assign, readonly) GLdouble	zTop;

- (void)assign:(NSString*)name with:(NSDictionary*)dict;

- (NSArray *)facetArray;

@end




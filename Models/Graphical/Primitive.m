// 
//  Primitive.m
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Primitive.h"
#import "GraphicalRep.h"

@implementation Primitive 

+ (BOOL)isNameOfPrimitive:(NSString*)name
{
	if ([name isEqualToString:@"quad"])
	{
		return true;
	}
	
	return false;
}

+ (Primitive*)addPrimitiveWithName:(NSString*)name toGraphicalRep:(GraphicalRep*)rep
{
	Primitive* p;
	
	p = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:[rep managedObjectContext]];
	
	[rep addPrimitivesObject:p];
	
	return p;
}

@dynamic graphicalRep;
@dynamic height;
@dynamic zPosition;
@dynamic identifier;

- (SPVec)color
{
	if ([self identifier] == nil )
		return SPMakeVec(0, 0, 1);
	
	return SPMakeVec(0.8, 1, 0.2);
}

- (GLdouble)zBottom
{
	return [[self zPosition] doubleValue];
}

- (GLdouble)zTop
{
	return [[self zPosition] doubleValue] + [[self height] doubleValue];
}

- (SPVec)center
{
    return SPMakeVec(0, 0, 0);
}

- (GLdouble)width
{
    return 0;
}

- (GLdouble)length
{
    return 0;
}

- (void)assign:(NSString*)name with:(NSDictionary*)dict
{
}

- (NSArray *)facetArray
{
	return nil;
}

@end

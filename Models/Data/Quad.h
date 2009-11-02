//
//  Quad.h
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Primitive.h"
#import "SPGeometry.h"

@interface Quad :  Primitive  
{
}

@property (nonatomic, retain) NSNumber * bY;
@property (nonatomic, retain) NSNumber * aY;
@property (nonatomic, retain) NSNumber * dX;
@property (nonatomic, retain) NSNumber * cX;
@property (nonatomic, retain) NSNumber * bX;
@property (nonatomic, retain) NSNumber * dY;
@property (nonatomic, retain) NSNumber * aX;
@property (nonatomic, retain) NSNumber * cY;

@end




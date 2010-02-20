//
//  Arc.h
//  Spark
//
//  Created by Matt Massicotte on 2/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Primitive.h"

@interface Arc :  Primitive  
{
}

@property (nonatomic, retain) NSNumber * centerX;
@property (nonatomic, retain) NSNumber * innerRadius;
@property (nonatomic, retain) NSNumber * centerY;
@property (nonatomic, retain) NSNumber * endAngle;
@property (nonatomic, retain) NSNumber * outerRadius;
@property (nonatomic, retain) NSNumber * startAngle;

@end




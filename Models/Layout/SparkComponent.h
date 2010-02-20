//
//  SparkComponent.h
//  Spark
//
//  Created by Matt Massicotte on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DesignElement.h"


@interface SparkComponent :  DesignElement  
{
}

@property (nonatomic, retain) NSSet* pinPadMapping;

@end


@interface SparkComponent (CoreDataGeneratedAccessors)
- (void)addPinPadMappingObject:(NSManagedObject *)value;
- (void)removePinPadMappingObject:(NSManagedObject *)value;
- (void)addPinPadMapping:(NSSet *)value;
- (void)removePinPadMapping:(NSSet *)value;

@end


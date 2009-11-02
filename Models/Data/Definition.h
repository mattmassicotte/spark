//
//  Definition.h
//  Spark
//
//  Created by Matt Massicotte on 10/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Definition : NSManagedObject  
{
}

@property (nonatomic, retain) NSString*		path;
@property (nonatomic, retain) NSSet*		graphicalRep;

@end


@interface Definition (CoreDataGeneratedAccessors)
- (void)addGraphicalRepObject:(NSManagedObject *)value;
- (void)removeGraphicalRepObject:(NSManagedObject *)value;
- (void)addGraphicalRep:(NSSet *)value;
- (void)removeGraphicalRep:(NSSet *)value;

@end


//
//  Folder+CoreDataProperties.h
//  Note_project_CoreData
//
//  Created by lanouhn on 16/5/5.
//  Copyright © 2016年 lanouhn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Folder.h"

NS_ASSUME_NONNULL_BEGIN

@interface Folder (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *creatDate;
@property (nullable, nonatomic, retain) Note *noteship;

@end

NS_ASSUME_NONNULL_END

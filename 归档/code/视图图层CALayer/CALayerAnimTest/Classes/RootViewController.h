//
//  RootViewController.h
//  CALayerAnimTest
//
//  Created by Michael Nachbaur on 10-11-28.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	CALayerAnimTestTypeOrbits,
	CALayerAnimTestTypeFloatingCloud,
	CALayerAnimTestTypeButtonActions,
	CALayerAnimTestTypeRaceTrack
} CALayerAnimTestType;

@interface RootViewController : UITableViewController {
}

+ (NSString*)titleForType:(CALayerAnimTestType)type;
+ (Class)classForType:(CALayerAnimTestType)type;

@end

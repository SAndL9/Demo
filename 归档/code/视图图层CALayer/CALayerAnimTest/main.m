//
//  main.m
//  CALayerAnimTest
//
//  Created by Michael Nachbaur on 10-11-28.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    double a = pow(1.01, 365);
    double b = pow(0.99, 365);
    NSLog(@"a = %lf , b = %lf",a,b);
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}

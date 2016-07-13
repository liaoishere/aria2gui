//
//  AppDelegate.h
//  MacGap
//
//  Created by Alex MacCaw on 08/01/2012.
//  Copyright (c) 2012 Twitter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Classes/ContentView.h"
#import "WindowController.h"



@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSWindowController *_preferencesWindowController;

}

@property (retain, nonatomic) WindowController *windowController;
@property (nonatomic, readonly) NSWindowController *preferencesWindowController;
@property (nonatomic) NSInteger focusedAdvancedControlIndex;

- (IBAction)openPreferences:(id)sender;


@end

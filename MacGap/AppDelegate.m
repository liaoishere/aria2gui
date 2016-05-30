//
//  AppDelegate.m
//  MacGap
//
//  Created by Alex MacCaw on 08/01/2012.
//  Copyright (c) 2012 Twitter. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize windowController;


- (void) applicationWillFinishLaunching:(NSNotification *)aNotification
{
[self startAria2];
}

-(BOOL)applicationShouldHandleReopen:(NSApplication*)application
                   hasVisibleWindows:(BOOL)visibleWindows{
    if(!visibleWindows){
        [self.windowController.window makeKeyAndOrderFront: nil];
    }
    return YES;
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.windowController = [[WindowController alloc] initWithURL: kStartPage];
    [self.windowController showWindow: [NSApplication sharedApplication].delegate];
    self.windowController.contentView.webView.alphaValue = 1.0;
    self.windowController.contentView.alphaValue = 1.0;
    [self.windowController showWindow:self];
}


-(void)applicationWillTerminate:(NSNotification *)notification
{
    [self closeAria2];
}


-(void)startAria2
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *supportPath=[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/sh/",supportPath,[[NSBundle mainBundle] bundleIdentifier]];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString *startAriaPath = [path stringByAppendingPathComponent:@"startaria.sh"];
    ///Users/Nick/Library/Application Support/com.Aria2GUI/sh/
    if ([fileManager fileExistsAtPath:startAriaPath])
    {
        NSLog(@"文件存在直接运行aria2c");
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/bin/sh";
        task.arguments = @[startAriaPath];
        [task launch];
    }
    else
    {
        NSLog(@"文件不存在先创建sh文件，写入配置，再运行aria2c");
        [fileManager createFileAtPath:startAriaPath contents:nil attributes:nil];
        NSString *shCommand = [NSString stringWithFormat:@"touch \"/Users/Shared/aria2.session\"\n %@ --input-file=\"/Users/Shared/aria2.session\" --save-session=\"/Users/Shared/aria2.session\" --save-session-interval=10 --dir=\"$HOME/Downloads/\" --force-save=true --max-connection-per-server=10 --max-concurrent-downloads=10 --continue=true --split=10 --min-split-size=10M --enable-rpc=true --rpc-listen-all=false --rpc-listen-port=6800 --rpc-allow-origin-all --check-integrity=true --bt-enable-lpd=true --follow-torrent=true --user-agent=\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0 Safari/601.3.9\" -c -D",[[NSBundle mainBundle] pathForResource:@"aria2gui" ofType:nil]];
        [shCommand writeToFile:startAriaPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSTask *task = [[NSTask alloc] init];
        task.launchPath = @"/bin/sh";
        task.arguments = @[startAriaPath];
        [task launch];
    }
}

-(void)closeAria2
{
    NSArray *arg =[NSArray arrayWithObjects:@"aria2gui",nil];
    NSTask *task=[[NSTask alloc] init];
    task.launchPath = @"/usr/bin/killall";
    task.arguments = arg;
    [task launch];
}

@end

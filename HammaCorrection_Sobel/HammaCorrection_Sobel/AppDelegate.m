//
//  AppDelegate.m
//  HammaCorrection_Sobel
//
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)onOpen:(id)sender {
    NSOpenPanel *openPanel	= [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    NSArray* imageTypes = [NSImage imageTypes];
    [openPanel setAllowedFileTypes:imageTypes];

    [openPanel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL * theDoc = [[openPanel URLs] objectAtIndex:0];
            NSString * path = [theDoc path];
            NSViewController * mainController = [[NSApplication sharedApplication] mainWindow].contentViewController;
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
            if (image == nil) {
                NSLog(@"image nil");
            } else {
                if ([mainController respondsToSelector:@selector(openImage:)]) {
                    [mainController performSelector:@selector(openImage:) withObject:image];
                }
                //[mainController openImage:image];
            }
        }
        
    }];
}

@end

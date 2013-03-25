//
//  UIManagedDocument+Shared.m
//  iALaCard
//
//  Created by Rodolfo Torres on 3/24/13.
//  Copyright (c) 2013 Rodolfo Torres. All rights reserved.
//

#import "UIManagedDocument+Shared.h"

@implementation UIManagedDocument (Shared)

+ (UIManagedDocument *) sharedUIManagedDocument
{
    static UIManagedDocument *shared = nil;
    
    if(!shared){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"iALaCard Doc"];
        
        shared = [[UIManagedDocument alloc] initWithFileURL:url];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            [shared saveToURL:url
             forSaveOperation:UIDocumentSaveForCreating
            completionHandler:^(BOOL success) {
                if (success) {
                    
                }
            }];
        } else if (shared.documentState == UIDocumentStateClosed) {
            [shared openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    
                }
            }];
        }
    }
    return shared;
}
@end

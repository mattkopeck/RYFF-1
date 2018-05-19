//
//  VCPhotoShare.h
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCPhotoShare : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIImageView *imgViewer;
    IBOutlet UIButton *btnChoose;
    IBOutlet UIButton *btnCamera;
    IBOutlet UIButton *btnUpload;
}

- (IBAction)photoChoose:(id)sender;
- (IBAction)photoCamera:(id)sender;
- (IBAction)photoUpload:(id)sender;

@end

//
//  VCPhotoShare.m
//  RYFF
//
//  Created by Scott Gjesdal on 1/2/2014.
//  Copyright (c) 2014 SportForm. All rights reserved.
//

#import "VCPhotoShare.h"
#import "MBProgressHUD.h"
#import "urls.h"

@interface VCPhotoShare ()
- (UIImage*)imageByScalingToSize:(CGSize)targetSize img:(UIImage*)sourceImage;
@end

@implementation VCPhotoShare
    UIImagePickerController *picker;
    static inline double radians (double degrees) {return degrees * M_PI/180;}
    MBProgressHUD *hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)photoChoose:(id)sender {
    //NSLog(@"photoChoose");
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)photoCamera:(id)sender {
    //NSLog(@"photoCamera");
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSLog(@"imagePickerController");
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *resized = [UIImage imageWithCGImage:[image CGImage] scale:0.5f orientation:UIImageOrientationUp];
    
    CGSize s = CGSizeMake( image.size.width/2 ,image.size.height/2);
    resized = [self imageByScalingToSize:s img:image];
    
    imgViewer.image = resized;
    
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //NSLog(@"imagePickerControllerDidCancel");
    //[self dismissModalViewControllerAnimated:YES];
    [imgViewer setImage:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)showHUD {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud.label setText:@"Sending"];
}

- (void)hideHUD {
    [hud hideAnimated:YES];
}

- (IBAction)photoUpload:(id)sender {
    
    NSData *imageData = UIImageJPEGRepresentation(imgViewer.image, 0.9f);
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:url_photo_upload]];
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = @"---------------------------14737809831466499882746641449";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"uploaded\"; filename=\".jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
    
    [self showHUD];
    
    NSURLSession *session = [NSURLSession sharedSession];
    // Asynchronously API is hit here
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self hideHUD];
                                                    });
                                                    
                                                    if (error == nil) {
                                                        NSLog(@"Response: %@", data);
                                                        
                                                        UIAlertController * alert = [UIAlertController
                                                                                     alertControllerWithTitle:@"Share Photos"
                                                                                     message:@"Upload complete. Thank you."
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction* yesButton = [UIAlertAction
                                                                                    actionWithTitle:@"OK"
                                                                                    style:UIAlertActionStyleDefault
                                                                                    handler:^(UIAlertAction * action) {
                                                                                        //Handle your yes please button action here
                                                                                    }];
                                                        [alert addAction:yesButton];
                                                    } else {
                                                        NSLog(@"Error = %@", error);
                                                    }
                                                }];
    [dataTask resume];    // Executed First
}





-(UIImage*)imageByScalingToSize:(CGSize)targetSize img:(UIImage*)sourceImage
{
	//UIImage* sourceImage = self;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
    
	CGImageRef imageRef = [sourceImage CGImage];
	uint32_t bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}
    
	CGContextRef bitmap;
    
	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
	}
    
	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}
    
	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];
    
	CGContextRelease(bitmap);
	CGImageRelease(ref);
    
	return newImage;
}
@end

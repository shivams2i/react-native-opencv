//OpenCV module to check blur image

#import "Opencv.h"
#import <React/RCTLog.h>
#import <opencv2/imgcodecs/ios.h>
#include <opencv2/imgproc/imgproc.hpp>


@implementation Opencv

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getOpenCVVersion:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    NSString *version = [NSString stringWithUTF8String:CV_VERSION];
    if (version) {
        resolve(version);
    } else {
        NSError *error = [NSError errorWithDomain:@"com.yourapp.opencv" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Failed to get OpenCV version"}];
        reject(@"error", @"Failed to get OpenCV version", error);
    }
}

RCT_EXPORT_METHOD(checkForBlurryImage:(NSString *)imageUrlString resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
    UIImage *image = [UIImage imageWithContentsOfFile:imageUrlString];
    BOOL isImageBlurryResult = [self isImageBlurry:image];
    id objects[] = { isImageBlurryResult ? @YES : @NO };
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSArray *dataArray = [NSArray arrayWithObjects:objects
                                             count:count];
    
    if ([dataArray count] > 0) {
        resolve(dataArray[0]);
    }else {
        NSError *error = [NSError errorWithDomain:@"com.yourapp.opencv" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Failed to check image is blur or not"}];
        reject(@"error", @"Failed ", error);
    }
    
}

- (cv::Mat)convertUIImageToCVMat:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (BOOL) isImageBlurry:(UIImage *) image {
    // converting UIImage to OpenCV format - Mat
    cv::Mat matImage = [self convertUIImageToCVMat:image];
    cv::Mat matImageGrey;
    // converting image's color space (RGB) to grayscale
    cv::cvtColor(matImage, matImageGrey, cv::COLOR_BGR2GRAY);
    
    cv::Mat dst2 = [self convertUIImageToCVMat:image];
    cv::Mat laplacianImage;
    dst2.convertTo(laplacianImage, CV_8UC1);
    
    // applying Laplacian operator to the image
    cv::Laplacian(matImageGrey, laplacianImage, CV_8U);
    cv::Mat laplacianImage8bit;
    laplacianImage.convertTo(laplacianImage8bit, CV_8UC1);
    
    unsigned char *pixels = laplacianImage8bit.data;
    
    // 16777216 = 256*256*256
    int maxLap = -16777216;
    for (int i = 0; i < ( laplacianImage8bit.elemSize()*laplacianImage8bit.total()); i++) {
        if (pixels[i] > maxLap) {
            maxLap = pixels[i];
        }
    }
    // one of the main parameters here: threshold sets the sensitivity for the blur check
    // smaller number = less sensitive; default = 180
    int threshold = 180;
    
    return (maxLap <= threshold);
}


@end


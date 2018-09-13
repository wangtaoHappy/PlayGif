//
//  ViewController.m
//  PlayGif
//
//  Created by 王涛 on 2017/4/19.
//  Copyright © 2017年 王涛. All rights reserved.
//

#import "ViewController.h"
#define Mask8(x) ((x) & 0xFF)
#define R(x) (Mask8(x))
#define G(x) (Mask8(x >> 8 ))
#define B(x) (Mask8(x >> 16))
#define A(x) (Mask8(x >> 24))
#define RGBA(r,g,b,a) (Mask8(r) | Mask8(g)<<8 | Mask8(b) << 16 | Mask8(a) << 24)
@interface ViewController ()
{

    UIImageView *imageView;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
    UIImageView *imageView4;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadImageView];
}

- (void)loadImageView {

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 150, 200)];
    imageView.image = [UIImage imageNamed:@"alalei.jpg"];
    [self.view addSubview:imageView];
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(12 + 150 + 5, 20, 150, 200)];
    [self.view addSubview:imageView1];
    [self setupImageWithImage:[UIImage imageNamed:@"alalei.jpg"]];
}

- (void)setupImageWithImage:(UIImage *)image {

    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;//每个像素的大小
    NSUInteger bytesPerRow = bytesPerPixel * width;//每行大小
    NSUInteger bytesPerComonent = 8;// 每个颜色通道大小
    UInt32 *pixels;
    pixels = (UInt32 *)calloc(height * width, sizeof(UInt32));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, bytesPerComonent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    UInt32 *currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            // 3.
            UInt32 color = *currentPixel;
            printf("%3.0f ",(R(color)+G(color)+B(color))/3.0);
            // 4.
            UInt32 r = (R(color) + G(color) + B(color)) / 3.0;

            *currentPixel = RGBA(r, r, r, A(color));
                printf("%u",(unsigned int)*currentPixel);
//             UInt32 thisR,thisG,thisB,thisA;
//            int lumi = 50;
//            //如何获取
//            //获取红色分量值（R）
//            
//            thisR = R(color);
//            thisR = thisR + lumi;
//            thisR = thisR > 255 ? 255 : thisR;
//            // NSLog(@"红色值：%d",thisR);
//            //获取绿色分量值
//            
//            thisG = G(color);
//            thisG = thisG + lumi;
//            thisG = thisG > 255 ? 255 : thisG;
//            thisB = B(color);
//            thisB = thisB + lumi;
//            thisB = thisB > 255 ? 255 : thisB;
//            thisA = A(color);
//            
//            //修改像素点的值
//            *currentPixel = RGBA(thisR, thisG, thisB, thisA);
            currentPixel++;
        }
        printf("\n");
    }
  
    
    inputCGImage = CGBitmapContextCreateImage(context);
    
    UIImage *resultImage = [UIImage imageWithCGImage:inputCGImage];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    imageView1.image = resultImage;
}

@end

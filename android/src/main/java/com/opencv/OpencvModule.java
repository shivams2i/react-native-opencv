package com.opencv;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import androidx.annotation.NonNull;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.File;

import org.opencv.android.Utils;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Core;
import org.opencv.android.OpenCVLoader;

public class OpencvModule extends ReactContextBaseJavaModule {

  private static boolean isOpenCVInitialized = false;

  public OpencvModule(@NonNull ReactApplicationContext reactContext) {
    super(reactContext);
    // Initialize OpenCV when the module is created (only once)
    if (!isOpenCVInitialized) {
      OpenCVLoader.initDebug();
      isOpenCVInitialized = true;
    }
  }

  @Override
  public String getName() {
    return "Opencv";
  }

  @ReactMethod
  public void getOpenCVVersion(Promise promise) {
    try {
      String version = Core.VERSION_MAJOR + "." + Core.VERSION_MINOR + "." + Core.VERSION_REVISION;
      promise.resolve(version);
    } catch (Exception e) {
      promise.reject("GET_OPENCV_VERSION_ERROR", e.getMessage());
    }
  }

  @ReactMethod
  public void checkForBlurryImage(String imagePath,  Promise promise) {
    try {
      File imageFile = new File(imagePath);
      if (!imageFile.exists()) {
        promise.reject("FILE_NOT_FOUND", "File not found");
        return;
      }

      Bitmap image = BitmapFactory.decodeFile(imagePath);
      int l = CvType.CV_8UC1; //8-bit grey scale image
      Mat matImage = new Mat();
      Utils.bitmapToMat(image, matImage);
      Mat matImageGrey = new Mat();
      Imgproc.cvtColor(matImage, matImageGrey, Imgproc.COLOR_BGR2GRAY);

      Bitmap destImage;
      destImage = Bitmap.createBitmap(image);
      Mat dst2 = new Mat();
      Utils.bitmapToMat(destImage, dst2);
      Mat laplacianImage = new Mat();
      dst2.convertTo(laplacianImage, l);
      Imgproc.Laplacian(matImageGrey, laplacianImage, CvType.CV_8U);
      Mat laplacianImage8bit = new Mat();
      laplacianImage.convertTo(laplacianImage8bit, l);

      Bitmap bmp = Bitmap.createBitmap(laplacianImage8bit.cols(), laplacianImage8bit.rows(), Bitmap.Config.ARGB_8888);
      Utils.matToBitmap(laplacianImage8bit, bmp);
      int[] pixels = new int[bmp.getHeight() * bmp.getWidth()];
      bmp.getPixels(pixels, 0, bmp.getWidth(), 0, 0, bmp.getWidth(), bmp.getHeight());
      int maxLap = -16777216; // 16m
      for (int pixel : pixels) {
        if (pixel > maxLap)
          maxLap = pixel;
      }

//     int soglia = -6118750;
      int soglia = -8118750;
      if (maxLap <= soglia) {
        System.out.println("is blur image");
      }

      promise.resolve(maxLap <= soglia);

    } catch (Exception e)  {
      promise.reject("IMAGE_PROCESSING_ERROR", e.getMessage());
    }
  }
}

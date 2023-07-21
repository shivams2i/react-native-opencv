#include <jni.h>
#include "react-native-opencv.h"

extern "C"
JNIEXPORT jdouble JNICALL
Java_com_opencv_OpencvModule_nativeMultiply(JNIEnv *env, jclass type, jdouble a, jdouble b) {
    return opencv::multiply(a, b);
}

const Opencv = require('./NativeOpencv').default;

export function multiply(a: number, b: number): number {
  return Opencv.multiply(a, b);
}

type CheckForBlurryImageFunction = (imageUrlString: string) => Promise<boolean>;
type GetOpenCVVersionFunction = () => Promise<string>;

declare module 'react-native-opencv' {
  export const checkForBlurryImage: CheckForBlurryImageFunction;
  export const getOpenCVVersion: GetOpenCVVersionFunction;
}
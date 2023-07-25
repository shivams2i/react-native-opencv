# react-native-opencv

OpenCv for react native

## Installation

```sh
npm install react-native-opencv
```

## Usage



```js
import { getOpenCVVersion, checkForBlurryImage } from 'react-native-opencv';

// ...
const version = await getOpenCVVersion();

const isBlur = await checkForBlurryImage('path')

```
## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

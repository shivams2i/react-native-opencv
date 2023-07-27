import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { getOpenCVVersion } from 'react-native-opencv'


export default function App() {
  const [openCVVersion, setOpenCVVersion] = React.useState('')



  React.useEffect(() => {
    (async () => {
      const version = await getOpenCVVersion()
      if (version) {
        setOpenCVVersion(version)
      }
    })()
  }, [])



  return (
    <View style={styles.container}>
      <Text>Opencv version {openCVVersion}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { getOpenCVVersion} from 'react-native-opencv';



export default function App() {
  const [version, setVersion]= React.useState('')


  React.useEffect(() => {
    getCVVersion()
  }, [])
  

  const getCVVersion=async()=>{
  const res = await  getOpenCVVersion()
  setVersion(res)
  }

  return (
    <View style={styles.container}>
     <Text>{`openCV version ${version}`}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});

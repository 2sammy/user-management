import { StyleSheet, View, Dimensions } from 'react-native';
import { useState, useEffect } from 'react';

export default function App() {
  const [dimensions ,setDimensions] = useState({
    window:Dimensions.get("window")
  });

  useEffect(() => {
    const subscription = Dimensions.addEventListener("change", ({window}) => {
      setDimensions({window});
    });
    return () => subscription ?.remove
  });

  return (
    <View style={styles.container}>
    <View style={styles.styles.box}>
      <Text style= {styles.text}> hello sam </Text>
    </View>
 </View>);
}

const windowWidth = Dimensions.get("window").width;
const windowHeight = Dimensions.get("window").height;
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#plum',
    alignItems: 'center',
    justifyContent: 'center',
  },

  box: {
    
    width : windowWidth > 500 ? "70%" : "90%",
    height: windowHeight > 500 ? "60%" : "90%",
    backgroundColor: "lightblue",
    alignItems: "center",
    justifyContent: "center",

  },

  text: {
    fontSize : windowWidth > 500 ? 50: 24


  }

});


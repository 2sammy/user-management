import React from 'react'
const logoImg = require("./assets/icon.png")
import { View, Text, Image } from 'react-native'

export default function App() {
  return (
    <View>
      <Text> 
        <Text>hello sam  </Text>
      </Text>
      <Image source={logoImg} style ={{width: 300, height: 300}}></Image>
      <Image source={{uri: "https://picsum.photos/300"}} style={{ width:300, height: 300}}></Image>
    </View>
  )
}

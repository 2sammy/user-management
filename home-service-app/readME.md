# its mandatory to set heihgt and width using images from network

# background 
import { View, Text, Image, ImageBackground} from "react-native"
const logoImg = require("./assets/icon.png")

export default function App () {
    return (
    <View style= {{flex: 1, backgroundColor: "plum", padding: 60}}>
    <ImageBackground source= {logoImg} style={{ flex: 1 }}>
    <Text>hello sam</Text>
    <ImageBackground>


    </View>
    );
}

# scroll view
scro view component wraps the platform-specific scrolling functionality
scrollView require a bounded height to function properly
# button
import React from 'react'
const logoImg = require("./assets/icon.png")
import { View, Text, Image } from 'react-native'

export default function App() {
  return (
    <View style= {{flex: 1, backgroundColor: "plum", padding: 60}}>
    <Button title = "press" onPress= {() => console.log("hello")} />

    <Button
    title = " hello sam"
    onPress = {() => console.log("helle there")}
    color="midnightblue"
    />
</View>
  )
}

# Pressable
This is  a wrapper component that detects various stages of press interactions on it defined children


import React from 'react'
const logoImg = require("./assets/icon.png")
import { View, Text, Image } from 'react-native'

export default function App() {
  return (
    <View>
    <Pressable onPress= {() => console .log("am pressed")}>
      <Text> 
        <Text>hello sam  </Text>
      </Text>
      </Pressable>
      <Image source={logoImg} style ={{width: 300, height: 300}}></Image>
      <Image source={{uri: "https://picsum.photos/300"}} style={{ width:300, height: 300}}></Image>
    </View>
  )
}

# Modal 

Modaal is a screen that overlays the app content to provide important info

<Modal >
<View style ={{flex: 1, backgroundColor: "lightblue", padding:60}}>

<Text> MODAL</Text>
<Button title= "Close", color: "midnightblue  />
</View>

</Modal>

# activity Indicator
-displays a circular loading indicator
-used to inform users about the status of ongoing processes , like submitting a form or saving update, or loading an app

import {Vies, ActivityIndicator} from "react-native"

export default function App () {
    return (
        <View style= {{flex:1, backgroundColor: "plum", padding: 60 }}>
        <Activity Indicator />
        <Activity Indicator size= "large" />
        <Activity Indicator size= "large" color= "red" animating = {false} />

        </View>
    )
}

# alert
launches an alert dialog with specified title and message

import {View, Button, Alert } from "react-native"

export default function App () {
    return (
        <View style= {{flex:1, backgroundColor: "plum", padding: 60 }}>
        <Button title = "Alert" onPress={() => Alert.alert(" invalid data")} />
        
        </View>
    )
}

# style RN

import {View, Text, StyleSheet} from "react-native";

export default function App() {
    return (
        <View style = {styles.container}>
        <Text> hello manoah</Text>
        </View>
    )
}

const styles = StyleSheet.create ( {
    container: {
        flex: 1, 
        backgroundColor: blue,
        paddingHorizontol: 10,
        paddingVertical: 10,
        marginVertical: 10,
        borderWidth:2,
        borderColor:purple
    }
})


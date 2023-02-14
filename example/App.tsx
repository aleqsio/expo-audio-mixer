import { Button, Slider, StyleSheet, Text, View } from "react-native";

import * as ExpoAudioMixer from "expo-audio-mixer";
import * as FileSystem from "expo-file-system";
import { useState } from "react";
// https://github.com/welbesw/CoreAudioMixer/blob/master/CoreAudioMixer/CoreAudioInterface/AudioEngineManager.m
export default function App() {
  const [uri, setUri] = useState<string>();
  const [uri2, setUri2] = useState<string>();

  const download = () => {
    FileSystem.downloadAsync(
      "https://aleqsiotestbucketaudioplayer.s3.eu-central-1.amazonaws.com/ImperialMarch60.wav",
      FileSystem.cacheDirectory + "M1F1.wav"
    )
      .then(({ uri }) => {
        console.log("Finished downloading to ", uri);
        setUri(uri);
      })
      .catch((error) => {
        console.error(error);
      });
    FileSystem.downloadAsync(
      "https://aleqsiotestbucketaudioplayer.s3.eu-central-1.amazonaws.com/inverted.wav",
      FileSystem.cacheDirectory + "M1F2.wav"
    )
      .then(({ uri }) => {
        console.log("Finished downloading to ", uri);
        setUri2(uri);
      })
      .catch((error) => {
        console.error(error);
      });
  };
  return (
    <View style={styles.container}>
      <Text>
        {uri}, {uri2}
      </Text>
      <Button onPress={download} title="download"></Button>
      <Button
        onPress={() => ExpoAudioMixer.play(uri, uri2)}
        title="Play me"
      ></Button>
      <Button onPress={() => ExpoAudioMixer.stop()} title="Stop me"></Button>
      <Slider
        style={{ width: 200 }}
        minimumValue={0}
        maximumValue={1}
        onSlidingComplete={(value) => ExpoAudioMixer.setPan(value)}
      />
      <Button
        onPress={() => ExpoAudioMixer.setPan(0.5)}
        title="Center me"
      ></Button>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});

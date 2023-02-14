// import {
//   NativeModulesProxy,
//   EventEmitter,
//   Subscription,
// } from "expo-modules-core";

// Import the native module. On web, it will be resolved to ExpoAudioMixer.web.ts
// and on native platforms to ExpoAudioMixer.ts
import {
  ChangeEventPayload,
  ExpoAudioMixerViewProps,
} from "./ExpoAudioMixer.types";
import ExpoAudioMixerModule from "./ExpoAudioMixerModule";

export function play(uri: string, uri2: string) {
  ExpoAudioMixerModule.play(uri, uri2);
}

export function setVolume(firstTrackVolume: number, secondTrackVolume: number) {
  ExpoAudioMixerModule.setVolume(firstTrackVolume, secondTrackVolume);
}

export function setPan(firstTrackPan: number, secondTrackPan: number) {
  ExpoAudioMixerModule.setVolume(firstTrackPan, secondTrackPan);
}

export function pause() {
  ExpoAudioMixerModule.pause();
}

export function resume() {
  ExpoAudioMixerModule.resume();
}

export function stop() {
  ExpoAudioMixerModule.stop();
}

export { ExpoAudioMixerViewProps, ChangeEventPayload };

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

export function play(uri: string, uri2: string): string {
  return ExpoAudioMixerModule.play(uri, uri2);
}

export function setPan(value: number): string {
  return ExpoAudioMixerModule.setPan(value);
}

export function stop() {
  ExpoAudioMixerModule.stop();
}

export function pause() {
  ExpoAudioMixerModule.pause();
}

// export async function setValueAsync(value: string) {
//   return await ExpoAudioMixerModule.setValueAsync(value);
// }

// const emitter = new EventEmitter(ExpoAudioMixerModule ?? NativeModulesProxy.ExpoAudioMixer);

// export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
//   return emitter.addListener<ChangeEventPayload>('onChange', listener);
// }

export { ExpoAudioMixerViewProps, ChangeEventPayload };

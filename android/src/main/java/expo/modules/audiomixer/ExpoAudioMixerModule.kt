package expo.modules.audiomixer

import android.net.Uri
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.source.ProgressiveMediaSource
import com.google.android.exoplayer2.upstream.DefaultDataSource
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class ExpoAudioMixerModule : Module() {
  // var lastFirstTrackVolume = 0.5f
  // var lastSecondTrackVolume = 0.5f


  var firstTrackPlayerIsReady = false
  val firstTrackPlayer: ExoPlayer by lazy {
    ExoPlayer
      .Builder(appContext.reactContext!!)
      .build()
      .apply {
        addListener(object : Player.Listener {
          override fun onPlaybackStateChanged(playbackState: Int) {
            firstTrackPlayerIsReady = playbackState == Player.STATE_READY

            if (firstTrackPlayerIsReady && secondTrackPlayerIsReady) {
              this@apply.play()
              secondTrackPlayer.play()
            }
          }
        })
      }
  }

  var secondTrackPlayerIsReady = false
  val secondTrackPlayer: ExoPlayer by lazy {
    ExoPlayer
      .Builder(appContext.reactContext!!)
      .build()
      .apply {
        addListener(object : Player.Listener {
          override fun onPlaybackStateChanged(playbackState: Int) {
            secondTrackPlayerIsReady = playbackState == Player.STATE_READY

            if (firstTrackPlayerIsReady && secondTrackPlayerIsReady) {
              this@apply.play()
              firstTrackPlayer.play()
            }
          }
        })
      }
  }

  override fun definition() = ModuleDefinition {
    Name("ExpoAudioMixer")

    Function("play") { file1: Uri, file2: Uri ->
      firstTrackPlayer.setMediaSource(ProgressiveMediaSource.Factory(
        DefaultDataSource.Factory(appContext.reactContext!!)
      ).createMediaSource(MediaItem.fromUri(file1)))

      firstTrackPlayer.prepare()

      secondTrackPlayer.setMediaSource(ProgressiveMediaSource.Factory(
        DefaultDataSource.Factory(appContext.reactContext!!)
      ).createMediaSource(MediaItem.fromUri(file2)))

      secondTrackPlayer.prepare()

      // firstTrackPlayer.volume = lastFirstTrackVolume
      // secondTrackPlayer.volume = lastSecondTrackVolume
    }

    Function("pause") {
      firstTrackPlayer.pause()
      secondTrackPlayer.pause()
    }

    Function("resume") {
      firstTrackPlayer.resume()
      secondTrackPlayer.resume()
    }

    Function("stop") {
      firstTrackPlayer.stop()
      secondTrackPlayer.stop()
    }

    Function("setVolume") { firstTrackVolume: Float, secondTrackVolume: Float ->
      firstTrackPlayer.volume = firstTrackVolume
      // lastFirstTrackVolume = firstTrackVolume
      secondTrackPlayer.volume = secondTrackVolume
      // lastSecondTrackVolume = secondTrackVolume
    }

    Function("setPan") { firstTrackPan: Float, secondTrackPan: Float ->
      firstTrackPlayer.pan = firstTrackPan
      secondTrackPlayer.pan = secondTrackPan
    }
  }
}

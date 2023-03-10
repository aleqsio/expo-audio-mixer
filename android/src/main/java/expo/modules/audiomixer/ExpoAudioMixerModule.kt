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
  var lastPan = 0.5f

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

      firstTrackPlayer.volume = lastPan
      secondTrackPlayer.volume = 1f - lastPan
    }

    Function("pause") {
      firstTrackPlayer.pause()
      secondTrackPlayer.pause()
    }

    Function("stop") {
      firstTrackPlayer.stop()
      secondTrackPlayer.stop()
    }

    Function("setPan") { pan: Float ->
      firstTrackPlayer.volume = pan
      secondTrackPlayer.volume = 1f - pan

      lastPan = pan
    }
  }
}

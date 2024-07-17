package uz.ikpydev.yandex_map

import android.app.Application
import com.yandex.mapkit.MapKitFactory

class MainApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setApiKey("41ab22dc-8d5e-4b55-a86f-bbc15e20e400") // Your generated API key
  }
}

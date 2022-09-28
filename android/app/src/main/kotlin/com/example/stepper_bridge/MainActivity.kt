package com.example.stepper_bridge

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val methodChannelKey = "com.stepperhit/methodChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,methodChannelKey).setMethodCallHandler { call, result ->
            if (call.method == "getTextForStepper") {
                var stepNeed = call.argument<String>("stepIndex")
                var index = stepNeed?.toInt()
                var needText = index?.let { getTextForStepper(it) }
                if (needText != null ) {
                    result.success(needText)
                }else {
                    result.error("01","Cannot Get Value","Details : Null ")
                }

            }else {
                result.notImplemented()
            }

        }
    }

    private fun getTextForStepper(index: Int):String? {

        return when (index) {
            0 -> "For each ad campaign that you create, you can control how much you're willing to spend on clicks and conversions, which networks and geographical locations you want your ads to show on, and more."
            1 -> "Hi I am some text in section 2 of stepper"
            2 -> "Try out different ad text to see what brings in the most customers, and learn how to enhance your ads using features like ad extensions. If you run into any problems with your ads, find out how to tell if they're running and how to resolve approval issues."
            else -> null
        }

    }
}

```log

05-28 18:27:58.368 869 1532 I ActivityTaskManager: START u0 {flg=0x10000000 cmp=com.termux.camera/.ui.ScriptConsoleActivity} from uid 2000, pid 20636
05-28 18:27:58.446 869 1050 D PerformanceDatabaseControl: queryMem pkgName = com.termux.camera
05-28 18:27:58.496 869 1532 I ActivityTaskManager: ->startActivity for ActivityRecord{fef1e84 u0 com.termux.camera/.ui.ScriptConsoleActivity t8820} result:START_SUCCESS
05-28 18:27:58.531 869 951 I ActivityManager: Start proc 20639:com.termux.camera/u0a68 for pre-top-activity {com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity}
05-28 18:27:58.693 869 4314 D os.ActivityManagerServiceLice: make process active com.termux.camera(20639)
05-28 18:27:58.718 869 4314 D os.fingerprint: onRealStartActivityLocked next:ActivityRecord{fef1e84 u0 com.termux.camera/.ui.ScriptConsoleActivity t8820} isKeyguardShowing:false
05-28 18:27:58.718 869 4314 D os.fingerprint: activityComponent = ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} inMultiWindow = false
05-28 18:27:58.718 869 4314 D WindowManager: setFocusedApp mFocusedApp = ActivityRecord{fef1e84 u0 com.termux.camera/.ui.ScriptConsoleActivity t8820}
05-28 18:27:58.727 476 476 D vendor.unisoc.hardware.power-service: Enter getSceneIdByName: sceneName:com.termux.camera
05-28 18:27:58.830 869 1023 D AlarmManager: Package com.termux.camera for user 0 now in bucket 10
05-28 18:27:59.045 20639 20639 V GraphicsEnvironment: ANGLE Developer option for 'com.termux.camera' set to: 'default'
05-28 18:27:59.046 20639 20639 D ApplicationPackageManager: junjie.li7 hasSystemFeature:name=android.hardware.vulkan.versionversion=4198400getOpPackageName=com.termux.camerahasSystemFeature=true
05-28 18:27:59.150 20639 20639 D ApplicationPackageManager: junjie.li7 hasSystemFeature:name=android.software.picture_in_pictureversion=0getOpPackageName=com.termux.camerahasSystemFeature=false
05-28 18:27:59.475 20639 20639 D TranLayerControlManager: initSkipInfo getSkipInfo fail strPkgName:com.termux.camera
05-28 18:27:59.503 869 1532 D DynamicFrameRateController: onAfterActivityResumed packageName: com.termux.camera, activityName: ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity}
05-28 18:27:59.505 869 1532 I ActivityTaskManager: LUCID activityResumed package name: com.termux.camera
05-28 18:27:59.505 869 942 I LightsService: LUCID hook setLucidFgApp com.termux.camera
05-28 18:27:59.583 869 1532 D os.fingerprint: onUpdateFocusedApp oldPackageName:null oldComponent:null newPackageName:com.termux.camera newComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:27:59.586 869 1532 I WindowManager: Input focus has changed to Window{3df67b2 u0 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} from 4651f9b com.google.android.apps.messaging/com.google.android.apps.messaging.ui.ConversationListActivity mDisplayId 0 updateInputWindows true
05-28 18:27:59.609 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=0, DrawingState.flags=0x103, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.793 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=0, DrawingState.flags=0x103, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.800 869 939 I ActivityTaskManager: Displayed com.termux.camera/.ui.ScriptConsoleActivity: +1s429ms
05-28 18:27:59.810 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.840 869 1532 W InputManager-JNI: Input channel object 'a82a6ee Splash Screen com.termux.camera (client)' was disposed without first being removed with the input manager!
05-28 18:27:59.844 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.863 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.868 869 1532 I input_debug: package: com.termux.camera isPassWordInput: false inputType: 0 mMethodMap: false TRAN_SECURITY_INPUT_SUPPORT=false isKeyguardShowing: false enable: 0 isSplitScreen: false
05-28 18:27:59.879 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.894 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.912 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.931 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.951 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.970 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:27:59.988 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:28:00.010 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:28:00.025 869 1050 D PerformanceDatabaseControl: queryMem pkgName = com.termux.camera
05-28 18:28:00.030 869 1050 D PerformanceDatabaseControl: queryCount pkgName = com.termux.camera
05-28 18:28:00.031 869 1050 D PerformanceDatabaseControl: updateDatabase pkgName = com.termux.camera
05-28 18:28:00.033 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:28:00.062 6456 6456 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1446 onStartInput(EditorInfo{EditorInfo{packageName=com.termux.camera, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=-1, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
05-28 18:28:00.325 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:28:00.376 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:28:00.377 1980 2313 D TPMS : getTopPackageName pkgName: com.termux.camera
05-28 18:28:05.178 20639 20679 D ProfileInstaller: Installing profile for com.termux.camera
05-28 18:28:13.618 869 1049 D performance: LRU skip stop: {com.google.android.tts=inputMethods, com.sprd.srmi=adj<=200, com.termux.camera=focus, com.transsion.statisticalsales=adj<=200, com.google.android.ext.services=adj<=200, com.transsion.ossettingsext=adj<=200, com.android.bluetooth=adj<=200, com.google.android.gms=adj<=200, com.google.android.apps.messaging=idleTime, com.google.android.webview=webview, com.hoffnung=adj<=200, com.android.phone=adj<=200, com.transsion.camera=adj<=200, com.transsion.trancare=adj<=200, com.android.mtp=adj<=200, com.transsnet.store=foreground service, com.android.systemui=wallpaper, com.android.se=adj<=200, com.google.android.inputmethod.latin=inputMethods, com.transsion.plat.appupdate=adj<=200, com.android.providers.media.module=adj<=200, com.google.android.permissioncontroller=adj<=200}, swapKill: -1
05-28 18:28:26.502 869 2635 W ActivityManager: Permission Denial: Accessing service com.termux.camera/.service.CameraForegroundService from pid=21118, uid=2000 that is not exported from uid 10068
05-28 18:28:32.089 869 7166 D PackageManager: PMS setEnabledSetting: packageName = com.facebook.katana, className = com.facebook.inspiration.platformsharing.activity.InspirationCameraShareMultipleCollageAlias, newState = 2, flags = 1, userId = 0, callingPackage = null, callingUid = 10361, allowedByPermission = false
05-28 18:28:55.306 869 2635 I ActivityTaskManager: START u0 {flg=0x10000000 cmp=com.termux.camera/.ui.ScriptConsoleActivity} from uid 2000, pid 21227
05-28 18:28:55.318 869 2635 I ActivityTaskManager: ->startActivity for ActivityRecord{279558c u0 com.termux.camera/.ui.ScriptConsoleActivity result:START_DELIVERED_TO_TOP
05-28 18:29:22.736 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:29:22.754 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:29:22.803 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:29:22.819 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:29:23.479 869 7166 D os.fingerprint: onUpdateFocusedApp oldPackageName:com.termux.camera oldComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} newPackageName:null newComponent:null mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:29:23.486 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:29:23.487 869 7166 I WindowManager: Input focus has changed to Window{f5f4032 u0 NotificationShade} from 3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity mDisplayId 0 updateInputWindows true
05-28 18:29:46.974 869 1228 W ActivityManager: Permission Denial: Accessing service com.termux.camera/.service.CameraForegroundService from pid=21445, uid=2000 that is not exported from uid 10068
05-28 18:30:13.649 869 1049 D performance: LRU skip stop: {com.google.android.tts=inputMethods, com.sprd.srmi=adj<=200, com.termux.camera=focus, com.transsion.statisticalsales=adj<=200, com.google.android.ext.services=adj<=200, com.transsion.ossettingsext=adj<=200, com.android.bluetooth=adj<=200, com.google.android.gms=adj<=200, com.google.android.apps.messaging=idleTime, com.google.android.webview=webview, com.transsion.phoenix=notification, com.hoffnung=adj<=200, com.android.phone=adj<=200, com.transsion.camera=adj<=200, com.transsion.trancare=adj<=200, com.android.mtp=adj<=200, com.transsnet.store=foreground service, com.android.systemui=wallpaper, com.android.se=adj<=200, com.google.android.inputmethod.latin=inputMethods, com.transsion.plat.appupdate=adj<=200, com.android.providers.media.module=adj<=200, com.google.android.permissioncontroller=adj<=200}, swapKill: -1
05-28 18:30:33.413 869 2093 D PackageManager: PMS setEnabledSetting: packageName = com.facebook.katana, className = com.facebook.inspiration.platformsharing.activity.InspirationCameraShareMultipleCollageAlias, newState = 2, flags = 1, userId = 0, callingPackage = null, callingUid = 10361, allowedByPermission = false
05-28 18:30:52.186 869 1184 D os.fingerprint: onUpdateFocusedApp oldPackageName:null oldComponent:null newPackageName:com.termux.camera newComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:30:52.210 869 1184 I WindowManager: Input focus has changed to Window{3df67b2 u0 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} from f5f4032 NotificationShade mDisplayId 0 updateInputWindows true
05-28 18:30:52.247 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:30:52.261 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:30:52.296 869 2622 I input_debug: package: com.termux.camera isPassWordInput: false inputType: 0 mMethodMap: false TRAN_SECURITY_INPUT_SUPPORT=false isKeyguardShowing: false enable: 0 isSplitScreen: false
05-28 18:30:52.346 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:30:52.367 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:30:52.479 6456 6456 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1446 onStartInput(EditorInfo{EditorInfo{packageName=com.termux.camera, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=-1, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
05-28 18:31:24.438 20639 20639 I CameraManagerGlobal: Connecting to camera service
05-28 18:31:24.445 20639 22004 E CommandServer: at com.termux.camera.service.CommandServer.start$lambda$2(CommandServer.kt:25)
05-28 18:31:24.445 20639 22004 E CommandServer: 	at com.termux.camera.service.CommandServer.$r8$lambda$1QATbFyM8qrpKBGKalyf6o6UOss(Unknown Source:0)
05-28 18:31:24.445 20639 22004 E CommandServer: 	at com.termux.camera.service.CommandServer$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
05-28 18:31:24.465 20639 20639 V CameraManagerGlobal: ignore id:20
05-28 18:31:24.466 20639 20639 V CameraManagerGlobal: ignore id:21
05-28 18:31:24.467 20639 20639 V CameraManagerGlobal: ignore id:24
05-28 18:31:24.467 20639 20639 V CameraManagerGlobal: ignore id:27
05-28 18:31:24.468 20639 20639 V CameraManagerGlobal: ignore id:30
05-28 18:31:24.468 20639 20639 V CameraManagerGlobal: ignore id:31
05-28 18:31:24.469 20639 20639 V CameraManagerGlobal: ignore id:32
05-28 18:31:24.469 20639 20639 V CameraManagerGlobal: ignore id:37
05-28 18:31:24.469 20639 20639 V CameraManagerGlobal: ignore id:38
05-28 18:31:24.470 20639 20639 V CameraManagerGlobal: ignore id:39
05-28 18:31:24.470 20639 20639 V CameraManagerGlobal: ignore id:42
05-28 18:31:24.471 20639 20639 V CameraManagerGlobal: ignore id:55
05-28 18:31:24.475 20639 20654 I CameraManagerGlobal: onTorchStatusChangedLocked id:21 ignore callback
05-28 18:31:24.476 20639 20654 I CameraManagerGlobal: onTorchStatusChangedLocked id:24 ignore callback
05-28 18:31:24.477 20639 20654 I CameraManagerGlobal: onTorchStatusChangedLocked id:37 ignore callback
05-28 18:31:24.477 20639 20654 I CameraManagerGlobal: onTorchStatusChangedLocked id:38 ignore callback
05-28 18:31:24.523   457   838 D ImageEffect: [setPackageName]packagename com.termux.camera
05-28 18:31:24.523   577 30711 I CameraService: CameraService::connect call (PID -1 "com.termux.camera", camera ID 0) and Camera API version 2
05-28 18:31:24.570   577 30711 I Camera2ClientBase: Camera 0: Opened. Client: com.termux.camera (PID 20639, UID 10068)
05-28 18:31:24.570   577 30711 I CameraDeviceClient: CameraDeviceClient 0: Opened
05-28 18:31:24.571   577 30711 D CameraDeviceClient: this isnot TrassionCameraApk
05-28 18:31:24.577   577 30711 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=0
05-28 18:31:24.582   577 30711 I CameraProviderManager: Camera HAL provider needs restart, calling getService(legacy/0)
05-28 18:31:24.601   869  2622 I Telecom : CallsManager: onStatusChanged mCameraStatus:-2
05-28 18:31:24.696   457   838 I Cam3HWI : 146, SprdCamera3HWI: :hal3: Constructor E camId=0
05-28 18:31:24.697   457   838 I Cam3HWI : 200, SprdCamera3HWI: :hal3: Constructor X
05-28 18:31:24.697   457   838 I Cam3HWI : 330, openCamera: [PerformanceFlow] open E
05-28 18:31:24.698   457   838 I Cam3HWI : 388, openCamera: :hal3: E camId=0
05-28 18:31:24.708   457   838 I Cam3OEMIf: 671, SprdCamera3OEMIf: :hal3: Constructor E camId=0
05-28 18:31:24.712   457   838 I Cam3PowerPerf: 52, SprdCameraSystemPerformance: E
05-28 18:31:24.728   457   838 I Cam3PowerPerf: 67, SprdCameraSystemPerformance: X
05-28 18:31:24.746   457   838 I Cam3OEMIf: 745, SprdCamera3OEMIf: loaded libcamoem.so mHalOem->dso = 0xc0020b2b
05-28 18:31:24.747   457   838 I Cam3OEMIf: 938, SprdCamera3OEMIf: :hal3: Constructor X
05-28 18:31:24.762   457   838 I Cam3OEMIf: 8620, openCamera: :hal3: E camId=0
05-28 18:31:24.765   457   838 I Cam3OEMIf: 8708, openCamera: :hal3: camera_init
05-28 18:31:24.826   457   838 I Cam3OEMIf: 8990, openCamera: sprd_3dcalibration_cap_size w=3264, h=2448
05-28 18:31:24.826   457   838 I Cam3OEMIf: 9000, openCamera: mIommuEnabled=1
05-28 18:31:24.827   457   838 I Cam3OEMIf: 9045, openCamera: :hal3: X
05-28 18:31:24.827   457   838 I Cam3HWI : 450, openCamera: :hal3: X
05-28 18:31:24.827   457   838 I Cam3HWI : 379, openCamera: [PerformanceFlow] open X
05-28 18:31:24.866   869  2622 V CameraService_proxy: The activity is N or above and claims to support resizeable-activity. Crop-rotate-scale is disabled.
05-28 18:31:24.873   869  2622 D SSense  : noteStartCamera: uid:10068
05-28 18:31:25.061   577 30711 D Camera3-Device: Set real time priority for request queue thread (tid 22049)
05-28 18:31:34.424   869  1033 D os.notification.SuspendJobManager: create job  com.transsion.util.SuspendJobManager$JobInfo@9d03d85 key:NotificationRecord(0x0f3602fc: pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null importance=2 key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 groupKey=silent vis=PRIVATE)) data:com.android.server.notification.NotificationManagerService$$ExternalSyntheticLambda10@a46e7da sn:-1 owner:{}
05-28 18:31:34.428  1980  2510 D os.notification: onNotifyNotification StatusBarNotification:StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=null shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 vis=PRIVATE)) callingUid:10068 NotificationChannel:NotificationChannel{mId='camera_service', mName=Camera Service, mDescription=, mImportance=2, mBypassDnd=false, mLockscreenVisibility=-1000, mSound=content://settings/system/notification_sound, mLights=false, mLightColor=0, mVibration=null, mUserLockedFields=0, mFgServiceShown=true, mVibrationEnabled=false, mShowBadge=true, mDeleted=false, mDeletedTimeMs=-1, mGroup='null', mAudioAttributes=AudioAttributes: usage=USAGE_NOTIFICATION content=CONTENT_TYPE_SONIFICATION flags=0x800 tags= bundle=null, mBlockableSystem=false, mAllowBubbles=-1, mImportanceLockedByOEM=false, mImportanceLockedDefaultApp=false, mOriginalImp=2, mParent=null, mConversationId=null, mDemoted=false, mImportantConvo=false} receipt:com.transsion.app.IEnqueueNotificationReceipt$Stub$Proxy@3c3075d sn:1210
05-28 18:31:34.434  1980  2510 D os_noti_center_rule: match = false, sendPkg = com.termux.camera, dbChannel = null, chName = Camera Service, chId = camera_service
05-28 18:31:34.444   869  1033 D os.notification.SuspendJobManager: done  com.transsion.util.SuspendJobManager$JobInfo@9d03d85 key:NotificationRecord(0x0f3602fc: pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null importance=2 key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 groupKey=silent vis=PRIVATE)) data:com.android.server.notification.NotificationManagerService$$ExternalSyntheticLambda10@a46e7da sn:1210 owner:{1980} for app-1980-request
05-28 18:31:34.447 869 950 D os.notification: onEnqueueNotificationInternal StatusBarNotification:StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 groupKey=silent vis=PRIVATE)) callingUid:10068 sn:1210 res:true
05-28 18:31:34.697 1195 1195 D NotificationListener: onNotificationPosted: StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x62 color=0x00000000 groupKey=silent vis=PRIVATE))
05-28 18:31:34.810 1195 1195 D TrCloudNotificationSupportController: containCloudNotificationSupportApp: com.termux.cameranot in the cloud list
05-28 18:31:34.810 1195 1195 D TrCloudNotificationSupportController: containLocalNotificationSupportApp: com.termux.cameranot in the local list
05-28 18:31:34.815 1195 1447 D PeopleSpaceWidgetMgr: Sbn doesn't contain valid PeopleTileKey: null/0/com.termux.camera
05-28 18:31:36.777 869 2629 D os.fingerprint: onUpdateFocusedApp oldPackageName:com.termux.camera oldComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} newPackageName:null newComponent:null mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:31:36.783 869 2629 I WindowManager: Input focus has changed to Window{f5f4032 u0 NotificationShade} from 3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity mDisplayId 0 updateInputWindows true
05-28 18:31:36.784 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:39.352 869 2092 D os.fingerprint: onUpdateFocusedApp oldPackageName:null oldComponent:null newPackageName:com.termux.camera newComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:31:39.358 869 2092 I WindowManager: Input focus has changed to Window{3df67b2 u0 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} from f5f4032 NotificationShade mDisplayId 0 updateInputWindows true
05-28 18:31:39.383 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:39.398 869 1184 I input_debug: package: com.termux.camera isPassWordInput: false inputType: 0 mMethodMap: false TRAN_SECURITY_INPUT_SUPPORT=false isKeyguardShowing: false enable: 0 isSplitScreen: false
05-28 18:31:39.399 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:39.407 6456 6456 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1446 onStartInput(EditorInfo{EditorInfo{packageName=com.termux.camera, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=-1, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
05-28 18:31:39.416 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:39.434 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:48.013 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:48.114 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:31:50.322 577 30711 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:31:50.323 577 30711 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:31:50.326 457 838 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:31:50.328 577 30711 I Camera3-Device: disconnectImpl: E
05-28 18:31:50.328 457 838 I Cam3HWI : 464, closeCamera: :hal3: E camId=0
05-28 18:31:50.328 457 838 I Cam3HWI : 465, closeCamera: [PerformanceFlow] close E
05-28 18:31:50.329 457 838 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:31:50.329 457 838 I Cam3OEMIf: 1003, closeCamera: :hal3: E camId=0
05-28 18:31:50.329 457 838 I Cam3OEMIf: 1096, closeCamera: :hal3: deinit camera
05-28 18:31:50.424 457 838 I Cam3OEMIf: 1119, closeCamera: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:31:50.424 457 838 I Cam3OEMIf: 944, ~SprdCamera3OEMIf: :hal3: Destructor E camId=0
05-28 18:31:50.424 457 838 I Cam3OEMIf: 968, ~SprdCamera3OEMIf: camera low power mode exit
05-28 18:31:50.425 457 838 I Cam3OEMIf: 3553, freeAllCameraMem: :hal3: E
05-28 18:31:50.425 457 838 I Cam3OEMIf: 3696, freeAllCameraMem: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:31:50.425 457 838 I Cam3OEMIf: 992, ~SprdCamera3OEMIf: :hal3: X
05-28 18:31:50.425 457 838 I Cam3PowerPerf: 71, ~SprdCameraSystemPerformance: E
05-28 18:31:50.426 457 838 I Cam3PowerPerf: 76, ~SprdCameraSystemPerformance: X
05-28 18:31:50.426 457 838 I Cam3HWI : 545, closeCamera: :hal3: X
05-28 18:31:50.426 457 838 I Cam3HWI : 546, closeCamera: [PerformanceFlow] close X
05-28 18:31:50.426 457 838 I Cam3HWI : 212, ~SprdCamera3HWI: :hal3: Destructor E camId=0
05-28 18:31:50.426 457 838 I Cam3HWI : 3357, close_camera_device: :hal3: camera3->close X mCameraSessionActive 0
05-28 18:31:50.429 577 30711 I Camera3-Device: disconnectImpl: X
05-28 18:31:50.430 869 1003 D SSense : noteStopCamera: uid:10068
05-28 18:31:50.431 577 30711 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=1
05-28 18:31:50.434 869 1003 I Telecom : CallsManager: onStatusChanged mCameraStatus:1
05-28 18:31:50.436 577 30711 I CameraService: disconnect: Disconnected client for camera 0 for PID 20639
05-28 18:31:50.443 457 838 D ImageEffect: [setPackageName]packagename com.termux.camera
05-28 18:31:50.444 577 30711 I CameraService: CameraService::connect call (PID -1 "com.termux.camera", camera ID 0) and Camera API version 2
05-28 18:31:50.450 577 30711 I Camera2ClientBase: Camera 0: Opened. Client: com.termux.camera (PID 20639, UID 10068)
05-28 18:31:50.450 577 30711 I CameraDeviceClient: CameraDeviceClient 0: Opened
05-28 18:31:50.451 577 30711 D CameraDeviceClient: this isnot TrassionCameraApk
05-28 18:31:50.453 577 30711 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=0
05-28 18:31:50.454 577 30711 I CameraProviderManager: Camera HAL provider needs restart, calling getService(legacy/0)
05-28 18:31:50.454 869 1003 I Telecom : CallsManager: onStatusChanged mCameraStatus:-2
05-28 18:31:50.459 457 838 I Cam3HWI : 146, SprdCamera3HWI: :hal3: Constructor E camId=0
05-28 18:31:50.459 457 838 I Cam3HWI : 200, SprdCamera3HWI: :hal3: Constructor X
05-28 18:31:50.459 457 838 I Cam3HWI : 330, openCamera: [PerformanceFlow] open E
05-28 18:31:50.459 457 838 I Cam3HWI : 388, openCamera: :hal3: E camId=0
05-28 18:31:50.460 457 838 I Cam3OEMIf: 671, SprdCamera3OEMIf: :hal3: Constructor E camId=0
05-28 18:31:50.460 457 838 I Cam3PowerPerf: 52, SprdCameraSystemPerformance: E
05-28 18:31:50.462 457 838 I Cam3PowerPerf: 67, SprdCameraSystemPerformance: X
05-28 18:31:50.465 457 838 I Cam3OEMIf: 745, SprdCamera3OEMIf: loaded libcamoem.so mHalOem->dso = 0xc0020b2b
05-28 18:31:50.465 457 838 I Cam3OEMIf: 938, SprdCamera3OEMIf: :hal3: Constructor X
05-28 18:31:50.465 457 838 I Cam3OEMIf: 8620, openCamera: :hal3: E camId=0
05-28 18:31:50.465 457 838 I Cam3OEMIf: 8708, openCamera: :hal3: camera_init
05-28 18:31:50.504 457 838 I Cam3OEMIf: 8990, openCamera: sprd_3dcalibration_cap_size w=3264, h=2448
05-28 18:31:50.505 457 838 I Cam3OEMIf: 9000, openCamera: mIommuEnabled=1
05-28 18:31:50.506 457 838 I Cam3OEMIf: 9045, openCamera: :hal3: X
05-28 18:31:50.506 457 838 I Cam3HWI : 450, openCamera: :hal3: X
05-28 18:31:50.506 457 838 I Cam3HWI : 379, openCamera: [PerformanceFlow] open X
05-28 18:31:50.515 869 2092 V CameraService_proxy: The activity is N or above and claims to support resizeable-activity. Crop-rotate-scale is disabled.
05-28 18:31:50.520 869 2092 D SSense : noteStartCamera: uid:10068
05-28 18:31:50.559 577 30711 D Camera3-Device: Set real time priority for request queue thread (tid 22189)
05-28 18:32:05.825 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:05.826 869 1003 D os.fingerprint: onUpdateFocusedApp oldPackageName:com.termux.camera oldComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} newPackageName:null newComponent:null mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:32:05.830 869 1003 I WindowManager: Input focus has changed to Window{f5f4032 u0 NotificationShade} from 3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity mDisplayId 0 updateInputWindows true
05-28 18:32:13.650 869 1049 D performance: LRU skip stop: {com.google.android.tts=inputMethods, com.sprd.srmi=adj<=200, com.termux.camera=focus, com.transsion.statisticalsales=adj<=200, com.google.android.ext.services=adj<=200, com.transsion.ossettingsext=adj<=200, com.android.bluetooth=adj<=200, com.google.android.gms=adj<=200, com.google.android.apps.messaging=idleTime, com.google.android.webview=webview, com.transsion.phoenix=notification, com.hoffnung=adj<=200, com.android.phone=adj<=200, com.transsion.camera=adj<=200, com.transsion.trancare=adj<=200, com.android.mtp=adj<=200, com.transsnet.store=foreground service, com.android.systemui=wallpaper, com.android.se=adj<=200, com.google.android.inputmethod.latin=inputMethods, com.transsion.plat.appupdate=adj<=200, com.android.providers.media.module=adj<=200, com.google.android.permissioncontroller=adj<=200}, swapKill: -1
05-28 18:32:15.903 869 1532 D os.fingerprint: onUpdateFocusedApp oldPackageName:null oldComponent:null newPackageName:com.termux.camera newComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:32:15.909 869 1532 I WindowManager: Input focus has changed to Window{3df67b2 u0 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} from f5f4032 NotificationShade mDisplayId 0 updateInputWindows true
05-28 18:32:15.941 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:15.955 869 2222 I input_debug: package: com.termux.camera isPassWordInput: false inputType: 0 mMethodMap: false TRAN_SECURITY_INPUT_SUPPORT=false isKeyguardShowing: false enable: 0 isSplitScreen: false
05-28 18:32:15.963 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:15.979 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:16.009 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:16.133 6456 6456 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1446 onStartInput(EditorInfo{EditorInfo{packageName=com.termux.camera, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=-1, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
05-28 18:32:23.078 1195 1195 D NotificationListener: onNotificationRemoved: StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x62 color=0x00000000 groupKey=silent vis=PRIVATE)) reason: 8
05-28 18:32:23.083 20639 22002 W MessageQueue: at android.hardware.camera2.impl.CameraDeviceImpl$CameraHandlerExecutor.execute(CameraDeviceImpl.java:2274)
05-28 18:32:23.083 20639 22002 W MessageQueue: 	at android.hardware.camera2.impl.CameraCaptureSessionImpl.close(CameraCaptureSessionImpl.java:598)
05-28 18:32:23.083 20639 22002 W MessageQueue: 	at com.termux.camera.service.CameraController.closeCameraLocked(CameraController.kt:327)
05-28 18:32:23.083 20639 22002 W MessageQueue: 	at com.termux.camera.service.CameraController.shutdown$lambda$25(CameraController.kt:378)
05-28 18:32:23.083 20639 22002 W MessageQueue: 	at com.termux.camera.service.CameraController.$r8$lambda$zMf_N86CM8PjE7OZEvoIlq9IGgI(Unknown Source:0)
05-28 18:32:23.083 20639 22002 W MessageQueue: at com.termux.camera.service.CameraController$$ExternalSyntheticLambda10.run(D8$$SyntheticClass:0)
05-28 18:32:23.083 1980 2510 D os.notification: onNotifyRemoved StatusBarNotification:StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x62 color=0x00000000 groupKey=silent vis=PRIVATE)) NotificationStats:NotificationStats{mSeen=true, mExpanded=true, mDirectReplied=false, mSnoozed=false, mViewedSettings=false, mInteracted=true, mDismissalSurface=0} reason:8
05-28 18:32:23.084 577 1018 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:32:23.085 577 1018 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:32:23.094 457 836 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:32:23.096 577 1018 I Camera3-Device: disconnectImpl: E
05-28 18:32:23.097 457 836 I Cam3HWI : 464, closeCamera: :hal3: E camId=0
05-28 18:32:23.097 457 836 I Cam3HWI : 465, closeCamera: [PerformanceFlow] close E
05-28 18:32:23.097 457 836 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:32:23.097 457 836 I Cam3OEMIf: 1003, closeCamera: :hal3: E camId=0
05-28 18:32:23.097 457 836 I Cam3OEMIf: 1096, closeCamera: :hal3: deinit camera
05-28 18:32:23.103 1195 1195 D TrCloudNotificationSupportController: containCloudNotificationSupportApp: com.termux.cameranot in the cloud list
05-28 18:32:23.103 1195 1195 D TrCloudNotificationSupportController: containLocalNotificationSupportApp: com.termux.cameranot in the local list
05-28 18:32:23.108 1195 1447 D PeopleSpaceWidgetMgr: Sbn doesn't contain valid PeopleTileKey: null/0/com.termux.camera
05-28 18:32:23.192 457 836 I Cam3OEMIf: 1119, closeCamera: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:32:23.192 457 836 I Cam3OEMIf: 944, ~SprdCamera3OEMIf: :hal3: Destructor E camId=0
05-28 18:32:23.193 457 836 I Cam3OEMIf: 968, ~SprdCamera3OEMIf: camera low power mode exit
05-28 18:32:23.193 457 836 I Cam3OEMIf: 3553, freeAllCameraMem: :hal3: E
05-28 18:32:23.193 457 836 I Cam3OEMIf: 3696, freeAllCameraMem: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:32:23.193 457 836 I Cam3OEMIf: 992, ~SprdCamera3OEMIf: :hal3: X
05-28 18:32:23.193 457 836 I Cam3PowerPerf: 71, ~SprdCameraSystemPerformance: E
05-28 18:32:23.195 457 836 I Cam3PowerPerf: 76, ~SprdCameraSystemPerformance: X
05-28 18:32:23.195 457 836 I Cam3HWI : 545, closeCamera: :hal3: X
05-28 18:32:23.195 457 836 I Cam3HWI : 546, closeCamera: [PerformanceFlow] close X
05-28 18:32:23.195 457 836 I Cam3HWI : 212, ~SprdCamera3HWI: :hal3: Destructor E camId=0
05-28 18:32:23.195 457 836 I Cam3HWI : 3357, close_camera_device: :hal3: camera3->close X mCameraSessionActive 0
05-28 18:32:23.198 577 1018 I Camera3-Device: disconnectImpl: X
05-28 18:32:23.199 869 2622 D SSense : noteStopCamera: uid:10068
05-28 18:32:23.200 577 1018 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=1
05-28 18:32:23.201 869 2622 I Telecom : CallsManager: onStatusChanged mCameraStatus:1
05-28 18:32:23.203 577 1018 I CameraService: disconnect: Disconnected client for camera 0 for PID 20639
05-28 18:32:23.206 20639 22002 W MessageQueue: at android.hardware.camera2.impl.CameraDeviceImpl$CameraHandlerExecutor.execute(CameraDeviceImpl.java:2274)
05-28 18:32:23.206 20639 22002 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl.close(CameraDeviceImpl.java:1368)
05-28 18:32:23.206 20639 22002 W MessageQueue: 	at com.termux.camera.service.CameraController.closeCameraLocked(CameraController.kt:331)
05-28 18:32:23.206 20639 22002 W MessageQueue: 	at com.termux.camera.service.CameraController.shutdown$lambda$25(CameraController.kt:378)
05-28 18:32:23.206 20639 22002 W MessageQueue: 	at com.termux.camera.service.CameraController.$r8$lambda$zMf_N86CM8PjE7OZEvoIlq9IGgI(Unknown Source:0)
05-28 18:32:23.206 20639 22002 W MessageQueue: at com.termux.camera.service.CameraController$$ExternalSyntheticLambda10.run(D8$$SyntheticClass:0)
05-28 18:32:33.077 869 1533 D PackageManager: PMS setEnabledSetting: packageName = com.facebook.katana, className = com.facebook.inspiration.platformsharing.activity.InspirationCameraShareMultipleCollageAlias, newState = 2, flags = 1, userId = 0, callingPackage = null, callingUid = 10361, allowedByPermission = false
05-28 18:32:46.347 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:46.364 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:46.381 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:46.614 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:46.631 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:46.994 869 1533 D os.fingerprint: onUpdateFocusedApp oldPackageName:com.termux.camera oldComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} newPackageName:null newComponent:null mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:32:46.999 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:32:47.001 869 1533 I WindowManager: Input focus has changed to Window{7de2e18 u0 QSCenter} from 3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity mDisplayId 0 updateInputWindows true
05-28 18:32:56.817 1195 1195 D QSTileHost: Creating tile: custom(com.termux.camera/.tiles.CameraTileService)
05-28 18:33:04.944 1195 1195 D Tile.CustomTile: click custom(com.termux.camera/.tiles.CameraTileService)
05-28 18:33:05.027 869 1033 D os.notification.SuspendJobManager: create job com.transsion.util.SuspendJobManager$JobInfo@ba8f2a5 key:NotificationRecord(0x0c19d89c: pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null importance=2 key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 groupKey=silent vis=PRIVATE)) data:com.android.server.notification.NotificationManagerService$$ExternalSyntheticLambda10@17bc67a sn:-1 owner:{}
05-28 18:33:05.033  1980  2510 D os.notification: onNotifyNotification StatusBarNotification:StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=null shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 vis=PRIVATE)) callingUid:10068 NotificationChannel:NotificationChannel{mId='camera_service', mName=Camera Service, mDescription=, mImportance=2, mBypassDnd=false, mLockscreenVisibility=-1000, mSound=content://settings/system/notification_sound, mLights=false, mLightColor=0, mVibration=null, mUserLockedFields=0, mFgServiceShown=true, mVibrationEnabled=false, mShowBadge=true, mDeleted=false, mDeletedTimeMs=-1, mGroup='null', mAudioAttributes=AudioAttributes: usage=USAGE_NOTIFICATION content=CONTENT_TYPE_SONIFICATION flags=0x800 tags= bundle=null, mBlockableSystem=false, mAllowBubbles=-1, mImportanceLockedByOEM=false, mImportanceLockedDefaultApp=false, mOriginalImp=2, mParent=null, mConversationId=null, mDemoted=false, mImportantConvo=false} receipt:com.transsion.app.IEnqueueNotificationReceipt$Stub$Proxy@536a8d2 sn:1212
05-28 18:33:05.038 20639 22881 E CommandServer: 	at com.termux.camera.service.CommandServer.start$lambda$2(CommandServer.kt:25)
05-28 18:33:05.038 20639 22881 E CommandServer: 	at com.termux.camera.service.CommandServer.$r8$lambda$1QATbFyM8qrpKBGKalyf6o6UOss(Unknown Source:0)
05-28 18:33:05.038 20639 22881 E CommandServer: 	at com.termux.camera.service.CommandServer$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
05-28 18:33:05.039  1980  2510 D os_noti_center_rule: match = false, sendPkg = com.termux.camera, dbChannel = null, chName = Camera Service, chId = camera_service
05-28 18:33:05.052   869  1033 D os.notification.SuspendJobManager: done  com.transsion.util.SuspendJobManager$JobInfo@ba8f2a5 key:NotificationRecord(0x0c19d89c: pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null importance=2 key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 groupKey=silent vis=PRIVATE)) data:com.android.server.notification.NotificationManagerService$$ExternalSyntheticLambda10@17bc67a sn:1212 owner:{1980} for  app-1980-request
05-28 18:33:05.053   869   950 D os.notification: onEnqueueNotificationInternal StatusBarNotification:StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x42 color=0x00000000 groupKey=silent vis=PRIVATE)) callingUid:10068 sn:1212 res:true
05-28 18:33:05.080   457   836 D ImageEffect: [setPackageName]packagename com.termux.camera
05-28 18:33:05.081   577  1018 I CameraService: CameraService::connect call (PID -1 "com.termux.camera", camera ID 0) and Camera API version 2
05-28 18:33:05.097   577  1018 I Camera2ClientBase: Camera 0: Opened. Client: com.termux.camera (PID 20639, UID 10068)
05-28 18:33:05.097   577  1018 I CameraDeviceClient: CameraDeviceClient 0: Opened
05-28 18:33:05.097   577  1018 D CameraDeviceClient: this isnot TrassionCameraApk
05-28 18:33:05.101   577  1018 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=0
05-28 18:33:05.104   577  1018 I CameraProviderManager: Camera HAL provider needs restart, calling getService(legacy/0)
05-28 18:33:05.113   869  1532 I Telecom : CallsManager: onStatusChanged mCameraStatus:-2
05-28 18:33:05.133   457   836 I Cam3HWI : 146, SprdCamera3HWI: :hal3: Constructor E camId=0
05-28 18:33:05.133   457   836 I Cam3HWI : 200, SprdCamera3HWI: :hal3: Constructor X
05-28 18:33:05.133   457   836 I Cam3HWI : 330, openCamera: [PerformanceFlow] open E
05-28 18:33:05.133   457   836 I Cam3HWI : 388, openCamera: :hal3: E camId=0
05-28 18:33:05.133   457   836 I Cam3OEMIf: 671, SprdCamera3OEMIf: :hal3: Constructor E camId=0
05-28 18:33:05.133   457   836 I Cam3PowerPerf: 52, SprdCameraSystemPerformance: E
05-28 18:33:05.141   457   836 I Cam3PowerPerf: 67, SprdCameraSystemPerformance: X
05-28 18:33:05.154   457   836 I Cam3OEMIf: 745, SprdCamera3OEMIf: loaded libcamoem.so mHalOem->dso = 0xc0020b2b
05-28 18:33:05.154   457   836 I Cam3OEMIf: 938, SprdCamera3OEMIf: :hal3: Constructor X
05-28 18:33:05.156   457   836 I Cam3OEMIf: 8620, openCamera: :hal3: E camId=0
05-28 18:33:05.158   457   836 I Cam3OEMIf: 8708, openCamera: :hal3: camera_init
05-28 18:33:05.208   457   836 I Cam3OEMIf: 8990, openCamera: sprd_3dcalibration_cap_size w=3264, h=2448
05-28 18:33:05.208   457   836 I Cam3OEMIf: 9000, openCamera: mIommuEnabled=1
05-28 18:33:05.209   457   836 I Cam3OEMIf: 9045, openCamera: :hal3: X
05-28 18:33:05.209   457   836 I Cam3HWI : 450, openCamera: :hal3: X
05-28 18:33:05.209   457   836 I Cam3HWI : 379, openCamera: [PerformanceFlow] open X
05-28 18:33:05.232   869  1532 V CameraService_proxy: The activity is N or above and claims to support resizeable-activity. Crop-rotate-scale is disabled.
05-28 18:33:05.234   869  1532 D SSense  : noteStartCamera: uid:10068
05-28 18:33:05.314  1195  1195 D NotificationListener: onNotificationPosted: StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x62 color=0x00000000 groupKey=silent vis=PRIVATE))
05-28 18:33:05.403  1195  1195 D TrCloudNotificationSupportController: containCloudNotificationSupportApp: com.termux.cameranot in the cloud list
05-28 18:33:05.403  1195  1195 D TrCloudNotificationSupportController: containLocalNotificationSupportApp: com.termux.cameranot in the local list
05-28 18:33:05.406  1195  1447 D PeopleSpaceWidgetMgr: Sbn doesn't contain valid PeopleTileKey: null/0/com.termux.camera
05-28 18:33:05.418   577  1018 D Camera3-Device: Set real time priority for request queue thread (tid 22923)
05-28 18:33:11.998   869  2616 D os.fingerprint: onUpdateFocusedApp oldPackageName:null oldComponent:null newPackageName:com.termux.camera newComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:33:12.002   869  2616 I WindowManager: Input focus has changed to Window{3df67b2 u0 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} from 7de2e18 QSCenter mDisplayId 0 updateInputWindows true
05-28 18:33:12.025   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:12.047   869  2616 I input_debug: package: com.termux.camera isPassWordInput: false inputType: 0 mMethodMap: false TRAN_SECURITY_INPUT_SUPPORT=false isKeyguardShowing: false enable: 0 isSplitScreen: false
05-28 18:33:12.236  6456  6456 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1446 onStartInput(EditorInfo{EditorInfo{packageName=com.termux.camera, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=-1, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
05-28 18:33:12.424   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:13.663   869  1049 D performance: LRU skip stop: {com.google.android.tts=inputMethods, com.sprd.srmi=adj<=200, com.termux.camera=focus, com.transsion.statisticalsales=adj<=200, com.google.android.ext.services=adj<=200, com.transsion.ossettingsext=adj<=200, com.android.bluetooth=adj<=200, com.google.android.gms=adj<=200, com.instagram.android=adj<=200, com.google.android.webview=webview, com.transsion.phoenix=notification, com.hoffnung=adj<=200, com.android.phone=adj<=200, com.transsion.camera=adj<=200, com.transsion.trancare=adj<=200, com.android.mtp=adj<=200, com.transsnet.store=foreground service, com.android.systemui=wallpaper, com.android.se=adj<=200, com.google.android.inputmethod.latin=inputMethods, com.transsion.plat.appupdate=adj<=200, com.android.providers.media.module=adj<=200, com.google.android.permissioncontroller=adj<=200}, swapKill: -1
05-28 18:33:13.824   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:17.722   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:17.739   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:17.756   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:17.823   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:17.840   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:18.422   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:18.439   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:19.972   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:19.989   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.405   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.437   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.454   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.471   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.526  1360  1463 D TaskIconCache:  activityInfo = ActivityInfo{31a2741 com.termux.camera.ui.ScriptConsoleActivity}
05-28 18:33:23.571   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.588   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.604   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:23.622   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:24.156   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:24.187   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:24.199  1980  2510 D TPMS    : getTopPackageName pkgName: com.termux.camera
05-28 18:33:24.204   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:26.304   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:26.320   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:26.686   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:26.704   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:30.819   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:30.835   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:30.851   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:30.886   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:31.249   869  1533 D os.fingerprint: onUpdateFocusedApp oldPackageName:com.termux.camera oldComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} newPackageName:null newComponent:null mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:33:31.253   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:33:31.259   869  1533 I WindowManager: Input focus has changed to Window{7de2e18 u0 QSCenter} from 3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity mDisplayId 0 updateInputWindows true
05-28 18:33:31.269   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:01.943   869  2622 D os.fingerprint: onUpdateFocusedApp oldPackageName:null oldComponent:null newPackageName:com.termux.camera newComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:34:01.951   869  2622 I WindowManager: Input focus has changed to Window{3df67b2 u0 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} from 7de2e18 QSCenter mDisplayId 0 updateInputWindows true
05-28 18:34:01.996   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:02.009   869  1533 I input_debug: package: com.termux.camera isPassWordInput: false inputType: 0 mMethodMap: false TRAN_SECURITY_INPUT_SUPPORT=false isKeyguardShowing: false enable: 0 isSplitScreen: false
05-28 18:34:02.019  6456  6456 I GoogleInputMethodService: GoogleInputMethodService.onStartInput():1446 onStartInput(EditorInfo{EditorInfo{packageName=com.termux.camera, inputType=0, inputTypeString=NULL, enableLearning=false, autoCorrection=false, autoComplete=false, imeOptions=0, privateImeOptions=null, actionName=UNSPECIFIED, actionLabel=null, initialSelStart=-1, initialSelEnd=-1, initialCapsMode=0, label=null, fieldId=-1, fieldName=null, extras=null, hintText=null, hintLocales=[]}}, false)
05-28 18:34:02.527   519   519 I Layer   : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:05.861  1195  1195 D NotificationListener: onNotificationRemoved: StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x62 color=0x00000000 groupKey=silent vis=PRIVATE)) reason: 8
05-28 18:34:05.877  1980  2510 D os.notification: onNotifyRemoved StatusBarNotification:StatusBarNotification(pkg=com.termux.camera user=UserHandle{0} id=1001 tag=null key=0|com.termux.camera|1001|null|10068: Notification(channel=camera_service shortcut=null contentView=null vibrate=null sound=null defaults=0x0 flags=0x62 color=0x00000000 groupKey=silent vis=PRIVATE)) NotificationStats:NotificationStats{mSeen=false, mExpanded=false, mDirectReplied=false, mSnoozed=false, mViewedSettings=false, mInteracted=false, mDismissalSurface=0} reason:8
05-28 18:34:05.888 20639 22879 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl$CameraHandlerExecutor.execute(CameraDeviceImpl.java:2274)
05-28 18:34:05.888 20639 22879 W MessageQueue: 	at android.hardware.camera2.impl.CameraCaptureSessionImpl.close(CameraCaptureSessionImpl.java:598)
05-28 18:34:05.888 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController.closeCameraLocked(CameraController.kt:327)
05-28 18:34:05.888 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController.shutdown$lambda$25(CameraController.kt:378)
05-28 18:34:05.888 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController.$r8$lambda$zMf_N86CM8PjE7OZEvoIlq9IGgI(Unknown Source:0)
05-28 18:34:05.888 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController$$ExternalSyntheticLambda10.run(D8$$SyntheticClass:0)
05-28 18:34:05.901  1195  1195 D TrCloudNotificationSupportController: containCloudNotificationSupportApp: com.termux.cameranot in the cloud list
05-28 18:34:05.902  1195  1195 D TrCloudNotificationSupportController: containLocalNotificationSupportApp: com.termux.cameranot in the local list
05-28 18:34:05.905  1195  1447 D PeopleSpaceWidgetMgr: Sbn doesn't contain valid PeopleTileKey: null/0/com.termux.camera
05-28 18:34:05.919   577  1018 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:34:05.919   577  1018 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:34:05.952   457   838 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:34:05.961   577  1018 I Camera3-Device: disconnectImpl: E
05-28 18:34:05.962   457   838 I Cam3HWI : 464, closeCamera: :hal3: E camId=0
05-28 18:34:05.962   457   838 I Cam3HWI : 465, closeCamera: [PerformanceFlow] close E
05-28 18:34:05.962   457   838 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:34:05.962   457   838 I Cam3OEMIf: 1003, closeCamera: :hal3: E camId=0
05-28 18:34:05.963   457   838 I Cam3OEMIf: 1096, closeCamera: :hal3: deinit camera
05-28 18:34:06.093   457   838 I Cam3OEMIf: 1119, closeCamera: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:34:06.093   457   838 I Cam3OEMIf: 944, ~SprdCamera3OEMIf: :hal3: Destructor E camId=0
05-28 18:34:06.095   457   838 I Cam3OEMIf: 968, ~SprdCamera3OEMIf: camera low power mode exit
05-28 18:34:06.095   457   838 I Cam3OEMIf: 3553, freeAllCameraMem: :hal3: E
05-28 18:34:06.095   457   838 I Cam3OEMIf: 3696, freeAllCameraMem: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:34:06.095   457   838 I Cam3OEMIf: 992, ~SprdCamera3OEMIf: :hal3: X
05-28 18:34:06.095   457   838 I Cam3PowerPerf: 71, ~SprdCameraSystemPerformance: E
05-28 18:34:06.101   457   838 I Cam3PowerPerf: 76, ~SprdCameraSystemPerformance: X
05-28 18:34:06.102   457   838 I Cam3HWI : 545, closeCamera: :hal3: X
05-28 18:34:06.102   457   838 I Cam3HWI : 546, closeCamera: [PerformanceFlow] close X
05-28 18:34:06.102   457   838 I Cam3HWI : 212, ~SprdCamera3HWI: :hal3: Destructor E camId=0
05-28 18:34:06.103   457   838 I Cam3HWI : 3357, close_camera_device: :hal3: camera3->close X mCameraSessionActive 0
05-28 18:34:06.119   577  1018 I Camera3-Device: disconnectImpl: X
05-28 18:34:06.120   869  2622 D SSense  : noteStopCamera: uid:10068
05-28 18:34:06.120   577  1018 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=1
05-28 18:34:06.124   577  1018 I CameraService: disconnect: Disconnected client for camera 0 for PID 20639
05-28 18:34:06.127 20639 22879 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl$CameraHandlerExecutor.execute(CameraDeviceImpl.java:2274)
05-28 18:34:06.127 20639 22879 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl.close(CameraDeviceImpl.java:1368)
05-28 18:34:06.127 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController.closeCameraLocked(CameraController.kt:331)
05-28 18:34:06.127 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController.shutdown$lambda$25(CameraController.kt:378)
05-28 18:34:06.127 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController.$r8$lambda$zMf_N86CM8PjE7OZEvoIlq9IGgI(Unknown Source:0)
05-28 18:34:06.127 20639 22879 W MessageQueue: 	at com.termux.camera.service.CameraController$$ExternalSyntheticLambda10.run(D8$$SyntheticClass:0)
05-28 18:34:06.134   869  1533 I Telecom : CallsManager: onStatusChanged mCameraStatus:1
05-28 18:34:13.722   869  1049 D performance: LRU skip stop: {com.google.android.tts=inputMethods, com.sprd.srmi=adj<=200, com.termux.camera=focus, com.transsion.statisticalsales=adj<=200, com.google.android.ext.services=adj<=200, com.transsion.ossettingsext=adj<=200, com.android.bluetooth=adj<=200, com.google.android.gms=adj<=200, com.google.android.webview=webview, com.hoffnung=adj<=200, com.android.phone=adj<=200, com.transsion.camera=adj<=200, com.transsion.trancare=adj<=200, com.android.mtp=adj<=200, com.transsnet.store=foreground service, com.android.systemui=wallpaper, com.android.se=adj<=200, com.google.android.inputmethod.latin=inputMethods, com.transsion.plat.appupdate=adj<=200, com.android.providers.media.module=adj<=200, com.google.android.permissioncontroller=adj<=200}, swapKill: -1
05-28 18:34:27.170 20639 24014 E CommandServer: 	at com.termux.camera.service.CommandServer.start$lambda$2(CommandServer.kt:25)
05-28 18:34:27.170 20639 24014 E CommandServer: 	at com.termux.camera.service.CommandServer.$r8$lambda$1QATbFyM8qrpKBGKalyf6o6UOss(Unknown Source:0)
05-28 18:34:27.170 20639 24014 E CommandServer: 	at com.termux.camera.service.CommandServer$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
05-28 18:34:27.206   457   838 D ImageEffect: [setPackageName]packagename com.termux.camera
05-28 18:34:27.207   577  1018 I CameraService: CameraService::connect call (PID -1 "com.termux.camera", camera ID 0) and Camera API version 2
05-28 18:34:27.247   577  1018 I Camera2ClientBase: Camera 0: Opened. Client: com.termux.camera (PID 20639, UID 10068)
05-28 18:34:27.253   577  1018 I CameraDeviceClient: CameraDeviceClient 0: Opened
05-28 18:34:27.253   577  1018 D CameraDeviceClient: this isnot TrassionCameraApk
05-28 18:34:27.258   577  1018 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=0
05-28 18:34:27.260   577  1018 I CameraProviderManager: Camera HAL provider needs restart, calling getService(legacy/0)
05-28 18:34:27.273   869  2093 I Telecom : CallsManager: onStatusChanged mCameraStatus:-2
05-28 18:34:27.320   457   838 I Cam3HWI : 146, SprdCamera3HWI: :hal3: Constructor E camId=0
05-28 18:34:27.320   457   838 I Cam3HWI : 200, SprdCamera3HWI: :hal3: Constructor X
05-28 18:34:27.320   457   838 I Cam3HWI : 330, openCamera: [PerformanceFlow] open E
05-28 18:34:27.320   457   838 I Cam3HWI : 388, openCamera: :hal3: E camId=0
05-28 18:34:27.321   457   838 I Cam3OEMIf: 671, SprdCamera3OEMIf: :hal3: Constructor E camId=0
05-28 18:34:27.321   457   838 I Cam3PowerPerf: 52, SprdCameraSystemPerformance: E
05-28 18:34:27.324   457   838 I Cam3PowerPerf: 67, SprdCameraSystemPerformance: X
05-28 18:34:27.366   457   838 I Cam3OEMIf: 745, SprdCamera3OEMIf: loaded libcamoem.so mHalOem->dso = 0xc0020b2b
05-28 18:34:27.366   457   838 I Cam3OEMIf: 938, SprdCamera3OEMIf: :hal3: Constructor X
05-28 18:34:27.367   457   838 I Cam3OEMIf: 8620, openCamera: :hal3: E camId=0
05-28 18:34:27.367   457   838 I Cam3OEMIf: 8708, openCamera: :hal3: camera_init
05-28 18:34:27.531   457   838 I Cam3OEMIf: 8990, openCamera: sprd_3dcalibration_cap_size w=3264, h=2448
05-28 18:34:27.531   457   838 I Cam3OEMIf: 9000, openCamera: mIommuEnabled=1
05-28 18:34:27.534   457   838 I Cam3OEMIf: 9045, openCamera: :hal3: X
05-28 18:34:27.534   457   838 I Cam3HWI : 450, openCamera: :hal3: X
05-28 18:34:27.534   457   838 I Cam3HWI : 379, openCamera: [PerformanceFlow] open X
05-28 18:34:27.575   869  1184 V CameraService_proxy: The activity is N or above and claims to support resizeable-activity. Crop-rotate-scale is disabled.
05-28 18:34:27.580   869  1184 D SSense  : noteStartCamera: uid:10068
05-28 18:34:27.733   577  1018 D Camera3-Device: Set real time priority for request queue thread (tid 24073)
05-28 18:34:28.922 20639 24012 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl$CameraHandlerExecutor.execute(CameraDeviceImpl.java:2274)
05-28 18:34:28.922 20639 24012 W MessageQueue: 	at android.hardware.camera2.impl.CameraCaptureSessionImpl.close(CameraCaptureSessionImpl.java:598)
05-28 18:34:28.922 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController.closeCameraLocked(CameraController.kt:327)
05-28 18:34:28.922 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController.shutdown$lambda$25(CameraController.kt:378)
05-28 18:34:28.922 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController.$r8$lambda$zMf_N86CM8PjE7OZEvoIlq9IGgI(Unknown Source:0)
05-28 18:34:28.922 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController$$ExternalSyntheticLambda10.run(D8$$SyntheticClass:0)
05-28 18:34:28.930   577  1018 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:34:28.930   577  1018 E Camera2-Metadata: acquire: Failed to validate metadata structure 0x0
05-28 18:34:28.946   457   839 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:34:28.947   577  1018 I Camera3-Device: disconnectImpl: E
05-28 18:34:28.948   457   839 I Cam3HWI : 464, closeCamera: :hal3: E camId=0
05-28 18:34:28.948   457   839 I Cam3HWI : 465, closeCamera: [PerformanceFlow] close E
05-28 18:34:28.948   457   839 I Cam3OEMIf: 4174, stopPreviewInternal: E mCameraId=0
05-28 18:34:28.948   457   839 I Cam3OEMIf: 1003, closeCamera: :hal3: E camId=0
05-28 18:34:28.950   457   839 I Cam3OEMIf: 1096, closeCamera: :hal3: deinit camera
05-28 18:34:29.053   457   839 I Cam3OEMIf: 1119, closeCamera: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:34:29.053   457   839 I Cam3OEMIf: 944, ~SprdCamera3OEMIf: :hal3: Destructor E camId=0
05-28 18:34:29.053   457   839 I Cam3OEMIf: 968, ~SprdCamera3OEMIf: camera low power mode exit
05-28 18:34:29.053   457   839 I Cam3OEMIf: 3553, freeAllCameraMem: :hal3: E
05-28 18:34:29.053   457   839 I Cam3OEMIf: 3696, freeAllCameraMem: :hal3: X CamId=0 TotalIonSize=0 TotalGpuSize=0, total_size 0
05-28 18:34:29.053   457   839 I Cam3OEMIf: 992, ~SprdCamera3OEMIf: :hal3: X
05-28 18:34:29.053   457   839 I Cam3PowerPerf: 71, ~SprdCameraSystemPerformance: E
05-28 18:34:29.055   457   839 I Cam3PowerPerf: 76, ~SprdCameraSystemPerformance: X
05-28 18:34:29.061   457   839 I Cam3HWI : 545, closeCamera: :hal3: X
05-28 18:34:29.061   457   839 I Cam3HWI : 546, closeCamera: [PerformanceFlow] close X
05-28 18:34:29.061   457   839 I Cam3HWI : 212, ~SprdCamera3HWI: :hal3: Destructor E camId=0
05-28 18:34:29.062   457   839 I Cam3HWI : 3357, close_camera_device: :hal3: camera3->close X mCameraSessionActive 0
05-28 18:34:29.067   577  1018 I Camera3-Device: disconnectImpl: X
05-28 18:34:29.069   869  2616 D SSense  : noteStopCamera: uid:10068
05-28 18:34:29.070   577  1018 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=1
05-28 18:34:29.072   869  2616 I Telecom : CallsManager: onStatusChanged mCameraStatus:1
05-28 18:34:29.079   577  1018 I CameraService: disconnect: Disconnected client for camera 0 for PID 20639
05-28 18:34:29.082 20639 24012 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl$CameraHandlerExecutor.execute(CameraDeviceImpl.java:2274)
05-28 18:34:29.082 20639 24012 W MessageQueue: 	at android.hardware.camera2.impl.CameraDeviceImpl.close(CameraDeviceImpl.java:1368)
05-28 18:34:29.082 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController.closeCameraLocked(CameraController.kt:331)
05-28 18:34:29.082 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController.shutdown$lambda$25(CameraController.kt:378)
05-28 18:34:29.082 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController.$r8$lambda$zMf_N86CM8PjE7OZEvoIlq9IGgI(Unknown Source:0)
05-28 18:34:29.082 20639 24012 W MessageQueue: 	at com.termux.camera.service.CameraController$$ExternalSyntheticLambda10.run(D8$$SyntheticClass:0)
05-28 18:34:34.848 869 1184 D PackageManager: PMS setEnabledSetting: packageName = com.facebook.katana, className = com.facebook.inspiration.platformsharing.activity.InspirationCameraShareMultipleCollageAlias, newState = 2, flags = 1, userId = 0, callingPackage = null, callingUid = 10361, allowedByPermission = false
05-28 18:34:40.334 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:40.353 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:40.383 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:40.467 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:40.777 869 1184 D os.fingerprint: onUpdateFocusedApp oldPackageName:com.termux.camera oldComponent:ComponentInfo{com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity} newPackageName:null newComponent:null mFm :android.hardware.fingerprint.FingerprintManager@1ef922a
05-28 18:34:40.789 519 519 I Layer : name=3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity, id=12386, visible=1, DrawingState.flags=0x102, paused=0, portal=-1, param=NOT_TOUCH_MODAL | LAYOUT_IN_SCREEN | LAYOUT_INSET_DECOR | SPLIT_TOUCH | HARDWARE_ACCELERATED | DRAWS_SYSTEM_BAR_BACKGROUNDS, feature=0x0
05-28 18:34:40.790 869 1184 I WindowManager: Input focus has changed to Window{7de2e18 u0 QSCenter} from 3df67b2 com.termux.camera/com.termux.camera.ui.ScriptConsoleActivity mDisplayId 0 updateInputWindows true
05-28 18:34:47.084 1195 1447 D FlashlightController: mCameraId = 0 , enabled = true
05-28 18:34:47.085 577 10126 I CameraProviderManager: Camera HAL provider needs restart, calling getService(legacy/0)
05-28 18:34:47.097 577 10126 I CameraProviderManager: Camera device device@3.5/legacy/0 torch status is now AVAILABLE_ON
05-28 18:34:47.098 577 10126 I CameraService: onTorchStatusChangedLocked: Torch status changed for cameraId=0, newStatus=2
05-28 18:34:47.127 577 10126 I CameraService: Torch for camera id 0 turned on for client PID 1195
05-28 18:34:48.547 1195 1447 D FlashlightController: mCameraId = 0 , enabled = false
05-28 18:34:48.550 577 10126 I CameraProviderManager: Camera device device@3.5/legacy/0 torch status is now AVAILABLE_OFF
05-28 18:34:48.550 577 10126 I CameraService: onTorc

```

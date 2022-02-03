import UIKit
import Flutter
import MCPSDK
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let appId = "1derful"
    let clientKey = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUNRd0RRWUpLb1pJaHZjTkFRRUJCUUFERXdBd0VBSUpBTFVERytpQk1rb2ZBZ01CQUFFPQotLS0tLUVORCBQVUJMSUMgS0VZLS0tLS0K"
    
    let authToken = "kr00kZsjq3KEKX34r8zNRLNdMRjQqE"
    let cardRefNo = "454000058269";
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      MCPSDKManager.initSDK(appId, apiKey: clientKey)
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.flutter.dev/mcpsdk",
                                                binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler({ [self]
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          print("I'm calling from swift")
          if call.method == "startTask" {
              
              
              self.startTask(authToken: self.authToken, cardRefNo: self.cardRefNo,completion: {
                  result("ConnectionMade");
              })
              
          } else if call.method == "addToWallet" {
              MCPPushProvisioningProvider().getWallet().canAddCard(pushProvCallBack: self, errorCallBack: self, viewController: controller)
          }
      })
      
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func startTask(authToken: String, cardRefNo: String, completion: @escaping(()->())) {
        let viewController = UIApplication.shared.windows.first!.rootViewController!
        var params : [String:String] = [:]
        
        // setting config
        let config = UIConfiguration()
        config.backgroundColor = UIColor.yellow
        config.loadingOption = .loadOnScreen
        MCPSDKManager.setUIConfiguration(config)
        
        // setting params
        
        
        params["authToken"] = authToken
        params["cardRefNo"] = cardRefNo
        MCPSDKManager.startTask("setPin", delegate: self, params: params, parentVC: viewController, viewNavigationStyle: .present, callBack:{ vc in
            print(vc)
            completion()
        })
       
    }
    
    
    
}

extension AppDelegate: MCPSDKCallBack {
    func onLoadingStarted() -> Bool {
        print("onLoadingStarted")
        return true
    }
    
   
    
    func onLoadingCompleted() {
        print("onLoadingCompleted")
    }
    
    func onSuccess(responsePayload: [String : String]) {
        print("onSuccess")
    }
    
    func onError(errorCode: String, errorDesc: String) {
        print("errorCode: \(errorCode), errorDesc:\(errorDesc)")
    }
    
    func onClosed() {
        print("onClosed")
    }
    
   
}

extension AppDelegate : MCPInAppPushProvCallBack {
    func onSupported(wallet: MCPInAppPushProvisioning) {
        wallet.pushCard(cardRef: cardRefNo, signoutToken: authToken, otpDelegate: self)
    }

    func onNotSupported(code: String, desc: String) {
        print(desc)
    }

    func walletStatusOnSuccess(cardRefNo: String, passState: MCPWalletState) {
        print(passState)
    }


}

extension AppDelegate: MCPOTPDelegate {
    func showOTPVerificationUI(maskedEmail: String, maskedPhone: String, codeLength: String, verificationFieldType: MCPOTPVerificationOpt, otpCodeExpiryTime: String, otpCodeCallBack: @escaping (String) -> Void) {
//        self.otpCallBack =
    }

    func invalidOTP() {
        print("Invalid OTP")
    }

    func selectOtpChannel(selectOtpChannelCallback: @escaping (MCPChannelType) -> Void) {
        selectOtpChannelCallback(.sms)
    }

    func enableResendOTPButton(resendOtpChannelCallback: @escaping () -> Void) {
      //  resendOtpChannelCallback()
    }

    func onOtpGenerationFailed(errorCode: String, errorDesc: String) {
        print(errorCode , errorDesc)
    }

    func timeLeftToResendCode(seconds: Int) {
        print(seconds)
    }

    func resendOTPCodeIfRequired() {
        print("Resent OTP Code")
    }

    func disableResendOTPButton() {
        print("Disable Resent OTP Button")
    }
}

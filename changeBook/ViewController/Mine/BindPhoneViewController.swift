//
//  BindPhoneViewController.swift
//  changeBook
//
//  Created by Jvaeyhcd on 05/08/2017.
//  Copyright © 2017 Jvaeyhcd. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import RxSwift
import RxCocoa

class BindPhoneViewController: BaseViewController {
    
    lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = kBarButtonItemTitleFont
        textField.textColor = UIColor(hex: 0x555555)
        textField.keyboardType = .numberPad
        textField.textAlignment = .left
        textField.placeholder = "请输入手机号"
        return textField
    }()
    
    lazy var verificationCodetf: UITextField = {
        let textField = UITextField()
        textField.font = kBarButtonItemTitleFont
        textField.textColor = UIColor(hex: 0x555555)
        textField.keyboardType = .numberPad
        textField.textAlignment = .left
        textField.placeholder = "请输入验证码"
        return textField
    }()
    
    lazy var verificationCodeBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = kBaseFont
        btn.setTitleColor(UIColor.init(hex: 0x79C505), for: UIControlState.normal)
        btn.setTitleColor(kBtnDisableBgColor, for: UIControlState.disabled)
        btn.backgroundColor = kMainBgColor
        btn.contentHorizontalAlignment = .right
        btn.setTitle("获取验证码", for: UIControlState.normal)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var bindBtn: UIButton = {
        let size = CGSize(width: kScreenWidth - scaleFromiPhone6Desgin(x: 60),
                          height: scaleFromiPhone6Desgin(x: 52))
        let btn = UIButton()
        btn.setTitle("确认绑定", for: UIControlState.normal)
        btn.titleLabel?.font = kBarButtonItemTitleFont
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.init(color: kBtnNormalBgColor!, size: size), for: .normal)
        btn.setBackgroundImage(UIImage.init(color: kBtnTouchInBgColor!, size: size), for: .selected)
        btn.setBackgroundImage(UIImage.init(color: kBtnDisableBgColor!, size: size), for: .disabled)
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        return btn
    }()
    
    fileprivate lazy var viewModel = BindPhoneViewModel(provider: UserAPIProvider)
    fileprivate let disposeBag = DisposeBag()
    
    //用NSTimer实现倒计时
    var countdownTimer: Timer?
    
    //开启和关闭倒计时的变量
    var isCounting = false {
        willSet{
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                                      target: self,
                                                      selector: #selector(updateTime(timer:)),
                                                      userInfo: nil,
                                                      repeats: true)
                
                verificationCodeBtn.backgroundColor = kMainBgColor
                verificationCodeBtn.layer.borderColor = kDisableColor?.cgColor
                
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                verificationCodeBtn.layer.borderColor = UIColor.init(hex: 0x79C505)?.cgColor
                verificationCodeBtn.backgroundColor = kMainBgColor
                verificationCodeBtn.setTitle("获取验证码", for: UIControlState.normal)
            }
            
            verificationCodeBtn.isEnabled = !newValue
        }
    }
    
    //当前倒计时剩余的秒数
    var remainingSeconds: Int = 0{
        willSet{
            verificationCodeBtn.setTitle("\(newValue)秒后重试", for: .normal)
            if newValue <= 0{
                verificationCodeBtn.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        initSubviews()
        bindToRx()
    }
    
    private func initSubviews() {
        
        self.title = "绑定账号"
        self.showBackButton()
        
        self.view.backgroundColor = kMainBgColor
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(backgroundViewClicked))
        self.view.addGestureRecognizer(tapGesture)
        
        userNameTextField.addTarget(self, action: #selector(textfieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints{
            make -> Void in
            make.left.equalTo(scaleFromiPhone6Desgin(x: 30))
            make.right.equalTo(-scaleFromiPhone6Desgin(x: 30))
            make.height.equalTo(scaleFromiPhone6Desgin(x: 54))
            make.top.equalTo(scaleFromiPhone6Desgin(x: 24))
        }
        userNameTextField.rx.text.orEmpty.bindTo(viewModel.username).addDisposableTo(disposeBag)
        
        let userNameTextFieldBottomView = UIView()
        userNameTextFieldBottomView.backgroundColor = UIColor.init(hex: 0xdddddd)
        self.view.addSubview(userNameTextFieldBottomView)
        userNameTextFieldBottomView.snp.makeConstraints{
            make -> Void in
            make.left.equalTo(userNameTextField.snp.left)
            make.right.equalTo(userNameTextField.snp.right)
            make.height.equalTo(scaleFromiPhone6Desgin(x: 0.5))
            make.bottom.equalTo(userNameTextField.snp.bottom)
        }
        
        verificationCodetf.addTarget(self, action: #selector(textfieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.view.addSubview(verificationCodetf)
        verificationCodetf.snp.makeConstraints{
            make -> Void in
            make.left.equalTo(scaleFromiPhone6Desgin(x: 30))
            make.width.equalTo(scaleFromiPhone6Desgin(x: 200))
            make.height.equalTo(scaleFromiPhone6Desgin(x: 54))
            make.top.equalTo(userNameTextField.snp.bottom).offset(scaleFromiPhone6Desgin(x: 6))
        }
        verificationCodetf.rx.text.orEmpty.bindTo(viewModel.vcode).addDisposableTo(disposeBag)
        
        let verificationCodetfBottomView = UIView()
        verificationCodetfBottomView.backgroundColor = UIColor.init(hex: 0xDDDDDD)
        self.view.addSubview(verificationCodetfBottomView)
        verificationCodetfBottomView.snp.makeConstraints{
            make -> Void in
            make.left.equalTo(verificationCodetf.snp.left)
            make.right.equalTo(-scaleFromiPhone6Desgin(x: 30))
            make.height.equalTo(scaleFromiPhone6Desgin(x: 0.5))
            make.bottom.equalTo(verificationCodetf.snp.bottom)
        }
        
        
        self.view.addSubview(verificationCodeBtn)
        verificationCodeBtn.snp.makeConstraints{
            make -> Void in
            make.right.equalTo(-scaleFromiPhone6Desgin(x: 30))
            make.centerY.equalTo(verificationCodetf.snp.centerY)
            make.height.equalTo(scaleFromiPhone6Desgin(x: 20))
        }
        self.checkCountTime()
        verificationCodeBtn.rx.tap.bindTo(viewModel.vcodeTaps).addDisposableTo(disposeBag)
        viewModel.getVcodeEnabled
            .drive(onNext: { [weak self] enabled in
                self?.verificationCodeBtn.isEnabled = enabled && !(self?.isCounting)!
                if (self?.verificationCodeBtn.isEnabled)! {
                    self?.verificationCodeBtn.layer.borderColor = UIColor.init(hex: 0x79C505)?.cgColor
                } else {
                    self?.verificationCodeBtn.layer.borderColor = kDisableColor?.cgColor
                }
            })
            .addDisposableTo(disposeBag)
        
        self.view.addSubview(bindBtn)
        bindBtn.snp.makeConstraints{
            make -> Void in
            make.left.equalTo(scaleFromiPhone6Desgin(x: 30))
            make.right.equalTo(-scaleFromiPhone6Desgin(x: 30))
            make.height.equalTo(scaleFromiPhone6Desgin(x: 52))
            make.top.equalTo(verificationCodetf.snp.bottom).offset(scaleFromiPhone6Desgin(x: 26))
        }
        
        bindBtn.rx.tap.bindTo(viewModel.registerTaps).addDisposableTo(disposeBag)
        
        viewModel.registerEnabled
            .drive(onNext: { enabled in
                self.bindBtn.isEnabled = enabled
                if enabled == true {
                    self.bindBtn.setTitle("确认绑定", for: UIControlState.normal)
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
    private func bindToRx() {
        
        viewModel.registerExecuting
            .drive(onNext: { [weak self] executing in
                UIApplication.shared.isNetworkActivityIndicatorVisible = executing
                if executing {
                    self?.showHudLoadingTipStr("")
                } else {
                    self?.hideHud()
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.getVcodeExecuting
            .drive(onNext: { [weak self] executing in
                UIApplication.shared.isNetworkActivityIndicatorVisible = executing
                if executing {
                    self?.showHudLoadingTipStr("")
                } else {
                    self?.hideHud()
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.registerFinished
            .drive(onNext: { [weak self] loginResult in
                
                switch loginResult {
                case .Failed(let message):
                    self?.showHudTipStr(message, in: self?.view)
                case .Scuccess:
                    // 注册成功自动登录
                    break
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.getVcodeFinished
            .drive(onNext: { [weak self] requestResult in
                
                switch requestResult {
                case .Failed(let message):
                    self?.showHudTipStr(message, in: self?.view)
                case .Scuccess:
                    self?.showHudTipStr("验证码发送成功，请注意查收", in: self?.view)
                    // 得到发送验证码成功的时间
                    let date = NSDate().timeIntervalSince1970
                    kUserDefaults.set(date, forKey: "lastSendRegisterCodeDateTime")
                    kUserDefaults.synchronize()
                    // 启动倒计时
                    self!.remainingSeconds = 60
                    self!.isCounting = true
                }
            })
            .addDisposableTo(disposeBag)
    }

    func updateTime(timer:Timer) -> Void {
        //计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    // 检测倒计时
    private func checkCountTime() {
        // 判断是否在倒计时
        let lastSendRegisterCodeDateTime = Int64(kUserDefaults.double(forKey: "lastSendRegisterCodeDateTime"))
        let nowTime = Int64(NSDate().timeIntervalSince1970)
        
        if nowTime - lastSendRegisterCodeDateTime > Int64(60) {
            isCounting = false
        } else {
            remainingSeconds = Int(Int64(60) - (nowTime - lastSendRegisterCodeDateTime))
            isCounting = true
        }
    }
    
    //view点击事件
    @objc private func backgroundViewClicked() {
        self.userNameTextField.resignFirstResponder()
        self.verificationCodetf.resignFirstResponder()
    }
    
    func textfieldDidChange(textField: UITextField) {
        var maxLength = 0
        switch textField {
        case userNameTextField:
            maxLength = 11
        case verificationCodetf:
            maxLength = 6
        default:
            maxLength = 0
        }
        let text = textField.text
        if text!.characters.count > maxLength {
            textField.text = text?.subStrToIndex(index: maxLength)
        }
    }
    
    override func leftNavBarButtonClicked() {
        self.popViewController(animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

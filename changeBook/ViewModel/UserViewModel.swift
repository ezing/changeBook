//
//  UserViewModel.swift
//  changeBook
//
//  Created by Jvaeyhcd on 06/07/2017.
//  Copyright © 2017 Jvaeyhcd. All rights reserved.
//

import Foundation


class UserViewModel: ViewModelProtocol {


    // 用户退出登录
    func logoutAccount(success: @escaping DataBlock,
                       fail: @escaping MessageBlock) {
        UserAPIProvider.request(UserAPI.logout()) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: {
                
            })
        }
    }
    
    // 获取个人信息
    func getUserInfo(userId: String,
                     success: @escaping DataBlock,
                     fail: @escaping MessageBlock,
                     loginSuccess: @escaping VoidBlock) {
        
        UserAPIProvider.request(UserAPI.getUserInfo(userId: userId)) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 修改个人信息
    func changeUserInfo(headPic:String,
                        nickName:String,
                        sex:String,
                        introduce:String,
                        success: @escaping DataBlock,
                        fail: @escaping MessageBlock,
                        loginSuccess: @escaping VoidBlock)  {
        
        UserAPIProvider.request(UserAPI.changeUserInfo(headPic: headPic, nickName: nickName, sex: sex, introduce: introduce)) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 获取积分记录
    func getUserIntegralLog(page: Int,
                            cache: @escaping DataBlock,
                            success: @escaping DataBlock,
                            fail: @escaping MessageBlock,
                            loginSuccess: @escaping VoidBlock) {
        var cacheName = ""
        if page == 1 {
            cacheName = "getInviteLog\(sharedGlobal.getSavedUser().userId)"
            self.getCacheData(cacheName: cacheName, cacheData: cache)
        } else {
            cacheName = kNoNeedCache
        }
        UserAPIProvider.request(UserAPI.getUserIntegralLog()) { (result) in
            self.request(cacheName: cacheName, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 获取学校列表
    func getSchoolList(cache: @escaping DataBlock,
                       success: @escaping DataBlock,
                       fail: @escaping MessageBlock,
                       loginSuccess: @escaping VoidBlock) {
        
        let cacheName = "getSchoolList"
        
        self.getCacheData(cacheName: cacheName, cacheData: cache)
        UserAPIProvider.request(UserAPI.getSchoolList()) { (result) in
            self.request(cacheName: cacheName, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 绑定学校
    func bindSchool(schoolId: String,
                    success: @escaping DataBlock,
                    fail: @escaping MessageBlock,
                    loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.bindSchool(schoolId: schoolId)) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 设置默认收货地址
    func setDefaultAddress(addressId: String,
                           success: @escaping DataBlock,
                           fail: @escaping MessageBlock,
                           loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.setDefaultAddress(addressId: addressId)) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 获取用户收货地址
    func getUserAddressList(cache: @escaping DataBlock,
                            success: @escaping DataBlock,
                            fail: @escaping MessageBlock,
                            loginSuccess: @escaping VoidBlock) {
        let cacheName = "getUserAddressList"
        
        self.getCacheData(cacheName: cacheName, cacheData: cache)
        UserAPIProvider.request(UserAPI.getUserAddressList()) { (result) in
            self.request(cacheName: cacheName, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 添加收货地址
    func addAddress(userName: String,
                    phone: String,
                    addressDetail: String,
                    isDefault: Int,
                    success: @escaping DataBlock,
                    fail: @escaping MessageBlock,
                    loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.addAddress(userName: userName, phone: phone, addressDetail: addressDetail, isDefault: isDefault)) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 编辑收货地址
    func editAddress(addressId: String,
                     userName: String,
                     phone: String,
                     addressDetail: String,
                     success: @escaping DataBlock,
                     fail: @escaping MessageBlock,
                     loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.editAddress(addressId: addressId, userName: userName, phone: phone, addressDetail: addressDetail)) { (result) in
            self.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 删除收货地址
    func deleteAddress(addressId: String,
                       success: @escaping DataBlock,
                       fail: @escaping MessageBlock,
                       loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.deleteAddress(addressId: addressId)) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 用户的借阅
    func userBorrowBook(userId: String,
                        page: Int,
                        cache: @escaping DataBlock,
                        success: @escaping DataBlock,
                        fail: @escaping MessageBlock,
                        loginSuccess: @escaping VoidBlock) {
        
        var cacheName = kNoNeedCache
        if 1 == page {
            cacheName = "userBorrowBook:" + userId
            self.getCacheData(cacheName: cacheName, cacheData: cache)
        }
        
        UserAPIProvider.request(UserAPI.userBorrowBook(userId: userId, page: page)) { [weak self] (result) in
            self?.request(cacheName: cacheName, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
        
    }
    
    // 用户的评论
    func getUserComment(userId: String,
                        page: Int,
                        cache: @escaping DataBlock,
                        success: @escaping DataBlock,
                        fail: @escaping MessageBlock,
                        loginSuccess: @escaping VoidBlock) {
        var cacheName = kNoNeedCache
        if 1 == page {
            cacheName = "getUserComment:" + userId
            self.getCacheData(cacheName: cacheName, cacheData: cache)
        }
        UserAPIProvider.request(UserAPI.getUserComment(userId: userId, page: page)) { [weak self] (result) in
            self?.request(cacheName: cacheName, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // QQ登录
    func qqLogin(openId: String,
                 nickName: String,
                 headPic: String,
                 success: @escaping DataBlock,
                 fail: @escaping MessageBlock,
                 loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.qqLogin(openId: openId, nickName: nickName, headPic: headPic)) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 隐私设置
    func privacySettings(viewComment: Int,
                         viewBorrow: Int,
                         success: @escaping DataBlock,
                         fail: @escaping MessageBlock,
                         loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.privacySettings(viewComment: viewComment, viewBorrow: viewBorrow)) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 申请学生认证
    func addUserCertification(userName: String,
                              studentNo: String,
                              pic: String,
                              success: @escaping DataBlock,
                              fail: @escaping MessageBlock,
                              loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.addUserCertification(userName: userName, studentNo: studentNo, pic: pic)) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 举报用户
    func userReport(beUserId: String,
                    reason: String,
                    success: @escaping DataBlock,
                    fail: @escaping MessageBlock,
                    loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.userReport(beUserId: beUserId)) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 拉黑用户
    func userBlackHouse(beUserId: String,
                        success: @escaping DataBlock,
                        fail: @escaping MessageBlock,
                        loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.userBlackHouse(beUserId: beUserId)) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
    // 押金明细
    func userAccountLog(success: @escaping DataBlock,
                        fail: @escaping MessageBlock,
                        loginSuccess: @escaping VoidBlock) {
        UserAPIProvider.request(UserAPI.userAccountLog()) { [weak self] (result) in
            self?.request(cacheName: kNoNeedCache, result: result, success: success, fail: fail, loginSuccess: loginSuccess)
        }
    }
    
}

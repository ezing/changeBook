//
//  DocumentAPI.swift
//  changeBook
//
//  Created by Jvaeyhcd on 11/07/2017.
//  Copyright © 2017 Jvaeyhcd. All rights reserved.
//

import Foundation
import Moya

let documentRequestClosure = { (endpoint: Endpoint<DocumentAPI>, done: @escaping MoyaProvider<DocumentAPI>.RequestResultClosure) in
    
    guard var request = endpoint.urlRequest else { return }
    
    request.timeoutInterval = TimeInterval(TIMEOUTTIME)    //设置请求超时时间
    done(.success(request))
}

let DocumentProvider = MoyaProvider<DocumentAPI>(requestClosure: documentRequestClosure)

public enum DocumentAPI {
    // 获取热门资料
    case getHotDocument()
    
    // 搜索资料
    case searchDocument(keyWords: String, page: Int)
    
    // 推荐资料
    case recommendDocument(documentId: String)
    
    // 积分购买资料
    case buyDocument(documentId: String)
    
    // 资料评论点赞
    case likeComment(commentId: String, likeType: Int)
    
    // 获取评论详情
    case getCommentDetail(documentCommentId: String, page: Int)
    
    // 获取资料评论
    case getDocumentComment(documentId: String, page: Int)
    
    // 评论资料
    case addDocumentComment(documentId: String, content: String, commentType: String, score: String, documentCommentId: String, receiverId: String)
    
    // 获取资料详情
    case getDocumentDetail(documentId: String)
    
    // 筛选资料
    case filterDocument(type: Int, rule: Int, page: Int)
}

extension DocumentAPI: TargetType {
    
    public var baseURL: URL {
        return URL(string: kBaseUrl)!
    }
    
    public var path: String {
        switch self {
        case .getHotDocument:
            return "/document/getHotDocument"
        case .searchDocument(keyWords: _, page: _):
            return "/document/searchDocument"
        case .recommendDocument(documentId: _):
            return "/document/recommendDocument"
        case .buyDocument(documentId: _):
            return "/document/buyDocument"
        case .likeComment(commentId: _, likeType: _):
            return "/document/likeComment"
        case .getCommentDetail(documentCommentId: _, page: _):
            return "/document/getCommentDetail"
        case .getDocumentComment(documentId: _, page: _):
            return "/document/getDocumentComment"
        case .addDocumentComment(documentId: _, content: _, commentType: _, score: _, documentCommentId: _, receiverId: _):
            return "/document/addDocumentComment"
        case .getDocumentDetail(documentId: _):
            return "/document/getDocumentDetail"
        case .filterDocument(type: _, rule: _, page: _):
            return "/document/filterDocument"
        }
    }
    
    public var method: Moya.Method {
        return Moya.Method.post
    }
    
    public var parameters: [String : Any]? {
        
        var userId = "0"
        var token = ""
        if Token().tokenExists {
            token = Token().token!
            userId = sharedGlobal.getSavedUser().userId
        }
        
        switch self {
        case .getHotDocument():
            return [
                "token": token,
                "userId": userId
            ]
        case .searchDocument(let keyWords, let page):
            return [
                "keyWords": keyWords,
                "page": page
            ]
        case .recommendDocument(let documentId):
            return [
                "token": token,
                "userId": userId,
                "documentId": documentId
            ]
        case .buyDocument(let documentId):
            return [
                "token": token,
                "userId": userId,
                "documentId": documentId
            ]
        case .likeComment(let commentId, let likeType):
            return [
                "token": token,
                "userId": userId,
                "commentId": commentId,
                "likeType": likeType
            ]
        case .getCommentDetail(let documentCommentId, let page):
            return [
                "token": token,
                "userId": userId,
                "documentCommentId": documentCommentId,
                "page": page
            ]
        case .getDocumentComment(let documentId, let page):
            return [
                "token": token,
                "userId": userId,
                "documentId": documentId,
                "page": page
            ]
        case .addDocumentComment(let documentId, let content, let commentType, let score, let documentCommentId, let receiverId):
            return [
                "token": token,
                "userId": userId,
                "documentId": documentId,
                "content": content,
                "commentType": commentType,
                "score": score,
                "documentCommentId": documentCommentId,
                "receiverId": receiverId
            ]
        case .getDocumentDetail(let documentId):
            return [
                "token": token,
                "userId": userId,
                "documentId": documentId
            ]
        case .filterDocument(let type, let rule, let page):
            return [
                "type": type,
                "rule": rule,
                "page": page
            ]
        }
    }
    
    public var task: Task {
        return .request
    }
    
    public var validate: Bool {
        return false
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var sampleData: Data {
        return "no thing".data(using: .utf8)!
    }
}

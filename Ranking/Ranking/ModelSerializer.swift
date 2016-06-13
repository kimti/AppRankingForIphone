//
//  ModelSerializer.swift
//  swiftkit
//
//  Created by HJC on 15/8/14.
//  Copyright © 2015年 DumbDuck. All rights reserved.
//

import Foundation

public protocol ModelRawInt {
    var rawValue: Int { get }
}

public class ModelObject: NSObject {
    
    public required override init() {
        super.init()
    }
    
    public func loadFromDictinary(dict: NSDictionary) {
        ModelSerializer.decodeObject(self, dict)
    }
    
    public func loadFromArray(array: NSArray) {
    }
    
    public override func setValue(value: AnyObject?, forUndefinedKey key: String)
    {
        // do nothing
    }
}

public extension ModelObject {
    @warn_unused_result
    final func loadFromJsonString(json: String) -> Bool
    {
        guard let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding) else { return false }
        return loadFromJsonData(jsonData)
    }
    
    @warn_unused_result
    final func loadFromJsonData(json: NSData) -> Bool
    {
        do
        {
            let obj = try NSJSONSerialization.JSONObjectWithData(json, options: [])
            if let dict = obj as? NSDictionary
            {
                self.loadFromDictinary(dict)
            }
            else if let array = obj as? NSArray
            {
                self.loadFromArray(array)
            }
            else
            {
                return false
            }
            return true
        }
        catch
        {
            return false
        }
    }
}


public class ModelSerializer {
    
    public static func encodeObject(obj: NSObject, _ dict: NSMutableDictionary) {
        
        walkPropertyList(obj) { label, any in
            
            if let value = objectFromAny(any)
            {
                dict[label] = value
            }
        }
    }
    
    public static func decodeObject(obj: ModelObject, _ dict: NSDictionary?) {
        
        guard let dict = dict else { return }
        walkPropertyList(obj) { label, any in
            
            if let value = dict[label] as? NSObject
            {
                if value.isKindOfClass(NSString) || value.isKindOfClass(NSNumber)
                {
                    obj.setValue(value, forKey: label)
                }
            }
        }
    }
}

public extension ModelSerializer
{
    static func encodeObject(obj: NSObject) -> NSDictionary {
        let dict = NSMutableDictionary()
        encodeObject(obj, dict)
        return dict;
    }
    
    static func decodeObjectList<T:ModelObject>(inout objs: [T], _ array: NSArray?) {
        guard let array = array else { return }
        for info in array {
            if let dict = info as? NSDictionary {
                let obj = T()
                obj.loadFromDictinary(dict)
                objs.append(obj)
            }
        }
    }
    
    static func decodeEnum<T:RawRepresentable>(inout value: T, _ number: NSNumber?) {
        guard let number = number else  { return }
        
        let rawValue = number.integerValue
        if let tmp = T(rawValue: rawValue as! T.RawValue)
        {
            value = tmp
        }
    }
}

public extension ModelSerializer
{
    static func toSet<T>(objs: [T], fun: T -> NSObject) -> NSSet {
        let set = NSMutableSet()
        for id in objs {
            set.addObject(fun(id))
        }
        return set
    }
    
    static func toArray<T>(objs: [T], fun: T -> NSObject) -> NSArray {
        let set = NSMutableArray()
        for id in objs {
            set.addObject(fun(id))
        }
        return set
    }
}

////////////////////////////////////
private func walkPropertyList(obj: Any, walkfun: (String, Any) -> Void)
{
    let mirror = Mirror(reflecting: obj)
    for k in mirror.children
    {
        if let label = k.label
        {
            walkfun(label, k.value)
        }
    }
}

private func numberFromAny(any: Any) -> NSNumber?
{
    switch any
    {
    case let val as NSNumber:
        return val
        
    case let val as Int64:
        return NSNumber(longLong: val)
        
    case let val as UInt64:
        return NSNumber(unsignedLongLong: val)
        
    case let val as Int32:
        return NSNumber(int: val)
        
    case let val as UInt32:
        return NSNumber(unsignedInt: val)
        
    case let val as Int16:
        return NSNumber(short: val)
        
    case let val as UInt16:
        return NSNumber(unsignedShort: val)
        
    case let val as Int8:
        return NSNumber(char: val)
        
    case let val as UInt8:
        return NSNumber(unsignedChar: val)
        
    case let val as Double:
        return NSNumber(double: val)
        
    case let val as Float:
        return NSNumber(float: val)
        
    case let val as Int:
        return NSNumber(integer: val)
        
    default:
        break
    }
    return nil
}

private func objectFromAny(any: Any) -> AnyObject?
{
    let mirror = Mirror(reflecting: any)
    if let style = mirror.displayStyle
    {
        switch style
        {
        case .Dictionary, .Collection:
            return nil
            
        case .Optional:
            guard let (_, some) = mirror.children.first else { return nil }
            return objectFromAny(some)
            
        case .Enum:
            guard let value = any as? ModelRawInt else { return nil  }
            return NSNumber(integer: value.rawValue)
            
        default:
            break
        }
    }
    if let str = any as? String
    {
        return str
    }
    return numberFromAny(any)
}



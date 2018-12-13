//
//  DTFileController.swift
//
// Copyright © 2016 Darktt Personal Company. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

public struct DTFileController
{
    // MARK: - Properties -
    
    /// Return the singleton object.
    @nonobjc
    public static let main: DTFileController = DTFileController()
    
    // MARK: Private propery
    fileprivate let fileManager: FileManager = FileManager.default
    
    // MARK: - Methods -
    // MARK: - Check file is exist -
    
    /**
     Check file is exist from file path.
     
     - Parameter path: The file path string.
     
     - Returns: If file is exist, return YES, NO if not exist.
     */
    public func fileExist(atPath path: String) -> Bool
    {
        return self.fileManager.fileExists(atPath: path)
    }
    
    /**
     Check file is exist from file path url.
     
     - Parameter url: The file path of NSURL type.
     
     - Returns: If file is exist, return YES, NO otherwise.
     */
    public func fileExist(atUrl url: URL) -> Bool
    {
        guard url.isFileURL else {
            
            return false
        }
        
        return self.fileManager.fileExists(atPath: url.path)
    }
    
    // MARK: - Check Remain Space -
    
    /**
     Get the free space of current device.
     
     - Returns: The number of space value.
     
     - Throws: Error type object when get free space failed.
     */
    public func getFreeSpace() throws -> UInt64
    {
        let path: String = self.documentPath()
        
        return try self.getFreeSpace(atPath: path)
    }
    
    /**
     Check the space is enough to operation from given path.
     
     - Parameter path: The path of file.
     
     - Returns: YES, is enough to operation, NO is otherwise.
     
     - Throws: Error type object when get free space failed.
     */
    public func checkSpaceEnough(withFilePath path: String) throws -> Bool
    {
        let freeSpace: UInt64 = try self.getFreeSpace()
        let fileSize: UInt64 = try getFileSize(atPath: path)
        
        return freeSpace > fileSize
    }
    
    /**
     Check the space is enough to operation from given size.
     
     - Parameter size: The size of file.
     
     - Returns: YES, is enough to operation, NO is otherwise.
     
     - Throws: Error type object when get free space failed.
     */
    public func checkSpaceEnough(forFileSize size: UInt64) throws -> Bool
    {
        let freeSpace: UInt64 = try self.getFreeSpace()
        
        return freeSpace > size
    }
    
    // MARK: - Get path -
    
    /**
     Get the application directory path with given file name.
     
     Like **\/var/mobile/Applications/30E6D646-48FC-4AFF-B1A9-830DB765FA41/AppName.app/fileName**.
     
     - Parameter fileName: The file name to combine path.<br/>
     **Default** is empty string, for don't need attach file name.
     - Parameter fileExtension: File's extension name.
     
     - Returns: The path of application directory with file name.
     */
    public func currentApplicationPath(withFileName fileName: String = "", ofType fileExtension: String? = nil) -> String?
    {
        let bundle = Bundle.main
        
        if fileName == "" {
            
            return bundle.bundlePath
        }
        
        let path: String? = bundle.path(forResource: fileName, ofType: fileExtension)
        
        return path
    }
    
    /**
     Get the application directory path with given file name.
     
     Like **file://var/mobile/Applications/30E6D646-48FC-4AFF-B1A9-830DB765FA41/AppName.app/fileName**.
     
     - Parameter fileName: The file name to combine path.<br/>
     **Default** is empty string, for don't need attach file name.
     - Parameter fileExtension: File's extension name.
     
     - Returns: The file URL for the application directory with file name.
    */
    public func currentApplicationURL(withFileName fileName: String = "", ofType fileExtension: String? = nil) -> URL?
    {
        let bundle = Bundle.main
        
        if fileName == "" {
            
            return bundle.bundleURL
        }
        
        let url: URL? = bundle.url(forResource: fileName, withExtension: fileExtension)
        
        return url
    }
    
    /**
     Get the document directory path under the application directory.
     
     - Parameter fileName: The file name to attach path.<br/>
     **Default** is empty string, for don't need attach file name.
     
     - Returns: The path of document directory.
     */
    public func documentPath(withFileName fileName: String = "") -> String
    {
        let paths: Array<String> = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path: String = paths.first!
        
        return path + "/" + fileName
    }
    
    /**
     Get the document directory path under the application directory.
     
     - Parameter fileName: The file name to attach path.<br/>
     **Default** is empty string, for don't need attach file name.
     
     - Returns: The file URL of document directory.
     */
    public func documentUrl(withFileName fileName: String = "") -> URL
    {
        let path: String = self.documentPath(withFileName: fileName)
        let isDirectory: Bool = (fileName == "")
        let fileUrl = URL(fileURLWithPath: path, isDirectory: isDirectory)
        
        return fileUrl
    }
    
    /**
     Get the caches directory path under the application directory.
     
     - Parameter fileName: The file name to attach path.
     **Default** is empty string, for don't need attach file name.
     
     - Returns: The path of caches directory.
     */
    public func cachesPath(withFileName fileName: String = "") -> String
    {
        let paths: Array<String> = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let path: String = paths.first!
        
        return path + "/" + fileName
    }
    
    /**
     Get the caches directory path under the application directory.
     
     - Parameter fileName: The file name to attach path.
     **Default** is empty string, for don't need attach file name.
     
     - Returns: The file URL of caches directory.
     */
    public func cachesUrl(withFileName fileName: String = "") -> URL
    {
        let path: String = self.cachesPath(withFileName: fileName)
        let isDirectory: Bool = (fileName == "")
        let fileUrl = URL(fileURLWithPath: path, isDirectory: isDirectory)
        
        return fileUrl
    }
    
    /**
     Get the share directory path for app groups share.
     
     - Parameter fileName: The file name to attach path.
     **Default** is empty string, for don't need attach file name.
     
     - Parameter groupIdentifier: The identifier for app groups.
     
     - Returns: The path of share directory.
     */
    public func sharePath(withFileName fileName: String = "", groupIdentifier: String) -> String?
    {
        guard let pathURL: URL = self.fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
            
            return nil
        }
        
        return pathURL.path + "/" + fileName
    }
    
    /**
     Get the share directory path for app groups share.
     
     - Parameter fileName: The file name to attach path.
     **Default** is empty string, for don't need attach file name.
     
     - Parameter groupIdentifier: The identifier for app groups.
     
     - Returns: The file URL of share directory.
     */
    public func shareUrl(withFileName fileName: String = "", groupIdentifier: String) -> URL?
    {
        guard let pathURL: URL = self.fileManager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else {
            
            return nil
        }
        
        let fileUrl: URL = pathURL.appendingPathComponent(fileName)
        
        return fileUrl
    }
    
    // MARK: - Create File Or Directory -
    
    /**
     Create the directory at given path.
     
     - Parameter path: The path to create directory.
     - Parameter createIntermediates: Also create intermedia directories.
     
     - Throws: Error type object when create failed
     */
    public func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool = false) throws
    {
        try self.fileManager.createDirectory(atPath: path, withIntermediateDirectories: createIntermediates, attributes: nil)
    }
    
    /**
     Create the directory at given file URL.
     
     - Parameter path: The path to create directory.
     - Parameter createIntermediates: Also create intermedia directories.
     
     - Throws: Error type object when create failed
     */
    public func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool = false) throws
    {
        try self.fileManager.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: nil)
    }
    
    /**
     Create the empty file at given path.
     
     - Parameter path: The path to create empty file.
     - Parameter contents: File content will create.
     
     - Returns: YES is file create succeed. NO is otherwise.
     */
    public func createFile(atPath path: String, contents: Data? = nil) -> Bool
    {
        return self.fileManager.createFile(atPath: path, contents: contents, attributes: nil)
    }
    
    /**
     Create the empty file at given file URL.
     
     - Parameter path: The path to create empty file.
     - Parameter contents: File content will create.
     
     - Returns: YES is file create succeed. NO is otherwise.
     */
    public func createFile(at url: URL, contents: Data? = nil) -> Bool
    {
        return self.createFile(atPath: url.path, contents:contents)
    }
    
    // MARK: - File Attribute Setting -
    
    /**
     Get directory or file is avoid backup from given path.
     
     - Parameter path: A path to check is excluded backup.
     
     - Throws: error of Error object.
     
     - Returns: Boolean value of is excluded or not.
     */
    public func isExcludedFromBackup(atPath path: String) throws -> Bool
    {
        let url = NSURL(fileURLWithPath: path)
        
        return try self.isExcludedFromBackup(atUrl: url)
    }
    
    /**
     Get directory or file is avoid backup from given filr URL.
     
     - Parameter path: A file path url to check is excluded backup.
     
     - Throws: error of Error object.
     
     - Returns: Boolean value of is excluded or not.
     */
    public func isExcludedFromBackup(atUrl url: NSURL) throws -> Bool
    {
        let resourceKey: URLResourceKey = .isExcludedFromBackupKey
        let resources: [URLResourceKey: Any] = try url.resourceValues(forKeys: [resourceKey])
        
        if let isExcludeBackup: Bool = resources[resourceKey] as? Bool {
            
            return isExcludeBackup
        }
        
        return false
    }
    
    // MARK: - Change File Attribute -
    
    /**
     Set directory or file path to avoid backup.
     
     - Parameter exclued: A boolean value to set this directory want exclude backup or not.
     - Parameter path: A path to add exclude.
     
     - Throws: error of Error object.
     */
    public func setExcludeBackupAttribute(_ exclued: Bool = true, atPath path: String) throws
    {
        let url = NSURL(fileURLWithPath: path)
        
        try self.setExcludeBackupAttribute(atUrl: url)
    }
    
    /**
     Set directory or file path of NSURL object to avoid backup.
     
     - Parameter exclued: A boolean value to set this directory want exclude backup or not.
     - Parameter url: A file path url to add exclude.
     
     - Throws: error of Error object.
     */
    public func setExcludeBackupAttribute(_ exclued: Bool = true, atUrl url: NSURL) throws
    {
        try url.setResourceValue(exclued, forKey: URLResourceKey.isExcludedFromBackupKey)
    }
    
    // MARK: - Get File List -
    
    /**
     Performs a shallow search of the specified directory and returns the paths of any contained items.
     
     - Parameter path: The path to the directory whose contents you want to enumerate.
     
     - Throws: If an error occurs, thorws error object containing the error information.
     
     - Returns: An array of String, each of which identifies a file, directory, or symbolic link contained in path. Returns an empty array if the directory exists but has no contents. If an error occurs, this method returns nil and assigns an appropriate error object to the error parameter
     */
    public func contentsOfDirectory(atPath path: String) throws -> Array<String>
    {
        let contents: Array<String> = try self.fileManager.contentsOfDirectory(atPath: path)
        
        return contents
    }
    
    // MARK: - Remove File -
    
    /**
     Removes the file or directory at the specified path.
     
     - Parameter path: The file path will be remove.
     
     - Throws: Error type object when remove failed.
     */
    public func removeFile(atPath path: String) throws
    {
        try self.fileManager.removeItem(atPath: path)
    }
    
    /**
     Removes the file or directory at the specified URL.
     
     - Parameter path: The file URL will be remove.
     
     - Throws: Error type object when remove failed.
     */
    public func removeFile(at url: URL) throws
    {
        try self.fileManager.removeItem(at: url)
    }
    
    // MARK: - Copy File -
    
    /**
     Copy file to destination path, Without the process progress.
     
     - Parameter path:   The source file path to copy.
     - Parameter toPath: The destination path will be copy.
     
     - Throws: Error type object when copy failed.
     */
    public func copyFile(atPath path: String, toPath: String) throws
    {
        try self.fileManager.copyItem(atPath: path, toPath: toPath)
    }
    
    /**
     Copy file to destination path, Without the process progress.
     
     - Parameter srcUrl:   The source file URL to copy.
     - Parameter destUrl: The destination file URL will be copy.
     
     - Throws: Error type object when copy failed.
     */
    public func copyFile(at srcUrl: URL, to destUrl: URL) throws
    {
        try self.fileManager.copyItem(at: srcUrl, to: destUrl)
    }
    
    // MARK: - Move File -
    
    /**
     Move file to destination path, Without the process progress.
     
     - Parameter path:   The source file path to move.
     - Parameter toPath: The destination path will be move.
     
     - Throws: Error type object when move failed.
     */
    public func moveFile(atPath path: String, toPath: String) throws
    {
        try self.fileManager.moveItem(atPath: path, toPath: toPath)
    }
    
    /**
     Move file to destination path, Without the process progress.
     
     - Parameter srcUrl:   The source file URL path to move.
     - Parameter destUrl: The destination file URL will be move.
     
     - Throws: Error type object when move failed.
     */
    public func moveFile(at srcUrl: URL, to destUrl: URL) throws
    {
        try self.fileManager.moveItem(at: srcUrl, to: destUrl)
    }
    
    // MARK: - Get File Information -
    
    /**
     Get the file information for given path.
     
     - Parameter path: The file path to get information.
     
     - Returns: The information dictionary.
     
     - Throws: Error type object when read attributes failed.
     */
    public func attributesOfFileSystem(atPath path: String) throws -> Dictionary<FileAttributeKey, Any>
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.fileManager.attributesOfFileSystem(forPath: path)
        
        return attributes
    }
    
    // MARK: File Size
    
    /**
     Get the file size for given path.
     
     - Parameter path: The file path to get information.
     
     - Returns: The file size.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: getFileSize(atPath:, converSizeUnit:)
     */
    public func getFileSize(atPath path: String) throws -> UInt64
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.attributesOfItem(atPath: path)
        
        return attributes.fileSize
    }
    
    /**
     Get the file size for given path.
     
     - Parameters:
     - path: The file path to get information.
     - convered: The boolean value to conver the size unit or not.
     
     - Returns: The file size.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: getFileSize(atPath:)
     */
    public func getFileSize(atPath path: String, convertSizeUnit converted: Bool = false) throws -> String
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.attributesOfFileSystem(atPath: path)
        
        let fileSize: NSNumber = attributes[FileAttributeKey.size] as! NSNumber
        
        var size: String = fileSize.stringValue
        
        if converted {
            
            size = String.convertFileSize(fileSize.int64Value)
        }
        
        return size
    }
    
    // MARK: File Creation Date
    
    /**
     Get the file creation for given path.
     
     - Parameter path: The file path to get file creation date.
     
     - Returns: The raw format creation date.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: getFileCreationDate(atPath:, dateFormat:)
     */
    public func getFileCreationDate(atPath path: String) throws -> Date?
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.attributesOfItem(atPath: path)
        
        return attributes.fileCreationDate
    }
    
    /**
     Get the file creation for given path.
     
     - Parameters:
     - path: The file path to get file creation date.
     - dateFormat: The date format to convert textual representations of dates and times into NSDate objects.
     
     - Returns: The converted creation date.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: getFileCreationDate(atPath:)
     */
    public func getFileCreationDate(atPath path: String, dateFormat: String = "YYYY/MM/dd HH:mm:ss aa") throws -> String?
    {
        guard let creationDate: Date = try self.getFileCreationDate(atPath: path) else {
            
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: creationDate)
    }
    
    // MARK: File Modification Date
    
    /**
     Get the file modification for given path.
     
     - Parameter path: The file path to get file modification date.
     
     - Returns: The raw format modification date.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: getFileModificationDate(atPath:, dateFormat:)
     */
    public func getFileModificationDate(atPath path: String) throws -> Date?
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.attributesOfItem(atPath: path)
        
        return attributes.fileModificationDate
    }
    
    /**
     Get the file modification for given path.
     
     - Parameters:
     - path: The file path to get file modification date.
     - dateFormat: The date format to convert textual representations of dates and times into NSDate objects.
     
     - Returns: The converted modification date.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: getFileModificationDate(atPath:)
     */
    public func getFileModificationDate(atPath path: String, dateFormat: String = "YYYY/MM/dd HH:mm:ss aa") throws -> String?
    {
        guard let modificationDate: Date = try self.getFileModificationDate(atPath: path) else {
            
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: modificationDate)
    }
    
    // MARK: Check path is directory
    
    /**
     Check the path of file is directory
     
     - Parameter path: path The file path to check type.
     
     - Returns: YES, When the type is directory.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: isDirectory(withUrl:)
     */
    public func isDirectory(atPath path: String) throws -> Bool
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.attributesOfItem(atPath: path)
        
        if let fileType: String = attributes.fileType {
            
            return fileType == FileAttributeType.typeDirectory.rawValue
        }
        
        return false
    }
    
    /**
     Check the path of file is directory
     
     - Parameter url: path The file path to check type.
     
     - Returns: YES, When the type is directory.
     
     - Throws: Error type object when get information failed.
     
     - SeeAlso: isDirectory(atPath:)
     */
    public func isDirectory(withUrl url: NSURL) throws -> Bool
    {
        guard url.isFileURL else {
            return false
        }
        
        return try self.isDirectory(atPath: url.path!)
    }
}

fileprivate extension DTFileController
{
    fileprivate func getFreeSpace(atPath path: String, converSizeUnit convered: Bool = false) throws -> String
    {
        let fileSystemInfomation: Dictionary<FileAttributeKey, Any> = try self.fileManager.attributesOfFileSystem(forPath: path)
        
        let remainSpace: NSNumber = fileSystemInfomation[FileAttributeKey.systemFreeSize] as! NSNumber
        
        var size: String = remainSpace.stringValue
        
        if convered {
            
            size = String.convertFileSize(remainSpace.int64Value)
        }
        
        return size
    }
    
    fileprivate func getFreeSpace(atPath path: String) throws -> UInt64
    {
        let fileSystemInfomation: Dictionary<FileAttributeKey, Any> = try self.fileManager.attributesOfFileSystem(forPath: path)
        
        let remainSpace: NSNumber = fileSystemInfomation[FileAttributeKey.systemFreeSize] as! NSNumber
        
        return remainSpace.uint64Value
    }
    
    fileprivate func attributesOfItem(atPath path: String) throws -> Dictionary<FileAttributeKey, Any>
    {
        let attributes: Dictionary<FileAttributeKey, Any> = try self.fileManager.attributesOfItem(atPath: path)
        
        return attributes
    }
}

fileprivate extension String
{
    fileprivate static func convertFileSize(_ size: Int64) -> String
    {
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .binary)
    }
}

public extension Dictionary where Value: Any
{
    fileprivate var dictionary: NSDictionary {
        
        return self as NSDictionary
    }
    
    public var fileSize: UInt64 {
        
        return self.dictionary.fileSize()
    }
    
    public var fileModificationDate: Date? {
        
        return self.dictionary.fileModificationDate()
    }
    
    public var fileType: String? {
        
        return self.dictionary.fileType()
    }
    
    public var filePosixPermissions: Int {
        
        return self.dictionary.filePosixPermissions()
    }
    
    public var fileOwnerAccountName: String? {
        
        return self.dictionary.fileOwnerAccountName()
    }
    
    public var fileGroupOwnerAccountName: String? {
        
        return self.dictionary.fileGroupOwnerAccountName()
    }
    
    public var fileSystemNumber: Int {
        
        return self.dictionary.fileSystemNumber()
    }
    
    public var fileSystemFileNumber: Int {
        
        return self.dictionary.fileSystemFileNumber()
    }
    
    public var fileExtensionHidden: Bool {
        
        return self.dictionary.fileExtensionHidden()
    }
    
    public var fileHFSCreatorCode: OSType {
        
        return self.dictionary.fileHFSCreatorCode()
    }
    
    public var fileHFSTypeCode: OSType {
        
        return self.dictionary.fileHFSTypeCode()
    }
    
    public var fileIsImmutable: Bool {
        
        return self.dictionary.fileIsImmutable()
    }
    
    public var fileIsAppendOnly: Bool {
        
        return self.dictionary.fileIsAppendOnly()
    }
    
    public var fileCreationDate: Date? {
        
        return self.dictionary.fileCreationDate()
    }
    
    public var fileOwnerAccountID: NSNumber? {
        
        return self.dictionary.fileOwnerAccountID()
    }
    
    public var fileGroupOwnerAccountID: NSNumber? {
        
        return self.dictionary.fileGroupOwnerAccountID()
    }
}

// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: novelDetail.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30004
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30004 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class NovelDetailInfoResponse;
@class NovelDetailInfoVolumeResponse;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NovelDetailRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
GPB_FINAL @interface NovelDetailRoot : GPBRootObject
@end

#pragma mark - NovelDetailResponse

typedef GPB_ENUM(NovelDetailResponse_FieldNumber) {
  NovelDetailResponse_FieldNumber_Errno = 1,
  NovelDetailResponse_FieldNumber_Errmsg = 2,
  NovelDetailResponse_FieldNumber_Data_p = 3,
};

GPB_FINAL @interface NovelDetailResponse : GPBMessage

@property(nonatomic, readwrite) int32_t errno;

@property(nonatomic, readwrite, copy, null_resettable) NSString *errmsg;

@property(nonatomic, readwrite, strong, null_resettable) NovelDetailInfoResponse *data_p;
/** Test to see if @c data_p has been set. */
@property(nonatomic, readwrite) BOOL hasData_p;

@end

#pragma mark - NovelDetailInfoResponse

typedef GPB_ENUM(NovelDetailInfoResponse_FieldNumber) {
  NovelDetailInfoResponse_FieldNumber_NovelId = 1,
  NovelDetailInfoResponse_FieldNumber_Name = 2,
  NovelDetailInfoResponse_FieldNumber_Zone_p = 3,
  NovelDetailInfoResponse_FieldNumber_Status = 4,
  NovelDetailInfoResponse_FieldNumber_LastUpdateVolumeName = 5,
  NovelDetailInfoResponse_FieldNumber_LastUpdateChapterName = 6,
  NovelDetailInfoResponse_FieldNumber_LastUpdateVolumeId = 7,
  NovelDetailInfoResponse_FieldNumber_LastUpdateChapterId = 8,
  NovelDetailInfoResponse_FieldNumber_LastUpdateTime = 9,
  NovelDetailInfoResponse_FieldNumber_Cover = 10,
  NovelDetailInfoResponse_FieldNumber_HotHits = 11,
  NovelDetailInfoResponse_FieldNumber_Introduction = 12,
  NovelDetailInfoResponse_FieldNumber_TypesArray = 13,
  NovelDetailInfoResponse_FieldNumber_Authors = 14,
  NovelDetailInfoResponse_FieldNumber_FirstLetter = 15,
  NovelDetailInfoResponse_FieldNumber_SubscribeNum = 16,
  NovelDetailInfoResponse_FieldNumber_RedisUpdateTime = 17,
  NovelDetailInfoResponse_FieldNumber_VolumeArray = 18,
};

GPB_FINAL @interface NovelDetailInfoResponse : GPBMessage

@property(nonatomic, readwrite) int32_t novelId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

@property(nonatomic, readwrite, copy, null_resettable) NSString *zone_p;

@property(nonatomic, readwrite, copy, null_resettable) NSString *status;

@property(nonatomic, readwrite, copy, null_resettable) NSString *lastUpdateVolumeName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *lastUpdateChapterName;

@property(nonatomic, readwrite) int32_t lastUpdateVolumeId;

@property(nonatomic, readwrite) int32_t lastUpdateChapterId;

@property(nonatomic, readwrite) int64_t lastUpdateTime;

@property(nonatomic, readwrite, copy, null_resettable) NSString *cover;

@property(nonatomic, readwrite) int32_t hotHits;

@property(nonatomic, readwrite, copy, null_resettable) NSString *introduction;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString*> *typesArray;
/** The number of items in @c typesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger typesArray_Count;

@property(nonatomic, readwrite, copy, null_resettable) NSString *authors;

@property(nonatomic, readwrite, copy, null_resettable) NSString *firstLetter;

@property(nonatomic, readwrite) int32_t subscribeNum;

@property(nonatomic, readwrite) int64_t redisUpdateTime;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NovelDetailInfoVolumeResponse*> *volumeArray;
/** The number of items in @c volumeArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger volumeArray_Count;

@end

#pragma mark - NovelDetailInfoVolumeResponse

typedef GPB_ENUM(NovelDetailInfoVolumeResponse_FieldNumber) {
  NovelDetailInfoVolumeResponse_FieldNumber_VolumeId = 1,
  NovelDetailInfoVolumeResponse_FieldNumber_LnovelId = 2,
  NovelDetailInfoVolumeResponse_FieldNumber_VolumeName = 3,
  NovelDetailInfoVolumeResponse_FieldNumber_VolumeOrder = 4,
  NovelDetailInfoVolumeResponse_FieldNumber_Addtime = 5,
  NovelDetailInfoVolumeResponse_FieldNumber_SumChapters = 6,
};

GPB_FINAL @interface NovelDetailInfoVolumeResponse : GPBMessage

@property(nonatomic, readwrite) int32_t volumeId;

@property(nonatomic, readwrite) int32_t lnovelId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *volumeName;

@property(nonatomic, readwrite) int32_t volumeOrder;

@property(nonatomic, readwrite) int64_t addtime;

@property(nonatomic, readwrite) int32_t sumChapters;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)

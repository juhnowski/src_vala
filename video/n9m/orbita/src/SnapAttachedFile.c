typedef struct _SnapAttachedFile_
{
rm_uint32_t uiSnapTaskNumber;
rm_uint8_t ucSnapType;
rm_uint8_t ucSnapChn;
rm_uint8_t ucReserve0[2];
rm_uint32_t uiSnapSerialNumber;
rm_uint64_t ullSubType;
rm_uint8_t ucLockFlag;
rm_uint8_t ucDeleteFlag;
rm_uint8_t ucPrivateDataType;
rm_uint8_t ucReserve[5];
rm_uint32_t uiUserFlag;
datetime_t stuDateTime;
rm_uint32_t uiItemOffset;
rm_uint32_t uiFileSize;
rm_uint8_t ucPrivateData[128];
}SnapAttachedFile_t;

struct _SnapHead_
{
unsigned long long SnapTime;
char Channel;
Unsigned char Snapcmdtype;
Unsigned char pictype;
char resever;
unsigned int PicDataLen;
char PicData[0];//图片数据
}__attribute__((packed));

struct SnapHead
{
unsigned long long SnapTime;
char Channel;
unsigned char Snapcmdtype;
Unsigned char pictype;
char resever;
unsigned int PicDataLen;
char PicData[0];
}__attribute__((packed));


typedef struct _SnapAttachedFile_Streamax-N9M {
unsigned int uiSnapTaskNumber;
unsigned char ucSnapType;
unsigned char ucSnapChn;
unsigned char ucReserve0[2];
unsigned int uiSnapSerialNumber;
unsigned long long ullSubType;
unsigned char ucLockFlag;
unsigned char ucDeleteFlag;
unsigned char ucPrivateDataType;
unsigned char ucReserve[5];
unsigned int uiUserFlag;
datetime_t stuDateTime;
unsigned int uiItemOffset;
unsigned int uiFileSize;
unsigned char ucPrivateData[120];
unsigned int uiAlarmUid;
unsigned int uiRunCounts;
}SnapAttachedFile_t;


typedef struct _datetime_{
unsigned char year;
/*from 2000 */
unsigned char month; /*1-12 */
unsigned char day;
/*1~31 */
unsigned char hour; /* 0~23,0=24:00*/
unsigned char minute; /* 0~59 */
unsigned char second; /* 0~59 */
unsigned char week; /* 0~6 0=sunday*/
unsigned char reserved;
}datetime_t;

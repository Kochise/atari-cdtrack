
#ifndef _MTSTRUCT_H
#define _MTSTRUCT_H


typedef struct
{
	unsigned short	mi_version;	/* 0x230 == '02.30' */
	long 			mi_magic;	/* == '_MET' */
	const char 		*mi_log2phys;	/* maps DOS-IDs to MetaDOS XBIOS device numbers */
} META_INFO_2;

typedef struct
{
	unsigned long	mi_drivemap;
	const char 		*mi_version_string;
	long 			reserved;
	META_INFO_2		*mi_info;
} META_INFO_1;

typedef struct
{
	char 			*mdr_name;
	long 			res[3];
} META_DRVINFO;

#endif /* _MTSTRUCT_H */

/********************************************************

  common.h
    copyright 2019.06.10 konoar

 ********************************************************/
#ifndef __COMMON_H__
#define __COMMON_H__

#define KS_SUCCESS	0
#define KS_ERROR	1

#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

enum ksKey
{
	KSKEY_NAME,
	KSKEY_AGE,
	KSKEY_BMI
};

enum ksType
{
	KSTYPE_STR,
	KSTYPE_INT,
	KSTYPE_DBL
};

struct ksJson
{
	char			name[128];
	long			age;
	double			bmi;
};

struct ksData
{
	yyscan_t		scaninfo;
	char			strbuff[128];
	int				key;
	int				type;
	char			vals[128];
	long			vali;
	double			vald;
	struct ksJson	person;
};

#endif /* __COMMON_H__ */


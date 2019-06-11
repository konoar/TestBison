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

enum ksType
{
	KSTYPE_STR,
	KSTYPE_INT,
	KSTYPE_DBL
};

enum ksKey
{
	KSKEY_NAME,
	KSKEY_AGE,
	KSKEY_BMI
};

struct ksPerson
{
	char			name[128];
	long			age;
	double			bmi;
};

struct ksData
{
	yyscan_t		scaninfo;
	char			buff[128];
	int				type;
	int				key;
	int				flag;
	char			vals[128];
	long			vali;
	double			vald;
	struct ksPerson	person;
};

#endif /* __COMMON_H__ */


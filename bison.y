/********************************************************

  bison.y
    copyright 2019.06.10 konoar

 ********************************************************/
%define api.pure full

%parse-param	{ void *pData }
%lex-param		{ pData }

%union {
	char*	s;
	long	l;
	double	d;
}

%{

	#include "common.h"
	#include "flex.h"
	#include "stdio.h"

	#define KSDATA ((struct ksData*)pData)
	#define KSFLAG(__KEY__) KSDATA->flag |= (1 << KSKEY_##__KEY__)

	int yyerror(struct ksData *pData, const char *msg);

	int yylex(YYSTYPE *yylval_param, void *pData)
	{
		return yylex_bare(yylval_param, KSDATA->scaninfo);
	}

%}

%code provides {
	extern int yylex_bare(YYSTYPE *yylval_param, void *yyscanner);
	#define YY_DECL int yylex_bare(YYSTYPE *yylval_param, void *yyscanner)
}

%token <s> TK_WORD
%token <l> TK_LONG
%token <d> TK_DBLE
%token TK_QUOT TK_IKEY TK_SEPK TK_SEPI TK_VALU TK_OBST TK_OBED

%%

object: TK_OBST items TK_OBED {
	if (KSDATA->flag != 7) {
		YYABORT;
	}
}

items: | item | item TK_SEPI items

item: key TK_SEPK value {
	switch (KSDATA->key) {
		case KSKEY_NAME:
			if (KSDATA->type == KSTYPE_STR) {
				KSFLAG(NAME);
				strcpy(KSDATA->person.name, KSDATA->vals);
			} else {
				YYABORT;
			}
			break;
		case KSKEY_AGE:
			if (KSDATA->type == KSTYPE_INT) {
				KSFLAG(AGE);
				KSDATA->person.age = KSDATA->vali;
			} else {
				YYABORT;
			}
			break;
		case KSKEY_BMI:
			if (KSDATA->type == KSTYPE_DBL) {
				KSFLAG(BMI);
				KSDATA->person.bmi = KSDATA->vald;
			} else {
				YYABORT;
			}
			break;
	}
}

key: TK_QUOT TK_WORD TK_QUOT {
	if (!strcmp($2, "name")) {
		KSDATA->key = KSKEY_NAME;
	}
	else
	if (!strcmp($2, "age")) {
		KSDATA->key = KSKEY_AGE;
	}
	else
	if (!strcmp($2, "bmi")) {
		KSDATA->key = KSKEY_BMI;
	}
}

value: TK_QUOT TK_WORD TK_QUOT {
	KSDATA->type = KSTYPE_STR;
	strcpy(KSDATA->vals, $2);
} | TK_LONG {
	KSDATA->type = KSTYPE_INT;
	KSDATA->vali = $1;
} | TK_DBLE {
	KSDATA->type = KSTYPE_DBL;
	KSDATA->vald = $1;
}

%%

int yyerror(struct ksData *pData, const char *msg)
{
	printf("error: %s\n", msg);
	return 1;
}


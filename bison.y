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

	#include "flex.h"
	#include "common.h"
	#include "stdio.h"

	int yyerror(struct ksData *pData, const char *msg);

	int yylex(YYSTYPE *yylval_param, void *pData)
	{
		return yylex_bare(yylval_param, ((struct ksData*)(pData))->scaninfo);
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

object: TK_OBST items TK_OBED
items: | item TK_SEPI items

item: key TK_SEPK value {
	switch (((struct ksData*)pData)->key) {
		case KSKEY_NAME:
			if (((struct ksData*)pData)->type == KSTYPE_STR) {
				strcpy(((struct ksData*)pData)->person.name, ((struct ksData*)pData)->vals);
			} else {
				YYABORT;
			}
			break;
		case KSKEY_AGE:
			if (((struct ksData*)pData)->type == KSTYPE_INT) {
				((struct ksData*)pData)->person.age = ((struct ksData*)pData)->vali;
			} else {
				YYABORT;
			}
			break;
		case KSKEY_BMI:
			if (((struct ksData*)pData)->type == KSTYPE_DBL) {
				((struct ksData*)pData)->person.bmi = ((struct ksData*)pData)->vald;
			} else {
				YYABORT;
			}
			break;
	}
}

key: TK_QUOT TK_WORD TK_QUOT {
	if (!strcmp($2, "name")) {
		((struct ksData*)pData)->key = KSKEY_NAME;
	}
	else
	if (!strcmp($2, "age")) {
		((struct ksData*)pData)->key = KSKEY_AGE;
	}
	else
	if (!strcmp($2, "bmi")) {
		((struct ksData*)pData)->key = KSKEY_BMI;
	}
}

value: TK_QUOT TK_WORD TK_QUOT {
	((struct ksData*)pData)->type = KSTYPE_STR;
	strcpy(((struct ksData*)pData)->vals, $2);
} | TK_LONG {
	((struct ksData*)pData)->type = KSTYPE_INT;
	((struct ksData*)pData)->vali = $1;
} | TK_DBLE {
	((struct ksData*)pData)->type = KSTYPE_DBL;
	((struct ksData*)pData)->vald = $1;
}

%%

int yyerror(struct ksData *pData, const char *msg)
{
	printf("error: %s\n", msg);
	return 1;
}


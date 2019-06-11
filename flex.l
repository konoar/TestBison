/********************************************************

  flex.l
    copyright 2019.06.10 konoar

 ********************************************************/
%option noyywrap reentrant bison-bridge
%option extra-type="struct ksData*"
%option outfile="flex.c" header-file="flex.h"

%{
	#include "common.h"
	#include "bison.h"
%}

%%

%{
	struct ksData *pData = yyextra;
%}

"{"		{ return TK_OBST; }
"}"		{ return TK_OBED; }
":"		{ return TK_SEPK; }
","		{ return TK_SEPI; }
"\""	{ return TK_QUOT; }

[0-9]+\.[0-9]+ {

	yylval->d = atof(yytext);
	return TK_DBLE;

}

[1-9]?[0-9]+ {

	yylval->l = atoi(yytext);
	return TK_LONG;

}

[a-zA-Z0-9]+ {

	yylval->s = pData->buff;
	strcpy(yylval->s, yytext);
	return TK_WORD;

}

.		{}
"\n"	{}

%%


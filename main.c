/********************************************************

  main.c
    copyright 2019.06.10 konoar

 ********************************************************/
#include "common.h"
#include "bison.h"
#include "flex.h"
#include "stdio.h"

int main(int argc, const char *argv[])
{

	struct ksData data;

	int parse()
	{

		FILE *fp = fopen("./data.json", "rb");

		if (fp == 0) {
			return KS_ERROR;
		}

		yyset_in(fp, data.scaninfo);
		yyparse(&data);

		fclose(fp);

		return KS_SUCCESS;

	}

	if (yylex_init_extra(&data, &data.scaninfo)) {

		return KS_ERROR;

	} else {

		if (!parse(&data)) {
			printf("person!\n");
			printf("  name: %s\n", data.person.name);
			printf("   age: %d\n", data.person.age);
			printf("   bmi: %f\n", data.person.bmi);
		}

		yylex_destroy(data.scaninfo);

		return KS_SUCCESS;

	}

}


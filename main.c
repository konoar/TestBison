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
		int retval = KS_ERROR;

		if (fp == 0) {
			return retval;
		}

		yyset_in(fp, data.scaninfo);

		if (yyparse(&data)) retval = KS_ERROR;
		else                retval = KS_SUCCESS;

		(void) fclose(fp);

		return retval;

	}

	data.person.name[0] = 0;
	data.person.age     = 0;
	data.person.bmi     = 18.0;

	data.type = data.key = data.flag = 0;

	if (yylex_init_extra(&data, &data.scaninfo)) {

		return KS_ERROR;

	} else {

		if (parse(&data) == KS_SUCCESS) {
			printf("person!\n");
			printf("  name: %s\n",	data.person.name);
			printf("   age: %ld\n",	data.person.age);
			printf("   bmi: %f\n",	data.person.bmi);
		} else {
			printf("error!\n");
		}

		(void) yylex_destroy(data.scaninfo);

		return KS_SUCCESS;

	}

}


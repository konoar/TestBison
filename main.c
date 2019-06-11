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
	FILE *fp;

	int parse()
	{

		int retval = KS_ERROR;

		if (yylex_init_extra(&data, &data.scaninfo)) {
			return retval;
		}

		yyset_in(fp, data.scaninfo);

		if (yyparse(&data)) retval = KS_ERROR;
		else                retval = KS_SUCCESS;

		(void) yylex_destroy(data.scaninfo);

		return retval;

	}

	data.person.name[0] = 0;
	data.person.age     = 0;
	data.person.bmi     = 18.0;
	
	data.type = data.key = data.flag = 0;

	if (!(fp = fopen("./data.json", "rb"))) {
		printf("error File Not Found!\n");
		return KS_ERROR;
	}

	if (parse(fp) == KS_SUCCESS) {
		printf("person!\n");
		printf("  name: %s\n",	data.person.name);
		printf("   age: %ld\n",	data.person.age);
		printf("   bmi: %f\n",	data.person.bmi);
	} else {
		printf("error!\n");
	}

	(void) fclose(fp);

	return KS_SUCCESS;

}


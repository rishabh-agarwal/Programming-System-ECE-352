#include "motion.tab.c"
#include "lex.yy.c"

int up_counter = 0;
int down_counter = 0;
int left_counter = 0;
int right_counter = 0;


extern int yylex();

int yyerror(char *s)
{
printf("%s\n",s);
return -1;
}




int main()
{
int parse_retval;

printf("\n Motion Trajectory Checker (Scanner/Parser)\n");
printf(" CPSC/ECE 3520 Spring 2015\n");

parse_retval = yyparse();

if (parse_retval == 0)
	{
	printf("\n\n***** congratulations *****\n");
	if ((left_counter == right_counter) &&
		(up_counter == down_counter) &&
		!((up_counter == 0) && (left_counter == 0)))
		printf("***** valid motion path AND CLOSED PATH *****\n");
	else
		printf("***** scan/parse for valid motion path successful *****\n");
	}

return 0;
}



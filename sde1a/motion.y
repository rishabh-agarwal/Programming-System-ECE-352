


%{

#include <stdlib.h>
#include <stdio.h>

extern int yyerror(char *s);
extern int yylex(void);

extern int up_counter;
extern int down_counter;
extern int left_counter;
extern int right_counter;

%}


%union {
	int ival;
	float fval;
	char* sval;
	}

%token UP
%token DOWN
%token RIGHT
%token LEFT
%token NOMOVEMENT
%token <ival> DIGIT
%token ENDOFFILE
%token GARBAGE

%type <ival> up_command
%type <ival> down_command
%type <ival> left_command
%type <ival> right_command
%type <ival> number

%start valid_trajectory

%%



valid_trajectory:
	commands_multiple
|
;


commands_multiple:
	commands_multiple command
|	command
;


command:
	up_command {
		up_counter += $1;
		}
|	down_command {
		down_counter += $1;
		}
|	left_command {
		left_counter += $1;
		}
|	right_command {
		right_counter += $1;
		}
|	no_command
;


up_command:
	UP number {
		$$ = $2;
		}
|	UP {
		$$ = 1;
		}
;


down_command:
	DOWN number {
		$$ = $2;
		}
|	DOWN {
		$$ = 1;
		}
;


left_command:
	LEFT number {
		$$ = $2;
		}
|	LEFT {
		$$ = 1;
		}
;


right_command:
	RIGHT number {
		$$ = $2;
		}
|	RIGHT {
		$$ = 1;
		}
;


no_command:
	NOMOVEMENT number
|	NOMOVEMENT
;


number:
	DIGIT {
		$$ = $1;
		}
|	number DIGIT {
		$$ = ($1 * 10) + $2;
		}
;




%%














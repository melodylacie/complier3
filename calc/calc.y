/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
int xtoi(char *hexstring);

%}

%union{
  int		int_val;
  string*	op_val;
}

%start	input 

%token	<int_val>	INTEGER_LITERAL
%type	<int_val>	exp

%right  RIGHT_PARENTHESIS
%left   LEFT_PARENTHESIS
%left	PLUS MINUS
%left	MULT DIVIDE
%left	MOD
%left	OR
%left	AND
%left	NOT


%%

input:		
		| exp	{ cout << "Result: " << $1 << endl; }
		
		;

exp:	INTEGER_LITERAL	{ $$ = $1; }
 			
		| exp MINUS exp	{ $$ = $1 - $3; }
		| exp PLUS exp	{ $$ = $1 + $3; }
		
		| exp MULT exp	{ $$ = $1 * $3; }
		| exp DIVIDE exp	{ $$ = $1 / $3; }
		| exp MOD exp	{ $$ = $1 % $3; }
		
		| exp OR exp	{ $$ = $1 | $3; }
		| exp AND exp	{ $$ = $1 & $3; }
		| NOT exp		{ $$ = ~$2; }
		| MINUS exp		{ $$ = -$2; }
		| '('  exp ')' { $$ = $2; }
		;

%%

/*
**	Copyright (c) Leigh Brasington 2012.  All rights reserved.
**	This code may be used and reproduced without written permission.
**
**	 C/C++ function to convert an ANSI hexadecimal string to an int
**
**	Keywords: Convert hexadecimal string int C/C++
*/

int xtoi(char *hexstring)
{
	int	i = 0;
	/*
	if ((*hexstring == '0') && (*(hexstring+1) == 'x'))
		  hexstring += 2;
	*/
	while (*(hexstring+1)) // ignore prelast = 'h|H'
	{
		char c = toupper(*hexstring++);
		if ((c < '0') || (c > 'F') || ((c > '9') && (c < 'A')))
			break;
		c -= '0';
		if (c > 9)
			c -= 7;
		i = (i << 4) + c;
	}
	return i;
}


int yyerror(string s)
{
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  return 0;
}

int yyerror(char *s)
{
  return yyerror(string(s));
}



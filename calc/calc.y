/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
int xtoi(char *hexstring);
 
int regToInt(char *reg);

int regArray[24] = {0};
int acc = 0;

struct stack {
    struct stack *prev;
    int     value;
};
struct stack *top;
int size = 0;

 
%}

%union{
  int		int_val;
  string*	op_val;
}

%start	input 

 
%token	<int_val>	INTEGER_LITERAL REG
%type	<int_val>	exp cmd ref

 

%left	PLUS MINUS
%left	MULT
%left	DIVIDE
%left	MOD
%left	OR
%left	AND
%left	NOT

%left ACC  
%left TOP  
%left SIZE  
%left PUSH  
%left POP  
%left SHOW  
%left LOAD  

%%

input:		
		| exp	{ cout << "Result: " << $1 << endl; }
		| cmd	{;}
		
		;

exp:	INTEGER_LITERAL		{ $$ = $1; }
		|REG				{ $$ = regArray[$1]; }
 			
		| exp MINUS exp		{ $$ = $1 - $3; acc = $$; }
		| exp PLUS exp		{ $$ = $1 + $3; acc = $$; }
		
		| exp MULT exp		{ $$ = $1 * $3; acc = $$; }
		| exp DIVIDE exp	{ $$ = $1 / $3; acc = $$; }
		| exp MOD exp		{ $$ = $1 % $3; acc = $$; }
			
		| exp OR exp		{ $$ = $1 | $3; acc = $$; }
		| exp AND exp		{ $$ = $1 & $3; acc = $$; }
		| NOT exp			{ $$ = ~$2; acc = $$; }
		| MINUS exp			{ $$ = -$2; acc = $$; }
		| '(' exp ')' 		{ $$ = $2;  acc = $$; }
		;
 
cmd:	SHOW ref			{$$ = $2; cout << "Reg Value: " << $2 << endl; }
		|LOAD ref REG		{regArray[$3] = $2; }
		|PUSH ref			{$$ = push($2); }
		|POP REG			{$$ = pop($2); }
		
		
		;

ref:	REG					{$$ = regArray[$1]; }
		|ACC				{$$ = acc; }
		|TOP				{$$ = top; }
		|SIZE				{$$ = size; }
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

int regToInt(char *reg){
	return ((int)*(reg+2)) - 65 ;
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

struct stack *push(int value)
{
	struct stack *temp = new stack;
	temp->prev = top;
	temp->value = value;
	size++;
	top = temp;
	return top;
}

struct stack *pop(int index)
{
	if(size > 0){
		regArray[index] = top->value;
		struct stack *temp;
		temp = top;
		top = top->prev;
		delete(temp);
		size--;
	}else{
		cerr << "ERROR: Stack is Empty!" <<endl;
	}
}


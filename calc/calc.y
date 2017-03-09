/* Mini Calculator */
/* calc.y */

%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
int xtoi(char *hexstring);
 
int regToInt(char *reg);

int regArray[24] = {0};
regArray[3]	= 5;
int top = 0;

struct list_node {
    struct list_node  *next;
    value_t           value;
};


 
%}

%union{
  int		int_val;
  string*	op_val;
}

%start	input 

 
%token	<int_val>	INTEGER_LITERAL REG
%type	<int_val>	exp cmd

 

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
		| cmd	{ cout << "Reg: " << $1 << endl;}
		
		;

exp:	INTEGER_LITERAL		{ $$ = $1; }
 			
		| exp MINUS exp		{ $$ = $1 - $3; }
		| exp PLUS exp		{ $$ = $1 + $3; }
		
		| exp MULT exp		{ $$ = $1 * $3; }
		| exp DIVIDE exp	{ $$ = $1 / $3; }
		| exp MOD exp		{ $$ = $1 % $3; }
			
		| exp OR exp		{ $$ = $1 | $3; }
		| exp AND exp		{ $$ = $1 & $3; }
		| NOT exp			{ $$ = ~$2; }
		| MINUS exp			{ $$ = -$2; }
		| '(' exp ')' 		{ $$ = $2; }
		;
 
cmd:	SHOW REG			{$$ = $1; }
		LOAD REG REG		{$3 = $1; }
		
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
int getReg(int index){
	return regArray[((int)*(reg+2)) - 65];
}
///////////////////////////////////////


struct list *new_list() {
    struct list *rv = malloc(sizeof(struct list));
    rv->head = 0;
    rv->tail = &rv->head;
    return rv; }
void push_back(struct list *list, value_t value) {
    struct list_node *node = malloc(sizeof(struct list_node));
    node->next = 0;
    node->value = value;
    *list->tail = node;
    list->tail = &node->next; }
//////////////////////////////////////

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

struct stack *push()
{
	
}


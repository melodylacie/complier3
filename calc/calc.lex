/* Mini Calculator */
/* calc.lex */

%{
#include "heading.h"
#include "tok.h"

int yyerror(char *s);
int xtoi(char *hexstring);
int regToInt(char *reg);


%}

digit		[0-9]
int_const	{digit}+

D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+

%%

{int_const}		{ yylval.int_val = atoi(yytext); return INTEGER_LITERAL; }


{H}+['h'|'H']	{ yylval.int_val = xtoi(yytext); return INTEGER_LITERAL;}

"AND"			{ yylval.op_val = new std::string(yytext); return AND; }
"OR"			{ yylval.op_val = new std::string(yytext); return OR; }
"NOT"			{ yylval.op_val = new std::string(yytext); return NOT; }
	
"+"				{ yylval.op_val = new std::string(yytext); return PLUS; }
"-"				{ yylval.op_val = new std::string(yytext); return MINUS; }
"*"				{ yylval.op_val = new std::string(yytext); return MULT; }
"/"				{ yylval.op_val = new std::string(yytext); return DIVIDE ; }
"\\"			{ yylval.op_val = new std::string(yytext); return MOD ; }
"("				{ yylval.op_val = new std::string(yytext); return '(' ; }
")"				{ yylval.op_val = new std::string(yytext); return ')' ; }

$r[A-Z]			{ yylval.int_val = getRec(regToInt(yytext)); return REG ; }
"$acc"			{ yylval.op_val = new std::string(yytext); return ACC ; }
"$top"			{ yylval.op_val = new std::string(yytext); return TOP ; }
"$size"			{ yylval.op_val = new std::string(yytext); return SIZE ; }
"PUSH"			{ yylval.op_val = new std::string(yytext); return PUSH ; }
"POP"			{ yylval.op_val = new std::string(yytext); return POP ; }
"SHOW"			{ yylval.op_val = new std::string(yytext); return SHOW ; }
"LOAD"			{ yylval.op_val = new std::string(yytext); return LOAD ; }

[ \t]*		{}
[\n]		{ return NULL ;}


.		{ std::cerr << "SCANNER "; yyerror(""); exit(1);	}

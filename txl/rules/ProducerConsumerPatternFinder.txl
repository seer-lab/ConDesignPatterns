% Producer Consumer Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, April 21, 2011

% include "Java.Grm"
% include "JavaCommentOverrides.Grm"
include "../helper.txl"

redefine annotation
	[annotation2]
end redefine

define annotation2
   [SPOFF] '@ [reference] [opt '@] [SPON] [opt annotation_value_spec] [NL]
end define

redefine class_declaration
	[class_declaration2]
    | [attr labelM] [class_header] [class_body]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [class_header] [class_body]
end redefine

define class_declaration2
    [class_header] [class_body]
end define

redefine class_body
	[class_body2]
    | [attr labelM] [class_or_interface_body]
end define

define class_body2
    [class_or_interface_body]
end define

redefine method_declaration
	[method_declaration2]
	| [attr labelM] [method_declaration2]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [method_declaration2]
 	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [method_declaration2]
end redefine

define method_declaration2
    [repeat modifier] [type_specifier] [method_declarator] [opt throws] [method_body]
end define

redefine variable_declaration
	[variable_declaration2]
    | [attr labelM] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end redefine

define variable_declaration2
    [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end define

redefine while_statement
	[while_statement2]
    | 'while '( [expression] ')
	'{
        [statement]
	'}
 	| [attr labelM]
	'while '( [expression] ')
	'{
        [statement]
	'}
 	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
	'while '( [expression] ')
	'{
		[NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
		[statement]
	'}
end redefine

define while_statement2
    'while '( [expression] ')
        [statement]
end define

redefine do_statement
	[do_statement2]
    | 'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';
 	| [attr labelM]
    'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';
 	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
    'do
	'{
		[NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
        [statement]
	'}
    'while '( [expression] ') ';
end redefine

define do_statement2
    'do
        [statement]
    'while '( [expression] ') ';
end define

redefine expression_statement
 	[expression_statement2]
	| [attr labelM]
	[expression] ';
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
	[expression] ';
end redefine

define expression_statement2
    [expression] ';
end define

redefine synchronized_statement
 	[synchronized_statement2]
	| [attr labelM]
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

define synchronized_statement2
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

redefine return_statement
 	[return_statement2]
	| [attr labelM]
    'return [opt expression] ';      [NL]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] */
    'return [opt expression] ';      [NL]
end redefine

define return_statement2
    'return [opt expression] ';      [NL]
end define

redefine formal_parameter
 	[formal_parameter2]
	| [attr labelM]
    [repeat annotation] [opt 'final] [type_specifier] [opt var_arg_specifier] [formal_parameter_name]
end redefine

define formal_parameter2
    [repeat annotation] [opt 'final] [type_specifier] [opt var_arg_specifier] [formal_parameter_name]
end define

redefine expression
	[expression2]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [assignment_expression]
end define

define expression2
    [assignment_expression]
end define

redefine assignment_expression
	[assignment_expression2]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [conditional_expression]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [unary_expression] [assignment_operator] [assignment_expression]
end define

define assignment_expression2
	[conditional_expression]
    |   [unary_expression] [assignment_operator] [assignment_expression]
end define


function main
	export Counter [number]
		0
	export CountProdrClassIDs [number]
		0
	% export qCountProddObjIDs [number]
		% 0
	export CountQueueClassIDs [number]
		0
	% export CountListIDs [number]
		% 0
	% export qCountUsedListIDs [number]
		% 0
	export qCountPushMethIDs [number]
		0
	export qCountPullMethIDs [number]
		0
	% export pCountProdObjIDs [number]
		% 0
	% export cCountProdObjIDs [number]
		% 0
	% export pCountQueueIDs [number]
		% 0
	% export cCountQueueIDs [number]
		% 0
	export CountConsrClassIDs [number]
		0
	% export CountConsdObjIDs [number]
		% 0
	% export tmpCntLocQueID [number]
		% 0
	export preCntQueueClassIDs [number]
		0

	export tmpRole2abPassed [number]
		0
	export tmpRole1Passed [number]
		0
	export tmpRole3Passed [number]
		0
	export cntListObjects [number]
		0
	% export tmpCntRole2cPossible [number]
		% 0

	export tmpParamIDCollection [repeat id]
		_
	export tmpTypeSpecIDCollection [repeat id]
		_
	export tmpLocalQueueID [id]
		_
	export tmpLocalProdObjID [id]
		_
	export tmpLocalProdObjTypeID [id]
		_
	export tmpLocalConsObjID [id]
		_

	export ProdrClassIDCollection [repeat id]
		_
	export ProddObjTypeCollection [repeat id]
		_
	export qProddObjIDCollection [repeat id]
		_
	export pProddObjIDCollection [repeat id]
		_
	export cProddObjIDCollection [repeat id]
		_
	export QueueClassIDCollection [repeat id]
		_
	export numVarsIDCollection [repeat id]
		_
	export ListIDCollection [repeat id]
		_
	export qUsedListIDCollection [repeat id]
		_
	export qPushMethIDCollection [repeat id]
		_
	export qPullMethIDCollection [repeat id]
		_
	export pQueueIDCollection [repeat id]
		_
	export cQueueIDCollection [repeat id]
		_
	export ConsrClassIDCollection [repeat id]
		_
	export ConsdObjIDCollection [repeat id]
		_

	export usedqPushMethIDCollection [repeat id]
		_
	export usedqPullMethIDCollection [repeat id]
		_

	replace [program]
        P [program]
	construct TransformedProgram [stringlit]
		"TransformedForProdConsPatt.java"
	by
		P [findAllNumberVars] [getAllListVars] [findQueueClass] [FindProducerClass] [FindConsumerClass]
		[printOutput] [printProdrClassID] [printQueueClassID] [printConsrClassID]
		[fput TransformedProgram]
		% P [findAllNumberVars] [getAllListVars] [findQueueClass] [FindProducerClass] [FindConsumerClass]
		% [printPatternNotFound] [printOutput] [printProdrClassID] [printQueueClassID] [printConsrClassID]
		% [fput TransformedProgram]
end function


function printPatternNotFound
	replace [program]
		P [program]

	import Counter [number]

	where
		Counter [= 0]

	construct InstanceFound [stringlit]
		"*** No instances of Producer Consumer Pattern found. "

	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]

	by
		P
end function

% Function print out the number of Producer Consumer design pattern instances found.
function printOutput
	replace [program]
		P [program]
	import Counter [number]
	% where
		% Counter [> 0]
	construct InstanceFound [stringlit]
		"** Complete instances of Producer Consumer Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function


% Function to print out the Producer Class IDs.
% The number of these Producer Classes should equal the number of instances printed out in the "printOutput" function.
function printProdrClassID
	replace [program]
		P [program]
	import ProdrClassIDCollection [repeat id]
	% import Counter [number]
	% where
		% Counter [> 0]
	import CountProdrClassIDs [number]
	where
		CountProdrClassIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 1.  Producer Classes: "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintProdrClassIDs each ProdrClassIDCollection]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printProdrClassID".
function thePrintProdrClassIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function


% Function to print out the Queue Class IDs.
% The number of these Queue Classes should equal the number of instances printed out in the "printOutput" function.
function printQueueClassID
	replace [program]
		P [program]
	import QueueClassIDCollection [repeat id]
	% import Counter [number]
	% where
		% Counter [> 0]
	import CountQueueClassIDs [number]
	where
		CountQueueClassIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 2.  Queue Classes: "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintQueueClassIDs each QueueClassIDCollection]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printQueueClassID".
function thePrintQueueClassIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function


% Function to print out the Consumer Class IDs.
% The number of these Consumer Classes should equal the number of instances printed out in the "printOutput" function.
function printConsrClassID
	replace [program]
		P [program]
	import ConsrClassIDCollection [repeat id]
	% import Counter [number]
	% where
		% Counter [> 0]
	import CountConsrClassIDs [number]
	where
		CountConsrClassIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 3.  Consumer Classes: "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintConsrClassIDs each ConsrClassIDCollection]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printConsrClassID".
function thePrintConsrClassIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function


rule findAllNumberVars
	construct  VARTYPE [type_specifier]
		'short
	construct  VARTYPE2 [type_specifier]
		'int
	construct  VARTYPE3 [type_specifier]
		'long
	construct  VARTYPE4 [type_specifier]
		'float
	construct  VARTYPE5 [type_specifier]
		'double
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [isVarOfType VARTYPE] [isVarOfType VARTYPE2] [isVarOfType VARTYPE3] [isVarOfType VARTYPE4] [isVarOfType VARTYPE5]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		objectID [id] OGP [opt generic_parameter]
	import numVarsIDCollection [repeat id]
	construct newIDCollection [repeat id]
		numVarsIDCollection [. objectID]
	export numVarsIDCollection
		newIDCollection
	by
		'MUTATED RM TS VDS ';
end rule


% //***ProducerConsumerPattern:  Role = 2a( list to house the produced objects.);
% Rule to find all list variables.  This will enable us to locate the Queue class
rule getAllListVars
	construct  VARTYPE [type_specifier]
		'AbstractList
	construct  VARTYPE2 [type_specifier]
		'ArrayList
	construct  VARTYPE3 [type_specifier]
		'LinkedList
	construct  VARTYPE4 [type_specifier]
		'Vector
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [isVarOfType VARTYPE] [isVarOfType VARTYPE2] [isVarOfType VARTYPE3] [isVarOfType VARTYPE4]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]

	import ListIDCollection [repeat id]
	construct newIDCollection [repeat id]
		ListIDCollection [. flagID]
	export ListIDCollection
		newIDCollection

	construct PlusOne [number]
		1
	import cntListObjects [number]
	construct NewCount [number]
		cntListObjects [+ PlusOne]
	export cntListObjects
		NewCount

	construct ProducerConsumerAnnotation2apt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='List object to house the produced objects.')"

	by
		'MUTATED /* ProducerConsumerAnnotation2apt1 [+ cntListObjects] [+ ProducerConsumerAnnotation2apt2] */ RM TS VDS ';
end rule


% //*************************************************************************//
% //*** Producer Consumer pattern:                                        ***//
% //*** This design pattern allows for objects or information to be       ***//
% //*** produced or consumed asynchronously in a coordinated manner.      ***//
% //*************************************************************************//
% //***ProducerConsumerPattern:  Role = 2(Queue class - buffer between producer and consumer classes.
% //								** Contains Role 2a.
% //								** Contains Role 2b.
% //								** Contains Role 2c.);
rule findQueueClass
	replace [class_declaration]
	    CH [class_header] CB [class_body]

	construct TransformedQueueCB [class_body]
		CB [findPushMethod] [findPullMethod CH] %[findPullMethod2 CH]

	% construct QueClMorePushPullMethsFnd [class_body]
		% CB [findPullMethod2 CH]

	construct numZero [number]
		'0

	% import tmpCntRole2cPossible [number]
	% export tmpCntRole2cPossible
		% numZero

	import CountQueueClassIDs [number]
	import preCntQueueClassIDs [number]
	where not
		CountQueueClassIDs [hasNumber numZero]
	where
		CountQueueClassIDs [> preCntQueueClassIDs]

	construct ProducerConsumerAnnotation2pt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Queue class - buffer between producer and consumer classes.')"

	by
		'MUTATED /* ProducerConsumerAnnotation2pt1 [+ CountQueueClassIDs] [+ ProducerConsumerAnnotation2pt2] */ CH TransformedQueueCB
end rule


% //***ProducerConsumerPattern:  Role = 2b(Synchronized method to push the produced objects into queue.
% //								** Contains Role 2ba.
% //								** Contains Role 2bb.
% //								** Contains Role 2bc.);
rule findPushMethod

	import CountQueueClassIDs [number]
	import preCntQueueClassIDs [number]
	export preCntQueueClassIDs
		CountQueueClassIDs

	construct  SYNCH [modifier]
		'synchronized
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	deconstruct TS
		TN [type_name]
	deconstruct TN
		PT [primitive_type]

	where
		RM [isMethodSynchronized SYNCH]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	construct thePushMethParams [list formal_parameter]
		LFP [getParamsInPushMeth]

	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	import ListIDCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [hasNotify MD] [isProdObjAddToList MD each ListIDCollection]

	import tmpRole2abPassed [number]
	where
		tmpRole2abPassed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	construct ProducerConsumerAnnotation2bpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2bpt2 [stringlit]
		", roleID=2b, roleDescription='Synchronized method to push the produced objects into queue.')"

	construct ProducerConsumerAnnotation2bapt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2bapt2 [stringlit]
		", roleID=2ba, roleDescription='One of the parameters of Role 2b must have produced object.')"

	import qCountPushMethIDs [number]

	export tmpRole2abPassed
		0

	by
		'MUTATED /* ProducerConsumerAnnotation2bpt1 [+ qCountPushMethIDs] [+ ProducerConsumerAnnotation2bpt2] */
		 /* ProducerConsumerAnnotation2bapt1 [+ qCountPushMethIDs] [+ ProducerConsumerAnnotation2bapt2] */ RM TS MD OT TransformedMB
end rule

% //***ProducerConsumerPattern:  Role = 2ba(One of the parameters of Role 2b must have produced object.);
rule getParamsInPushMeth
	replace [formal_parameter]
		RA [repeat annotation] OF [opt 'final] TS [type_specifier] OV [opt var_arg_specifier] FPN [formal_parameter_name]

	deconstruct FPN
		VN [variable_name]
	deconstruct VN
	    DN [declared_name] RD [repeat dimension]
	deconstruct DN
	   paramID [id] OGP [opt generic_parameter]

	import tmpParamIDCollection [repeat id]
	construct newParamIDs [repeat id]
		tmpParamIDCollection [. paramID]
	export tmpParamIDCollection
		newParamIDs

	deconstruct TS
        TN [type_name]
	deconstruct TN
		QN [qualified_name]
	deconstruct QN
		REF [reference]
	deconstruct REF
		typeSpecID [id] RC [repeat component]

	import tmpTypeSpecIDCollection [repeat id]
	construct newTypeSpecIDs [repeat id]
		tmpTypeSpecIDCollection [. typeSpecID]
	export tmpTypeSpecIDCollection
		newTypeSpecIDs

	by
		'MUTATED RA OF TS OV FPN
end rule

% //***ProducerConsumerPattern:  Role = 2bb(Adding the produced object, Role 2ba to Role 2a, the list.);
rule isProdObjAddToList MD [method_declarator] ListID [id]
	replace [expression_statement]
		EX [expression] ';

	import tmpParamIDCollection [repeat id]
	construct ProdObjParamFound [expression]
		EX [isProdObjParam EX MD ListID each tmpParamIDCollection]

	export tmpParamIDCollection
		_

	construct ProducerConsumerAnnotation2bbpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2bbpt2 [stringlit]
		", roleID=2bb, roleDescription='Adding the produced object, Role 2ba to Role 2a, the arraylist.')"

	import qCountPushMethIDs [number]

	by
		'MUTATED /* ProducerConsumerAnnotation2bbpt1 [+ qCountPushMethIDs] [+ ProducerConsumerAnnotation2bbpt2] */
		EX ';
end rule

% Function to find if the Produced object is part of the add expression.
function isProdObjParam EX [expression] MD [method_declarator] ListID [id] paramID [id]
	replace [expression]
		EX

	construct idAdd [id]
		'add
	deconstruct EX
		AE [assignment_expression]
	where all
		AE [matchesVarID ListID] [matchesVarID idAdd] [matchesVarID paramID]

	import qProddObjIDCollection [repeat id]
	construct newParamIDs [repeat id]
		qProddObjIDCollection [. paramID]
	export qProddObjIDCollection
		newParamIDs

	import qUsedListIDCollection [repeat id]
	construct newListIDs [repeat id]
		qUsedListIDCollection [. ListID]
	export qUsedListIDCollection
		newListIDs

	by
		EX
end function

% //***ProducerConsumerPattern:  Role = 2bc(Nofification that the thread has completed.);
rule hasNotify MD [method_declarator]
	replace [expression_statement]
		EX [expression] ';
	construct idNotify [id]
		'notify
	construct idNotifyAll [id]
		'notifyAll
	deconstruct EX
		AE [assignment_expression]
	where
		AE [matchesVarID idNotify] [matchesVarID idNotifyAll]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	construct PlusOne [number]
		1

	import qPushMethIDCollection [repeat id]
	construct newMethodIDs [repeat id]
		qPushMethIDCollection [. methodID]
	export qPushMethIDCollection
		newMethodIDs

	import qCountPushMethIDs [number]
	construct NewCount [number]
		qCountPushMethIDs [+ PlusOne]
	export qCountPushMethIDs
		NewCount

	% import qCountUsedListIDs [number]
	% construct NewCountb [number]
		% qCountUsedListIDs [+ PlusOne]
	% export qCountUsedListIDs
		% NewCountb

	% import qCountProddObjIDs [number]
	% construct NewCountc [number]
		% qCountProddObjIDs [+ PlusOne]
	% export qCountProddObjIDs
		% NewCountc

	import tmpTypeSpecIDCollection [repeat id]
	import ProddObjTypeCollection [repeat id]
	export ProddObjTypeCollection
		tmpTypeSpecIDCollection

	export tmpTypeSpecIDCollection
		_

	import tmpRole2abPassed [number]
	construct NewCountd [number]
		tmpRole2abPassed [+ PlusOne]
	export tmpRole2abPassed
		NewCountd

	construct ProducerConsumerAnnotation2bcpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2bcpt2 [stringlit]
		", roleID=2bc, roleDescription='Nofification that the thread has completed.')"

	by
		'MUTATED /* ProducerConsumerAnnotation2bcpt1 [+ qCountPushMethIDs] [+ ProducerConsumerAnnotation2bcpt2] */
		EX ';
end rule

% //***ProducerConsumerPattern:  Role = 2c(Synchronized method to pull the produced objects from queue to be consumed.
% //								** Contains Role 2ca.
% //								** Contains Role 2cb.
% //								** Contains Role 2cc.
% //								** Contains Role 2cd.);
rule findPullMethod CH [class_header]

	import qCountPushMethIDs [number]
	construct numZero [number]
		'0
	where not
		qCountPushMethIDs [hasNumber numZero]

	replace [class_body]
		CIB [class_or_interface_body]

	% Check for list object used in 2ca, 2cb, 2cc.
	import qUsedListIDCollection [repeat id]
	where
		CIB [matchesVarID each qUsedListIDCollection]

	% Check for role 2cc
	construct removeID [id]
		'remove
	construct removeID2 [id]
		'removeRange
	construct removeID3 [id]
		'removeFirst
	construct removeID4 [id]
		'removeLast
	construct removeID5 [id]
		'removeAll
	construct removeID6 [id]
		'removeAllElements
	construct removeID7 [id]
		'removeElement
	construct removeID8 [id]
		'removeElementAt
	where
		CIB [matchesVarID removeID] [matchesVarID removeID2] [matchesVarID removeID3] [matchesVarID removeID4] [matchesVarID removeID5]
		[matchesVarID removeID6] [matchesVarID removeID7] [matchesVarID removeID8]

	%Check for role 2cb
	import ProddObjTypeCollection [repeat id]
	where
		CIB[matchesVarID each ProddObjTypeCollection]

	% Check for last part of role 2ca
	construct iSize [id]
		'size
	where
		CIB [matchesVarID iSize]

	construct TransformedCIB [class_or_interface_body]
		CIB [findPullMethodRole2c CH]

	by
		'MUTATED TransformedCIB
end rule

% //***ProducerConsumerPattern:  Role = 2c continued.
rule findPullMethodRole2c CH [class_header]

	import qCountPushMethIDs [number]
	construct numZero [number]
		'0
	where not
		qCountPushMethIDs [hasNumber numZero]

	construct  SYNCH [modifier]
		'synchronized
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	where
		RM [isMethodSynchronized SYNCH]

	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}

	import ProddObjTypeCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isListSizeChecked] [isWaitStmt] [isProdObjCreated each ProddObjTypeCollection] [isDataRemoveEx] [isConsObjRemd MD CH]

	import CountQueueClassIDs [number]
	where
		CountQueueClassIDs [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	construct removeID [id]
		'remove
	construct removeID2 [id]
		'removeRange
	construct removeID3 [id]
		'removeFirst
	construct removeID4 [id]
		'removeLast
	construct removeID5 [id]
		'removeAll
	construct removeID6 [id]
		'removeAllElements
	construct removeID7 [id]
		'removeElement
	construct removeID8 [id]
		'removeElementAt

	where
		MB [matchesVarID removeID] [matchesVarID removeID2] [matchesVarID removeID3] [matchesVarID removeID4] [matchesVarID removeID5]
		[matchesVarID removeID6] [matchesVarID removeID7] [matchesVarID removeID8]

	import qUsedListIDCollection [repeat id]
	where
		MB [matchesVarID each qUsedListIDCollection]%[matchesVarID each qPullMethIDCollection]

	construct ProducerConsumerAnnotation2cpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2cpt2 [stringlit]
		", roleID=2c, roleDescription='Synchronized method to pull the produced objects from queue to be consumed.')"

	by
		'MUTATED /* ProducerConsumerAnnotation2cpt1 [+ CountQueueClassIDs] [+ ProducerConsumerAnnotation2cpt2] */ RM TS MD OT TransformedMB
end rule

% //***ProducerConsumerPattern:  Role = 2ca(Check size of the queue of Role 2a.)
rule isListSizeChecked
	replace [assignment_expression]
		CE [conditional_expression]

	import qUsedListIDCollection [repeat id]
	where
		CE  [matchesVarID each qUsedListIDCollection]

	construct iSize [id]
		'size
	where
		CE [matchesVarID iSize]

	construct ProducerConsumerAnnotation2capt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2capt2 [stringlit]
		", roleID=2ca, roleDescription='Check size of the queue of Role 2a.')"

	import CountQueueClassIDs [number]
	construct tmpCountQueueClassIDs [number]
		CountQueueClassIDs [+ 1]

	by
		'MUTATED /* ProducerConsumerAnnotation2capt1 [+ tmpCountQueueClassIDs] [+ ProducerConsumerAnnotation2capt2] */ CE
end rule


% //***ProducerConsumerPattern:  Role = 2caa(Wait statement.);
rule isWaitStmt
	replace [expression]
		AE [assignment_expression]

	construct iWait [id]
		'wait
	where
		AE [matchesVarID iWait]

	construct ProducerConsumerAnnotation2caapt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2caapt2 [stringlit]
		", roleID=2caa, roleDescription='Wait statement.')"

	import CountQueueClassIDs [number]
	construct tmpCountQueueClassIDs [number]
		CountQueueClassIDs [+ 1]

	by
		'MUTATED /* ProducerConsumerAnnotation2caapt1 [+ tmpCountQueueClassIDs] [+ ProducerConsumerAnnotation2caapt2] */ AE
end rule

%OBSOLETE  //***ProducerConsumerPattern:  Role = 2cb(Creating instance of produced object and assigning it the 1st value in the list Role 2a.);
% //***ProducerConsumerPattern:  Role = 2cb(Creating instance of produced object.);
rule isProdObjCreated ProdObjTypeID [id]

	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		consObjID [id] OGP [opt generic_parameter]

	where all
		VDS [matchesVarID ProdObjTypeID]

	import tmpLocalConsObjID [id]
	export tmpLocalConsObjID
		consObjID

	construct ProducerConsumerAnnotation2cbpt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2cbpt2 [stringlit]
		", roleID=2cb, roleDescription='Creating instance of produced object and assigning it the 1st value in the arraylist Role 2a.')"

	import CountQueueClassIDs [number]
	construct tmpCountQueueClassIDs [number]
		CountQueueClassIDs [+ 1]

	by
		'MUTATED /* ProducerConsumerAnnotation2cbpt1 [+ tmpCountQueueClassIDs] [+ ProducerConsumerAnnotation2cbpt2] */ RM TS VDS ';

end rule

% //***ProducerConsumerPattern:  Role = 2cc(Remove the assigned value in Role 2cb from the list Role 2a.);
rule isDataRemoveEx
	replace [expression_statement]
		EX [expression] ';

	deconstruct EX
		AE [assignment_expression]

	construct removeID [id]
		'remove
	construct removeID2 [id]
		'removeRange
	construct removeID3 [id]
		'removeFirst
	construct removeID4 [id]
		'removeLast
	construct removeID5 [id]
		'removeAll
	construct removeID6 [id]
		'removeAllElements
	construct removeID7 [id]
		'removeElement
	construct removeID8 [id]
		'removeElementAt

	import qUsedListIDCollection [repeat id]
	where
		AE [matchesVarID each qUsedListIDCollection]%[matchesVarID each qPullMethIDCollection]

	where
		AE [matchesVarID removeID] [matchesVarID removeID2] [matchesVarID removeID3] [matchesVarID removeID4] [matchesVarID removeID5]
		[matchesVarID removeID6] [matchesVarID removeID7] [matchesVarID removeID8]


	construct ProducerConsumerAnnotation2ccpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2ccpt2 [stringlit]
		", roleID=2cc, roleDescription='Remove the assigned value in Role 2cb from the arraylist Role 2a.')"

	import CountQueueClassIDs [number]
	construct tmpCountQueueClassIDs [number]
		CountQueueClassIDs [+ 1]

	by
		'MUTATED /* ProducerConsumerAnnotation2ccpt1 [+ tmpCountQueueClassIDs] [+ ProducerConsumerAnnotation2ccpt2] */
		EX ';
end rule

% //***ProducerConsumerPattern:  Role = 2cd(Returning the produced object - to be consumed by Role 3.);
rule isConsObjRemd MD [method_declarator] CH [class_header]
	replace [return_statement]
		'return OE [opt expression] ';

	import tmpLocalConsObjID [id]

	where all
		OE [matchesVarID tmpLocalConsObjID]

	%-------------------------------------------------------------------------------------
	%-------------------------------------------------------------------------------------
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	deconstruct CH
		RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]

	import qPullMethIDCollection [repeat id]
	construct newMethodIDs [repeat id]
		qPullMethIDCollection [. methodID]
	export qPullMethIDCollection
		newMethodIDs

	import qCountPullMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		qCountPullMethIDs [+ PlusOne]
	export qCountPullMethIDs
		NewCount

	import QueueClassIDCollection [repeat id]
	construct newClassIDs [repeat id]
		QueueClassIDCollection [. classID]
	export QueueClassIDCollection
		newClassIDs

	import CountQueueClassIDs [number]
	construct PlusOneb [number]
		1
	construct NewCountb [number]
		CountQueueClassIDs [+ PlusOneb]
	export CountQueueClassIDs
		NewCountb
	%-------------------------------------------------------------------------------------
	%-------------------------------------------------------------------------------------

	construct ProducerConsumerAnnotation2cdpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation2cdpt2 [stringlit]
		", roleID=2cd, roleDescription='Returning the produced object - to be consumed by Role 3.')"

	by
		'MUTATED /* ProducerConsumerAnnotation2cdpt1 [+ CountQueueClassIDs] [+ ProducerConsumerAnnotation2cdpt2] */
		'return OE ';
end rule


% % //***ProducerConsumerPattern:  Role = 2c(Synchronized method to pull the produced objects from queue to be consumed.
% % //								** Contains Role 2ca.
% % //								** Contains Role 2cb.
% % //								** Contains Role 2cc.
% % //								** Contains Role 2cd.);
% rule findPullMethod2 CH [class_header]

	% import qCountPushMethIDs [number]
	% construct numZero [number]
		% '0
	% where not
		% qCountPushMethIDs [hasNumber numZero]

	% construct  SYNCH [modifier]
		% 'synchronized
	% replace [method_declaration]
		% RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	% where
		% RM [isMethodSynchronized SYNCH]

	% import qPullMethIDCollection [repeat id]
	% where
		% MB [matchesVarID each qPullMethIDCollection]

	% deconstruct MD
	    % MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	% deconstruct MN
		% DN [declared_name]
	% deconstruct DN
	   % methodID [id] OGP [opt generic_parameter]

	% deconstruct CH
		% RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	% deconstruct CN
		% DN2 [declared_name]
	% deconstruct DN2
	   % classID [id] OGP2 [opt generic_parameter]

	% import qPullMethIDCollection
	% construct newMethodIDs [repeat id]
		% qPullMethIDCollection [. methodID]
	% export qPullMethIDCollection
		% newMethodIDs

	% import qCountPullMethIDs [number]
	% construct PlusOne [number]
		% 1
	% construct NewCount [number]
		% qCountPullMethIDs [+ PlusOne]
	% export qCountPullMethIDs
		% NewCount

	% construct ProducerConsumerAnnotation2cpt1 [stringlit]
		% "@ProducerConsumerPatternAnnotation(patternInstanceID="
	% construct ProducerConsumerAnnotation2cpt2 [stringlit]
		% ", roleID=2c, roleDescription='Synchronized method to pull the produced objects from queue to be consumed.')"

	% by
		% 'MUTATED /* ProducerConsumerAnnotation2cpt1 [+ qCountPullMethIDs] [+ ProducerConsumerAnnotation2cpt2] */ RM TS MD OT MB
% end rule


% //***ProducerConsumerPattern:  Role = 1(Producer class - supply objects to be consumed by the Role 3, the Consumer class.
% //								** Contains Role 1a.
% //								** Contains Role 1b.
% //								** Contains Role 1c.);
rule FindProducerClass
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	import QueueClassIDCollection [repeat id]
	construct TransformedProdCB [class_body]
		CB [findProdLocalQuInstance each QueueClassIDCollection] [findProdObj CH]

	import tmpRole1Passed [number]
	where
		tmpRole1Passed [> 0]

	construct GuardedSuspensionAnnotation1pt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Producer class - supply objects to be consumed by the Role 3, the Consumer class.')"

	import CountProdrClassIDs [number]

	export tmpRole1Passed
		0
	import tmpLocalQueueID [id]
	export tmpLocalQueueID
		_
	import tmpLocalProdObjID [id]
	export tmpLocalProdObjID
		_

	by
		'MUTATED /* GuardedSuspensionAnnotation1pt1 [+ CountProdrClassIDs] [+ GuardedSuspensionAnnotation1pt2] */ CH TransformedProdCB
end rule


% //***ProducerConsumerPattern:  Role = 1a(local instance of Role 2, the Queue.);
rule findProdLocalQuInstance queueClassID [id]

	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [matchesVarID queueClassID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		localQueueID [id] OGP [opt generic_parameter]

	import tmpLocalQueueID [id]
	export tmpLocalQueueID
		localQueueID

	import tmpRole1Passed [number]
	% where
		% tmpRole1Passed [> 0]
	construct tmptmpRole1Passed [number]
		tmpRole1Passed [+ 1]

	construct GuardedSuspensionAnnotation1apt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation1apt2 [stringlit]
		", roleID=1a, roleDescription='Local instance of Role 2, the Queue.')"

	by
		'MUTATED /* GuardedSuspensionAnnotation1apt1 [+ tmptmpRole1Passed] [+ GuardedSuspensionAnnotation1apt2] */ RM TS VDS ';
end rule

% //***ProducerConsumerPattern:  Role = 1b(local instance of produced object.);
rule findProdObj CH [class_header]
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}

	import ProddObjTypeCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isProdObjDecl each ProddObjTypeCollection] [isProdObjPushd CH ]

	import tmpRole1Passed [number]
	where
		tmpRole1Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}

	construct TransformedMB [method_body]
		TransformedBL2

	% construct GuardedSuspensionAnnotation1bpt1 [stringlit]
		% "@GuardedSuspensionPatternAnnotation(patternInstanceID="
	% construct GuardedSuspensionAnnotation1bpt2 [stringlit]
		% ", roleID=1b, roleDescription='Ensuring a method in the class is synchronized - guarded')"

	% import CountProdrClassIDs [number]

	% by
		% 'MUTATED /* GuardedSuspensionAnnotation1bpt1 [+ CountProdrClassIDs] [+ GuardedSuspensionAnnotation1bpt2] */ RM TS MD OT TransformedMB
	by
		'MUTATED RM TS MD OT TransformedMB
end rule

% Role 1b continued...
rule isProdObjDecl ProdObjTypeID [id]
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [matchesVarID ProdObjTypeID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		prodObjID [id] OGP [opt generic_parameter]

	import tmpLocalProdObjID [id]
	export tmpLocalProdObjID
		prodObjID

	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [isProdObjPushd CH prodObjID localQueueID]

	import tmpRole1Passed [number]
	% where
		% tmpRole1Passed [> 0]
	construct tmptmpRole1Passed [number]
		tmpRole1Passed [+ 1]

	construct GuardedSuspensionAnnotation1bpt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation1bpt2 [stringlit]
		", roleID=1b, roleDescription='Local instance of produced object.')"

	by
		'MUTATED /* GuardedSuspensionAnnotation1bpt1 [+ tmptmpRole1Passed] [+ GuardedSuspensionAnnotation1bpt2] */ RM TS VDS ';

	% by
		% 'MUTATED RM TS VDS ';
end rule

% //***ProducerConsumerPattern:  Role = 1c(Call to push method of Role 1a, the local instance of the Queue.  Pushes Role 1b, the produced object);
rule isProdObjPushd CH [class_header]
	replace [expression_statement]
		EX [expression] ';

	% construct pushID [id]
		% 'push
	import tmpLocalQueueID [id]
	import tmpLocalProdObjID [id]
	import qPushMethIDCollection [repeat id]
	where all
		 EX [matchesVarID tmpLocalQueueID] [matchesVarID each qPushMethIDCollection] [matchesVarID tmpLocalProdObjID]

	deconstruct CH
		RM [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]

	import pQueueIDCollection [repeat id]
	construct newQueueIDs [repeat id]
		pQueueIDCollection [. tmpLocalQueueID]
	export pQueueIDCollection
		newQueueIDs

	construct PlusOne [number]
		1

	% import pCountQueueIDs [number]
	% construct NewCount [number]
		% pCountQueueIDs [+ PlusOne]
	% export pCountQueueIDs
		% NewCount

	import pProddObjIDCollection [repeat id]
	construct newProdObjIDs [repeat id]
		pProddObjIDCollection [. tmpLocalProdObjID]
	export pProddObjIDCollection
		newProdObjIDs

	% import pCountProdObjIDs [number]
	% construct NewCountb [number]
		% pCountProdObjIDs [+ PlusOne]
	% export pCountProdObjIDs
		% NewCountb

	import ProdrClassIDCollection [repeat id]
	construct newClassIDs [repeat id]
		ProdrClassIDCollection [. classID]
	export ProdrClassIDCollection
		newClassIDs

	import CountProdrClassIDs [number]
	construct NewCountc [number]
		CountProdrClassIDs [+ PlusOne]
	export CountProdrClassIDs
		NewCountc

	import tmpRole1Passed [number]
	construct NewCountd [number]
		tmpRole1Passed [+ PlusOne]
	export tmpRole1Passed
		NewCountd

	construct ProducerConsumerAnnotation1cpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation1cpt2 [stringlit]
		", roleID=1c, roleDescription='Call to push method of Role 1a, the local instance of the Queue.  Pushes Role 1b, the produced object.')"

	by
		'MUTATED /* ProducerConsumerAnnotation1cpt1 [+ tmpRole1Passed] [+ ProducerConsumerAnnotation1cpt2] */
		EX ';
end rule


% //***ProducerConsumerPattern:  Role = 3(Consumer class - use objects to be produced by the Role 1, the Producer class.
% //							** Contains Role 3a.
% //							** Contains Role 3b.
% //							** Contains Role 3c.);
rule FindConsumerClass
	% replace [class_declaration]
	    % CH [class_header] CB [class_body]
	% import QueueClassIDCollection [repeat id]
	% construct TransformedConsCB [class_body]
		% CB [findConsLocalQuInstance CB CH each QueueClassIDCollection]

	% import tmpRole3Passed [number]
	% where
		% tmpRole3Passed [> 0]


	% construct GuardedSuspensionAnnotation3pt1 [stringlit]
		% "@GuardedSuspensionPatternAnnotation(patternInstanceID="
	% construct GuardedSuspensionAnnotation3pt2 [stringlit]
		% ", roleID=3, roleDescription='Consumer class - use objects produced by the Role 1, the Producer class.')"

	% import CountConsrClassIDs [number]

	% export tmpRole3Passed
		% 0

	% by
		% 'MUTATED /* GuardedSuspensionAnnotation3pt1 [+ CountConsrClassIDs] [+ GuardedSuspensionAnnotation3pt2] */ CH TransformedConsCB
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	import QueueClassIDCollection [repeat id]
	construct TransformedProdCB [class_body]
		CB [findConsLocalQuInstance each QueueClassIDCollection] [findConsObj CH]

	import tmpRole3Passed [number]
	where
		tmpRole3Passed [> 0]

	construct GuardedSuspensionAnnotation3pt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Consumer class - use objects produced by the Role 1, the Producer class.')"

	import CountConsrClassIDs [number]

	export tmpRole3Passed
		0
	import tmpLocalQueueID [id]
	export tmpLocalQueueID
		_
	import tmpLocalProdObjTypeID [id]
	export tmpLocalProdObjTypeID
		_
	% import tmpLocalProdObjID [id]
	% export tmpLocalProdObjID
		% _

	by
		'MUTATED /* GuardedSuspensionAnnotation3pt1 [+ CountConsrClassIDs] [+ GuardedSuspensionAnnotation3pt2] */ CH TransformedProdCB

end rule


% //***ProducerConsumerPattern:  Role = 3a(local instance of Role 2, the Queue.);
rule findConsLocalQuInstance queueClassID [id]
	% replace [variable_declaration]
		% RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	% where
		 % TS [matchesVarID queueClassID]
	% deconstruct VDS
		% LVD [list variable_declarator+]
	% deconstruct LVD
		% VN [variable_name] OEVI [opt equals_variable_initializer]
	% deconstruct VN
		% DN [declared_name] RD [repeat dimension]
	% deconstruct DN
		% localQueueID [id] OGP [opt generic_parameter]

	% construct ProdObjFound [class_body]
		% CB [findConsObj CH localQueueID]

	% by
		% 'MUTATED RM TS VDS ';
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [matchesVarID queueClassID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		localQueueID [id] OGP [opt generic_parameter]

	import tmpLocalQueueID [id]
	export tmpLocalQueueID
		localQueueID

	import tmpRole3Passed [number]
	% where
		% tmpRole1Passed [> 0]
	construct tmptmpRole3Passed [number]
		tmpRole3Passed [+ 1]

	construct GuardedSuspensionAnnotation3apt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation3apt2 [stringlit]
		", roleID=3a, roleDescription='Local instance of Role 2, the Queue.')"

	by
		'MUTATED /* GuardedSuspensionAnnotation3apt1 [+ tmptmpRole3Passed] [+ GuardedSuspensionAnnotation3apt2] */ RM TS VDS ';


end rule


% //***ProducerConsumerPattern:  Role = 3b(local instance of consumed object.);
rule findConsObj CH [class_header]
	% replace [method_declaration]
		% RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	% deconstruct MB
        % BL2 [block]
	% deconstruct BL2
		% '{
			% RDS3 [repeat declaration_or_statement]
		% '}

	% import ProddObjTypeCollection [repeat id]
	% construct ProdObjDeclFound [repeat declaration_or_statement]
		% RDS3 [isConsObjDecl CH RDS3 localQueueID each ProddObjTypeCollection]

	% by
		% 'MUTATED RM TS MD OT MB

	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]

	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}

	import ProddObjTypeCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isConsObjDeclPulld CH each ProddObjTypeCollection] [isConsObjDecl each ProddObjTypeCollection] [isConsObjPulld CH]

	import tmpRole3Passed [number]
	where
		tmpRole3Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}

	construct TransformedMB [method_body]
		TransformedBL2

	by
		'MUTATED RM TS MD OT TransformedMB

end rule

% Role 3b and 3c
rule isConsObjDeclPulld CH [class_header] ProdObjTypeID [id]
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [matchesVarID ProdObjTypeID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		prodObjID [id] OGP [opt generic_parameter]

	deconstruct OEVI
		'= VI [variable_initializer]
	deconstruct VI
		EX [expression]

	import tmpLocalQueueID [id]
	where
		 EX [matchesVarID tmpLocalQueueID]

	import qPullMethIDCollection [repeat id]
	where
		 EX [matchesVarID each qPullMethIDCollection]

	deconstruct CH
		RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]

	import cQueueIDCollection [repeat id]
	construct newQueueIDs [repeat id]
		cQueueIDCollection [. tmpLocalQueueID]
	export cQueueIDCollection
		newQueueIDs

	construct PlusOne [number]
		1

	% import cCountQueueIDs [number]
	% construct NewCount [number]
		% cCountQueueIDs [+ PlusOne]
	% export cCountQueueIDs
		% NewCount

	import cProddObjIDCollection [repeat id]
	construct newProdObjIDs [repeat id]
		cProddObjIDCollection [. prodObjID]
	export cProddObjIDCollection
		newProdObjIDs

	% import cCountProdObjIDs [number]
	% construct NewCountb [number]
		% cCountProdObjIDs [+ PlusOne]
	% export cCountProdObjIDs
		% NewCountb

	import ConsrClassIDCollection [repeat id]
	construct newClassIDs [repeat id]
		ConsrClassIDCollection [. classID]
	export ConsrClassIDCollection
		newClassIDs

	import CountConsrClassIDs [number]
	construct NewCountc [number]
		CountConsrClassIDs [+ PlusOne]
	export CountConsrClassIDs
		NewCountc

	import CountProdrClassIDs [number]
	import CountQueueClassIDs [number]
	construct numZero [number]
		'0
	where not
		CountProdrClassIDs [hasNumber numZero]
	where not
		CountConsrClassIDs [hasNumber numZero]
	where not
		CountQueueClassIDs [hasNumber numZero]
	import Counter [number]
	construct NewCountd [number]
		Counter [+ PlusOne]
	export Counter
		NewCountd

	import tmpRole3Passed [number]
	construct NewCounte [number]
		tmpRole3Passed [+ PlusOne]
	export tmpRole3Passed
		NewCounte

	construct GuardedSuspensionAnnotation3bpt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation3bpt2 [stringlit]
		", roleID=3b, roleDescription='Local instance of consumed object.')"

	construct ProducerConsumerAnnotation3cpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation3cpt2 [stringlit]
		", roleID=3c, roleDescription='Call to pull method of Role 3a, the local instance of the Queue.  Pulls Role 3b, the object to be consumed.')"

	by
		'MUTATED /* GuardedSuspensionAnnotation3bpt1 [+ CountConsrClassIDs] [+ GuardedSuspensionAnnotation3bpt2] */
		 /* ProducerConsumerAnnotation3cpt1 [+ CountConsrClassIDs] [+ ProducerConsumerAnnotation3cpt2] */ RM TS VDS ';

end rule

% Role 3b continued...
rule isConsObjDecl ProdObjTypeID [id]
	% replace [variable_declaration]
		% RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	% where
		 % TS [matchesVarID ProdObjTypeID]
	% deconstruct VDS
		% LVD [list variable_declarator+]
	% deconstruct LVD
		% VN [variable_name] OEVI [opt equals_variable_initializer]
	% deconstruct VN
		% DN [declared_name] RD [repeat dimension]
	% deconstruct DN
		% prodObjID [id] OGP [opt generic_parameter]

	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [isConsObjPulld CH ProdObjTypeID localQueueID]
	% by
		% 'MUTATED RM TS VDS ';
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [matchesVarID ProdObjTypeID]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		prodObjID [id] OGP [opt generic_parameter]

	% import tmpLocalProdObjID [id]
	% export tmpLocalProdObjID
		% prodObjID
	import tmpLocalProdObjTypeID [id]
	export tmpLocalProdObjTypeID
		ProdObjTypeID

	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [isProdObjPushd CH prodObjID localQueueID]

	import tmpRole3Passed [number]
	% where
		% tmpRole1Passed [> 0]
	construct tmptmpRole3Passed [number]
		tmpRole3Passed [+ 1]

	construct GuardedSuspensionAnnotation3bpt1 [stringlit]
		"@GuardedSuspensionPatternAnnotation(patternInstanceID="
	construct GuardedSuspensionAnnotation3bpt2 [stringlit]
		", roleID=3b, roleDescription='Local instance of consumed object.')"

	by
		'MUTATED /* GuardedSuspensionAnnotation3bpt1 [+ tmptmpRole3Passed] [+ GuardedSuspensionAnnotation3bpt2] */ RM TS VDS ';
end rule


% //***ProducerConsumerPattern:  Role = 3c(Call to pull method of Role 3a, the local instance of the Queue.  Pulls Role 3b, the object to be consumed.);
rule isConsObjPulld CH [class_header]
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';

	import tmpLocalProdObjTypeID [id]
	where
		 TS [matchesVarID tmpLocalProdObjTypeID]

	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		prodObjID [id] OGP [opt generic_parameter]

	deconstruct OEVI
		'= VI [variable_initializer]
	deconstruct VI
		EX [expression]

	% construct pullID [id]
		% 'pull
	import tmpLocalQueueID [id]
	where
		 EX [matchesVarID tmpLocalQueueID]

	import qPullMethIDCollection [repeat id]
	where
		 EX [matchesVarID each qPullMethIDCollection]

	deconstruct CH
		RM2 [repeat modifier] 'class CN [class_name] OEC [opt extends_clause] OIC [opt implements_clause]
	deconstruct CN
		DN2 [declared_name]
	deconstruct DN2
	   classID [id] OGP2 [opt generic_parameter]

	import cQueueIDCollection [repeat id]
	construct newQueueIDs [repeat id]
		cQueueIDCollection [. tmpLocalQueueID]
	export cQueueIDCollection
		newQueueIDs

	construct PlusOne [number]
		1

	% import cCountQueueIDs [number]
	% construct NewCount [number]
		% cCountQueueIDs [+ PlusOne]
	% export cCountQueueIDs
		% NewCount

	import cProddObjIDCollection [repeat id]
	construct newProdObjIDs [repeat id]
		cProddObjIDCollection [. tmpLocalProdObjTypeID]
	export cProddObjIDCollection
		newProdObjIDs

	% import cCountProdObjIDs [number]
	% construct NewCountb [number]
		% cCountProdObjIDs [+ PlusOne]
	% export cCountProdObjIDs
		% NewCountb

	import ConsrClassIDCollection [repeat id]
	construct newClassIDs [repeat id]
		ConsrClassIDCollection [. classID]
	export ConsrClassIDCollection
		newClassIDs

	import CountConsrClassIDs [number]
	construct NewCountc [number]
		CountConsrClassIDs [+ PlusOne]
	export CountConsrClassIDs
		NewCountc

	import CountProdrClassIDs [number]
	import CountQueueClassIDs [number]
	construct numZero [number]
		'0
	where not
		CountProdrClassIDs [hasNumber numZero]
	where not
		CountConsrClassIDs [hasNumber numZero]
	where not
		CountQueueClassIDs [hasNumber numZero]
	import Counter [number]
	construct NewCountd [number]
		Counter [+ PlusOne]
	export Counter
		NewCountd

	import tmpRole3Passed [number]
	construct NewCounte [number]
		tmpRole3Passed [+ PlusOne]
	export tmpRole3Passed
		NewCounte

	construct ProducerConsumerAnnotation3cpt1 [stringlit]
		"@ProducerConsumerPatternAnnotation(patternInstanceID="
	construct ProducerConsumerAnnotation3cpt2 [stringlit]
		", roleID=3c, roleDescription='Call to pull method of Role 3a, the local instance of the Queue.  Pulls Role 3b, the object to be consumed.')"

	by
		'MUTATED /* ProducerConsumerAnnotation3cpt1 [+ tmpRole3Passed] [+ ProducerConsumerAnnotation3cpt2] */ RM TS VDS ';

	% by
		% 'MUTATED RM TS VDS ';
end rule


% Function to check if it is a variable of a specific type.
function isVarOfType VARTYPE [type_specifier]
	match * [type_specifier]
		VARTYPE
end function

% Function to check if the synchronized modifier is being used.
function isMethodSynchronized SYNCH [modifier]
	match * [modifier]
		SYNCH
end function

% Function to check if the synchronized modifier is being used by the "this" keyword.
function isMethodSynchdUsingThis THIS [expression]
	match * [expression]
		THIS
end function

% Function to check if there is a match to a variable ID.
function matchesVarID theID [id]
	match * [id]
		theID
end function

% Function to check if there is a match to an assignment operator.
function matchesAssignOp theAssignOp [assignment_operator]
	match * [assignment_operator]
		theAssignOp
end function

% Function to check if there is a match to one of the equality operators ('== | '!=).
function matchesEqOp theEqOp [equality_op]
	match * [equality_op]
		theEqOp
end function

% Function to check if there is a match to one of the relational operators ('<  | '> | '<= | '>=).
function matchesRelOp theRelOp [relational_op]
	match * [relational_op]
		theRelOp
end function

% Function to check if there is a match to one of the post_inc_dec operators ('++ | '--).
function matchesPostIncDec theOp [post_inc_dec]
	match * [post_inc_dec]
		theOp
end function

% Function to check if there is a match to the keyword "null".
function hasNull theNull [null_literal]
	match * [null_literal]
		theNull
end function

% Function to check if the expression exists in the statment.
function hasExpression theExpression [expression]
	match * [expression]
		theExpression
end function

% Function to check if the statement is a match.
function hasStmt stmtToMatch [statement]
	match * [statement]
		stmtToMatch
end function

% Function to check if there is a match to a specific number.
function hasNumber theNumber [number]
	match * [number]
		theNumber
end function

function hasWaitStmt idToMatch [id]
	match * [statement]
		'wait( idToMatch ');
end function



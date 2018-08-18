% Read Write Lock Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, February 25, 2011

include "Java.Grm"
% include "JavaCommentOverrides.Grm"

define labelM
	'MUTATED
end define

redefine annotation
	[annotation2]
end redefine

define annotation2
   [SPOFF] '@ [reference] [opt '@] [SPON] [opt annotation_value_spec] [NL]
end define

redefine class_declaration
	[class_declaration2]
    | [attr labelM] [class_header] [class_body]
    | [attr labelM] [NL] /* [stringlit] */ [NL] [class_header] [class_body]
end redefine

define class_declaration2
    [class_header] [class_body]
end define

redefine method_declaration
	[method_declaration2]
	| [attr labelM] [method_declaration2]
	| [attr labelM] [NL] /* [stringlit] */ [NL] [method_declaration2]
end redefine

define method_declaration2
    [repeat modifier] [type_specifier] [method_declarator] [opt throws] [method_body]
end define

redefine variable_declaration
	[variable_declaration2]
    | [attr labelM] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
	| [attr labelM] [NL] /* [stringlit] */ [NL] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end redefine

define variable_declaration2
    [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end define

redefine synchronized_statement
 	[synchronized_statement2]
	| [attr labelM] 
    'synchronized '( [expression] ')
        [statement]                  [NL]
	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

define synchronized_statement2
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

redefine if_statement
	[if_statement2]
    | 'if '( [expression] ') 
		[statement]
    [opt else_clause]      [NL]
	| [attr labelM]
	'if '( [expression] ') 
		[statement]
    [opt else_clause]      [NL] 
	| [attr labelM] [NL] /* [stringlit] */ [NL]
	'if '( [expression] ') 
		[statement]
    [opt else_clause]      [NL]
end redefine

define if_statement2
    'if '( [expression] ')     
        [statement]
    [opt else_clause]      [NL]
end define

redefine else_clause
	[else_clause2]
    | 'else
 	'{
       [statement]
	'}
end redefine

define else_clause2
    'else
        [statement]
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
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
	'while '( [expression] ') 
	'{
		[statement]     
	'}
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
	'while '( [expression] ') 
	'{
		[NL] /* [stringlit] */ [NL]
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
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';  
 	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'do
	'{
		[NL] /* [stringlit] */ [NL]
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
	| [attr labelM] [NL] /* [stringlit] */ [NL] 
	[expression] ';
end redefine

define expression_statement2
    [expression] ';
end define

redefine return_statement
 	[return_statement2]
	| [attr labelM] [NL] /* [stringlit] */ [NL] 
    'return [opt expression] ';      [NL]
end redefine

define return_statement2
    'return [opt expression] ';      [NL]
end define

% redefine return_statement
 	% [return_statement2]
	% | [attr labelM] [NL] /* [stringlit] */ [NL] 
    % 'return [opt expression] ';      [NL]
% end redefine

% define return_statement2
    % 'return [opt expression] ';      [NL]
% end define


function main
	export Counter [number]
		0
	export CountRLMethodIDs [number]
		0
	export CountWLMethodIDs [number]
		0
	export CountDoneMethodIDs [number]
		0	
		
	export tmpRole1Passed [number]
		0
	export tmpRole1aPassed [number]
		0
	% export tmpRole1aaPassed [number]
		% 0
	% export tmpRole1abPassed [number]
		% 0
	% export tmpRole1abaPassed [number]
		% 0
	% export tmpRole1acPassed [number]
		% 0
	% export tmpRole1bPassed [number]
		% 0
	export tmpRole2Passed [number]
		0
	% export tmpRole2aPassed [number]
		% 0
	export tmpRole2bPassed [number]
		0
	% export tmpRole2baPassed [number]
		% 0
	% export tmpRole2baaPassed [number]
		% 0
	% export tmpRole2babPassed [number]
		% 0
	% export tmpRole2bacPassed [number]
		% 0
	% export tmpRole2badPassed [number]
		% 0
	% export tmpRole2cPassed [number]
		% 0
	% export tmpRole2caPassed [number]
		% 0
	% export tmpRole2caaPassed [number]
		% 0
	% export tmpRole2dPassed [number]
		% 0
	% export tmpRole2daPassed [number]
		% 0
	export tmpRole3Passed [number]
		0
	export tmpIsOutStdRLGTZeroPassed [number]
		0
	export tmpIsOutStdRLDecrPassed [number]
		0
	export tmpGetIfStmtOSRLZeroWFWLSizePassed [number]
		0
	export tmpIsOSRLZeroWFWLSizeGTZeroPassed [number]
		0
	export tmpIsWLThNotifyAllPassed [number]
		0
	export tmpIsWLThAssignedWaitingThPassed [number]
		0
	export tmpGetIfStmtOSRLZeroWFWLSize2Passed [number]
		0
	export tmpisOSRLZeroWFWLSizeGTZero2Passed [number]
		0
 	export tmpisWLThAssignedWaitingTh2Passed [number]
		0
  	export tmpisWLThNotifyAll2Passed [number]
		0
   	export tmpgetWLAssignNullPassed [number]
		0
   	export tmpgetIfWaitForRLThGTZero [number]
		0
	% export tmpRole3aPassed [number]
		% 0
	export tmpThreadID [id]		
		_
	export tmpIntVarID [id]		
		_
	export tmpWLThreadID [id]
		_
	export tmpNewThreadID [id]
		_
	export tmpArrListID [id]
		_
	export tmpDoneIntVarID [id]
		_
	export tmpDoneArrListID [id]
		_
	export tmpDoneUsedThreadID [id]
		_
	
	export threadIdCollection [repeat id]
		_
	export intIdCollection [repeat id]
		_
	export arrListIdCollection [repeat id]
		_
 	export RLMethodIDs [repeat id]
		_
 	export WLMethodIDs [repeat id]
		_
 	export DoneMethodIDs [repeat id]
		_
	export usedThreadIdCollectionWL [repeat id]
		_
	export usedIntIdCollectionWaitRL [repeat id]
		_
	export usedIntIdCollectionOutStandRL [repeat id]
		_
	export usedArrListIdCollection [repeat id]
		_
   replace [program]
        P [program]		
	construct TransformedProgram [stringlit]
		"TransformedForReadWriteLockPatt.java"
	by
		P [getAllIntVars] [getAllArrayListVars] [getAllThreadVars] [findReadWriteLockPattern] 
		[printOutput] [printRLMethodIDs] [printWLMethodIDs] [printDoneMethodIDs] [printWLThreadIDs] [printWaitForRLCounterIDs] [printOutStdRLCounterIDs]
		[fput TransformedProgram]
		% P [getAllIntVars] [getAllArrayListVars] [getAllThreadVars] [findReadWriteLockPattern] 
		% [printPatternNotFound] [printOutput] [printRLMethodIDs] [printWLMethodIDs] [printDoneMethodIDs] [printWLThreadIDs] [printWaitForRLCounterIDs] [printOutStdRLCounterIDs]
		% [fput TransformedProgram]
end function

function printPatternNotFound
	replace [program]
		P [program]
	
	import Counter [number]
	
	where
		Counter [= 0]
	
	construct InstanceFound [stringlit]
		"*** No instances of Read Write Lock Pattern found. "
	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	
	by 
		P
end function

% Function print out the number of ReadWriteLock design pattern instances found.
function printOutput
	replace [program]
		P [program]	
	import Counter [number]	
	% where
		% Counter [> 0]	
	construct InstanceFound [stringlit]
		"** Complete instances of ReadWriteLock Pattern found = "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]	
	by 
		P
end function

% Function to print out the names of the readlock methods that are used within the ReadWriteLock design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printRLMethodIDs
	replace [program]
		P [program]	
	import RLMethodIDs [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	import CountRLMethodIDs [number]	
	where
		CountRLMethodIDs [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 1.  Read Lock methods instances used within the instance of the ReadWriteLock Design Pattern:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintRLMethodIDs each RLMethodIDs]
	by 
		P
end function

% Function to aid in the printing of the method names in the function "printRLMethodIDs".
function thePrintRLMethodIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function

% Function to print out the names of the writelock methods that are used within the ReadWriteLock design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printWLMethodIDs
	replace [program]
		P [program]	
	import WLMethodIDs [repeat id]
	import CountWLMethodIDs [number]	
	where
		CountWLMethodIDs [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 2.  Write Lock methods instances used within the instance of the ReadWriteLock Design Pattern:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintWLMethodIDs each WLMethodIDs]
	by 
		P
end function

% Function to aid in the printing of the method names in the function "printWLMethodIDs".
function thePrintWLMethodIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function

% Function to print out the names of the done methods that are used within the ReadWriteLock design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printDoneMethodIDs
	replace [program]
		P [program]	
	import DoneMethodIDs [repeat id]
	import CountDoneMethodIDs [number]	
	where
		CountDoneMethodIDs [> 0]	
	construct InstanceFound [stringlit]
		"** ROLE 3.  Done methods instances used within the instance of the ReadWriteLock Design Pattern:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintDoneMethodIDs each DoneMethodIDs]
	by 
		P
end function

% Function to aid in the printing of the method names in the function "printDoneMethodIDs".
function thePrintDoneMethodIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function

% Function to print out the names of the Write Lock thread used in the methods printed out in the "printRLMethodIDs" function.
% The number of these threads should equal the number of ReadLock method names printed out in the "printRLMethodIDs" function.
function printWLThreadIDs
	replace [program]
		P [program]	
	import usedThreadIdCollectionWL [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	construct InstanceFound [stringlit]
		"** Methods above respectively use the following WriteLock thread:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintWLThreadIDs each usedThreadIdCollectionWL]
	by 
		P
end function

% Function to aid in the printing of the Write Lock thread names in the function "printWLThreadIDs".
function thePrintWLThreadIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function

% Function to print out the names of the variables holding the count of number of threads waiting to get a read lock 
% (used in the Read Lock methods printed out in the "printRLMethodIDs" function).
% The number of these variables should equal the number of ReadLock method names printed out in the "printRLMethodIDs" function.
function printWaitForRLCounterIDs
	replace [program]
		P [program]	
	import usedIntIdCollectionWaitRL [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	construct InstanceFound [stringlit]
		"** Methods above respectively use the following variables holding the count of number of threads waiting to get a read lock:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintWaitForRLCounterIDs each usedIntIdCollectionWaitRL]
	by 
		P
end function

% Function to aid in the printing of the counter variable names in the function "printWaitForRLCounterIDs".
function thePrintWaitForRLCounterIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function

% Function to print out the names of the variables holding the count of number of read locks issued but have not yet been released by the threads they were issued to 
% (used in the Read Lock methods printed out in the "printRLMethodIDs" function).
% The number of these variables should equal the number of ReadLock method names printed out in the "printRLMethodIDs" function.
function printOutStdRLCounterIDs
	replace [program]
		P [program]	
	import usedIntIdCollectionOutStandRL [repeat id]
	% import Counter [number]	
	% where
		% Counter [> 0]	
	construct InstanceFound [stringlit]
		"** Methods above respectively use the following variables holding the count of number of read locks issued but have not yet been released by the threads they were issued to:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [program]
		_ [thePrintOutStdRLCounterIDs each usedIntIdCollectionOutStandRL]
	by 
		P
end function

% Function to aid in the printing of the counter variable names in the function "printOutStdRLCounterIDs".
function thePrintOutStdRLCounterIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [program]
		P [program]
	by
		P	
end function

% //*** ReadWriteLockPattern:  Role = Counter declaration outside of any methods within Role 1 (will contain count of number of read locks issued but have not yet 
					% been released by the threads they were issued to).);
% Function to obtain all integer variables declared within the ReadWriteLock class (at the top level i.e. not within any methods of the class) in the Java program hence obtaining:
% 1) All possible counters within the class that will contain the count of the number of threads waiting to get the read lock.
% 2) All possible counters within the class that will contain the count of the number of read locks issued but have not yet been released by the threads they were issued to.
rule getAllIntVars
	construct  VARTYPE [type_specifier]
		'int
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]    
	import intIdCollection [repeat id]
	construct newIDCollection [repeat id]
		intIdCollection [. flagID]
	export intIdCollection
		newIDCollection
	by
		'MUTATED RM TS VDS ';
end rule

% //*** ReadWriteLockPattern:  Arraylist declaration outside of any methods within Role 1 (will contain a list of threads waiting to get a write lock).
% Function to obtain all arraylist variables declared within the ReadWriteLock class (at the top level i.e. not within any methods of the class) in the Java program hence obtaining
% all possible lists within the class that will contain a list of threads waiting to get a write lock.
rule getAllArrayListVars
	construct  VARTYPE [type_specifier]
		'ArrayList
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]    
	import arrListIdCollection [repeat id]
	construct newIDCollection [repeat id]
		arrListIdCollection [. flagID]
	export arrListIdCollection
		newIDCollection
	by
		'MUTATED RM TS VDS ';
end rule

% //*** ReadWriteLockPattern:  Thread creation outside of any methods within Role 1 (will contain the thread that currently has the write lock and 
		% will be null when no thread has the write lock).
% Function to obtain all thread variables declared within the ReadWriteLock class (at the top level i.e. not within any methods of the class) in the Java program hence obtaining
% all possible threads within the class that will currently have the write lock (and will be null when no thread has the write lock).
rule getAllThreadVars
	construct  VARTYPE [type_specifier]
		'Thread
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where 
		 TS [isVarOfType VARTYPE]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]    
	import threadIdCollection [repeat id]
	construct newIDCollection [repeat id]
		threadIdCollection [. flagID]
	export threadIdCollection
		newIDCollection
	by
		'MUTATED RM TS VDS ';
end rule


% //*********************************************************************************//
% //*** Read/Write Lock pattern allows for concurrent reads but exclusive writes. ***//
% //*********************************************************************************//
% rule findReadWriteLockPattern
	% replace [class_declaration]
	    % CH [class_header] CB [class_body]
	% construct RLInstanceFound [class_body]
		% CB [findReadLockSynchMeth] [findReadLockSynchMeth2]
	% construct WLInstanceFound [class_body]
		% CB [findWriteLockSynchMeth]
	% construct DoneInstanceFound [class_body]
		% CB [findDoneSynchMeth] [findDoneSynchMeth2]
	% by
		% 'MUTATED CH CB
% end rule
rule findReadWriteLockPattern
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	construct TransformedCB [class_body]
		CB [findReadLockSynchMeth] [findReadLockSynchMeth2] [findWriteLockSynchMeth] [findDoneSynchMeth] [findDoneSynchMeth2]
		
	by
		'MUTATED CH TransformedCB
	% import Counter [number]
	% where 
		% Counter [> 0]
		
	% construct ReadWriteLockAnnotation1pt1 [stringlit]
		% "@ReadWriteLockPatternAnnotation(patternInstanceID="
	% construct ReadWriteLockAnnotation1pt2 [stringlit]
		% ", roleID=1, roleDescription='ReadWriteLock object/class.')"	

	% by
		% 'MUTATED /* ReadWriteLockAnnotation1pt1 [+ Counter] [+ ReadWriteLockAnnotation1pt2] */ CH TransformedCB
end rule


% //*** ReadWriteLockPattern:  Role = 1(Synchronized method to issue a read lock.
% //							** Contains Role 1a
% //							** Contains Role 1b);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a read lock.
rule findReadLockSynchMeth
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
	deconstruct RDS3
		DS [declaration_or_statement]
		RDS4 [repeat declaration_or_statement]   
		
	construct TransformedDS [declaration_or_statement]
		DS [getIfStmtRL]
		
	import tmpRole1aPassed [number]
	where
		tmpRole1aPassed [> 0]
		
	import intIdCollection [repeat id]		
	construct TransformedRDS4 [repeat declaration_or_statement]
		RDS4 [isIntVarOutStdRLIncr MD RDS4 each intIdCollection]
	
	import tmpRole1Passed [number]	
	where
		tmpRole1Passed [> 0]
		
	export tmpThreadID [id]		
		_
	export tmpIntVarID [id]		
		_

	construct TransformedRDS3 [repeat declaration_or_statement]
		TransformedDS 
		TransformedRDS4    
	
	construct TransformedBL2 [block] 
		'{                                        
			TransformedRDS3   
		'}	
	construct TransformedMB [method_body]
        TransformedBL2  		 
		
	construct ReadWriteLockAnnotation1pt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Synchronized method to issue a read lock.')"	
		
	export tmpRole1aPassed 
		0
	export tmpRole1Passed 
		0
		
	import CountRLMethodIDs [number]	
	where 
		CountRLMethodIDs [> 0]
		
	by
		'MUTATED /* ReadWriteLockAnnotation1pt1 [+ CountRLMethodIDs] [+ ReadWriteLockAnnotation1pt2] */ RM TS MD OT TransformedMB 
end rule

% //*** ReadWriteLockPattern:  Role = 1(Synchronized method to issue a read lock.
% //							** Contains Role 1a
% //							** Contains Role 1b);
% Second Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a read lock.
rule findReadLockSynchMeth2
	construct  THIS [expression]
		'this		
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]		
	deconstruct MB
        BL [block]  		
	deconstruct BL
	    '{                                       
			RDS [repeat declaration_or_statement] 
		'}			
	deconstruct RDS
		STMT [statement]
		RDS2 [repeat declaration_or_statement]		
	deconstruct STMT
		SSTMT [synchronized_statement]		
	deconstruct SSTMT
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
	deconstruct RDS3
		DS [declaration_or_statement]
		RDS4 [repeat declaration_or_statement]   
		
	construct TransformedDS [declaration_or_statement]
		DS [getIfStmtRL]
		
	import tmpRole1aPassed [number]
	where
		tmpRole1aPassed [> 0]
		
	import intIdCollection [repeat id]		
	construct TransformedRDS4 [repeat declaration_or_statement]
		RDS4 [isIntVarOutStdRLIncr MD RDS4 each intIdCollection]
	
	import tmpRole1Passed [number]	
	where
		tmpRole1Passed [> 0]
		
	export tmpThreadID [id]		
		_
	export tmpIntVarID [id]		
		_

	construct TransformedRDS3 [repeat declaration_or_statement]
		TransformedDS 
		TransformedRDS4    
	
	construct TransformedBL2 [block] 
		'{                                        
			TransformedRDS3   
		'}	
	construct TransformedSSTMT [synchronized_statement]
	    'synchronized '( EX ')
			TransformedBL2 		
	construct TransformedSTMT [statement]
		TransformedSSTMT		
	construct TransformedRDS [repeat declaration_or_statement]
		TransformedSTMT
		RDS2 		
	construct TransformedBL [block]
	    '{                                       
			TransformedRDS
		'}			
	construct TransformedMB [method_body]
        TransformedBL  		 
		
	construct ReadWriteLockAnnotation1pt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Synchronized method to issue a read lock.')"	
		
	export tmpRole1aPassed 
		0
	export tmpRole1Passed 
		0
		
	import CountRLMethodIDs [number]	
	where 
		CountRLMethodIDs [> 0]
		
	by
		'MUTATED /* ReadWriteLockAnnotation1pt1 [+ CountRLMethodIDs] [+ ReadWriteLockAnnotation1pt2] */ RM TS MD OT TransformedMB 	
end rule

% Called from within findReadLockSynchMeth and findReadLockSynchMeth2 to check if there is an if-statement
% //*** ReadWriteLockPattern:  Role = 1a(Boolean check if the designated thread has the write lock.
% ///							** If true i.e. a thread has the write lock then processing continues to Role 1aa and then Role 1ab.
% //							** If false then processing continues to 1b.);
rule getIfStmtRL 
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	import threadIdCollection [repeat id]
	import intIdCollection [repeat id]		
		
	construct InstanceFound [expression]
		EX2 [isWriteLockThreadCheckExp EX2 each threadIdCollection]
	
	construct TransformedIfExpSTMT [statement]
		ifExpSTMT [isIntVarWaitRLIncr each intIdCollection]
			[isWhileLpWaitforWriteLock] [isDoWhileLpWaitforWriteLock]
			[isIntVarWaitRLDecr]
			
	import tmpRole1aPassed [number]
	where
		tmpRole1aPassed [> 0]

	construct ReadWriteLockAnnotation1apt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1apt2 [stringlit]
		", roleID=1a, roleDescription='Boolean check if the designated writeLockedThread has the write lock.')"	
	
	import CountRLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountRLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation1apt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1apt2] */ 
		'if '( EX2 ')     
		'{
			TransformedIfExpSTMT 
		'}
		OEC 		
end rule

% //*** ReadWriteLockPattern:  Role = 1a(Boolean check if the designated thread has the write lock.
% ///							** If true i.e. a thread has the write lock then processing continues to Role 1aa and then Role 1ab.
% //							** If false then processing continues to 1b.);
function isWriteLockThreadCheckExp EX2 [expression] threadID [id]
	replace [expression]
		EX2
	construct theNull [null_literal]
		'null		
	where all
		EX2 [matchesVarID threadID] [hasNull theNull]
		
	import tmpThreadID [id]		
	export tmpThreadID	
		threadID
		
	% import intIdCollection [repeat id]		
	% construct InstanceFound [statement]
		% ifExpSTMT [isIntVarWaitRLIncr ifExpSTMT MD threadID RDS4 each intIdCollection]
		
	by
		EX2
			
end function

% //*** ReadWriteLockPattern:  Role = 1aa(Increment designated counter variable by 1.);
rule isIntVarWaitRLIncr intVarID [id]
	replace [expression_statement]
		EX [expression] '; 
		
	construct incExpression1 [expression]
		intVarID '++
	construct incExpression2 [expression]
		'++ intVarID 
	construct incExpression3 [expression]
		intVarID '+=1
	construct incExpression4 [expression]
		intVarID '+1
		
	construct waitRLIncrExpStmt [statement]
		EX '; 
		
	where
		waitRLIncrExpStmt [hasExpression incExpression1] [hasExpression incExpression2] [hasExpression incExpression3] [hasExpression incExpression4]
		
	import tmpIntVarID [id]		
	export tmpIntVarID
		intVarID
		
	% construct InstanceFound [statement]
		% ifExpSTMT [isWhileLpWaitforWriteLock ifExpSTMT MD threadID intVarID RDS4] [isDoWhileLpWaitforWriteLock ifExpSTMT MD threadID intVarID RDS4]

	construct ReadWriteLockAnnotation1aapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1aapt2 [stringlit]
		", roleID=1aa, roleDescription='Increment designated waitingForReadLock counter variable by 1.')"	
	
	import CountRLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountRLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation1aapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1aapt2] */ 
		EX '; 
end rule

% //*** ReadWriteLockPattern:  Role = 1ab(Loop iteratively checking if the designated thread has the write lock.);
% //							** As long as true i.e. a thread has the write lock Role 1aba occurs
% //							** When condition becomes false processing continues to Role 1ac.);
% //*** ReadWriteLockPattern:  Role = 1aba(wait() is called to pause further processing);
rule isWhileLpWaitforWriteLock 
	replace [while_statement]
	    'while '( EX [expression] ') 
			STMT [statement]                     

	construct theNull [null_literal]
		'null	        
	import tmpThreadID [id]		
	where all
		EX [matchesVarID tmpThreadID] [hasNull theNull]
		
	construct waitStmt [statement]
		'wait();
	where
		STMT [hasStmt waitStmt]
		
	% construct InstanceFound [statement]
		% ifExpSTMT [isIntVarWaitRLDecr MD threadID intVarID RDS4]

	construct ReadWriteLockAnnotation1abpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1abpt2 [stringlit]
		", roleID=1ab, roleDescription='Loop iteratively checking if the designated writeLockedThread has the write lock.')"	

	construct ReadWriteLockAnnotation1abapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1abapt2 [stringlit]
		", roleID=1aba, roleDescription='wait() is called to pause further processing.')"	
	
	import CountRLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountRLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation1abpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1abpt2] */ 
	    'while '( EX ') 
		{
			/* ReadWriteLockAnnotation1abapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1abapt2] */ 
			STMT                     
		}
		
		% 'MUTATED /* GuardedSuspensionAnnotation2apt1 [+ Counter] [+ GuardedSuspensionAnnotation2apt2] */
	    % 'while '( EX ') 
		% {
			% /* GuardedSuspensionAnnotation2aapt1 [+ Counter] [+ GuardedSuspensionAnnotation2aapt2] */
			% STMT                     
		% }

end rule

% //*** ReadWriteLockPattern:  Role = 1ab(Loop iteratively checking if the designated thread has the write lock.);
% //							** As long as true i.e. a thread has the write lock Role 1aba occurs
% //							** When condition becomes false processing continues to Role 1ac.);
% //*** ReadWriteLockPattern:  Role = 1aba(wait() is called to pause further processing);
rule isDoWhileLpWaitforWriteLock 
	replace [do_statement]
		'do
			 STMT [statement]
		'while '( EX [expression] ') '; 			

	construct theNull [null_literal]
		'null	        
	import tmpThreadID [id]		
	where all
		EX [matchesVarID tmpThreadID] [hasNull theNull]
		
	construct waitStmt [statement]
		'wait();
	where
		STMT [hasStmt waitStmt]
		
	% construct InstanceFound [statement]
		% ifExpSTMT [isIntVarWaitRLDecr MD threadID intVarID RDS4]

	construct ReadWriteLockAnnotation1abpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1abpt2 [stringlit]
		", roleID=1ab, roleDescription='Loop iteratively checking if the designated writeLockedThread has the write lock.')"	

	construct ReadWriteLockAnnotation1abapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1abapt2 [stringlit]
		", roleID=1aba, roleDescription='wait() is called to pause further processing.')"	
	
	import CountRLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountRLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation1abpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1abpt2] */ 
		'do
		{
			/* ReadWriteLockAnnotation1abapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1abapt2] */ 
			STMT
		}
		'while '( EX ') '; 			
end rule

% //*** ReadWriteLockPattern:  Role = 1ac(Decrement designated counter variable by 1.);
rule isIntVarWaitRLDecr 
	replace [expression_statement]
		EX [expression] '; 
	
	import tmpIntVarID [id]		
	
	construct decExpression1 [expression]
		tmpIntVarID '--
	construct decExpression2 [expression]
		'-- tmpIntVarID 
	construct decExpression3 [expression]
		tmpIntVarID '-=1
	construct decExpression4 [expression]
		tmpIntVarID '-1
		
	construct waitRLDecrExpStmt [statement]
		EX '; 
		
	where
		waitRLDecrExpStmt [hasExpression decExpression1] [hasExpression decExpression2] [hasExpression decExpression3] [hasExpression decExpression4]
		
	construct PlusOne [number]
		1
	import tmpRole1aPassed [number]
	construct NewCount [number]
		tmpRole1aPassed [+ PlusOne]
	export tmpRole1aPassed
		NewCount	
				
	% import intIdCollection [repeat id]		
	% construct InstanceFound [repeat declaration_or_statement]
		% RDS4 [isIntVarOutStdRLIncr MD threadID intVarID RDS4 each intIdCollection]
		
	construct ReadWriteLockAnnotation1acpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1acpt2 [stringlit]
		", roleID=1ac, roleDescription='Decrement designated waitingForReadLock counter variable by 1.')"	
	
	import CountRLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountRLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation1acpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation1acpt2] */ 
		EX '; 
end rule

% //*** ReadWriteLockPattern:  Role = 1b(Increment counter variable by 1.);
rule isIntVarOutStdRLIncr MD [method_declarator] RDS4 [repeat declaration_or_statement] secondIntVarID [id]
	replace [expression_statement]
		EX [expression] '; 
		
	import tmpIntVarID [id]		
	import tmpThreadID [id]		

	where not
		tmpIntVarID [= secondIntVarID]
		
	construct incExpression1 [expression]
		secondIntVarID '++
	construct incExpression2 [expression]
		'++ secondIntVarID 
	construct incExpression3 [expression]
		secondIntVarID '+=1
	construct incExpression4 [expression]
		secondIntVarID '+1
	
	where
		RDS4 [hasExpression incExpression1] [hasExpression incExpression2] [hasExpression incExpression3] [hasExpression incExpression4]
		
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	import RLMethodIDs [repeat id]
	construct newRLMethodIDs [repeat id]
		RLMethodIDs [. methodID]
	export RLMethodIDs
		newRLMethodIDs
		
	construct PlusOne [number]
		1
		
	import CountRLMethodIDs [number]
	construct NewCount [number]
		CountRLMethodIDs [+ PlusOne]
	export CountRLMethodIDs
		NewCount	
		
	import tmpRole1Passed [number]
	construct NewCountb [number]
		tmpRole1Passed [+ PlusOne]
	export tmpRole1Passed
		NewCountb	
		
		
	import usedThreadIdCollectionWL [repeat id]
	construct newThreadIdCollection [repeat id]
		usedThreadIdCollectionWL [. tmpThreadID]
	export usedThreadIdCollectionWL
		newThreadIdCollection
		
	import usedIntIdCollectionWaitRL [repeat id]
	construct newIntIdCollectionWRL [repeat id]
		usedIntIdCollectionWaitRL [. tmpIntVarID]
	export usedIntIdCollectionWaitRL
		newIntIdCollectionWRL
		
	import usedIntIdCollectionOutStandRL [repeat id]
	construct newIntIdCollectionORL [repeat id]
		usedIntIdCollectionOutStandRL [. secondIntVarID]
	export usedIntIdCollectionOutStandRL
		newIntIdCollectionORL

	% tmpRole1Passed

	construct ReadWriteLockAnnotation1bpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation1bpt2 [stringlit]
		", roleID=1b, roleDescription='Increment designated outstandingReadLocks counter variable by 1.')"	
	
	by
		'MUTATED /* ReadWriteLockAnnotation1bpt1 [+ CountRLMethodIDs] [+ ReadWriteLockAnnotation1bpt2] */ 
		EX '; 
end rule


% //*** ReadWriteLockPattern:  Role = 2(Method to issue a write lock.
% //							** Contains Role 2a
% //							** Contains Role 2b
% //							** Contains Role 2c
% //							** Contains Role 2d);     
rule findWriteLockSynchMeth
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]		
	deconstruct MB
        BL [block]  
	construct TransformedBL [block]
		BL [obtain1stSychStmtfromBL BL MD] 
		[obtain2ndSychStmtfromBL]	
		[obtain3rdSychStmtfromBL MD]
		
	import tmpRole2Passed [number]	
	where
		tmpRole2Passed [> 0]
		
	construct TransformedMB [method_body]
        TransformedBL  		 
		
	construct ReadWriteLockAnnotation2pt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Method to issue a write lock.')"	

	export tmpRole2Passed 
		0
	import tmpWLThreadID [id]	
	export tmpWLThreadID
		_
	import tmpNewThreadID [id]
	export tmpNewThreadID
		_
	import tmpArrListID [id]
	export tmpArrListID
		_
	
	import CountWLMethodIDs [number]	
	where 
		CountWLMethodIDs [> 0]
		
	by
		'MUTATED /* ReadWriteLockAnnotation2pt1 [+ CountWLMethodIDs] [+ ReadWriteLockAnnotation2pt2] */ RM TS MD OT TransformedMB 	

end rule

% //*** ReadWriteLockPattern:  Role = 2b(Critical section creation by synchronization of this Read/Write Lock object Role 1.
% //							** Contains Role 2ba);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a write lock.
rule obtain1stSychStmtfromBL BL [block] MD [method_declarator] 
	construct  THIS [expression]
		'this		
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	import threadIdCollection [repeat id]
	import arrListIdCollection [repeat id]	
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getIfStmtWL] 
		[isNewThrdAssignedCurrThrd each threadIdCollection] 
		[isNewThrdAddedtoWLWaitingArr each arrListIdCollection]
	
	import tmpRole2bPassed [number]	
	where
		tmpRole2bPassed [> 0]
	
	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3   
		'}	
		
	construct ReadWriteLockAnnotation2bpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2bpt2 [stringlit]
		", roleID=2b, roleDescription='Critical section creation by synchronization of this writeLock method.')"	
	
	export tmpRole2bPassed 
		0
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2bpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2bpt2] */ 
	    'synchronized '( EX ')
		'{
			TransformedBL2  	
		'}
end rule

% Called from within obtain1stSSfromBL to check if there is an if-statement
rule getIfStmtWL    
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	import usedThreadIdCollectionWL [repeat id]
	import usedIntIdCollectionOutStandRL [repeat id]

	construct InstanceFound [expression]
		EX2 [isNoOutStdRLExp EX2 each usedIntIdCollectionOutStandRL] [isWLThreadNull EX2 each usedThreadIdCollectionWL]
		
	construct TransformedIfExpSTMT [statement]
		ifExpSTMT [isWLThrdAssignedCurrThrd] [isReturnStmt]
	
	% import tmpRole2bPassed [number]	
	% where
		% tmpRole2bPassed [> 0]

	construct ReadWriteLockAnnotation2bapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2bapt2 [stringlit]
		", roleID=2ba, roleDescription='Within Role 2b checking if the designated writeLockedThread is null and designated outstandingReadLocks counter variable is zero.')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2bapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2bapt2] */ 
		'if '( EX2 ')     
		'{
			TransformedIfExpSTMT 
		'}
		OEC 		
end rule

% //*** ReadWriteLockPattern:  Role = 2ba(Within Role 2b a check to whether designated counter variable is zero.  
% //							** If true proceed with Role 2baa and 2bab.
% //							** If false proceed with Role 2bac and 2bad);
function isNoOutStdRLExp EX2 [expression] intVarID [id]
	replace [expression]
		EX2
	where 
		EX2 [matchesVarID intVarID] 		
	by
		EX2
end function

% //*** ReadWriteLockPattern:  Role = 2ba(Within Role 2b a check to whether the designated writelock thread is null.  
% //							** If true proceed with Role 2baa and 2bab.
% //							** If false proceed with Role 2bac and 2bad);
function isWLThreadNull EX2 [expression] threadID [id]
	replace [expression]
		EX2
	construct theNull [null_literal]
		'null		
	where all
		EX2 [matchesVarID threadID] [hasNull theNull]	

	import tmpWLThreadID [id]
	export tmpWLThreadID
		threadID
	% import intIdCollection [repeat id]		
	% construct InstanceFound [statement]
		% ifExpSTMT [isWLThrdAssignedCurrThrd BL RDS3 ifExpSTMT MD threadID]	
	by
		EX2
end function

% //*** ReadWriteLockPattern:  Role = 2baa(Assign the current thread to the designated writelock thread );
rule isWLThrdAssignedCurrThrd 
	replace [expression_statement]
		EX [expression] '; 
	construct threadID2 [id]
		'Thread
	construct threadID3 [id]
		'currentThread
	construct assignOp [assignment_operator]
		'=
	deconstruct EX
		AE [assignment_expression]
	import tmpWLThreadID [id]
	where all
		AE [matchesVarID tmpWLThreadID] [matchesVarID threadID2] [matchesVarID threadID3] [matchesAssignOp assignOp] 

	% import threadIdCollection [repeat id]
	% construct InstanceFound  [repeat declaration_or_statement]
		% RDS3 [isNewThrdAssignedCurrThrd MD BL RDS3 threadID each threadIdCollection]
 
	construct ReadWriteLockAnnotation2baapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2baapt2 [stringlit]
		", roleID=2baa, roleDescription='Assign the current thread to the designated writeLockedThread.')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2baapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2baapt2] */ 
		EX '; 
end rule

% //*** ReadWriteLockPattern:  Role = 2bab(Return to the calling object that is using this method Role 2 of an instance of this object Role 1 .); 
rule isReturnStmt 
	% replace [expression_statement]
		% EX [expression] '; 
		
	% construct rtnStmt [statement]
		% 'return;		
	% where 
		% EX [hasStmt rtnStmt]
		
	replace [return_statement]
		'return OE [opt expression] ';		
		
	% deconstruct EX
		% AE [assignment_expression]

	% import tmpWLThreadID [id]
	% where all
		% AE [matchesVarID tmpWLThreadID] [matchesVarID threadID2] [matchesVarID threadID3] [matchesAssignOp assignOp] 

	% import threadIdCollection [repeat id]
	% construct InstanceFound  [repeat declaration_or_statement]
		% RDS3 [isNewThrdAssignedCurrThrd MD BL RDS3 threadID each threadIdCollection]
 
	construct ReadWriteLockAnnotation2babpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2babpt2 [stringlit]
		", roleID=2bab, roleDescription='Return to the calling object that is using this method Role 2 of an instance of this object Role 1.')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2babpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2babpt2] */ 
		'return OE ';
		% EX '; 
end rule

% //*** ReadWriteLockPattern:  Role = 2bac(Make thread Role 2a the current thread.);
rule isNewThrdAssignedCurrThrd newThreadID [id]
	replace [expression_statement]
		EX [expression] '; 
		
	import tmpWLThreadID [id]
	where not
		tmpWLThreadID [= newThreadID]
	construct threadID2 [id]
		'Thread
	construct threadID3 [id]
		'currentThread
	construct assignOp [assignment_operator]
		'=
	deconstruct EX
		AE [assignment_expression]

	where all
		AE [matchesVarID newThreadID] [matchesVarID threadID2] [matchesVarID threadID3] [matchesAssignOp assignOp] 
		
	import tmpNewThreadID [id]
	export tmpNewThreadID
		newThreadID
	% import arrListIdCollection [repeat id]	
	% construct InstanceFound  [repeat declaration_or_statement]
		% RDS3 [isNewThrdAddedtoWLWaitingArr MD usedThreadID BL RDS3 newThreadID each arrListIdCollection]
		
	construct ReadWriteLockAnnotation2bacpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2bacpt2 [stringlit]
		", roleID=2bac, roleDescription='Make thread Role 2a the current thread.')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2bacpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2bacpt2] */ 
		EX '; 
end rule

% //*** ReadWriteLockPattern:  Role = 2bad(Add thread Role 2a to arraylist);
rule isNewThrdAddedtoWLWaitingArr arrListID [id]
	replace [expression_statement]
		EX [expression] '; 
		
	construct idAdd [id]
		'add
	deconstruct EX
		AE [assignment_expression]

	import tmpNewThreadID [id]
	where all
		AE [matchesVarID tmpNewThreadID] [matchesVarID arrListID] [matchesVarID idAdd] 
		
	import tmpArrListID [id]
	export tmpArrListID
		arrListID

	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain2ndSychStmtfromBL arrListID usedThreadID newThreadID BL MD]		
		
	construct PlusOne [number]
		1		
	import tmpRole2bPassed [number]
	construct NewCount [number]
		tmpRole2bPassed [+ PlusOne]
	export tmpRole2bPassed
		NewCount	
			
	construct ReadWriteLockAnnotation2badpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2badpt2 [stringlit]
		", roleID=2bad, roleDescription='Add thread Role 2a to arraylist.')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2badpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2badpt2] */ 
		EX '; 
end rule

% //*** ReadWriteLockPattern:  Role = 2c(Critical section creation by synchronization of thread Role 2a.
% //							** Contains Role 2ca);
rule obtain2ndSychStmtfromBL 
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 	

	import tmpNewThreadID [id]
	where 
		EX [matchesVarID tmpNewThreadID]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isWhileLpThreadChk] [isDoWhileLpThreadChk]
	construct TransformedBL2 [block]
		'{                                        
				TransformedRDS3
		'}	
		
	construct ReadWriteLockAnnotation2cpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2cpt2 [stringlit]
		", roleID=2c, roleDescription='Critical section creation by synchronization of thread Role 2a.')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2cpt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2cpt2] */ 
	    'synchronized '( EX ')
		'{
			TransformedBL2
		'}
end rule

% //*** ReadWriteLockPattern:  Role = 2ca(A loop within critical section Role 2c to check if the new thread Role 2a is NOT the same as thread the designated writelock thread .  
% //							** If true proceed with Role 2caa.
% //							** If false then new thread Role 2a is allowed to continue to run and proceeds to Role 2d.);
% //*** ReadWriteLockPattern:  Role = 2caa(New thread Role 2a is placed in a waiting state until method Role 3 wakes it up using a nofityAll().); 
rule isWhileLpThreadChk 
	replace [while_statement]
	    'while '( EX [expression] ') 
			STMT [statement]                     

	construct neOp [equality_op]
		'!=
		
	import tmpWLThreadID [id]
	import tmpNewThreadID [id]
		
	where all
		EX [matchesVarID tmpNewThreadID] [matchesVarID tmpWLThreadID] [matchesEqOp neOp]
		
	construct waitID [id]
		'wait
	where all
		STMT [matchesVarID tmpNewThreadID] [matchesVarID waitID]
		
	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain3rdSychStmtfromBL arrListID newThreadID MD]		

	construct ReadWriteLockAnnotation2capt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2capt2 [stringlit]
		", roleID=2ca, roleDescription='A loop within critical section Role 2c to check if the new thread Role 2a is NOT the same as the designated writeLockedThread.')"	

	construct ReadWriteLockAnnotation2caapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2caapt2 [stringlit]
		", roleID=2caa, roleDescription='New thread Role 2a is placed in a waiting state until method Role 3 wakes it up using a nofityAll().')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2capt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2capt2] */ 
	    'while '( EX ') 
		{
			/* ReadWriteLockAnnotation2caapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2caapt2] */
			STMT                     
		}
end rule

% //*** ReadWriteLockPattern:  Role = 2ca(A loop within critical section Role 2c to check if the new thread Role 2a is NOT the same as the designated writelock thread.  
% //							** If true proceed with Role 2caa.
% //							** If false then new thread Role 2a is allowed to continue to run and proceeds to Role 2d.);
% //*** ReadWriteLockPattern:  Role = 2caa(New thread Role 2a is placed in a waiting state until method Role 3 wakes it up using a nofityAll().); 
rule isDoWhileLpThreadChk 
	replace [do_statement]
		'do
			 STMT [statement]
		'while '( EX [expression] ') '; 			

	import tmpWLThreadID [id]
	import tmpNewThreadID [id]

	construct neOp [equality_op]
		'!=
	where all
		EX [matchesVarID tmpNewThreadID] [matchesVarID tmpWLThreadID] [matchesEqOp neOp]
		
	construct waitID [id]
		'wait
	where all
		STMT [matchesVarID tmpNewThreadID] [matchesVarID waitID]
		
	% construct InstanceFound [repeat declaration_or_statement]
		% BL [obtain3rdSychStmtfromBL arrListID newThreadID MD]		

	construct ReadWriteLockAnnotation2capt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2capt2 [stringlit]
		", roleID=2ca, roleDescription='A loop within critical section Role 2c to check if the new thread Role 2a is NOT the same as the designated writeLockedThread.')"	

	construct ReadWriteLockAnnotation2caapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2caapt2 [stringlit]
		", roleID=2caa, roleDescription='New thread Role 2a is placed in a waiting state until method Role 3 wakes it up using a nofityAll().')"	
	
	import CountWLMethodIDs [number]	
	construct tmpCountRLMethodIDs [number]
		CountWLMethodIDs [+ 1]
	
	by
		'MUTATED /* ReadWriteLockAnnotation2capt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2capt2] */ 
		'do
		{
			/* ReadWriteLockAnnotation2caapt1 [+ tmpCountRLMethodIDs] [+ ReadWriteLockAnnotation2caapt2] */
			STMT
		}
		'while '( EX ') '; 			
end rule

% //*** ReadWriteLockPattern:  Role = 2d(Critical section creation by synchronization of this Read Write Lock object Role 1.
% //							** Contains Role 2da);
rule obtain3rdSychStmtfromBL MD [method_declarator] 
	construct  THIS [expression]
		'this		
	replace [synchronized_statement]
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isNewThrdRemdFromWLWaitingArr MD]
		
	construct TransformedBL2 [block]
		'{                                        
			TransformedRDS3   
		'}	
		
	construct ReadWriteLockAnnotation2dpt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2dpt2 [stringlit]
		", roleID=2d, roleDescription='Critical section creation by synchronization of this writelock method.')"	
	
	import CountWLMethodIDs [number]	
	
	by
		'MUTATED /* ReadWriteLockAnnotation2dpt1 [+ CountWLMethodIDs] [+ ReadWriteLockAnnotation2dpt2] */ 
	    'synchronized '( EX ')
		'{
			TransformedBL2  	
		'}
end rule

% //*** ReadWriteLockPattern:  Role = 2da(Remove current thread (Role 2a) from the arraylist of waiting threads.)
rule isNewThrdRemdFromWLWaitingArr MD [method_declarator]
	replace [expression_statement]
		EX [expression] '; 
		
	construct idRemove [id]
		'remove
	deconstruct EX
		AE [assignment_expression]

	import tmpArrListID [id]
	import tmpNewThreadID [id]
	where all
		AE [matchesVarID tmpNewThreadID] [matchesVarID tmpArrListID] [matchesVarID idRemove] 
		
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	import WLMethodIDs [repeat id]
	construct newWLMethodIDs [repeat id]
		WLMethodIDs [. methodID]
	export WLMethodIDs
		newWLMethodIDs		
		
	construct PlusOne [number]
		1
		
	import CountWLMethodIDs [number]
	construct NewCount [number]
		CountWLMethodIDs [+ PlusOne]
	export CountWLMethodIDs
		NewCount		 
		
	import tmpRole2Passed [number]
	construct NewCountb [number]
		tmpRole2Passed [+ PlusOne]
	export tmpRole2Passed
		NewCountb	

	construct ReadWriteLockAnnotation2dapt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation2dapt2 [stringlit]
		", roleID=2da, roleDescription='Remove current thread (Role 2a) from the arraylist of waiting threads.')"	
	
	by
		'MUTATED /* ReadWriteLockAnnotation2dapt1 [+ CountWLMethodIDs] [+ ReadWriteLockAnnotation2dapt2] */ 
		EX '; 
end rule


% //Call to the done method indicates current thread is finished with the resource
% //*** ReadWriteLockPattern:  Role = 3(Synchronized method called when the current thread is finished with resource.);
% //							** Contains Role 3a.);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a read lock.
rule findDoneSynchMeth
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
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getIfStmtDone] [getIfStmtDone2 MD]
		
	import tmpRole3Passed [number]	
	where 
		tmpRole3Passed [> 0]

	construct TransformedBL2 [block] 
		'{                                        
			TransformedRDS3   
		'}	
	construct TransformedMB [method_body]
        TransformedBL2  		 
		
	construct ReadWriteLockAnnotation3pt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Synchronized method called when the current thread is finished with resource.')"	
		
	export tmpRole3Passed
		0
	import CountDoneMethodIDs [number]	

	by
		'MUTATED /* ReadWriteLockAnnotation3pt1 [+ CountDoneMethodIDs] [+ ReadWriteLockAnnotation3pt2] */ RM TS MD OT TransformedMB 
end rule

% //Call to the done method indicates current thread is finished with the resource
% //*** ReadWriteLockPattern:  Role = 3(Synchronized method called when the current thread is finished with resource.);
% //							** Contains Role 3a.);
% Second Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition 
% uses the synchronized keyword.  The method can then be a candidate for being the synchronized method to issue a read lock.
rule findDoneSynchMeth2
	construct  THIS [expression]
		'this		
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]		
	deconstruct MB
        BL [block]  		
	deconstruct BL
	    '{                                       
			RDS [repeat declaration_or_statement] 
		'}			
	deconstruct RDS
		STMT [statement]
		RDS2 [repeat declaration_or_statement]		
	deconstruct STMT
		SSTMT [synchronized_statement]		
	deconstruct SSTMT
	    'synchronized '( EX [expression] ')
			BL2 [block] 		
	where 
		EX [isMethodSynchdUsingThis THIS]		
	deconstruct BL2
		'{                                        
			RDS3 [repeat declaration_or_statement]   
		'}	
		
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getIfStmtDone] [getIfStmtDone2 MD]
		
	import tmpRole3Passed [number]	
	where 
		tmpRole3Passed [> 0]

	construct TransformedBL2 [block] 
		'{                                        
			TransformedRDS3   
		'}	
	construct TransformedSSTMT [synchronized_statement]	
	    'synchronized '( EX ')
			TransformedBL2		
	construct TransformedSTMT [statement]
		TransformedSSTMT		
	construct TransformedRDS [repeat declaration_or_statement]
		TransformedSTMT
		RDS2 	
	construct TransformedBL [block] 
	    '{                                       
			TransformedRDS 
		'}			
		
	construct TransformedMB [method_body]
        TransformedBL2  			
		
	construct ReadWriteLockAnnotation3pt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Synchronized method called when the current thread is finished with resource.')"	
		
	export tmpRole3Passed
		0
	import CountDoneMethodIDs [number]	

	by
		'MUTATED /* ReadWriteLockAnnotation3pt1 [+ CountDoneMethodIDs] [+ ReadWriteLockAnnotation3pt2] */ RM TS MD OT TransformedMB 
end rule

% Called from within findDoneSynchMeth2 to check if there is an if-statement
rule getIfStmtDone     
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	% import usedThreadIdCollectionWL [repeat id]
	import usedIntIdCollectionOutStandRL [repeat id]
	construct InstanceFound [expression]
		EX2 [isOutStdRLGTZero EX2 each usedIntIdCollectionOutStandRL] 
		
	import tmpIsOutStdRLGTZeroPassed [number]	
	where 
		tmpIsOutStdRLGTZeroPassed [> 0]
	export tmpIsOutStdRLGTZeroPassed
		0
		
	construct TransformedifExpSTMT [statement]
		ifExpSTMT [isOutStdRLDecr] [getIfStmtOSRLZeroWFWLSize]
		
		
	import tmpIsOutStdRLDecrPassed [number]	
	where 
		tmpIsOutStdRLDecrPassed [> 0]
	export tmpIsOutStdRLDecrPassed
		0
		
	import tmpGetIfStmtOSRLZeroWFWLSizePassed [number]	
	where 
		tmpGetIfStmtOSRLZeroWFWLSizePassed [> 0]
	export tmpGetIfStmtOSRLZeroWFWLSizePassed
		0
	
	by
		'MUTATED 
		'if '( EX2 ')     
		'{
			ifExpSTMT 
		'}
		OEC 		
end rule

function isOutStdRLGTZero EX2 [expression] intVarID [id]
	replace [expression]
		EX2
		
	construct gtRelOp [relational_op]
		'>
	construct numZero [number]
		'0
	where all
		EX2 [matchesVarID intVarID] [matchesRelOp gtRelOp] [hasNumber numZero]		
	% construct InstanceFound [statement]
		% ifExpSTMT [isOutStdRLDecr RDS3 ifExpSTMT MD intVarID]	
	import tmpDoneIntVarID [id]
	export tmpDoneIntVarID 
		intVarID
		
	import tmpIsOutStdRLGTZeroPassed [number]
	export tmpIsOutStdRLGTZeroPassed 
		1
	
	by
		EX2
end function

rule isOutStdRLDecr 
	replace [expression_statement]
		EX [expression] '; 
		
	construct decr [post_inc_dec]
		'--
	deconstruct EX
		AE [assignment_expression]
		
	import tmpDoneIntVarID [id]
	where all
		AE [matchesVarID tmpDoneIntVarID] [matchesPostIncDec decr]
		
	import tmpIsOutStdRLDecrPassed [number]
	export tmpIsOutStdRLDecrPassed 
		1
		
	% construct InstanceFound [statement]
		% ifExpSTMT [getIfStmtOSRLZeroWFWLSize RDS3 MD intVarID]	
		
	by
		'MUTATED 
		EX '; 
end rule

rule getIfStmtOSRLZeroWFWLSize
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT2 [statement]
		OEC [opt else_clause] 		
		
	import arrListIdCollection [repeat id]
	construct InstanceFound [expression]
		EX2 [isOSRLZeroWFWLSizeGTZero EX2 each arrListIdCollection] 
		
	import tmpIsOSRLZeroWFWLSizeGTZeroPassed [number]	
	where 
		tmpIsOSRLZeroWFWLSizeGTZeroPassed [> 0]
	export tmpIsOSRLZeroWFWLSizeGTZeroPassed
		0
		
	import usedThreadIdCollectionWL [repeat id]
	construct InstanceFound2 [statement]
		ifExpSTMT2 [isWLThAssignedWaitingTh each usedThreadIdCollectionWL]	
		 [isWLThNotifyAll]
		 
	import tmpIsWLThAssignedWaitingThPassed [number]	
	where 
		tmpIsWLThAssignedWaitingThPassed [> 0]
	export tmpIsWLThAssignedWaitingThPassed
		0
		
	import tmpIsWLThNotifyAllPassed [number]	
	where 
		tmpIsWLThNotifyAllPassed [> 0]
	export tmpIsWLThNotifyAllPassed
		0
		
	import tmpGetIfStmtOSRLZeroWFWLSizePassed [number]
	export tmpGetIfStmtOSRLZeroWFWLSizePassed 
		1
		 
	by
		'MUTATED 
		'if '( EX2 ')     
		'{
			ifExpSTMT2 
		'}
		OEC 		
end rule

function isOSRLZeroWFWLSizeGTZero EX2 [expression] arrListID [id]
	replace [expression]
		EX2
		
	construct eqOp [equality_op]
		'==
	construct numZero [number]
		'0
	construct gtRelOp [relational_op]
		'>
	construct idSize [id]
		'size
		
	import tmpDoneIntVarID [id]
	where all
		EX2 [matchesVarID tmpDoneIntVarID] [matchesEqOp eqOp] [hasNumber numZero] [matchesVarID arrListID] [matchesVarID idSize] [matchesRelOp gtRelOp]

	import tmpDoneArrListID [id]
	export tmpDoneArrListID 
		arrListID
		
	import tmpIsOSRLZeroWFWLSizeGTZeroPassed [number]
	export tmpIsOSRLZeroWFWLSizeGTZeroPassed 
		1
	% import usedThreadIdCollectionWL [repeat id]
	% construct InstanceFound [statement]
		% ifExpSTMT2 [isWLThAssignedWaitingTh RDS3 ifExpSTMT2 MD intVarID arrListID each usedThreadIdCollectionWL]	
	by
		EX2
end function

rule isWLThAssignedWaitingTh usedThreadID [id]
	replace [expression_statement]
		EX [expression] '; 
	construct assignOp [assignment_operator]
		'=
	construct threadID2 [id]
		'Thread
	construct idGet [id]
		'get
	construct numZero [number]
		'0
	deconstruct EX
		AE [assignment_expression]
		
	import tmpDoneArrListID [id]
	where all
		AE [matchesVarID usedThreadID] [matchesAssignOp assignOp] [matchesVarID threadID2] [matchesVarID tmpDoneArrListID] [matchesVarID idGet] [hasNumber numZero]

	import tmpDoneUsedThreadID [id]
	export tmpDoneUsedThreadID 
		usedThreadID
	% construct InstanceFound [statement]
		% ifExpSTMT2 [isWLThNotifyAll RDS3 MD intVarID arrListID usedThreadID]	
	import tmpIsWLThAssignedWaitingThPassed [number]
	export tmpIsWLThAssignedWaitingThPassed 
		1
 
	by
		'MUTATED 
		EX '; 
end rule

rule isWLThNotifyAll 
	replace [expression_statement]
		EX [expression] '; 
	construct idNotifyAll [id]
		'notifyAll
	deconstruct EX
		AE [assignment_expression]
		
	import tmpDoneUsedThreadID [id]
	where all
		AE [matchesVarID tmpDoneUsedThreadID] [matchesVarID idNotifyAll] 
		
	import tmpIsWLThNotifyAllPassed [number]
	export tmpIsWLThNotifyAllPassed 
		1

	% construct InstanceFound [repeat declaration_or_statement]
		% RDS3 [getIfStmtDone2 MD intVarID arrListID usedThreadID]	
 
	by
		'MUTATED 
		EX '; 
end rule

rule getIfStmtDone2 MD [method_declarator] 
	replace [if_statement]
		'if '( EX [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	construct threadID2 [id]
		'Thread
	construct threadID3 [id]
		'currentThread
	construct eqOp [equality_op]
		'==
		
	import tmpDoneUsedThreadID [id]
	where all
		EX [matchesVarID threadID2] [matchesVarID threadID3] [matchesEqOp eqOp] [matchesVarID tmpDoneUsedThreadID]
		
	construct TransformedIfExpSTMT [statement]
		ifExpSTMT [getIfStmtOSRLZeroWFWLSize2 MD]	

	import tmpGetIfStmtOSRLZeroWFWLSize2Passed [number]	
	where 
		tmpGetIfStmtOSRLZeroWFWLSize2Passed [> 0]
	export tmpGetIfStmtOSRLZeroWFWLSize2Passed
		0
		
	by
		'MUTATED 
		'if '( EX ')     
		'{
			TransformedIfExpSTMT 
		'}
		OEC 		
end rule

rule getIfStmtOSRLZeroWFWLSize2 MD [method_declarator] 
	replace [if_statement]
		'if '( EX2 [expression] ')     
			ifExpSTMT2 [statement]
		OEC [opt else_clause] 		

	construct InstanceFound [expression]
		EX2 [isOSRLZeroWFWLSizeGTZero2 EX2] 
		
	import tmpisOSRLZeroWFWLSizeGTZero2Passed [number]	
	where 
		tmpisOSRLZeroWFWLSizeGTZero2Passed [> 0]
	export tmpisOSRLZeroWFWLSizeGTZero2Passed
		0
		
	construct InstanceFound2 [statement]
		ifExpSTMT2 [isWLThAssignedWaitingTh2] [isWLThNotifyAll2]	

	import tmpisWLThAssignedWaitingTh2Passed [number]	
	where 
		tmpisWLThAssignedWaitingTh2Passed [> 0]
	export tmpisWLThAssignedWaitingTh2Passed
		0
		
	import tmpisWLThNotifyAll2Passed [number]	
	where 
		tmpisWLThNotifyAll2Passed [> 0]
	export tmpisWLThNotifyAll2Passed
		0

	import usedIntIdCollectionWaitRL [repeat id]
	construct TransformedOEC [opt else_clause]
		OEC [getWLAssignNull] [getIfWaitForRLThGTZero MD each usedIntIdCollectionWaitRL]
		
	import tmpgetWLAssignNullPassed [number]	
	where 
		tmpgetWLAssignNullPassed [> 0]
	export tmpgetWLAssignNullPassed
		0
		
	import tmpgetIfWaitForRLThGTZero [number]	
	where 
		tmpgetIfWaitForRLThGTZero [> 0]
	export tmpgetIfWaitForRLThGTZero
		0
		
	import tmpGetIfStmtOSRLZeroWFWLSize2Passed [number]
	export tmpGetIfStmtOSRLZeroWFWLSize2Passed 
		1

	by
		'MUTATED 
		'if '( EX2 ')     
		'{
			ifExpSTMT2 
		'}
		TransformedOEC 		
end rule

function isOSRLZeroWFWLSizeGTZero2 EX2 [expression]  
	replace [expression]
		EX2
		
	construct eqOp [equality_op]
		'==
	construct numZero [number]
		'0
	construct gtRelOp [relational_op]
		'>
	construct idSize [id]
		'size
		
	import tmpDoneIntVarID [id]
	import tmpDoneArrListID [id]
	where all
		EX2 [matchesVarID tmpDoneIntVarID] [matchesEqOp eqOp] [hasNumber numZero] [matchesVarID tmpDoneArrListID] [matchesVarID idSize] [matchesRelOp gtRelOp]
		
	import tmpisOSRLZeroWFWLSizeGTZero2Passed [number]
	export tmpisOSRLZeroWFWLSizeGTZero2Passed 
		1
	
	% construct InstanceFound [statement]
		% ifExpSTMT2 [isWLThAssignedWaitingTh2 ifExpSTMT2 MD arrListID usedThreadID OEC]	
	by
		EX2
end function

rule isWLThAssignedWaitingTh2 
	replace [expression_statement]
		EX [expression] '; 
	construct assignOp [assignment_operator]
		'=
	construct threadID2 [id]
		'Thread
	construct idGet [id]
		'get
	construct numZero [number]
		'0
	deconstruct EX
		AE [assignment_expression]
		
	import tmpDoneUsedThreadID [id]
	import tmpDoneArrListID [id]
	where all
		AE [matchesVarID tmpDoneUsedThreadID] [matchesAssignOp assignOp] [matchesVarID threadID2] [matchesVarID tmpDoneArrListID] [matchesVarID idGet] [hasNumber numZero]

	% construct InstanceFound [statement]
		% ifExpSTMT2 [isWLThNotifyAll2 MD arrListID usedThreadID OEC]	
 	import tmpisWLThAssignedWaitingTh2Passed [number]
	export tmpisWLThAssignedWaitingTh2Passed 
		1

	by
		'MUTATED 
		EX '; 
end rule

rule isWLThNotifyAll2 
	replace [expression_statement]
		EX [expression] '; 
	construct idNotifyAll [id]
		'notifyAll
	deconstruct EX
		AE [assignment_expression]

	import tmpDoneUsedThreadID [id]
	where all
		AE [matchesVarID tmpDoneUsedThreadID] [matchesVarID idNotifyAll] 

	% construct InstanceFound [opt else_clause]
		% OEC [getWLAssignNull MD arrListID usedThreadID OEC]	
  	import tmpisWLThNotifyAll2Passed [number]
	export tmpisWLThNotifyAll2Passed 
		1

	by
		'MUTATED 
		EX '; 
end rule

rule getWLAssignNull 
	replace [expression_statement]
		EX [expression] '; 
	deconstruct EX
		AE [assignment_expression]
	construct assignOp [assignment_operator]
		'=
	construct theNull [null_literal]
		'null		
		
	import tmpDoneUsedThreadID [id]
	where all
		EX [matchesVarID tmpDoneUsedThreadID] [matchesAssignOp assignOp] [hasNull theNull]
		
	% import usedIntIdCollectionWaitRL [repeat id]
	% construct InstanceFound [opt else_clause]
		% OEC [getIfWaitForRLThGTZero MD each usedIntIdCollectionWaitRL]	
   	import tmpgetWLAssignNullPassed [number]
	export tmpgetWLAssignNullPassed 
		1

	by
		'MUTATED 
		EX '; 
end rule

rule getIfWaitForRLThGTZero MD [method_declarator] intVarID [id]
	replace [if_statement]
		'if '( EX [expression] ')     
			ifExpSTMT [statement]
		OEC [opt else_clause] 		
		
	construct numZero [number]
		'0
	construct gtRelOp [relational_op]
		'>
		
	where all
		EX [matchesVarID intVarID] [matchesRelOp gtRelOp] [hasNumber numZero]

	construct TransformedIfExpSTMT [statement]
		ifExpSTMT [isNotifyAll MD] 

	import tmpRole3Passed [number]	
	where 
		tmpRole3Passed [> 0]
		
   	import tmpgetIfWaitForRLThGTZero [number]
	export tmpgetIfWaitForRLThGTZero 
		1

	by
		'MUTATED 
		'if '( EX ')     
		'{
			TransformedIfExpSTMT 
		'}
		OEC 		
end rule

% //*** ReadWriteLockPattern:  Role = 3a(NotifyAll to wake up other waiting threads.);
rule isNotifyAll MD [method_declarator] 
	replace [expression_statement]
		EX [expression] '; 
	construct idNotifyAll [id]
		'notifyAll
	deconstruct EX
		AE [assignment_expression]
	where all
		AE [matchesVarID idNotifyAll] 
		
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	construct PlusOne [number]
		1
		
	import DoneMethodIDs [repeat id]
	construct newDoneMethodIDs [repeat id]
		DoneMethodIDs [. methodID]
	export DoneMethodIDs
		newDoneMethodIDs		
		
	import CountDoneMethodIDs [number]
	construct NewCounta [number]
		CountDoneMethodIDs [+ PlusOne]
	export CountDoneMethodIDs
		NewCounta		 
		
	import CountRLMethodIDs [number]
	import CountWLMethodIDs [number]
	construct numZero [number]
	'0

	where not
		CountRLMethodIDs [hasNumber numZero]
	where not
		CountWLMethodIDs [hasNumber numZero]
	where not
		CountDoneMethodIDs [hasNumber numZero]
				
	import Counter [number]
	construct NewCount [number]
		Counter [+ PlusOne]
	export Counter
		NewCount		
				
	import tmpRole3Passed [number]
	construct NewCountb [number]
		tmpRole3Passed [+ PlusOne]
	export tmpRole3Passed
		NewCountb		
		
	construct ReadWriteLockAnnotation3apt1 [stringlit]
		"@ReadWriteLockPatternAnnotation(patternInstanceID="
	construct ReadWriteLockAnnotation3apt2 [stringlit]
		", roleID=3a, roleDescription='NotifyAll to wake up other waiting threads.')"	
	
	by
		'MUTATED /* ReadWriteLockAnnotation3apt1 [+ CountDoneMethodIDs] [+ ReadWriteLockAnnotation3apt2] */ 
		EX '; 
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

	
	
	
	
	
	
	
	
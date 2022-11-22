# PEGASUS Assembler/Editor
written in 1987/88 by Mike Hesser for CPC 464/664/6128

It took me almost exactly one year to develop my biggest project on the CPC: An assembler written in assembler.

An assembler converts instructions of the assembly language (in this case of the Z80 processor) into machine code.
The development tool was an assembler written in BASIC. When the project matured sufficiently, the assembler could assemble and run its own code.
The development conditions were quite adverse. My Amstrad CPC 464 had only the cassette drive and was accordingly slow.
Errors in the program code quickly led to crashes. If you didn't save before (which took some time) the written code was gone.

I learned a lot from this project, especially that you can write efficient and fast programs with little code.

## User manual

Pegasus is a 2-pass assembler with the following features:

* Full Screen Editor
* Automatic indentation and formatting of the entered commands
* Converts commands to tokens, thus saving space
* can hold source code for about 7 Kbytes of machine code in memory!
* very fast assembler (6 KByte in 13 sec.)
* generates code for any memory address
* simple integer arithmetic
* Start generated programs from Pegasus and display registers by pseudo command 'BRK


### The Editor

This is a full screen editor that works without line numbers. For speed reasons a status line was omitted, so that scrolling is fast.
The other functions known from Basic, like DEL, are not mentioned here.

Note: The following functions will not be executed if PEGASUS encounters a syntax error in the line entered or if the specified label has already occurred in the source code.


Here are the editor functions:

| key combination | function |
| -------------------- | ------------- |
| `CTRL + <left>` | Places the cursor at the beginning of the line |
| `CTRL + <right>` | Places the cursor at the end of the line |
| `CTRL + <up>` | Moves the cursor to the beginning of the source text |
| `CTRL + <down>` | Moves the cursor to the end of the source text |
| `CTRL + F` | Jump to a label: After entering the searched label, the cursor will be placed on the line of the label, if it exists in the source text.            |
| `CTRL + C` | Deletes the line at cursor position. The following lines are moved up.           |
| `COPY` | This key can be used to narrow down text areas. To do this, move the cursor to the beginning of the area and press the COPY key, which is acknowledged with a sound signal. Now the end is marked in the same way. During marking, no changes can be made to the source text! If you want to return from the block mode to the editing mode, the ESC key must be pressed.           |
| 'ENTER' | Input confirmation of the entered line. The command is output formatted on the screen. The cursor also moves to the beginning of the next line. If you want to insert a line, the cursor must be moved to the beginning of the line and ENTER must be pressed. |
| 'CTRL + K' (Copy block). This key combination copies the block previously marked with the COPY key to the current cursor position. |
| `CTRL + N` | This function deletes the entire source text after a confirmation prompt. If a block was marked before, it will be deleted. |
| `CTRL + ^` | With this option you can start the assembled program. However, no changes should be made to the source code between assembling and starting the program, otherwise the machine code could be overwritten.
| `CTRL + S` | The program asks for the file name and then saves the source code. For cassette users: default is 2000 baud |
| `CTRL + L` | as above, but a source code is loaded. If there is already a program in memory Pegasus will simply append it. If no filename is specified with a LOAD/SAVE option Pegasus will output the directory.| 
| `CTRL + Q` | (Quit). Returns from Pegasus back to Basic. The top memory address is additionally lowered to protect the source code. By typing `CALL 0` (don't be afraid!) you get back to Pegasus. |

### THE ASSEMBLER PART

It is called from the editor with `CTRL + A`. The screen is cleared and the following questions appear on the screen in order:</p>

#### Screen output (y/n)? 
 
While assembling, the lines are also displayed.
During the assembling process the lines are also displayed.
The listing of the line can be stopped by ESC, and continued by
and continue by pressing any key. Pressing the
Pressing the ESC key again cancels the process.

#### Printer (y/n)? 

As above, only additional output on the printer

#### Save MC directly (y/n)? 

With this option it is possible to generate machine code for any memory address. The code will be written directly to the disk.
However, when loading the generated machine code you have to make sure to include the load address.

If Pegasus encounters an error in the source code, it immediately switches to edit mode and places the cursor on the erroneous line. The error type will be displayed at the bottom of the screen.

Here are the meanings of the individual messages:

| Error | Description |
| ------------------ | ------------- |
|`Syntax error` | Pegasus does not understand the line. e.g. there is no `LD HL,DE.`|
|`Overflow` | A value or the result of an operation is too large. (e.g. `LD A,500` or `LD A,200+200`) |
|`Memory full` | Es ist nicht mehr genügend Speicherplatz für den Objektcode oder für die Labeltabelle vorhanden |
|`Distance too high` | Die Distanz zweier Adressen ist für eine relative Adressierung zu groß| 
|`Out of Memory` | Die angegebene ORG-Adresse ist über oder unter dem zulässigen Speicherbereich.|
|`Unknown Label` | Das Label ist nicht im Quelltext definiert|

## Argumente

### Labels

Labels dürfen maximal 6 Zeichen lang sein und müssen mit einem Buchstaben beginnen. Weiterhin muß ein Doppelpunkt angehängt werden.
Labels können auf folgende Arten definiert werden:

|Syntax|Beschreibung|
| -------------------- | ------------- |
|`<label>: EQU <wert>` | <label> nimmt den Wert <wert> an|
|`<label>: <Befehl>` | <label> nimmt den Wert des aktuellen Programcounters (PC) an.|

### Der Assembler

#### Zahlen

Bei Hexadzimalzahlen muß ein Doppelkreuz `#` und bei Binärzahlen ein Prozentzeichen `%` vorangestellt werden.


z.B.
|Wert|Bedeutung|
| ----- | ------------- |
|`ABCD` |hexadecimal|
|`%1010`|Binary|
|`1234` |Decimal|

#### Strings


For example, if you want to load the register `A` (accumulator) with the ASCII value of 'A', enter:

`LD A, "A"` or for 16-bit: `LD HL, "AB"`.

#### PC

The value of the program counter is read out by '$'.

`JR $+10`

#### Operators

The above arguments can be linked using the following operators:
| operator|function|
| -------------------- | ------------- |
|+|Addition|
|-|Subtraction|
|*|Multiplication|
|/|Division|
|OR|
|&|AND|
|!|XOR|


In case of possible overflows or underflows Pegasus branches to the editor. There are no brackets and signs. Calculations are done from left to right without consideration of the calculation hierarchy.


#### Pseudo commands

| command|description|
| -------------------- | ------------- |
|`ORG <value>`|The MC is stored from address <value>. <value> must be a number. If there are several ORG instructions in the source code, the MC will only be stored starting from the last ORG instruction specified. |
|`END`|Ends the assembling process. Not mandatory.|
|`DEFB <value>,...`|One or more comma-separated byte expressions can be specified here.|
|`DEFW <value>,...`|as above, only Word expressions|
|`DEFM "<text>"`|The text string <text> will be translated according to the ASCII table.|
|`DEFS <value>`|Zero bytes are inserted in the program. `<value>` must be an 8-bit number.|
|`ENT <value>`|Defines the address from which the startup process of the MC should run from the editor. This command should be present in every assembler program.|
|`BRK`|The assembler inserts a restart command (RST 6) into the program. If the program is now started from the editor and the processor encounters RST 6, the sequence is stopped and the register contents are displayed. A keystroke transports you back to the editor.|

#### Structure of an assembler line:

1. label, command or REM
2. command or REM
3. first operand
4. second operand
5. REM (semicolon ;)


### Pegasus internal

#### Memory allocation

| memory area|content|
| -------------------- | ------------- |
|#0170 - #02FF|Free for basic programs|
|#0300 - #84FF|Memory for source code|
|#8500 - #8EFF|Buffer for disk/cass I/O|
|#8D00 - #A6D0|Pegasus|



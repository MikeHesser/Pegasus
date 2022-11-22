
# PEGASUS Assembler/Editor
written in 1987/88 by Mike Hesser for CPC 464/664/6128

Ziemlich genau ein Jahr lang dauerte die Entwicklung meines größten Projektes auf dem CPC: Ein in Assembler geschriebener Assembler.

Ein Assembler wandelt Befehle der Assemblersprache (in diesem Fall des Z80-Prozessors) in Maschinencode.
Als Entwicklungswerkzeug diente ein in BASIC geschriebener Assembler. Als das Projekt genügend gereift war, konnte der Assembler seinen eigenen Code assemblieren und ausführen.
Die Entwicklungsbedingungen waren ziemlich widrig. Der CPC464 hatte ja nur das Kassettenlaufwerk und war dementsprechend langsam.
Fehler im Programmcode führten schnell zu Abstürzen. Hat man nicht vorher abgespeichert (was eine Zeit lang dauerte) war der geschriebene Code weg.

An diesem Projekt habe ich viel gelernt, vor allem dass man auch mit wenig Code effiziente und schnelle Programme schreiben kann.

## Bedienungsanleitung

Pegasus ist ein 2-Pass Assembler mit folgenden Leistungsmerkmalen:

* Full Screen Editor
* Automatischen Einrücken und Formatieren der eingegebenen Befehle
* Umwandlung der Befehle in Tokens, dadurch Platzeinsparung
* kann Sourcecode für circa 7 Kbyte Maschinencode im Speicher halten!
* sehr schneller Assembler (6 KByte in 13 sec.)
* Erzeugt Code fuer jede beliebige Speicheradresse
* einfache Integerarithmetik
* Starten der erzeugten Programme von Pegasus aus und Registeranzeige per Pseudobefehl `BRK`


### Der Editor

Hier handelt es sich um einen Full Screen Editor der ohne Zeilennummern arbeitet. Aus Geschwindigkeitsgründen wurde auf eine Statuszeile verzichtet, so daß das Scrolling schnell von statten geht.
Die sonstigen, von Basic bekannten Funktionen wie DEL, werden hier nicht erwähnt.

Anmerkung: Die folgenden Funktionen werden nicht ausgeführt, wenn PEGASUS auf einen Syntaxfehler in der eingegebenen Zeile gestoßen oder das angegebene Label schon im Quelltext vorgekommen ist.


Hier die Editorfunktionen:

| Tastenkombination    | Funktion      |
| -------------------- | ------------- |
| `CTRL + <links>`     | Setzt den Cursor an den Anfang der Zeile |
| `CTRL + <rechts>`    | Setzt den Cursor an das Ende der Zeile |
| `CTRL + <oben>`      | Der Cursor geht an den Anfang des Quelltextes |
| `CTRL + <unten>`     | befördert den Cursor an das Ende des Quelltextes  |
| `CTRL + F`           | Sprung zu einem Label: Nach Eingabe des gesuchten Labels wird, sofern im Quelltext vorhanden, der Cursor auf die Zeile des Labels gesetzt.            |
| `CTRL + C`           | Löscht die Zeile auf Cursorposition. Die nachfolgenden Zeilen werden nachgerückt.           |
| `COPY`               | Mit dieser Taste können Textbereiche eingegrenzt werden. Dazu steuern Sie den Cursor auf den Anfang des Bereiches und drücken die COPY-Taste was mit einem Tonsignal quittiert wird. Nun wird auf gleiche Weise das Ende markiert. Während des Markierens können keine Änderungen am Quelltext vorgenommen werden! Wollen Sie aus dem Blockmodus zurück in den Editiermodus, muss die ESC-Taste betätigt werden.           |
| `ENTER`              | Eingabebestätigung der eingegebenen Zeile. Der Befehl wird formatiert auf dem Bildschirm ausgegeben. Der Cursor geht außerdem auf den Anfang der nächsten Zeile. Wollen Sie eine Zeile einfügen, so muß der Cursor an den Anfang der Zeile gesetzt und ENTER gedrückt werden. |
| `CTRL + K`           | (Kopiere Block). Diese Tastenkombination kopiert den vorher mit der COPY-Taste markierten Block auf die aktuelle Cursorposition. |
| `CTRL + N`           | Diese Funktion löscht nach einer Sicherheitsabfrage den gesamten Quelltext. Wurde vorher ein Block markiert so wird dieser gelöscht. |
| `CTRL + ^`           | Mit dieser Option können Sie das assemblierte Programm starten. Zwischen dem Assemblieren und dem Starten des Programms sollten aber keine Änderungen am Quelltext vorgenommen werden, da sonst der Maschinencode überschrieben werden könnte.
| `CTRL + S`           | Das Programm fragt nach dem Dateinamen und speichert dann den Quelltext. Für Kassettenbenutzer: voreingestellt sind 2000 Baud |
| `CTRL + L`           | wie oben, nur wird ein Quelltext geladen. Befindet sich schon ein Programm im Speicher, fügt Pegasus es einfach an. Wird bei einer LOAD/SAVE Option kein Dateiname angegeben, gibt Pegasus das Directory aus.| 
| `CTRL + Q`           | (Quit). Kehrt von Pegasus zurück zu Basic. Die oberste Speicheradresse wird zusätzlich herabgesetzt um den Quelltext zu schützen. Durch Eingabe von `CALL 0` (keine Angst!) gelangen Sie wieder zurück zu Pegasus. |

### DER ASSEMBLERTEIL

Aufgerufen wird er vom Editor mit `CTRL + A`. Der Bildschirm wird gelöscht und folgende Fragen erscheinen der Reihe nach auf dem Bildschirm:</p>

#### Bildschirmausgabe (j/n)? 
 
Während des Assemblierens werden die Zeilen mitangezeigt.
Das Listen der Zeile kann durch ESC angehalten, und durch
Drücken einer beliebigen Taste fortgesetzt werden. Ein nochmaliges
Drücken der ESC Taste bricht den Vorgang ab.

#### Drucker (j/n)? 

Wie oben, nur zusätzliche Ausgabe auf dem Drucker

#### MC direkt speichern (j/n)? 

Mit dieser Option ist es möglich, für jede beliebige Speicheradresse Maschinencode zu erzeugen. Der Code wird dabei direkt auf den Datenträger geschrieben.
Allerdings müssen Sie beim Laden des erzeugten Maschinencodes darauf achten, die Ladeadresse mitanzugeben.

Trifft Pegasus auf einen Fehler im Quelltext, schaltet er sofort in den Editiermodus um und setzt den Cursor auf die fehlerhafte Zeile. Dabei wird am unteren Bildschirmrand die Fehlerart angezeigt.

Hier die Bedeutungen der einzelnen Meldungen:

| Fehler             | Beschreibung      |
| ------------------ | ------------- |
|`Syntax error`      | Pegasus versteht die Zeile nicht. z.B. gibt es kein `LD HL,DE.`|
|`Overflow`          | Ein Wert oder das Ergebnis einer Rechenoperation ist zu groß. (z.B. `LD A,500` oder `LD A,200+200`) |
|`Memory full`       | Es ist nicht mehr genügend Speicherplatz für den Objektcode oder für die Labeltabelle vorhanden |
|`Distance too high` | Die Distanz zweier Adressen ist für eine relative Adressierung zu groß| 
|`Out of Memory`     | Die angegebene ORG-Adresse ist über oder unter dem zulässigen Speicherbereich.|
|`Unknown Label`     | Das Label ist nicht im Quelltext definiert|

## Argumente

### Labels

Labels dürfen maximal 6 Zeichen lang sein und müssen mit einem Buchstaben beginnen. Weiterhin muß ein Doppelpunkt angehängt werden.
Labels können auf folgende Arten definiert werden:

|Syntax|Beschreibung|
| -------------------- | ------------- |
|`<label>: EQU <wert>` | <label> nimmt den Wert <wert> an|
|`<label>: <Befehl>`   | <label> nimmt den Wert des aktuellen Programcounters (PC) an.|

### Der Assembler

#### Zahlen

Bei Hexadzimalzahlen muß ein Doppelkreuz `#` und bei Binärzahlen ein Prozentzeichen `%` vorangestellt werden.


z.B.
|Wert|Bedeutung|
| -------------------- | ------------- |
|`#ABCD`|Hexadezimal|
|`%1010`|Binär|
|`1234`|Dezimal|

#### Strings


Wenn Sie zum Beispiel das Register `A` (Akku) mit dem ASCII-WERT von 'A' laden wollen, so geben Sie ein:

`LD A,"A"` oder für 16-Bit: `LD HL,"AB"`

#### PC

Der Wert des Programmcounters wird durch '$' ausgelesen.

`JR $+10`

#### Operatoren

Die oben genannten Argumente können über die folgenden Operatoren verknüpft werden:
|Operator|Funktion|
| -------------------- | ------------- |
|+|Addition|
|-|Subtraktion|
|*|Multiplikation|
|/|Division|
|?|OR|
|&|AND|
|!|XOR|


Bei eventuellen Über- oder Unterläufen verzweigt Pegasus in den Editor. Es gibt keine Klammern und Vorzeichen. Gerechnet wird ohne Berücksichtigung der Rechenhierarchie von links nach rechts.


#### Pseudobefehle

|Befehl|Beschreibung|
| -------------------- | ------------- |
|`ORG <wert>`|Der MC wird ab Adresse <wert> abgelegt. <wert> muss eine Zahl sein. Bei mehreren ORG-Anweisungen im Quelltext wird bei einer eventuellen Aufzeichnung nur ab dem zuletzt angegebenen ORG-Befehl abgespeichert. |
|`END`|Beendet den Assembliervorgang. Nicht zwingend notwendig.|
|`DEFB <wert>,...`|Hier können ein oder mehrere durch Komma getrennte Byte-Ausdrücke angegeben werden.|
|`DEFW <wert>,...`|wie oben, nur Word-Ausdrücke|
|`DEFM "<text>"`|Der Textstring <text> wird nach der ASCII-Tabelle übersetzt.|
|`DEFS <wert>`|Es werden <wert> Nullbytes im Programm eingesetzt. `<wert>` muss eine 8-Bit Zahl sein.|
|`ENT <wert>`|Definiert die Adresse, ab der der Startvorgang des MC vom Editor aus laufen soll. Dieser Befehl sollte in jedem Assemblerprogramm vorhanden sein.|
|`BRK`|Der Assembler setzt einen Restart-Befehl (RST 6) ins Programm ein. Wird nun das Programm vom Editor aus gestartet und der Prozessor trifft auf den RST 6 so wird der Ablauf gestoppt und die Registerinhalte angezeigt. Ein Tastendruck befördert Sie in den Editor zurück.|

#### Aufbau einer Assemblerzeile:

1. Label, Befehl oder REM
2. Befehl oder REM
3. erster Operand
4. zweiter Operand
5. REM (Semikolon ;)


### Pegasus intern

#### Speicherbelegung

|Speicherbereich|Inhalt|
| -------------------- | ------------- |
|#0170 - #02FF|Frei für Basicprogramme|
|#0300 - #84FF|Speicher für Sourcecode|
|#8500 - #8EFF|Puffer fuer Disk/Kass I/O|
|#8D00 - #A6D0|Pegasus|



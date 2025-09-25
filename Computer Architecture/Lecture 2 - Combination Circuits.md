
A **combinational** circuit
- Contains just logic gates (no flip flops)
- Does not contain any feedback loops
- Calculates a pure Boolean function: the output depends on the inputs (with a gate delay)

A **sequential** circuit
- May contain flip flops
- May contain feedback loops
- May have state (memory) resulting from either flip flops or feedback
- Two categories depending on how timing is handles
	- **Synchronous** - A clock ensures simple behaviour
	- **Asynchronous** - Can have complicated time behaviour

A **combinational** circuit is appropriate for the following scenarios: 
- The output can be calculated from the inputs using expressions
	- Computational is likely to be good
- If state is inherently needed to calculate the output
	- You cannot use combinational, you need sequential 
- If the solution requires an iterative algorithm, it depends
	- Sequential may be easier but combinational might still be effective


Multiplexers use control inputs to select one of the data inputs and output it.

Demultiplexers steer a data input onto one of several outputs, chosen using control inputs.

Bit Adders - halfAdd, fullAdd, ripple carry adder, etc.

#### Half Adder
---
The **half adder** allow us to adds two bits: since the result could be 0, 1, or 2 we need a two-bit representation of the sum, called (carry, sum).

It an help to specify the circuit with the addition (truth) table.
- The carry function is just `and2`
- The sum function is just `xor2`

```
halfAdd x y = (and2 x y, xor2 x y)
```

| x   | y   | result | carry | sum |
| --- | --- | ------ | ----- | --- |
| 0   | 0   | 0      | 0     | 0   |
| 0   | 1   | 1      | 0     | 1   |
| 1   | 0   | 1      | 0     | 1   |
| 1   | 1   | 2      | 1     | 0   |

#### Full Adder
---
A **full adder** allow us to add three bits. This is useful because to add binary numbers, we need to add in the carries, and there are also many ways to implement a full adder.

| x   | y   | z   | c   | s   |
| --- | --- | --- | --- | --- |
| 0   | 0   | 0   | 0   | 0   |
| 0   | 0   | 1   | 0   | 1   |
| 0   | 1   | 0   | 0   | 1   |
| 0   | 1   | 1   | 1   | 0   |
| 1   | 0   | 0   | 0   | 1   |
| 1   | 0   | 1   | 1   | 0   |
| 1   | 1   | 0   | 1   | 0   |
| 1   | 1   | 1   | 1   | 1   |
It is convenient to have separate circuits to calculate the carry and the sum.
```
carry (x, y) z = or3 (and2 x y) (and2 x z) (and2 y z)
sum (x, y) z = xor3 x y z

fullAdd (x, y) z = (carry (x, y) z, sum (x, y) z)
```

#### 4-bit Ripple Carry Adder
---
![[Pasted image 20250925201850.png]]

```
rippleAdd4 cin [x0, x1, x2, x3] [y0, y1, y2, y3] = [c0, s0, s1, s2, s3]
	where
		(c0, s0) = fullAdd (x0, y0) c1
		(c1, s1) = fullAdd (x1, y1) c2
		(c2, s2) = fullAdd (x2, y2) c3
		(c3, s3) = fullAdd (x3, y3) cin
```

#### Design Techniques
---
Question - How would you go about designing a circuit that has to implement some functionality?

Start with a **specification**, which may be either formal or informal. If it is an expression in Boolean algebra serves as implementation.

Be sure you know the circuit's inputs outputs before you try to design it. You can **synthesis circuits** from a truth table, but some are too complex to specify with a truth table. 

Know the basic **building blocks** (logic gates, `mux1`, etc) and use them!
- Many circuits contain a building block replicated for each bit position, e.g. the ripple carry adder.

Always ensure that there is no feedback loop in your combinational logic.

#### Sum of Cases
---
```
mux1 c a b = if c is zero then a else b
```

Instead of designing it randomly, we can apply the "sum of cases" technique directly.
For a multiplexer the two cases are:
- If $c = 0$ the output should be $a$, the case is contributed by `and2 (inv c) a`
- If $c=0$ : the output should be $b$, the case is contributed by `and2 c b`

The final result is obtains as the `logical or` of the cases.
```
mux1 c a b = or2 (and2 (inv c) a) (and2 c b)
```

The sum of cases technique gives a better insight into `mux1`

#### Synthesis From Truth Table
---
A truth table is a logical function specified showing its output for all possible inputs.

You can synthesise a logical expression for the function using the sum of cases.
- The cases are the situation where there is a 1 in the output column.

For example, Full Adder:
```
c = or4 (and3 x' y z) 
		(and3 x y' z)
		(and3 x y z')
		(and3 x y z)
	where 
		x' = inv x
		y' = inv y
		z' = inv z
		
s = or4 (and3 x' y' z)
		(and3 x' y z')
		(and3 x y' z')
		(and3 x y z)
	where 
		x' = inv x
		y' = inv y
		z' = inv z
```

#### Synthesis From Algebraic Logic
---
Combinational circuits are often specified using Boolean algebra, or informally in a form that can be transformed into logic.

For example, the interrupt signal should be 1 if the I/O interrupt signal is 1, or if there is an **overflow condition** and **arithmetic** are not disabled 

This can be rewritten stages, ending up with a precise circuit.
- The interrupt signal should be 1 if either
	- `iointerrupt` is 1, or
	- `ofl` is 1 `arithExcDisable` is 0

```
intSig = or2 ioInterrupt (and2 ofl (inv arithExcDisable))
```

#### Conditional and Cases
---
You can often define a signal as a conditional expression
```
x = if ... then exp1 else exp2
```

This is solved using a **multiplexer**.

If there are more than two cases use:
- A multiplexer with more control bits
- Nested multiplexers

#### Using Encodings - The Demultiplexer
---
Sometimes there is a group of signals, and they all correspond to the $2^k$ cases specified by the $k$ bit opcode.
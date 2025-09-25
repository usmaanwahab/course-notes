Computer architecture is the science and art of interconnecting hardware components to create computer, subject to constraints.
- Hardware Components - gates, circuits, chips, etc
- Computers - desktop, server, mobile phones, etc
- Constraints - performance, energy, cost, etc

Modern systems require an understanding of different levels of abstraction. Computer architecture has three aspects. 

**Instruction Set Architecture (ISA)** which can be thought of as the programmer/compiler view. Instructions visible to the (system) programmer: opcodes, architectural registers, address translation, etc.

**Micro-architecture** which can be thought of as the processor designer view. Logical organisation that implements the ISA: pipe lining, functional units, caches, registers, etc.

**Digital Circuits** which can be though of as the circuit/chip design view. Detailed logic design and packaging technology: gates, wires, cells, CMOS process, etc.

- **Buffer** - Outputs exactly what is input. **Boolean**: $Y = A$
- **Inverter (NOT)**  - Outputs the opposite of the input. **Boolean**: $Y = \bar{A}$
- **AND** - Outputs 1 only if all inputs are 1, otherwise 0. **Boolean**: $Y = A \cdot B$
- **NAND** - Outputs 0 only if all inputs are 1, otherwise 0. **Boolean**: $Y = \overline{A \cdot B}$
- **Inclusive OR (OR)** - Outputs 1 if any input is 1, otherwise 0. **Boolean**: $Y = A + B$
- **Inclusive NOR (NOR)** - Outputs 1 only if all inputs are 0, otherwise 0. **Boolean**: $Y = \overline{A + B}$
- **Exclusive OR (XOR)** - Output 1 if an odd number of inputs are 1, otherwise 0. **Boolean**: $Y = A \oplus B$ 
- **Exclusive NOR (XNOR)** - Outputs 1 if an even number of inputs are 1, otherwise 0. **Boolean**: $Y = \overline{A \oplus B}$ 

A **Computer Hardware Description Language** (CHDL/HDL) is a textual language for specifying and designing digital circuits. Circuits represented in a text document, like a computer program. Offers standard programming techniques (abstractions, algorithmic specification, type checking, simulation). Scale up well to large circuits and supports the use of formal methods.

**Schematic Design** is an abstract picture of a circuit with geometric information. Easier for beginner to understand. It is more obvious that a schematic describes hardware. Schematics break down badly for large complex circuits.

We can use **Hydra** to specify circuits, to simulate them, do formal reasoning and generate netlists.

A **signal** is a value on a wire. An abstraction of the value being used: 0/1, low/high, false/true. In Hydra we write constant signals as **zero/one** not 0/1. 0 and 1 are integers that will be used for describing word sizes.

A **circuit** consists of components connected by signals. Components may be primitives or smaller circuits. We connect a component to its inputs by applying it (just like a function).

```
circuit_name input_signal_names
inv x
and2 x y
or3 p q r
```

A **multiplexer** is a hardware version of the `if-then-else` expression.
```
mux1 c a b = if c is zero then a else b
mux1 c a b = or2(and2 (inv c) a) (and2 c b)
```

We can define a circuit as a black box. Giving it a name, specifying its ports (inputs and outputs). This is analogous to using a function in a programming language, for a commonly used computation.

```
circuit_name input_1 input_2 = (output1, output2)
	where
		output1 = ...
		output2 = ...
		x = ... (internal signal...)
		y = ... (internal signal...)
```
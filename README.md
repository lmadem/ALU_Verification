# ALU Design Verification in UVM Environment
Design of a simple ALU block in Verilog(which can accomodate 8 instructions) and built a verification environment in UVM architecture. The main intension of this repository is to document the verification plan, discuss about the environment architecture and have a hands-on exercise on ALU Design Verification

<details>
  <Summary> ALU BLOCK Spec </Summary>

  #### In general, an arithmetic logic unit(ALU) is a digital circuit that performs arithmetic and bitwise operations on integer binary numbers. It is a fundamental building block of many types of computing circuits, including the central processing unit(CPU), floating-point unit(FPU), and graphics processing units(GPU) 

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/01f008d7-a43c-47c7-8796-fc2198665baf)

  #### A simple ALU design has three parallel data buses consisting of two input operands(A and B), a result output(Y), and a code indicating the operation to be performed(OPCODE). The OPCODE input is also a parallel bus that conveys to the ALU an operation selection code, which is an enumerated value that specifies the desired arithmetic or logic operation to be performed by the ALU
  
</details>


<details>
  <summary> Defining the black box design of ALU </summary>

  #### Designed a simple ALU block which can support 8 instructions(ADD, SUB, MUL, DIV, LOGICALOR, LOGICALAND, COMP, and {LSHIFT, RSHIFT}

  <li> Input Ports : CLK, RESET, INP1, INP2, OP_CODE </li>

  <li> Output Port : OUTP </li>

  #### Input Signals Description

  <li> CLK        : Clock </li>
  <li> RESET      : Asynchronous reset, active high </li>
  <li> INP1       : Parameterized Operand1 </li>
  <li> INP2       : Parameterized Operand2 </li>
  <li> OP_CODE    : 3-bit operation signal </li>

  #### Output Signal Description

  <li> OUTP       : Parameterized result Output </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/974a0ad8-ceb7-47d9-8048-d52e6d09bf6f)

  <li> This is a simple ALU Model implemented in verilog. Please check out the file "alu.v" for verilog code</li>
  
</details>

<details>
  <summary> Verification Strategy </summary>

  #### The verification environment for ALU block is implemented in two methods
  <li> First one is building a predictor component and implementing a reference model in system verilog. please see the file: "predictor_env.sv" </li>
  <li> Second one is implementing a "DPI-C" reference model and embedding it in the environment. please check out the golden/reference model in the file: "alu_cmodel.c" and "predictor_dpi.sv"  </li>

  <details> 
    <summary> Predictor Component Model - environment flow </summary>

![image](https://github.com/lmadem/APB_Slave_Verification/assets/93139766/0dde8c50-ebd8-44db-b94a-9a93d3f8eafd)



  </details>
</details>

<details>
  <summary> DPI-C Reference Model - environment flow </summary>



  </details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/wYVB
  ```

  #### Verification Standards

  <li> Implemented predictor component, robust monitors, driver and DPI-C reference model, and in-order scoreboard. Built a robust & reusable components in UVM architecture </li>

  #### Simulation Steps
  <details>
    <summary> To run predictor model </summary>

##### Open "alu_env_pkg.pkg", uncomment the line with filename: "predictor_env.sv" and comment file: "predictor_dpi.sv"

##### To run base_test : provide +UVM_TESTNAME=base_test in runtime arguments

  </details>
  
  <details>
    <summary> To run DPI-C reference model </summary>

##### Open "alu_env_pkg.pkg", uncomment the line with filename: "predictor_dpi.sv" and comment file: "predictor_env.sv"

##### To run base_test : provide +UVM_TESTNAME=base_test in runtime arguments

##### provide alu_cmodel.c in the compile options(-timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog alu_cmodel.c)

  </details>
</details>


</details>

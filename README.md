# Coprosit

Posit and quire arithmetic coprocessor compliant with the RISC-V eXtension interface [core-v-xif](https://github.com/openhwgroup/core-v-xif). It uses the [PRAU](https://github.com/esl-epfl/PRAU) as execution unit.

![Coprosit diagram](docs/Coprosit_diagram.drawio.svg)

## Posit configuration

To configure the posit size, specify the appropiate flag when running `make sim` or `make synth-pynq-z2`, i.e. `FUSESOC_FLAGS="--flag=use_posit32"`.

In any case, only values of `POSLEN` smaller or equal to `XLEN` are supported (for now). E.g. you can only use posit32 or smaller in a 32-bit CPU.

You can also set flags to include log-approximate multiplication, division and square root units or to include quire operations.

The available flags are the following:
- Posit size: `use_posit8`, `use_posit16`, `use_posit32`, `use_posit64`
- Posit log-approximate units: `use_pos_log_mult`, `use_pos_log_div`, `use_pos_log_sqrt`
- Quire operations: `use_quire`

## Example

~~~bash
source venv/bin/activate
make sim FUSESOC_FLAGS="--flag=use_posit32 --flag=use_quire"
cd build/esl-epfl_ip_coprosit_0.0.1/sim-modelsim
make run-gui
~~~

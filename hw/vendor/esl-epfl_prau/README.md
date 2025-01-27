# PRAU: Posit and quiRe Arithmetic Unit

PRAU started its journey as the Posit Arithmetic Unit (PAU) available in the [PERCIVAL](https://github.com/artecs-group/PERCIVAL) posit RISC-V core.

## Posit configuration

To configure the posit size, specify the appropiate flag when running FuseSoC, i.e. `--flag=use_posit32`.
You can also set flags to include log-approximate multiplication, division, and square root units, or to include quire operations.

The available flags are the following:
- Posit size: `use_posit8`, `use_posit16`, `use_posit32`, `use_posit64`
- Posit log-approximate units: `use_pos_log_mult`, `use_pos_log_div`, `use_pos_log_sqrt`
- Quire operations: `use_quire`

## Example

~~~bash
fusesoc --cores-root . run --no-export --target=sim --flag=use_posit32 --flag=use_quire --setup --build esl-epfl:ip:prau:0.0.1
cd build/esl-epfl_ip_prau_0.0.1/sim-modelsim
make run-gui
~~~

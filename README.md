# tcpsnitch\_analyzer

Analysis tool for [tcpsnitch](https://github.com/GregoryVds/tcpsnitch) traces. 

## Usage

Accepts a single or multiple tcpsnitch JSON traces as argument and compute statistical information.

The `-a` option indicates the type of statistical analysis to perform on the traces:
- Descriptive statistics: use `-a desc` or `-a d`. Compute a serie of descriptive statistics for values at a given node in the JSON trace. Valid for numerical values only.
- Proportion breakdown: use `-a prop` or `-a p`. Compute a proportion breakdown of values at a given node in the JSON. Valid for discrete values only.
- Time serie: use `-a time` or `-a t`. Shows a time-serie plot of values at a given node in the JSON. Use the timestamp on the X axis.

Two other important options are:
- `-e` to filter on a specific type of event.
- `-n` which specify on which node of the JSON the analysis should be performed.

Run `./tcpsnitch_analyzer -h` for more information about usage.

## Installation

- `gem install tcpsnitch_analyzer`
- TO CHECK: Requries gnu-plot: `sudo apt-get install gnu-plot` to install gnu-plot.

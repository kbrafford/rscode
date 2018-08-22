# rscode
Reed-Solomon Code by **Henry Minsky**

This is a fork of Henry Minsky's Reed-Solomon error correction code.  [The original repository is here](http://rscode.sourceforge.net/).

The code is GPL and a very reasonable licensing structure is available for uses where the GPL is unsuitable. From Minsky's page:

   *The code is licensed under the GPL, however a commercial license is also available. A royalty-free license to modify and redistribute the
   code in binary or source form is available. [Pricing info is available here](http://beartronics.com/rscode.html). Please contact
   [hqm@alum.mit.edu](hqm@alum.mit.edu)*

### This repo
This github-hosted project has the original source code in unmodified form, with the following build configuration additions:

#### Docker-hosted build for the following targets
 * 64-bit Windows example program *(done)*
 * 32-bit Windows example program
 * 64-bit Windows static library *(done)*
 * 32-bit Windows static library
 * 64-bit Windows dll *(done)*
 * 32-bit Windows dll
 * 64-bit Linux example program
 * 32-bit Linux example program
 * 64-bit Linux static library
 * 32-bit Linux static library
 * 64-bit Linux shared library
 * 32-bit Linux shared library
 

#### More Configuration Options
 * 64-bit Python2/3 wrapper class (cross platform)
 * 32-bit Python2/3 wrapper class (cross platform)
 
### Docker
This project is being developed using [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) on **Windows 7** and **Windows 10**, and will be tested on a **Mint Linux** virtual machine as time allows. I welcome any feedback about how the Docker strategy is handled here.

The docker container being used to generate windows output is [https://hub.docker.com/r/kbrafford/win-gcc/](https://hub.docker.com/r/kbrafford/win-gcc/) (Source: [https://github.com/kbrafford/win-gcc](https://github.com/kbrafford/win-gcc))
# rscode
Reed-Solomon Code by **Henry Minsky**


### *Hi. The RSCODE project is an implementation of a Reed-Solomon error correction algorithm. Error correcting codes are marvelous jewels of mathematics and algorithms, providing an almost supernatural ability to recover good data from a corrupted channel.*

This github repository is a fork of Henry Minsky's Reed-Solomon error correction code.  [The original repository is here](http://rscode.sourceforge.net/).

The code license is the GPL, and a very reasonable licensing structure is available for uses where the GPL is unsuitable. From Minsky's page:

   *The code is licensed under the GPL, however a commercial license is also available. A royalty-free license to modify and redistribute the
   code in binary or source form is available. [Pricing info is available here](http://beartronics.com/rscode.html). Please contact
   [hqm@alum.mit.edu](hqm@alum.mit.edu)*


### This repo ([http://github.com/kbrafford/rscode](http://github.com/kbrafford/rscode))
This github-hosted project has the original source code in unmodified form, as well as a new docker-based build platform and Python wrapper class.

### Docker
The C and libraries for this project are developed using [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) on **Windows 7** and **Windows 10**, and will be tested on a **Mint Linux** virtual machine as time allows. I welcome any feedback about how the Docker strategy is handled here.

The docker container being used to generate windows output is [https://hub.docker.com/r/kbrafford/win-gcc/](https://hub.docker.com/r/kbrafford/win-gcc/) (Source: [https://github.com/kbrafford/win-gcc](https://github.com/kbrafford/win-gcc))


#### Docker-hosted build for the following targets


##### Example Executables
| Target         | Status        |
| -------------- |:-------------:|
| 64-bit Windows | ***(done)***  |
| 32-bit Windows |   *(todo)*    |
| 64-bit Linux   |   *(todo)*    |
| 32-bit Linux   |   *(todo)*    |


##### Static Libraries
| Target         | Status        |
| -------------- |:-------------:|
| 64-bit Windows | ***(done)***  |
| 32-bit Windows |   *(todo)*    |
| 64-bit Linux   |   *(todo)*    |
| 32-bit Linux   |   *(todo)*    |


##### Dynamic Link Libraries
| Target         | Status        |
| -------------- |:-------------:|
| 64-bit Windows .dll | ***(done)***  |
| 32-bit Windows .dll |   *(todo)*    |
| 64-bit Linux .so    |   *(todo)*    |
| 32-bit Linux .so    |   *(todo)*    |

   
#### More Configuration Options
| Target         | Status        |
| -------------- |:-------------:|
| 32/64-bit Python2/3 wrapper class (cross platform) |   *(todo)*    |

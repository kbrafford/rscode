# rscode
Reed-Solomon Code by **Henry Minsky**


### *Hi. The RSCODE project is an implementation of a Reed-Solomon error correction algorithm. Error correcting codes are marvelous jewels of mathematics and algorithms, providing an almost supernatural ability to recover good data from a corrupted channel.*

This github repository is a fork of Henry Minsky's Reed-Solomon error correction code.  [The original repository is here](http://rscode.sourceforge.net/).

The code license is the GPL, and a very reasonable licensing structure is available for uses where the GPL is unsuitable. From Minsky's page:

   *The code is licensed under the GPL, however a commercial license is also available. A royalty-free license to modify and redistribute the
   code in binary or source form is available. [Pricing info is available here](http://beartronics.com/rscode.html). Please contact
   [hqm@alum.mit.edu](hqm@alum.mit.edu)*


#### This repo
[http://github.com/kbrafford/rscode](http://github.com/kbrafford/rscode)

This github-hosted project has the original source code in unmodified form, as well as a new docker-based build platform and Python wrapper class.

If you build it on Windows or Linux, you get a sample executable, static library, and shared library for both 32-bit and 64-bit Windows and Linux.

If you build it on the Mac, you get all of the Windows and Linux targets, as well as an executable, static lib, and shared lib for the Mac as well.


#### Docker
The C and libraries for this project are developed using [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) on **Windows 7** and **Windows 10**, [Docker for Mac](https://docs.docker.com/docker-for-mac/install/) on the **Mac**, and will be tested on a **Mint Linux** virtual machine as time allows. I welcome any feedback about how the Docker strategy is handled here.

I typically set up Docker on my Linux machine thusly:
```
# First import the GPG key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys \
58118E89F3A912897C070ADBF76221572C52609D

# Next, point the package manager to the official Docker repository
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

# Installing both packages will eliminate an unmet dependencies error when you try to install the 
# linux-image-extra-virtual by itself
sudo apt install -y linux-image-generic linux-image-extra-virtual
 
# Reboot the system so it would be running on the newly installed kernel image 
sudo reboot
```

Then do this:
```
sudo apt install -y docker.io
sudo groupadd docker
sudo usermod -aG docker $USER
```


###### Containers Being Used
| Target OS         | Container        |  Source  |
| -------------- |-------------|------------|
| Windows  | [https://hub.docker.com/r/kbrafford/win-gcc/](https://hub.docker.com/r/kbrafford/win-gcc/) | [https://github.com/kbrafford/win-gcc](https://github.com/kbrafford/win-gcc)|
| Linux    | [https://hub.docker.com/r/kbrafford/x86_64-linux-gcc/](https://hub.docker.com/r/kbrafford/x86_64-linux-gcc/) |[https://github.com/kbrafford/x86_64-linux-gcc](https://github.com/kbrafford/x86_64-linux-gcc)|
| Mac OS X | (N/A -- Mac builds are handled natively, but on mac only)


**Note:** On Windows 7 and 10 using Docker Toolbox, I find that I need to check out this repo in C:\Users\Public in order for Docker to correctly get the *-v* volume mapping option to work. I do not know why this is, but it appears to be normally expected behavior, so I don't assume it's a big problem.

**Note:** None of this has been tested on Linux yet.

**Note:** If you're on Linux or Mac, make sure `_getcwd.py` is marked as executable.  I'll stop using this python hack once I figure out the best way to migrate that hack into the makefile, but that will have to wait until I get all of my test setups working.

#### Status

| Target Architecture        | Executable Status | Library Status | Shared Library Status |
| -------------- |:-------------:|:-------------:|:-------------:|
| 64-bit Windows | ***(done)***  | ***(done)***  | ***(done)***  |
| 32-bit Windows | ***(done)***  | ***(done)***  | ***(done)***  |
| 64-bit Linux   | ***(done)***  | ***(done)***  | ***(done)***  |
| 32-bit Linux   | ***(done)***  | ***(done)***  | ***(done)***  |
| Mac            | ***(done)***  | ***(done)***  | ***(done)***  |

    
| Target         | Status        |
| -------------- |:-------------:|
| 32/64-bit Python2/3 wrapper class (cross platform) |   *(todo)*    |

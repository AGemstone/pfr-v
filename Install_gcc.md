## GUíA PARA LA INSTALACIÓN DEL COMPILADOR DE GCC PARA ARQUITECTURA RISC-V

Los siguientes pasos están escritos para que, con el acceso a una terminal, puedas instalar sin problemas un compilador GCC para usarlo con la arquitectura RISC-V. En caso que haya algún problema a la hora de compilar los mismos, vamos a incluir al final del archivo una sección con posibles errores y sus soliciones.

## Acceder al repo de Risc-V

`$ git clone https://github.com/riscv/riscv-gnu-toolchain`
`$ cd riscv-gnu-toolchain`

## Instalar prerequisitos para la instalación del compilador

### Ubuntu

1. `$ sudo apt-get install autoconf automake autotools-dev curl python3 python3-pip libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build git cmake libglib2.0-dev`

### Fedora/CentOS/RHEL OS

`$ sudo yum install autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel`

### Arch Linux

`$ sudo pacman -Syyu autoconf automake curl python3 libmpc mpfr gmp gawk base-devel bison flex texinfo gperf libtool patchutils bc zlib expat`

### OS X

`$ brew install python3 gawk gnu-sed gmp mpfr libmpc isl zlib expat texinfo flock`

## Configurar el make para que la instalación se haga de forma correcta:

 `$ ./configure --prefix=/opt/riscv --with-arch=rv64iazicsr --with-abi=lp64 --enable-multilib`

## Ejecutamos el compilador, este paso suele demorar bastante (Descarga de hasta 6GB) (2h 31min última ejecución)

`$ sudo make`

Con esto deberíamos tener instalado el compilador. Este se va a instalar por default en la dirección `/opt/riscv/bin/`

Para realizar un ejemplo, pueden escribir un script sencillo en C que sea un "Hello World", lo podemos probar de la siguiente manera:

`$ /opt/riscv/bin/riscv64-unknown-elf-gcc hello.c`

Esto debería conseguirles un archivo `a.out`, en el cual, si ejecutamos el comando:

`$ file a.out`

Nos debería dar el siguiente resultado:

`a.out: ELF 64-bit LSB executable, UCB RISC-V, soft-float ABI, version 1 (SYSV), statically linked, with debug_info, not stripped`

Con esto ya tenemos instalado un compilador de C que puede compilar programas para el uso en una arquitectura RISC-V

----

## Posibles errores
TODO: lo más probable es que sean prerequisitos que falten, depende de las dependencias instaladas anteriormente del usuario. A medida que surjan estos casos, vamos a seguir aumentando esta sección.


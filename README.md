# P4-Kataran

```bash
p4c-ebpf --arch psa --xdp -o OUTPUT.c test.p4

```

## Compilation

You can compile a P4-16 PSA program for eBPF in a single step using:

```bash
make -f backends/ebpf/runtime/kernel.mk BPFOBJ=out.o P4FILE=<P4-PROGRAM>.p4 P4C=p4c-ebpf psa
```

You can also perform compilation step by step:

```
$ P4C_DIR=path/to/your/copy/of/p4c/repo
$ p4c-ebpf --arch psa --target kernel -o out.c main.p4
$ clang -I${P4C_DIR}/backends/ebpf/runtime -I${P4C_DIR}/backends/ebpf/runtime/usr/include -O2 -g -c -emit-llvm -o out.bc out.c
```

Note that you can use `-mcpu` flag to define the eBPF instruction set. Visit [this blog post](https://pchaigno.github.io/bpf/2021/10/20/ebpf-instruction-sets.html) to learn more about eBPF instruction sets.

The above steps generate `out.o` BPF object file that can be loaded to the kernel. 

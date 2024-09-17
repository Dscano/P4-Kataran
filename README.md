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
$ p4c-ebpf --arch psa --target kernel -o out.c <program>.p4
$ clang -Ibackends/ebpf/runtime -Ibackends/ebpf/runtime/usr/include -O2 -g -c -emit-llvm -o out.bc out.c
$ llc -march=bpf -mcpu=generic -filetype=obj -o out.o out.bc
```

Note that you can use `-mcpu` flag to define the eBPF instruction set. Visit [this blog post](https://pchaigno.github.io/bpf/2021/10/20/ebpf-instruction-sets.html) to learn more about eBPF instruction sets.

The above steps generate `out.o` BPF object file that can be loaded to the kernel. 

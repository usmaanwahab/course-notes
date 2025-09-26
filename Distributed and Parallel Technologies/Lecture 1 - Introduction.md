Moore's Law is the idea that computational power will increase as we increase the density of transistors. There is still a (near) exponential growth in number of transistors per chip, but it is non-trivial to get to 1-2nm.

Performance/frequency per core is not increasing (much), there are physics constraints as too much heat can cause the chips to melt. Possible solutions are more caching, having multiple cores per chip, and inventing/using novel architectures.

Compute fabric has changed such that devices have many different types of cores. Graphical processing cores, vector processors, low power cores, tensor processing units, FPGAs, etc.

This heterogeneity comes with challenges:
- How do we use the right compute for the right job?
- How much to expose to the programmer?
- Can we use the compute without understanding all the details?
- What is the porting effort for existing code?

The **shared memory architectures** involes a single address (possibly virtual) where threads synchronise on shared variables. Programming models: pthreads, Go, OpenMP.
Locality is not a huge issue on shared memory architectures unless you need every cycle of performanc, as there is high bandwidth, low latency memory access. However, there is limit scalability, 32 cores per socket (and memory bus) before contention kill performance.

The **distributed memory architecture** involves no direct memory access, and synchronisation via explicit messages. Networks are scalable due to fancy topologies (e.g. dragonfly). However it is low bandwidth and high latency. This is commonly used in HPC, cloud and clusters, allowing for 100's+ of (full features) cores.

A **hybrid memory architecture** may have elements of both shared and distributed memory. This can involve racks of shared memory machines connected via networks, different memory on one machine (CPU memory + GPU memory) which is still distributed but the bandwidth/latency is different.
Most systems are **Non-Uniform Memory Access** architectures (NUMA). This is where memory blocks are closer to certain cores. It is still shared memory (single address space) but it can perform like (fast) distributed memory.

A lot of effort is expended to pretend memory is flat/uniform.1
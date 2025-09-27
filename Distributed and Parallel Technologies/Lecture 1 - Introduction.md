Moore's Law is the idea that computational power will increase as we increase the density of transistors. There is still a (near) exponential growth in number of transistors per chip, but it is non-trivial to get to 1-2 nanometres.

Performance/frequency per core is not increasing (much), there are physics constraints as too much heat can cause the chips to melt. Possible solutions are more caching, having multiple cores per chip, and inventing/using novel architectures.

Compute fabric has changed such that devices have many different types of cores. Graphical processing cores, vector processors, low power cores, tensor processing units, FPGAs, etc.

This heterogeneity comes with challenges:
- How do we use the right compute for the right job?
- How much to expose to the programmer?
- Can we use the compute without understanding all the details?
- What is the porting effort for existing code?

The **shared memory architectures** involves a single address (possibly virtual) where threads synchronise on shared variables. Programming models: pthreads, Go, OpenMP.
Locality is not a huge issue on shared memory architectures unless you need every cycle of performance, as there is high bandwidth, low latency memory access. However, there is limit scalability, 32 cores per socket (and memory bus) before contention kill performance.

The **distributed memory architecture** involves no direct memory access, and synchronisation via explicit messages. Networks are scalable due to fancy topologies (e.g. dragonfly). However it is low bandwidth and high latency. This is commonly used in HPC, cloud and clusters, allowing for 100's+ of (full features) cores.

A **hybrid memory architecture** may have elements of both shared and distributed memory. This can involve racks of shared memory machines connected via networks, different memory on one machine (CPU memory + GPU memory) which is still distributed but the bandwidth/latency is different.
Most systems are **Non-Uniform Memory Access** architectures (NUMA). This is where memory blocks are closer to certain cores. It is still shared memory (single address space) but it can perform like (fast) distributed memory.

A lot of effort is expended to pretend memory is flat/uniform, but is this really the best idea?

Hybrid configurations provide several challenges?
- How to best utilise components, for example the placement of computation of physical cores/nodes, the placement of data and concerns of data replication. You must also consider when to communicate about what data has been.
- What programming model to use, for example using two languages, one local and one remote, how to port tricky abstractions?, moving a thread barrier to distributed threads can work, but it will kill performance etc.

Using multiple compute units enables two things:
- **Parallelism** - Doing many tasks simultaneously towards a common goal, normally concerned with performance
- **Concurrency** - Expressing computations as interactions between different threads. A way to structure programs; less concerned with performance. For example, GUI is concurrent to the model underneath.

We use multiple compute units because:
- **Distribution** - some problems need multiple hosts, for example, a supermarket with one point of sale per shop. There could also be locality constraints, for example, wireless sensors are locality based.
- **Mobility** - to provide robustness to failure, for example, many micro services are moving over to cloud.

**Scalability** is a metric usually reserved for parallel system/tasks. It involves measuring how well a program can utilise extra cores. Typically to use HPC facilities you need to demonstrate that you will benefit from more cores. **Variants** allow changing workloads.

**Throughput** is a metric usually reserved for distributed system. It involves metrics such as request per second. It typically involves specific service level agreements such as up-time, latency, quality of service.

**Reliability** is a core consideration for many systems as failures can be expensive.

Distributed system mitigate failure via **redundancy**. That is multiple software copies are on multiple hosts typically at multiple locations. There are micro service architectures based on this. However, in distributed systems there are more points of failure (network cards, etc.), and thus there is more chance of a component failing as even if each device has a low failure rate, the chances of 1 of $n$ devices failing is much greater. So these systems need to be considered carefully.

HPC system usually just buy expensive hardware with low failure rates. They checkpoint progress regularly. If something fails, stop everything and run from the checkpoint. This scales well, is very easy to implement and utilises the fancy parallel file system well, although it can take ages to get jobs rescheduled.

Cloud systems usually buy cheaper commodity hardware, under the assumption that they will fail. So they embed recovery in the frameworks: micro-services, hadoop/mapreduce, erlang, scala, etc.

Concurrency is hard because concurrent system can be in many possible states, and the number of states grows faster than expected. It is already difficult to get sequential programs correct: correctness, data structure choice, efficiency.

Multi-threaded programs also have coordination, when and how are resources being used, where the states explode.

There are several import aspects of coordination:
- **Partitioning** - Which parts of the computation can and should be broken down. Large chunks don't utilise resources whereas small chunks overwhelm resources.
- **Placement** - Should use local or distributed, where is the data/memory?
- **Communication** - What data to send, is it better to recompute instead? When to send messages?
- **Synchronisation** - Handle the "state space explosion", how should thread interact? Who has priority, on which resources
- **Scheduling** - Which thread executes next (especially important for concurrency), is there ordering needed even over distributed hosts?
- **Fault Tolerance** - How to detect failures? How to recover from failures?

Different programming models have different ways to think about coordination 
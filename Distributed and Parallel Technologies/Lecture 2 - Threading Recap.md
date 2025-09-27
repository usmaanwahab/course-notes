An operating system executes many processes at once (physically: parallel, multiplexing: concurrently). Each process has its own (virtual) address space. This is important for distributed memory concurrency. Even on one host this is essentially distributed (due to page security).

Threads are a separate object of execution within a process, that share the same address space as its parent. These threads are usually mapped to physical threads by the operating system. For example, the POSIX standard.

The thread lifecycle is simple. 
- Fork (create) a thread with a set of instructions or entry point (usually a function pointer).
- Wait till threads finish and join back with the parent thread.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <assert.h>

void printHello() {
	printf("Hello from a thread\n");
}

int main() {
	pthread_t t;
	// (thread_id, attributes, fn, args)
	int e = pthread_create(&t, NULL, printHello, NULL);
	assert(e == 0)
	// second arg is address for return values
	e = pthread_join(t, NULL)
	assert(e == 0)
}
```

Threads that are executing independent functions with no dependencies and returning a value are easy to reason about.

However, many problems require communication between threads, it is the key to parallel programming. Communication needs some resource, usually memory, since memory is normally shared, it could also be file handler or even a network interface.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <assert.h>

static int counter = 0;

void foo() {
	for (int i = 0; i < 1000000; i++) {
		counter++;
		couner--;
		assert(counter == 0);
	}
}

int main()
{
	pthread_t t1, t2;
	pthread_create(&t1, NULL, foo, NULL);
	pthread_create(&t2, NULL, foo, NULL);
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
}

```

**Critical Region** is an area of code where the shared resource must be consistent.
**Mutual Exclusion** is a mechanism used to ensure only a single thread executes a critical section. Usually it is just a shared flag, and atomic memory instructions.

Typically, a lock is **acquired** while a thread is executing within the critical region as is **released** when the thread exits the scope of the critical region.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
static int counter = 0;
pthread_mutex_t m;

void* foo(void*) {
	for (int i = 0; i < 1000000; i++) {
		pthread_mutex_lock(&m);
		counter = counter + 1;
		counter = counter - 1;
		assert(counter == 0);
		pthread_mutex_unlock(&m);
	}
}

int main() {
	pthread_t t1, t2;
	pthread_mutex_init(&m, NULL);
	pthread_create(&t1, NULL, foo, NULL);
	pthread_create(&t2, NULL, foo, NULL);
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
	pthread_mutex_destroy(&m);
}
```

A **deadlock** occurs when no thread can make progress, usually due to one thread waiting for a resource from another thread.

A **live-lock** occurs when no threads exchange state but don't make progress.

A **condition variable** is useful as it avoid **busy waiting**. It sends a signal to a thread when it has been updated to check the condition variable.

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

static int counter = 100;
static pthread_mutex_t m;
static pthread_cond_t c;

void zeroer() {
	pthread_mutex_lock(&m);
	while (counter != 42) {
		pthread_cond_wait(&c, &m);
	}
	counter = 0;
	pthread_mutex_unlock(&m);
	return NULL;
}

void setter() {
	sleep(rand() % 5);
	pthread_mutex_lock(&m);
	counter = 42;
	pthread_mutex_unlock(&m);
	pthread_cond_signal(&c);
	return NULL;
}
int main() {
	pthread_t t1, t2;
	pthread_mutex_init(&m, NULL);
	pthread_cond_init(&c, NULL);
	// (Thread id, attributes, fn, args)
	pthread_create(&t1, NULL, zeroer, NULL);
	pthread_create(&t2, NULL, setter, NULL);
	pthread_join(t1, NULL); pthread_join(t2, NULL);
	printf("Counter: %d\n", counter);
	pthread_cond_destroy(&c);
}
```

**Semaphores** provide an abstraction based on a counter, mutex and condition variable.

**Futures** are another higher level abstraction, they typically represent a possibly value that has yet to be computed. A `get()` call to the future will then block until the value is ready. These futures can be passed around, so the creating thread doesn't need to be the reader.

**Barriers** are used to wake all threads once $n$ threads call `wait`. They are used when all threads need to finish to continue.
#ifndef __QUEUE_H
#define __QUEUE_H

typedef struct queue queue_t;

void enqueue(queue_t queue, unsigned int value);
void dequeue(queue_t queue);

#endif
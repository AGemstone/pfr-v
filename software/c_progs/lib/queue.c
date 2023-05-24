#define MAX_QUEUE_SIZE 64
struct queue {
  uint32_t data[MAX_QUEUE_SIZE];
  unsigned long first;
  unsigned long last;
  unsigned long size;
};

typedef struct queue queue_t;

queue_t queue_init() {
  queue_t queue;
  queue.first = 0;
  queue.last = -1;
  queue.size = 0;
  return queue;
}

bool is_empty(queue_t *queue) { return queue->size == 0; }
bool is_full(queue_t *queue) { return queue->size == MAX_QUEUE_SIZE; }

void enqueue(queue_t *queue, uint32_t value) {
  if (!is_full(queue)) {
    queue->last++;
    queue->data[queue->last] = value;
    queue->size++;
  }
}

void dequeue(queue_t *queue, uint32_t n) {
  if (!is_empty(queue) && n > 0) {
    queue->first += n;
    queue->size -= n;
  }
}

void swap(uint32_t *data, uint32_t i, uint32_t j) {
  uint32_t temp = data[i];
  data[i] = data[j];
  data[j] = temp;
}

// Just be careful with it
void sort(queue_t *queue) {
  for (uint32_t i = 0; i < (queue->size >> 1); i++) {
    for (uint32_t j = queue->first; j < queue->last - 1; j += 2) {
      if (queue->data[j + 2] < queue->data[j]) {
        swap(queue->data, j, j + 2);
        swap(queue->data, j + 1, j + 3);
      }
    }
  }
}

uint32_t find(queue_t *queue, uint32_t item) {
  uint32_t index = INFINITY;
  for (uint32_t i = queue->first + 1; i < queue->last; i += 2) {
    if (queue->data[i] == item) {
      index = i;
      break;
    }
  }
  return index - 1;
}
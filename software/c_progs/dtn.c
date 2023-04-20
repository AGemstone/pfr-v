#ifdef RV
void printf(const char *){}
#else
#include <stdio.h>
#endif

#define MESH_NODE_COUNT 16
#define MAX_NEIGHBORS 8
#define MESSAGE 0xfeedc0dedeadbeef


typedef enum { DOWN, UP } status_t;
typedef struct Node {
  status_t status:1 ;
  unsigned int cost : 31;
  unsigned int index;
  unsigned int neighbor_count;
  unsigned int neighbors[MAX_NEIGHBORS];
  long long message;
} Node_t;

void network_init(Node_t *network) {
  unsigned int neighbors_per_layer[4] = {5,8,8,5};
  network[0] = (Node_t){.status = UP,
                        .index = 0,
                        .message = MESSAGE,
                        .neighbor_count = 4,
                        .neighbors = {1, 2, 3, 4}};

  for (unsigned int i = 1; i < MESH_NODE_COUNT + 2; i++) {
    network[i].index = i;
    network[i].status = UP;
    network[i].message = 0;
  }
  for (unsigned int i = 0; i < 4; i++) {
    for(unsigned int j = 0; j < 4; j++){
        network[(j+1)*4].neighbor_count = neighbors_per_layer[i];
    }
    for(unsigned int j = 0; j < 4; j++){}
    for(unsigned int j = 0; j < 4; j++){}
  }
    // network[MESH_NODE_COUNT + 1] = ;
}

int main() {
  // first and last are endpoints
  // we assume the relative distance between the nodes stays the same
  Node_t network[MESH_NODE_COUNT + 2];
//   network_init(network);
//   for (;;)
//     ;
  return 0;
}
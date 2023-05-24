#include "compile_helpers.h"
#include "rand.h"
#include <stdbool.h>

#define NET_NODES 4
#define NET_LEVEL_COUNT_BITS 2
// Level count should be a power of 2 for faster computation
#define NET_LEVELS (1 << NET_LEVEL_COUNT_BITS)
#define NET_SIZE (NET_NODES * NET_LEVELS + 2)
#define SENDER_INDEX (NET_SIZE - 1)
#define RECIEVER_INDEX (NET_SIZE - 2)
#define INFINITY (~0)
#define RUN_COUNT 10
#define SAME_LEVEL_COST 10
#define SEED 0xaddc0defe3d5ee3d

// Using powers of 2 we can calculate modulus this way
#define UMOD2(n, bits) (n & ((1 << bits) - 1))
#define GET_LEVEL(INDEX) (INDEX >> NET_LEVEL_COUNT_BITS)
#define ABS(n) (n < 0 : -n : n)

typedef unsigned int uint32_t;

typedef struct Node {
  bool up;
  // bool visited;
  uint32_t neighbor_cost[NET_NODES];
} Node_t;

#pragma GCC push_options
// #pragma GCC optimize ("O2")

void random_status_all(Node_t *network) {
  for (uint32_t i = 0; i < NET_SIZE - 2; i++) {
    // 75% chance to be up
    network[i].up = UMOD2(rand(), 10) > 255;
    for (uint32_t j = 0; j < NET_NODES; j++)
      network[i].neighbor_cost[j] = UMOD2(rand(), 10);
  }

  // Ensure at least one node from first level is up
  unsigned char down_count = 0;
  for (uint32_t i = 0; i < NET_NODES; i++) {
    down_count += !network[i].up;
  }
  if (down_count == NET_NODES) {
    network[UMOD2(rand(), 2)].up = true;
  }

  // Recalculate cost to send to first level
  for (uint32_t j = 0; j < NET_NODES; j++)
    network[SENDER_INDEX].neighbor_cost[j] = UMOD2(rand(), 10);
}

void random_status_level(Node_t *network, uint32_t level) {
  for (uint32_t i = 0; i < NET_NODES; i++) {
    uint32_t index = level * NET_NODES + i;
    // 75% chance to be up
    network[index].up = UMOD2(rand(), 10) > 255;
    for (uint32_t j = 0; j < NET_NODES; j++)
      network[index].neighbor_cost[j] = UMOD2(rand(), 10);
  }
}

// Always try to go FORWARD
// Disregard neighbors of same level unless all neighbors of next level are down
uint32_t greedy_path(Node_t *network) {
  uint32_t min_cost = INFINITY;
  uint32_t current_node, current_cost;

  // Select the first network node
  // First level always has one node up, otherwise we would wait to send
  for (uint32_t i = 0; i < NET_NODES; i++) {
    if (network[i].up) {
      if (network[SENDER_INDEX].neighbor_cost[i] < min_cost) {
        current_node = i;
        min_cost = network[SENDER_INDEX].neighbor_cost[i];
        current_cost = network[SENDER_INDEX].neighbor_cost[i];
      }
    }
  }

  // Route to Reciever
  while (GET_LEVEL(current_node) != NET_LEVELS) {
    uint32_t next_node = current_node;
    uint32_t neighbor_count =
        GET_LEVEL(current_node) < (NET_LEVELS - 1) ? NET_NODES : 1;
    min_cost = INFINITY;
    for (uint32_t i = 0; i < neighbor_count; i++) {
      uint32_t neighbor_index = (GET_LEVEL(current_node) + 1) * NET_NODES + i;
      if (network[neighbor_index].up) {
        if (network[current_node].neighbor_cost[i] < min_cost) {
          next_node = neighbor_index;
          min_cost = network[current_node].neighbor_cost[i];
        }
      }
    }
    // if next_node is unchanged, all next nodes are down
    if (next_node == current_node) {
      // go to same level neighbor and "wait" for a node to be up
      current_node =
          GET_LEVEL(current_node) * NET_NODES + UMOD2(current_node + 1, 2);
      current_cost += SAME_LEVEL_COST;
      random_status_level(network, GET_LEVEL(current_node) + 1);
    } else {

      current_node = next_node;
      current_cost += min_cost;
    }
  }

  return current_cost;
}

// Cost between same level is fixed known value
// Cost for next level is random
// Can't go backwards
// If at last level only consider first neighbor (the reciever)

void network_init(Node_t *network) {

  // Network nodes
  for (uint32_t i = 0; i < NET_SIZE - 2; i++) {
    network[i].up = true;

    for (uint32_t j = 0; j < NET_NODES; j++)
      network[i].neighbor_cost[j] = UMOD2(rand(), 10);
  }

  // // Endpoints
  network[RECIEVER_INDEX].up = true;
  network[SENDER_INDEX].up = true;

  for (uint32_t j = 0; j < NET_NODES; j++) {
    network[RECIEVER_INDEX].neighbor_cost[j] = -1;
    network[SENDER_INDEX].neighbor_cost[j] = UMOD2(rand(), 10);
  }
}
#pragma GCC pop_options
int main() {
  rand_init(SEED);

  Node_t network[NET_SIZE];
  network_init(network);
  uint32_t cost[RUN_COUNT];
  for (uint32_t i = 0; i < RUN_COUNT; i++) {
    cost[i] = greedy_path(network);
    random_status_all(network);
  }
  // Expected costs:
  // {1627, 724, 929, 2052, 1605, 1065, 1842, 1464, 1421, 2150}
  return 0;
}
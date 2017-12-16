#include <pthread.h>
#include <stdio.h>


int x = 17000;
int y = 12000;


void drop_x()
{
  while (x--)
    {
      printf("x: %d\n", x);
      if (x % 10 == 0)
	sched_yield();
    }
}


void drop_y()
{
  while (y--)
    {
      printf("y: %d\n", y);
      if (y % 5 == 0)
	sched_yield();
    }
}


int main()
{
  pthread_t thread_x;
  pthread_t thread_y;

  pthread_create(&thread_x, 0, drop_x, 0);
  pthread_create(&thread_y, 0, drop_y, 0);

  pthread_join(thread_x, 0);
  pthread_join(thread_y, 0);

  return 0;
}

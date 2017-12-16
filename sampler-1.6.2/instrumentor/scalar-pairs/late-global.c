int early = 0;
int counter = 0;

void incr()
{
  ++counter;
}

int late = 0;

void decr()
{
  --counter;
}


int main()
{
  incr();
  decr();
  return 0;
}

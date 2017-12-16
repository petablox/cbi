enum Channel { Alpha, Red, Green, Blue };


void set(enum Channel *holder, enum Channel value)
{
  *holder = value;
}


int main()
{
  enum Channel channel;
  set(&channel, Green);
  set(&channel, Blue);
  channel = Red;

  return 0;
}

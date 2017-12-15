int opaque();


int x;


void loopy()
{
  while (opaque())
    ++x;
}


void conditional()
{
  if (x)
    loopy();
  else
    conditional();
}

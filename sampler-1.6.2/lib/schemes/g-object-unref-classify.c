#include <glib-object.h>
#include "g-object-unref.h"


unsigned cbi_gObjectUnrefClassify(gpointer chaff)
{
  if (G_LIKELY(G_IS_OBJECT(chaff)))
    switch (((GObject *) chaff)->ref_count)
      {
      case 0:
	return 0;
      case 1:
	return 1;
      default:
	return 2;
      }
  else
    return 3;
}

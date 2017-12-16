#include <glib-object.h>


typedef struct _Test Test;
typedef struct _TestClass TestClass;

struct _Test
{
  GObject parent;
};

struct _TestClass
{
  GObjectClass parent;
};


static void
test_init (GTypeInstance *instance, gpointer g_class)
{
  Test *self = (Test *) instance;
}


static void
test_finalize (Test *self)
{
  g_object_unref (self);
}


static void
test_class_init (TestClass *klass)
{
  klass->parent.finalize = (GObjectFinalizeFunc) test_finalize;
}


GType
test_get_type()
{
  static GType type = 0;

  if (type == 0)
    {
      static const GTypeInfo info =
	{
	  sizeof (TestClass),
	  NULL,
	  NULL,
	  (GClassInitFunc) test_class_init,
	  NULL,
	  NULL,
	  sizeof (Test),
	  0,
	  NULL
	};

      type = g_type_register_static (G_TYPE_OBJECT, "TestType", &info, 0);
    }

  return type;
}


int
main (int argc __attribute((unused)), char *argv[] __attribute((unused)))
{
  Test *object;

  g_type_init ();

  object = g_object_new (test_get_type (), 0);
  g_object_ref (object);
  g_object_unref (object);
  g_object_unref (object);

  return 0;
}

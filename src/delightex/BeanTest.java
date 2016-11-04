package delightex;

import org.mozilla.javascript.Context;
import org.mozilla.javascript.NativeJavaMethod;
import org.mozilla.javascript.NativeJavaObject;
import org.mozilla.javascript.Scriptable;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;


public class BeanTest {
  private static final Set<String> L_OBJECT_ATTRS = new HashSet<String>(
      Arrays.asList("class", "getClass", "toString", "equals", "hashCode", "wait", "notify", "notifyAll", "getName"));

  private final Scriptable myScope;

  {
    Context rhino = Context.enter();
    rhino.setOptimizationLevel(-1);
    myScope = rhino.initStandardObjects();
  }

  public static void main(String[] args) {
    new BeanTest().runTest();
  }

  private void runTest() {
    NativeJavaObject service = (NativeJavaObject) Context.javaToJS(new BeanService(), myScope);
    for (Object idObj : service.getIds()) {
      String id = idObj.toString();
      if (L_OBJECT_ATTRS.contains(id)) continue;
      System.out.println(idObj);
      Object methodObj = service.get(id, service);
      if (methodObj instanceof NativeJavaMethod) {
        System.out.println("This is method!");
      }
    }
//    ItemRhino item = new ItemRhino(myScope);
//    item.register(new BeanService());
//    item.getNativeObject();
  }

}


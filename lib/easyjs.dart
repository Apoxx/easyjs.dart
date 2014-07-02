library easyjs;
import "dart:async";
import "dart:html";
import "dart:mirrors";
import "package:js/js.dart";

var _js = new EasyJS._();

EasyJS getJS() => _js;

class EasyJS{
  EasyJS._() : super();

  Proxy call(dynamic arg,{List args: const[], withThis: false}){
    if(arg is String){
      return context.eval(arg);
    }
    if(arg is Map){
      return map(arg);
    }
    if(arg is Iterable){
      return array(arg);
    }
    if(arg is Proxy){
      return new Proxy.withArgList(arg,args);
    }
    if(arg is Function){
      if(withThis){
        return new FunctionProxy.withThis(arg);
      }else{
        return new FunctionProxy(arg);
      }
    }
  }

  dynamic noSuchMethod(invocation){
    return context.noSuchMethod(invocation);
  }
}

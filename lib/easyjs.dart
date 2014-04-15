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

Future loadJS(List<String> src){
  List<Future> futures = [];

  Function loadFile = (String filePath){
    ScriptElement script = new ScriptElement();
    script.type = "application/javascript";
    script.src = filePath;
    document.head.append(script);
    futures.add(script.onLoad.first);
    print("+ $filePath");
  };
  if(!hasProperty(context,"DartObject")){
    loadFile("packages/browser/interop.js");
  }
  for(String s in src){
    loadFile(s);
  }
  return Future.wait(futures).then((list){
    print("= ${list.length} JavaScript lib(s) loaded !");
    return _js;
  });
}

getTypeName(dynamic obj) {
  return reflect(obj).type.reflectedType.toString();
}
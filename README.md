EasyJS
======

This is a little wrapper around [js-interop] that simplify a bit more the interactions between Dart and JavaScript.

A litte example:

    import "package:easyjs/easyjs.dart";

    main() {
      loadJS([
          "//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.6.0/underscore-min.js"
      ]).then((js){
        //The js value is the js context and the "casting tool" at the same time.

        //Use the js object to convert Maps to JS Objects, It works with Iterables too.
        var jsObj = js({"test" : 1, "test2" : 5});

        //Call functions from the JS context and pass them Dart Functions
        var jsObj2 = js._.map(jsObj,js((val,arg,context) => val + 1));

        print(jsObj2);

        //eval works, can be useful.
        js.eval("var obj = {name :'James'};");

        print("My name is ${js.obj.name}");

        //An example here how you can create classes and objects in the JS context from Dart.
        var MyJSClass = js((jthis,name) => jthis.name = name, withThis: true);

        //If you want to have acces the de "JS this", you must pass "true" to the named parameter "withThis" of the js object.
        //The "JS this" will be the first argument the function will receive.
        MyJSClass.prototype.sayName = js((jthis) => print("My name is ${jthis.name}"), withThis: true);

        //To create new js Objects, you need to pass the js Contructor and the arguments (as a list) to the js object.
        var myObj = js(MyJSClass,args: ["Jack"]);

        myObj.sayName();

        //It's quite flexible.
        js.square = js(doSquare);

        js.console.log(js.square(10));

        print(js.square(10));

      });
    }


    doSquare(value){
      return value * value;
    }


[js-interop]: https://github.com/dart-lang/js-interop
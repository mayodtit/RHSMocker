// NativeBridge: Bridge between JS and ObjC
// Based on https://github.com/ochameau/NativeBridge
// Simplified to pass a single JSON object between the JS and native code
var NativeBridge = {
  callbacksCount: 1,
  callbacks: {},
  
  resultForCallback: function resultForCallback(callbackId, result) {
    try {
      var callback = NativeBridge.callbacks[callbackId];
      if (callback) {
        callback(result);
      }
    } catch(e) {
      alert(e);
    }
  },
  
  // Use this in javascript to request native objective-c code
  // functionName : string
  // args : JSON object
  // callback : optional function accepting a JSON object
  call: function call(functionName, args, callback) {
    var hasCallback = callback && typeof callback == "function";
    var callbackId = hasCallback ? NativeBridge.callbacksCount++ : 0;
    
    if (hasCallback) {
      NativeBridge.callbacks[callbackId] = callback;
    }
    
    var iframe = document.createElement("IFRAME");
    var encodedArgs = encodeURIComponent(JSON.stringify(args));
    iframe.setAttribute("src", "native-bridge:" + functionName + ":" + callbackId+ ":" + encodedArgs);
    // For some reason we need to set a non-empty size for the iOS6 simulator...
    iframe.setAttribute("height", "1px");
    iframe.setAttribute("width", "1px");
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  }
};

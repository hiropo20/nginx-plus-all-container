export default { reqall, headers, args, hello, sleep, sleep2};

// two types sleep functions
function isNumber(value) {
  return !Number.isNaN(parseInt(value));
}

// 1 sleep using async / await / Promise
function ms_sleep(milsec) {  return new Promise(function(resolve) {
  let ms ;
  if(!isNumber(milsec)){ ms = 1000; }
  if(isNumber(milsec)){ ms = parseInt(milsec); }
  setTimeout(function(){resolve(ms)}, ms)
})}

async function sleep(r) {
  let ms = await ms_sleep(r.variables.sleep_time_ms)
  r.return(200, "wait " + ms +"msec")

}

// 2 sleep using Promise
function sleep2(r) {
  let ms ;
  if(!isNumber(r.variables.sleep_time_ms)){ ms = 1000; }
  if(isNumber(r.variables.sleep_time_ms)){ ms = parseInt(r.variables.sleep_time_ms); }
  let ms_sleep_promise =  new Promise(function(resolve) {
      setTimeout(function(){resolve()}, ms)
  })
  Promise.all([ms_sleep_promise]).then(function(){
    r.return(200, "wait " + ms +"msec")
  })
}

// hello
function hello(r) {
  r.return(200, "Hello world!\n")
}

// reqall
function reqall(r) {
  let str = {};
  str.headers = r.rawHeadersIn;
  str.status = r.status;
  str.httpversion = r.httpVersion;
  str.method = r.method;
  str.uri = r.uri;
  str.args = r.variables.args;
  str.reqbody = r.requestText;
  r.return(200, JSON.stringify(str));
  return;
}
function headers(r) {
  let str = r.rawHeadersIn;
  r.return(200, JSON.stringify(str));
  return;
}
function args(r) {
  let str = r.variables.args;
  r.return(200, JSON.stringify(str));
  return;
}
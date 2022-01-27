export default { reqall, headers, args, hello};
function hello(r) {
  r.return(200, "Hello world!\n")
}
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
  let str = new Array();
  str = r.variables.args;
  r.return(200, JSON.stringify(str));
  return;
}
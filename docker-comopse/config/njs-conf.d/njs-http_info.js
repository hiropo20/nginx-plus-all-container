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
  str.args = new Array();
  r.variables.args.split("&").forEach(e => str.args.push(e.split("=")));
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
  r.variables.args.split("&").forEach(e => str.push(e.split("=")));
  r.return(200, JSON.stringify(str));
  return;
}
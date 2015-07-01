//var window = this;
var cheerio = require('cheerio');

window['loadHTML'] = function (html) {
  $ = cheerio.load(html);
}

window['queryWithCss'] = function(selector){
  var ret = [];
  $(selector).each(function(i, elem) {
    var obj = {text:$(this).text()};
    ret.push(obj);
  })
  return ret;
}

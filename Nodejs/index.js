var cheerio = require('cheerio');

function isObject ( obj ) {
   return obj && (typeof obj  === "object");
}
if(typeof(String.prototype.trim) === "undefined")
{
    String.prototype.trim = function()
    {
        return String(this).replace(/^\s+|\s+$/g, '');
    };
}

function getValue (obj,value) {
  var dom;
  if(value){
    dom = $(obj).find(value).get(0);
  } else{
    dom = $(obj).get(0);
  }
  var tagName = dom.tagName.toLowerCase();
  var ret = "";
  switch (tagName){
    case "a":
      ret = $(dom).eq(0).attr('href');
      break;
    case 'img':
      ret = $(dom).eq(0).attr('src');
      break;
    default:
      ret = $(dom).eq(0).text().trim();
  }
  return ret;
}
global.loadHTML = function (html) {
  $ = cheerio.load(html);
}


global.queryWithCss = function(selector,child,map){
  var ret = [];
  $(selector).each(function(i, elem) {
    var obj ={} ;
    if(map){
      obj['val'] = map('',getValue(this));
    }else{
      obj['val'] = getValue(this);
    }
    if(child && isObject(child)){
      for (var key in child) {
        var value = child[key];
        if(value){
          var item = $(this).find(value);
          if(map){
            obj[key] = map(key,getValue(this,value))
          }else{
            obj[key] = getValue(this,value)
          }
        }
      }
    }
    ret.push(obj);
  })
  return ret;
}


if (module && !module.parent) {

}
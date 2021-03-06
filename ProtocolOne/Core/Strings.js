.pragma library
function stripTags(input, allowed) {
    //  discuss at: http://phpjs.org/functions/strip_tags/
    // original by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // improved by: Luke Godfrey
    // improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    //    input by: Pul
    //    input by: Alex
    //    input by: Marc Palau
    //    input by: Brett Zamir (http://brett-zamir.me)
    //    input by: Bobby Drake
    //    input by: Evertjan Garretsen
    // bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // bugfixed by: Onno Marsman
    // bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // bugfixed by: Eric Nagel
    // bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
    // bugfixed by: Tomasz Wesolowski
    //  revised by: Rafał Kukawski (http://blog.kukawski.pl/)
    //   example 1: strip_tags('<p>Kevin</p> <br /><b>van</b> <i>Zonneveld</i>', '<i><b>');
    //   returns 1: 'Kevin <b>van</b> <i>Zonneveld</i>'
    //   example 2: strip_tags('<p>Kevin <img src="someimage.png" onmouseover="someFunction()">van <i>Zonneveld</i></p>', '<p>');
    //   returns 2: '<p>Kevin van Zonneveld</p>'
    //   example 3: strip_tags("<a href='http://kevin.vanzonneveld.net'>Kevin van Zonneveld</a>", "<a>");
    //   returns 3: "<a href='http://kevin.vanzonneveld.net'>Kevin van Zonneveld</a>"
    //   example 4: strip_tags('1 < 5 5 > 1');
    //   returns 4: '1 < 5 5 > 1'
    //   example 5: strip_tags('1 <br/> 1');
    //   returns 5: '1  1'
    //   example 6: strip_tags('1 <br/> 1', '<br>');
    //   returns 6: '1 <br/> 1'
    //   example 7: strip_tags('1 <br/> 1', '<br><br/>');
    //   returns 7: '1 <br/> 1'

    allowed = (((allowed || '') + '')
               .toLowerCase()
               .match(/<[a-z][a-z0-9]*>/g) || [])
    .join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
            commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
    return input.replace(commentsAndPhpTags, '')
    .replace(tags, function ($0, $1) {
        return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
}

function htmlDecode(s) {
    //http://pynej.blogspot.ru/2013/03/javascript-html-decode-function-to.html
    return s.replace(/&[a-z]+;/gi, function(entity) {
        switch (entity) {
        case '&quot;': return String.fromCharCode(0x0022);
        case '&amp;': return String.fromCharCode(0x0026);
        case '&lt;': return String.fromCharCode(0x003c);
        case '&gt;': return String.fromCharCode(0x003e);
        case '&nbsp;': return String.fromCharCode(0x00a0);
        case '&iexcl;': return String.fromCharCode(0x00a1);
        case '&cent;': return String.fromCharCode(0x00a2);
        case '&pound;': return String.fromCharCode(0x00a3);
        case '&curren;': return String.fromCharCode(0x00a4);
        case '&yen;': return String.fromCharCode(0x00a5);
        case '&brvbar;': return String.fromCharCode(0x00a6);
        case '&sect;': return String.fromCharCode(0x00a7);
        case '&uml;': return String.fromCharCode(0x00a8);
        case '&copy;': return String.fromCharCode(0x00a9);
        case '&ordf;': return String.fromCharCode(0x00aa);
        case '&laquo;': return String.fromCharCode(0x00ab);
        case '&not;': return String.fromCharCode(0x00ac);
        case '&shy;': return String.fromCharCode(0x00ad);
        case '&reg;': return String.fromCharCode(0x00ae);
        case '&macr;': return String.fromCharCode(0x00af);
        case '&deg;': return String.fromCharCode(0x00b0);
        case '&plusmn;': return String.fromCharCode(0x00b1);
        case '&sup2;': return String.fromCharCode(0x00b2);
        case '&sup3;': return String.fromCharCode(0x00b3);
        case '&acute;': return String.fromCharCode(0x00b4);
        case '&micro;': return String.fromCharCode(0x00b5);
        case '&para;': return String.fromCharCode(0x00b6);
        case '&middot;': return String.fromCharCode(0x00b7);
        case '&cedil;': return String.fromCharCode(0x00b8);
        case '&sup1;': return String.fromCharCode(0x00b9);
        case '&ordm;': return String.fromCharCode(0x00ba);
        case '&raquo;': return String.fromCharCode(0x00bb);
        case '&frac14;': return String.fromCharCode(0x00bc);
        case '&frac12;': return String.fromCharCode(0x00bd);
        case '&frac34;': return String.fromCharCode(0x00be);
        case '&iquest;': return String.fromCharCode(0x00bf);
        case '&Agrave;': return String.fromCharCode(0x00c0);
        case '&Aacute;': return String.fromCharCode(0x00c1);
        case '&Acirc;': return String.fromCharCode(0x00c2);
        case '&Atilde;': return String.fromCharCode(0x00c3);
        case '&Auml;': return String.fromCharCode(0x00c4);
        case '&Aring;': return String.fromCharCode(0x00c5);
        case '&AElig;': return String.fromCharCode(0x00c6);
        case '&Ccedil;': return String.fromCharCode(0x00c7);
        case '&Egrave;': return String.fromCharCode(0x00c8);
        case '&Eacute;': return String.fromCharCode(0x00c9);
        case '&Ecirc;': return String.fromCharCode(0x00ca);
        case '&Euml;': return String.fromCharCode(0x00cb);
        case '&Igrave;': return String.fromCharCode(0x00cc);
        case '&Iacute;': return String.fromCharCode(0x00cd);
        case '&Icirc;': return String.fromCharCode(0x00ce);
        case '&Iuml;': return String.fromCharCode(0x00cf);
        case '&ETH;': return String.fromCharCode(0x00d0);
        case '&Ntilde;': return String.fromCharCode(0x00d1);
        case '&Ograve;': return String.fromCharCode(0x00d2);
        case '&Oacute;': return String.fromCharCode(0x00d3);
        case '&Ocirc;': return String.fromCharCode(0x00d4);
        case '&Otilde;': return String.fromCharCode(0x00d5);
        case '&Ouml;': return String.fromCharCode(0x00d6);
        case '&times;': return String.fromCharCode(0x00d7);
        case '&Oslash;': return String.fromCharCode(0x00d8);
        case '&Ugrave;': return String.fromCharCode(0x00d9);
        case '&Uacute;': return String.fromCharCode(0x00da);
        case '&Ucirc;': return String.fromCharCode(0x00db);
        case '&Uuml;': return String.fromCharCode(0x00dc);
        case '&Yacute;': return String.fromCharCode(0x00dd);
        case '&THORN;': return String.fromCharCode(0x00de);
        case '&szlig;': return String.fromCharCode(0x00df);
        case '&agrave;': return String.fromCharCode(0x00e0);
        case '&aacute;': return String.fromCharCode(0x00e1);
        case '&acirc;': return String.fromCharCode(0x00e2);
        case '&atilde;': return String.fromCharCode(0x00e3);
        case '&auml;': return String.fromCharCode(0x00e4);
        case '&aring;': return String.fromCharCode(0x00e5);
        case '&aelig;': return String.fromCharCode(0x00e6);
        case '&ccedil;': return String.fromCharCode(0x00e7);
        case '&egrave;': return String.fromCharCode(0x00e8);
        case '&eacute;': return String.fromCharCode(0x00e9);
        case '&ecirc;': return String.fromCharCode(0x00ea);
        case '&euml;': return String.fromCharCode(0x00eb);
        case '&igrave;': return String.fromCharCode(0x00ec);
        case '&iacute;': return String.fromCharCode(0x00ed);
        case '&icirc;': return String.fromCharCode(0x00ee);
        case '&iuml;': return String.fromCharCode(0x00ef);
        case '&eth;': return String.fromCharCode(0x00f0);
        case '&ntilde;': return String.fromCharCode(0x00f1);
        case '&ograve;': return String.fromCharCode(0x00f2);
        case '&oacute;': return String.fromCharCode(0x00f3);
        case '&ocirc;': return String.fromCharCode(0x00f4);
        case '&otilde;': return String.fromCharCode(0x00f5);
        case '&ouml;': return String.fromCharCode(0x00f6);
        case '&divide;': return String.fromCharCode(0x00f7);
        case '&oslash;': return String.fromCharCode(0x00f8);
        case '&ugrave;': return String.fromCharCode(0x00f9);
        case '&uacute;': return String.fromCharCode(0x00fa);
        case '&ucirc;': return String.fromCharCode(0x00fb);
        case '&uuml;': return String.fromCharCode(0x00fc);
        case '&yacute;': return String.fromCharCode(0x00fd);
        case '&thorn;': return String.fromCharCode(0x00fe);
        case '&yuml;': return String.fromCharCode(0x00ff);
        case '&OElig;': return String.fromCharCode(0x0152);
        case '&oelig;': return String.fromCharCode(0x0153);
        case '&Scaron;': return String.fromCharCode(0x0160);
        case '&scaron;': return String.fromCharCode(0x0161);
        case '&Yuml;': return String.fromCharCode(0x0178);
        case '&fnof;': return String.fromCharCode(0x0192);
        case '&circ;': return String.fromCharCode(0x02c6);
        case '&tilde;': return String.fromCharCode(0x02dc);
        case '&Alpha;': return String.fromCharCode(0x0391);
        case '&Beta;': return String.fromCharCode(0x0392);
        case '&Gamma;': return String.fromCharCode(0x0393);
        case '&Delta;': return String.fromCharCode(0x0394);
        case '&Epsilon;': return String.fromCharCode(0x0395);
        case '&Zeta;': return String.fromCharCode(0x0396);
        case '&Eta;': return String.fromCharCode(0x0397);
        case '&Theta;': return String.fromCharCode(0x0398);
        case '&Iota;': return String.fromCharCode(0x0399);
        case '&Kappa;': return String.fromCharCode(0x039a);
        case '&Lambda;': return String.fromCharCode(0x039b);
        case '&Mu;': return String.fromCharCode(0x039c);
        case '&Nu;': return String.fromCharCode(0x039d);
        case '&Xi;': return String.fromCharCode(0x039e);
        case '&Omicron;': return String.fromCharCode(0x039f);
        case '&Pi;': return String.fromCharCode(0x03a0);
        case '& Rho ;': return String.fromCharCode(0x03a1);
        case '&Sigma;': return String.fromCharCode(0x03a3);
        case '&Tau;': return String.fromCharCode(0x03a4);
        case '&Upsilon;': return String.fromCharCode(0x03a5);
        case '&Phi;': return String.fromCharCode(0x03a6);
        case '&Chi;': return String.fromCharCode(0x03a7);
        case '&Psi;': return String.fromCharCode(0x03a8);
        case '&Omega;': return String.fromCharCode(0x03a9);
        case '&alpha;': return String.fromCharCode(0x03b1);
        case '&beta;': return String.fromCharCode(0x03b2);
        case '&gamma;': return String.fromCharCode(0x03b3);
        case '&delta;': return String.fromCharCode(0x03b4);
        case '&epsilon;': return String.fromCharCode(0x03b5);
        case '&zeta;': return String.fromCharCode(0x03b6);
        case '&eta;': return String.fromCharCode(0x03b7);
        case '&theta;': return String.fromCharCode(0x03b8);
        case '&iota;': return String.fromCharCode(0x03b9);
        case '&kappa;': return String.fromCharCode(0x03ba);
        case '&lambda;': return String.fromCharCode(0x03bb);
        case '&mu;': return String.fromCharCode(0x03bc);
        case '&nu;': return String.fromCharCode(0x03bd);
        case '&xi;': return String.fromCharCode(0x03be);
        case '&omicron;': return String.fromCharCode(0x03bf);
        case '&pi;': return String.fromCharCode(0x03c0);
        case '&rho;': return String.fromCharCode(0x03c1);
        case '&sigmaf;': return String.fromCharCode(0x03c2);
        case '&sigma;': return String.fromCharCode(0x03c3);
        case '&tau;': return String.fromCharCode(0x03c4);
        case '&upsilon;': return String.fromCharCode(0x03c5);
        case '&phi;': return String.fromCharCode(0x03c6);
        case '&chi;': return String.fromCharCode(0x03c7);
        case '&psi;': return String.fromCharCode(0x03c8);
        case '&omega;': return String.fromCharCode(0x03c9);
        case '&thetasym;': return String.fromCharCode(0x03d1);
        case '&upsih;': return String.fromCharCode(0x03d2);
        case '&piv;': return String.fromCharCode(0x03d6);
        case '&ensp;': return String.fromCharCode(0x2002);
        case '&emsp;': return String.fromCharCode(0x2003);
        case '&thinsp;': return String.fromCharCode(0x2009);
        case '&zwnj;': return String.fromCharCode(0x200c);
        case '&zwj;': return String.fromCharCode(0x200d);
        case '&lrm;': return String.fromCharCode(0x200e);
        case '&rlm;': return String.fromCharCode(0x200f);
        case '&ndash;': return String.fromCharCode(0x2013);
        case '&mdash;': return String.fromCharCode(0x2014);
        case '&lsquo;': return String.fromCharCode(0x2018);
        case '&rsquo;': return String.fromCharCode(0x2019);
        case '&sbquo;': return String.fromCharCode(0x201a);
        case '&ldquo;': return String.fromCharCode(0x201c);
        case '&rdquo;': return String.fromCharCode(0x201d);
        case '&bdquo;': return String.fromCharCode(0x201e);
        case '&dagger;': return String.fromCharCode(0x2020);
        case '&Dagger;': return String.fromCharCode(0x2021);
        case '&bull;': return String.fromCharCode(0x2022);
        case '&hellip;': return String.fromCharCode(0x2026);
        case '&permil;': return String.fromCharCode(0x2030);
        case '&prime;': return String.fromCharCode(0x2032);
        case '&Prime;': return String.fromCharCode(0x2033);
        case '&lsaquo;': return String.fromCharCode(0x2039);
        case '&rsaquo;': return String.fromCharCode(0x203a);
        case '&oline;': return String.fromCharCode(0x203e);
        case '&frasl;': return String.fromCharCode(0x2044);
        case '&euro;': return String.fromCharCode(0x20ac);
        case '&image;': return String.fromCharCode(0x2111);
        case '&weierp;': return String.fromCharCode(0x2118);
        case '&real;': return String.fromCharCode(0x211c);
        case '&trade;': return String.fromCharCode(0x2122);
        case '&alefsym;': return String.fromCharCode(0x2135);
        case '&larr;': return String.fromCharCode(0x2190);
        case '&uarr;': return String.fromCharCode(0x2191);
        case '&rarr;': return String.fromCharCode(0x2192);
        case '&darr;': return String.fromCharCode(0x2193);
        case '&harr;': return String.fromCharCode(0x2194);
        case '&crarr;': return String.fromCharCode(0x21b5);
        case '&lArr;': return String.fromCharCode(0x21d0);
        case '&uArr;': return String.fromCharCode(0x21d1);
        case '&rArr;': return String.fromCharCode(0x21d2);
        case '&dArr;': return String.fromCharCode(0x21d3);
        case '&hArr;': return String.fromCharCode(0x21d4);
        case '&forall;': return String.fromCharCode(0x2200);
        case '&part;': return String.fromCharCode(0x2202);
        case '&exist;': return String.fromCharCode(0x2203);
        case '&empty;': return String.fromCharCode(0x2205);
        case '&nabla;': return String.fromCharCode(0x2207);
        case '&isin;': return String.fromCharCode(0x2208);
        case '&notin;': return String.fromCharCode(0x2209);
        case '&ni;': return String.fromCharCode(0x220b);
        case '&prod;': return String.fromCharCode(0x220f);
        case '&sum;': return String.fromCharCode(0x2211);
        case '&minus;': return String.fromCharCode(0x2212);
        case '&lowast;': return String.fromCharCode(0x2217);
        case '&radic;': return String.fromCharCode(0x221a);
        case '&prop;': return String.fromCharCode(0x221d);
        case '&infin;': return String.fromCharCode(0x221e);
        case '&ang;': return String.fromCharCode(0x2220);
        case '&and;': return String.fromCharCode(0x2227);
        case '&or;': return String.fromCharCode(0x2228);
        case '&cap;': return String.fromCharCode(0x2229);
        case '&cup;': return String.fromCharCode(0x222a);
        case '&int;': return String.fromCharCode(0x222b);
        case '&there4;': return String.fromCharCode(0x2234);
        case '&sim;': return String.fromCharCode(0x223c);
        case '&cong;': return String.fromCharCode(0x2245);
        case '&asymp;': return String.fromCharCode(0x2248);
        case '&ne;': return String.fromCharCode(0x2260);
        case '&equiv;': return String.fromCharCode(0x2261);
        case '&le;': return String.fromCharCode(0x2264);
        case '&ge;': return String.fromCharCode(0x2265);
        case '&sub;': return String.fromCharCode(0x2282);
        case '&sup;': return String.fromCharCode(0x2283);
        case '&nsub;': return String.fromCharCode(0x2284);
        case '&sube;': return String.fromCharCode(0x2286);
        case '&supe;': return String.fromCharCode(0x2287);
        case '&oplus;': return String.fromCharCode(0x2295);
        case '&otimes;': return String.fromCharCode(0x2297);
        case '&perp;': return String.fromCharCode(0x22a5);
        case '&sdot;': return String.fromCharCode(0x22c5);
        case '&lceil;': return String.fromCharCode(0x2308);
        case '&rceil;': return String.fromCharCode(0x2309);
        case '&lfloor;': return String.fromCharCode(0x230a);
        case '&rfloor;': return String.fromCharCode(0x230b);
        case '&lang;': return String.fromCharCode(0x2329);
        case '&rang;': return String.fromCharCode(0x232a);
        case '&loz;': return String.fromCharCode(0x25ca);
        case '&spades;': return String.fromCharCode(0x2660);
        case '&clubs;': return String.fromCharCode(0x2663);
        case '&hearts;': return String.fromCharCode(0x2665);
        case '&diams;': return String.fromCharCode(0x2666);
        default: return '';
        }
    })
}

function sprintf() {
  //  discuss at: http://phpjs.org/functions/sprintf/
  // original by: Ash Searle (http://hexmen.com/blog/)
  // improved by: Michael White (http://getsprink.com)
  // improved by: Jack
  // improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // improved by: Dj
  // improved by: Allidylls
  //    input by: Paulo Freitas
  //    input by: Brett Zamir (http://brett-zamir.me)
  //   example 1: sprintf("%01.2f", 123.1);
  //   returns 1: 123.10
  //   example 2: sprintf("[%10s]", 'monkey');
  //   returns 2: '[    monkey]'
  //   example 3: sprintf("[%'#10s]", 'monkey');
  //   returns 3: '[####monkey]'
  //   example 4: sprintf("%d", 123456789012345);
  //   returns 4: '123456789012345'
  //   example 5: sprintf('%-03s', 'E');
  //   returns 5: 'E00'

  var regex = /%%|%(\d+\$)?([-+\'#0 ]*)(\*\d+\$|\*|\d+)?(\.(\*\d+\$|\*|\d+))?([scboxXuideEfFgG])/g;
  var a = arguments;
  var i = 0;
  var format = a[i++];

  // pad()
  var pad = function(str, len, chr, leftJustify) {
    if (!chr) {
      chr = ' ';
    }
    var padding = (str.length >= len) ? '' : new Array(1 + len - str.length >>> 0)
      .join(chr);
    return leftJustify ? str + padding : padding + str;
  };

  // justify()
  var justify = function(value, prefix, leftJustify, minWidth, zeroPad, customPadChar) {
    var diff = minWidth - value.length;
    if (diff > 0) {
      if (leftJustify || !zeroPad) {
        value = pad(value, minWidth, customPadChar, leftJustify);
      } else {
        value = value.slice(0, prefix.length) + pad('', diff, '0', true) + value.slice(prefix.length);
      }
    }
    return value;
  };

  // formatBaseX()
  var formatBaseX = function(value, base, prefix, leftJustify, minWidth, precision, zeroPad) {
    // Note: casts negative numbers to positive ones
    var number = value >>> 0;
    prefix = prefix && number && {
      '2': '0b',
      '8': '0',
      '16': '0x'
    }[base] || '';
    value = prefix + pad(number.toString(base), precision || 0, '0', false);
    return justify(value, prefix, leftJustify, minWidth, zeroPad);
  };

  // formatString()
  var formatString = function(value, leftJustify, minWidth, precision, zeroPad, customPadChar) {
    if (precision != null) {
      value = value.slice(0, precision);
    }
    return justify(value, '', leftJustify, minWidth, zeroPad, customPadChar);
  };

  // doFormat()
  var doFormat = function(substring, valueIndex, flags, minWidth, _, precision, type) {
    var number, prefix, method, textTransform, value;

    if (substring === '%%') {
      return '%';
    }

    // parse flags
    var leftJustify = false;
    var positivePrefix = '';
    var zeroPad = false;
    var prefixBaseX = false;
    var customPadChar = ' ';
    var flagsl = flags.length;
    for (var j = 0; flags && j < flagsl; j++) {
      switch (flags.charAt(j)) {
        case ' ':
          positivePrefix = ' ';
          break;
        case '+':
          positivePrefix = '+';
          break;
        case '-':
          leftJustify = true;
          break;
        case "'":
          customPadChar = flags.charAt(j + 1);
          break;
        case '0':
          zeroPad = true;
          customPadChar = '0';
          break;
        case '#':
          prefixBaseX = true;
          break;
      }
    }

    // parameters may be null, undefined, empty-string or real valued
    // we want to ignore null, undefined and empty-string values
    if (!minWidth) {
      minWidth = 0;
    } else if (minWidth === '*') {
      minWidth = +a[i++];
    } else if (minWidth.charAt(0) == '*') {
      minWidth = +a[minWidth.slice(1, -1)];
    } else {
      minWidth = +minWidth;
    }

    // Note: undocumented perl feature:
    if (minWidth < 0) {
      minWidth = -minWidth;
      leftJustify = true;
    }

    if (!isFinite(minWidth)) {
      throw new Error('sprintf: (minimum-)width must be finite');
    }

    if (!precision) {
      precision = 'fFeE'.indexOf(type) > -1 ? 6 : (type === 'd') ? 0 : undefined;
    } else if (precision === '*') {
      precision = +a[i++];
    } else if (precision.charAt(0) == '*') {
      precision = +a[precision.slice(1, -1)];
    } else {
      precision = +precision;
    }

    // grab value using valueIndex if required?
    value = valueIndex ? a[valueIndex.slice(0, -1)] : a[i++];

    switch (type) {
      case 's':
        return formatString(String(value), leftJustify, minWidth, precision, zeroPad, customPadChar);
      case 'c':
        return formatString(String.fromCharCode(+value), leftJustify, minWidth, precision, zeroPad);
      case 'b':
        return formatBaseX(value, 2, prefixBaseX, leftJustify, minWidth, precision, zeroPad);
      case 'o':
        return formatBaseX(value, 8, prefixBaseX, leftJustify, minWidth, precision, zeroPad);
      case 'x':
        return formatBaseX(value, 16, prefixBaseX, leftJustify, minWidth, precision, zeroPad);
      case 'X':
        return formatBaseX(value, 16, prefixBaseX, leftJustify, minWidth, precision, zeroPad)
          .toUpperCase();
      case 'u':
        return formatBaseX(value, 10, prefixBaseX, leftJustify, minWidth, precision, zeroPad);
      case 'i':
      case 'd':
        number = +value || 0;
        number = Math.round(number - number % 1); // Plain Math.round doesn't just truncate
        prefix = number < 0 ? '-' : positivePrefix;
        value = prefix + pad(String(Math.abs(number)), precision, '0', false);
        return justify(value, prefix, leftJustify, minWidth, zeroPad);
      case 'e':
      case 'E':
      case 'f': // Should handle locales (as per setlocale)
      case 'F':
      case 'g':
      case 'G':
        number = +value;
        prefix = number < 0 ? '-' : positivePrefix;
        method = ['toExponential', 'toFixed', 'toPrecision']['efg'.indexOf(type.toLowerCase())];
        textTransform = ['toString', 'toUpperCase']['eEfFgG'.indexOf(type) % 2];
        value = prefix + Math.abs(number)[method](precision);
        return justify(value, prefix, leftJustify, minWidth, zeroPad)[textTransform]();
      default:
        return substring;
    }
  };

  return format.replace(regex, doFormat);
}

/**
 * Функция возвращает окончание для множественного числа слова на основании числа и массива окончаний
 * @param  iNumber Integer Число на основе которого нужно сформировать окончание
 * @param  aEndings Array Массив слов или окончаний для чисел (1, 4, 5),
 *         например ['яблоко', 'яблока', 'яблок']
 * @return String
 */
function pluralForm(iNumber, aEndings)
{
    var sEnding, i;
    iNumber = iNumber % 100;
    if (iNumber>=11 && iNumber<=19) {
        sEnding=aEndings[2];
    }
    else {
        i = iNumber % 10;
        switch (i)
        {
            case (1): sEnding = aEndings[0]; break;
            case (2):
            case (3):
            case (4): sEnding = aEndings[1]; break;
            default: sEnding = aEndings[2];
        }
    }
    return sEnding;
}

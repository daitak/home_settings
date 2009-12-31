// statusline ‚É favicon ‚ð•\Ž¦
(function() {
  var setFavicon = function(){
    var p = document.getElementById('page-proxy-favicon-clone');
    var b = document.getElementById('page-proxy-favicon');
    if (!p) {
      p = document.createElement('statusbarpanel');
      p.setAttribute('id','page-proxy-favicon-clone');
      p.appendChild(b.cloneNode(true));
      document.getElementById('status-bar').insertBefore(p,document.getElementById('liberator-statusline'));
    }
    if (p.childNodes.length > 0) {
      var node = p.childNodes.item(0);
      node.setAttribute('src', b.getAttribute('src'));
    }
  }
  getBrowser().addEventListener("load", function() setFavicon() , true);
  getBrowser().addEventListener("TabSelect", function() setFavicon() , true);
})();

// statusline ‚Ì [+-] ‚ð‚í‚©‚è‚â‚·‚¢ˆÊ’u‚É‚í‚©‚è‚â‚·‚­•\Ž¦
(function() {
  var p = document.createElement('statusbarpanel');
  var l = document.getElementById('liberator-statusline-field-tabcount').cloneNode(false);
  l.setAttribute('id', 'liberator-statusline-field-history');
  l.setAttribute('value', '  ');
  p.appendChild(l);
  document.getElementById('status-bar').insertBefore(p,
    document.getElementById('liberator-statusline'));
  var setter = function() {
    var e = document.getElementById('liberator-statusline-field-history');
    var h = getWebNavigation().sessionHistory;
    h = (h.index > 0 ? "<" : " ") + (h.index < h.count - 1 ? ">" : " ");
    e.setAttribute('value', h);
  };
  setter();
  getBrowser().addEventListener("load", function() setter(), true);
  getBrowser().addEventListener("TabSelect", function() setter(), true);
})();
